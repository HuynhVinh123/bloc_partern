import 'dart:math';

import 'package:facebook_api_client/facebook_api_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/new_game_lucky_wheel/new_game_lucky_wheel_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/new_game_lucky_wheel/new_game_lucky_wheel_state.dart';
import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/lucky_wheel_setting.dart';
import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/player.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/config_service/shop_config_service.dart';
import 'package:tpos_mobile/services/print_service.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';

class GameLuckyWheelBloc extends Bloc<GameLuckyWheelEvent, GameLuckyWheelState> {
  GameLuckyWheelBloc(
      {ITposApiService tposApi,
      ShopConfigService shopConfigService,
      FacebookApi facebookApi,
      PrintService printService,
      TposFacebookApi tposFacebookApi,
      PartnerApi partnerApi})
      : super(GameLuckyWheelLoading()) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _shopConfig = shopConfigService ?? GetIt.I<ShopConfigService>();
    _facebookApi = facebookApi ?? GetIt.I<FacebookApi>();
    _tposFacebookApi = tposFacebookApi ?? GetIt.I<TposFacebookApi>();
    _print = printService ?? locator<PrintService>();
    _partnerApi = partnerApi ?? GetIt.I<PartnerApi>();
  }

  PrintService _print;
  ITposApiService _tposApi;
  final Logger _logger = Logger();
  FacebookApi _facebookApi;
  ShopConfigService _shopConfig;
  final List<Player> _players = [];
  String _postId;
  List<Player> _lastWinners = [];
  final List<Player> _validPlayers = [];
  Player _winPlayer;
  List<Users> _users;
  LuckyWheelSetting _luckyWheelSetting;
  String _accessToken;
  List<FacebookShareInfo> _faceBookShareInfoList = [];
  SaleOnlineFacebookPostSummaryUser _postSummary = SaleOnlineFacebookPostSummaryUser();
  CRMTeam _crmTeam;
  TposFacebookApi _tposFacebookApi;
  PartnerApi _partnerApi;
  List<TposFacebookWinner> _faceBookWinners = [];

  bool _isLoadLastWinner = false;
  bool _isLoadPlayer = false;
  bool _userShareApi = true;

  @override
  Stream<GameLuckyWheelState> mapEventToState(GameLuckyWheelEvent event) async* {
    if (event is GameLuckyWheelLoaded) {
      yield GameLuckyWheelLoading();
      _postId = event.postId;
      _crmTeam = event.crmTeam;
      _accessToken = event.token;
      _luckyWheelSetting = LuckyWheelSetting(
          isPriorityComment: _shopConfig.luckyWheelConfig.luckyWheelPriorityCommentPlayers,
          isPriorityShare: _shopConfig.luckyWheelConfig.luckyWheelPrioritySharers,
          hasOrder: _shopConfig.luckyWheelConfig.luckyWheelHasOrder,
          isIgnorePriorityWinner: _shopConfig.luckyWheelConfig.luckyWheelPriorityIgnoreWinner,
          isPriorityShareGroup: _shopConfig.luckyWheelConfig.luckyWheelPriorityGroupSharers,
          isPrioritySharePersonal: _shopConfig.luckyWheelConfig.luckyWheelPriorityPersonalSharers,
          isSkipWinner: _shopConfig.luckyWheelConfig.luckyWheelIgnoreWinnerPlayer,
          numberSkipDays: _shopConfig.luckyWheelConfig.luckyWheelSkipDays,
          timeInSecond: _shopConfig.luckyWheelConfig.luckyWheelTimeInSecond,
          isPriority: _shopConfig.luckyWheelConfig.luckyWheelIsPriority,
          useShareApi: _shopConfig.luckyWheelConfig.luckyWheelUseApi,
          minNumberComment: _shopConfig.luckyWheelConfig.luckyWheelMinNumberComment,
          minNumberShare: _shopConfig.luckyWheelConfig.luckyWheelMinNumberShare,
          minNumberShareGroup: _shopConfig.luckyWheelConfig.luckyWheelMinNumberShareGroup,
          isPriorityUnWinner: _shopConfig.luckyWheelConfig.luckyWheelPriorityUnWinner,
          isMinComment: _shopConfig.luckyWheelConfig.luckyWheelIsMinComment,
          isMinShare: _shopConfig.luckyWheelConfig.luckyWheelIsMinShare,
          isMinShareGroup: _shopConfig.luckyWheelConfig.luckyWheelIsMinShareGroup);
      _userShareApi = _luckyWheelSetting.useShareApi;
      yield* _load();
    } else if (event is GameLuckyWheelStarted) {
      final List<int> allNumbers = <int>[];
      final DateTime now = DateTime.now();
      _winPlayer = null;

      for (final Player player in _validPlayers) {
        allNumbers.add(player.id);

        if (!_luckyWheelSetting.isPriority) {
          continue;
        }

        ///Kiểm tra xem người chơi có từng thắng trước đây không, nếu thắng trước đây xem số ngày thắng có nằm trong
        ///ngày của cài đặt không
        if (_luckyWheelSetting.isIgnorePriorityWinner &&
            !_luckyWheelSetting.isSkipWinner &&
            player.lastWinDate != null) {
          final int differentDays = now.difference(player.lastWinDate).inDays;

          if (differentDays <= _luckyWheelSetting.numberSkipDays) {
            continue;
          }
        }

        if (_luckyWheelSetting.isPriorityUnWinner && !player.isWinner) {
          allNumbers.add(player.id);
        }

        if (_luckyWheelSetting.useShareApi) {
          ///Nếu có chọn share thì ta thêm tỉ lệ tương ứng với số lượng share
          if (_luckyWheelSetting.isPriorityShare && player.shareCount > 0) {
            allNumbers.addAll(List.generate(player.shareCount, (genIndex) => player.id));
          }

          if (_luckyWheelSetting.isPriorityShareGroup) {
            allNumbers.addAll(List.generate(player.groupShareCount, (genIndex) => player.id));
          }
        } else {
          ///Nếu có chọn comment thì ta thêm tỉ lệ tương ứng với số lượng comment
          // if (_luckyWheelSetting.isPriorityComment && player.commentCount > 0) {
          //   allNumbers.addAll(
          //       List.generate(player.commentCount, (genIndex) => player.id));
          // }

        }
      }

      if (_validPlayers.isNotEmpty) {
        ///random index trong danh sách
        final int randomIndex = Random().nextInt(allNumbers.length);
        _winPlayer = _validPlayers.firstWhere((element) => element.id == allNumbers[randomIndex]);

        yield GameLuckyWheelFinished(
            players: _validPlayers, winPlayer: _winPlayer, setting: _luckyWheelSetting, winners: _lastWinners);
      } else {
        yield GameLuckyWheelGameStartError(error: 'Không có người chơi');
        return;
      }
    } else if (event is GameLuckyWheelPlayerInserted) {
      final Player player = event.player;
      bool check = false;
      if (_luckyWheelSetting.isSkipWinner && player.isWinner) {
        check = true;
      }
      if (_luckyWheelSetting.useShareApi) {
        if (player.shareCount < _luckyWheelSetting.minNumberShare && _luckyWheelSetting.isMinShare) {
          check = true;
        }

        if (player.groupShareCount < _luckyWheelSetting.minNumberShareGroup && _luckyWheelSetting.isMinShareGroup) {
          check = true;
        }
      } else {
        if (player.commentCount < _luckyWheelSetting.minNumberComment && _luckyWheelSetting.isMinComment) {
          check = true;
        }
      }

      if (_luckyWheelSetting.hasOrder && !player.hasOrder) {
        check = true;
      }

      if (check) {
        yield GameLuckyWheelGameError(error: 'Người chơi không có đủ điều kiện');
        yield GameLuckyWheelLoadSuccess(players: _validPlayers, setting: _luckyWheelSetting, winners: _lastWinners);
      } else {
        _validPlayers.add(player);
        yield GameLuckyWheelInsertSuccess(players: _validPlayers, setting: _luckyWheelSetting, winners: _lastWinners);
      }
    } else if (event is GameLuckyWheelSaveConfig) {
      yield GameLuckyWheelBusy();
      _luckyWheelSetting = event.luckyWheelSetting;
      _shopConfig.luckyWheelConfig.setLuckyWheelIsPriority(_luckyWheelSetting.isPriority);
      _shopConfig.luckyWheelConfig.setLuckyWheelHasOrder(_luckyWheelSetting.hasOrder);
      _shopConfig.luckyWheelConfig.setLuckyWheelIgnoreWinnerPlayer(_luckyWheelSetting.isSkipWinner);
      _shopConfig.luckyWheelConfig.setLuckyWheelPrioritySharers(_luckyWheelSetting.isPriorityShare);
      _shopConfig.luckyWheelConfig.setLuckyWheelPriorityGroupSharers(_luckyWheelSetting.isPriorityShareGroup);
      _shopConfig.luckyWheelConfig.setLuckyWheelPriorityPersonalSharers(_luckyWheelSetting.isPrioritySharePersonal);
      _shopConfig.luckyWheelConfig.setLuckyWheelPriorityIgnoreWinner(_luckyWheelSetting.isIgnorePriorityWinner);
      _shopConfig.luckyWheelConfig.setLuckyWheelTimeInSecond(_luckyWheelSetting.timeInSecond);
      _shopConfig.luckyWheelConfig.setLuckyWheelSkipDays(_luckyWheelSetting.numberSkipDays);
      _shopConfig.luckyWheelConfig.setLuckyWheelPriorityCommentPlayers(_luckyWheelSetting.isPriorityComment);
      _shopConfig.luckyWheelConfig.setLuckyWheelMinNumberComment(_luckyWheelSetting.minNumberComment);
      _shopConfig.luckyWheelConfig.setLuckyWheelMinNumberShare(_luckyWheelSetting.minNumberShare);
      _shopConfig.luckyWheelConfig.setLuckyWheelMinNumberShareGroup(_luckyWheelSetting.minNumberShareGroup);
      _shopConfig.luckyWheelConfig.setLuckyWheelPriorityUnWinner(_luckyWheelSetting.isPriorityUnWinner);
      _shopConfig.luckyWheelConfig.setLuckyWheelUseApi(_luckyWheelSetting.useShareApi);
      _shopConfig.luckyWheelConfig.setLuckyWheelIsMinComment(_luckyWheelSetting.isMinComment);
      _shopConfig.luckyWheelConfig.setLuckyWheelIsMinShare(_luckyWheelSetting.isMinShareGroup);
      _shopConfig.luckyWheelConfig.setLuckyWheelIsMinShareGroup(_luckyWheelSetting.isMinShareGroup);
      _validPlayers.clear();

      if (_userShareApi != _luckyWheelSetting.useShareApi) {
        _isLoadPlayer = false;
        _userShareApi = _luckyWheelSetting.useShareApi;
      }

      yield* _load();
    } else if (event is GameLuckyWheelWinnerUpdateLocal) {
      _lastWinners = event.players;
      yield GameLuckyWheelLoadSuccess(players: _validPlayers, setting: _luckyWheelSetting, winners: _lastWinners);
    } else if (event is GameLuckyWheelPlayerShared) {
      try {
        yield GameLuckyWheelBusy();
        await _facebookApi.postMessage(
            message: 'Người thắng cuộc trong vòng quay may mắn là ${event.winner.name}', accessToken: _accessToken);
        yield GameLuckyWheelShareSuccess(players: _validPlayers, setting: _luckyWheelSetting, winners: _lastWinners);
      } catch (e, stack) {
        _logger.e('GameLuckyWheelGameError', e, stack);
        yield GameLuckyWheelGameError(error: e.toString());
      }
    } else if (event is GameLuckyWheelRefreshed) {
      yield GameLuckyWheelLoading();
      _isLoadPlayer = false;
      _isLoadLastWinner = false;
      yield* _load();
    } else if (event is GameLuckyWheelWinnerSaved) {
      try {
        yield GameLuckyWheelBusy();

        ///TODO(sangcv): đối với danh sách người chơi lấy từ share thì đợi api bổ sung asuId vào hàm getshared
        await _tposFacebookApi.updateFacebookWinner(TposFacebookWinner(
          // facebookUId: _winPlayer.uId,
          // dateCreated: DateTime.now(),
          facebookASUId: _winPlayer.asuId,
          facebookName: _winPlayer.name,
          facebookPostId: _postId,
        ));

        try {
          await _loadWinners();
        } catch (e, stack) {
          _logger.e('GameLuckyWheelWinnerGetError', e, stack);
          yield GameLuckyWheelWinnerGetError(error: e.toString());
        }

        yield GameLuckyWheelWinnerSaveSuccess(
            players: _validPlayers, setting: _luckyWheelSetting, winners: _lastWinners);
      } catch (e, stack) {
        _logger.e('GameLuckyWheelWinnerSaveError', e, stack);
        yield GameLuckyWheelWinnerSaveError(error: e.toString());
      }
    } else if (event is GameLuckyWheelWinnerPrinted) {
      try {
        yield GameLuckyWheelBusy();

        final partnerWin = await _partnerApi.checkPartner(asuid: _winPlayer.asuId, crmTeamId: _crmTeam?.id);

        Partner customer;
        if (partnerWin != null && partnerWin.value.isNotEmpty) {
          customer = partnerWin?.value?.first;
        }

        await _print.printGame(
          name: _winPlayer.name,
          uid: _winPlayer.uId,
          phone: customer?.phone ?? '',
          partnerCode: customer?.ref ?? '',
        );
        yield GameLuckyWheelWinnerPrintSuccess(
            players: _validPlayers, setting: _luckyWheelSetting, winners: _lastWinners);
      } catch (e, stack) {
        _logger.e('GameLuckyWheelWinnerPrintError', e, stack);
        yield GameLuckyWheelWinnerPrintError(error: e.toString());
      }
    }
  }

  Future<void> _loadPlayers() async {
    if (_luckyWheelSetting.useShareApi) {
      _faceBookShareInfoList =
          await _tposApi.getSharedFacebook(_postId, _crmTeam?.facebookId, teamId: _crmTeam?.id, mapUid: true);
      for (final FacebookShareInfo faceBookShareInfo in _faceBookShareInfoList) {
        if (_players.any((Player player) => player.uId == faceBookShareInfo.from?.id)) {
          /// Kiểm tra xem share nhóm hay share cá nhân
          final Player player = _players.firstWhere((Player item) => item.uId == faceBookShareInfo.from?.id);

          if (faceBookShareInfo.permalinkUrl.contains('/groups') &&
              !faceBookShareInfo.permalinkUrl.contains('/posts') &&
              !faceBookShareInfo.permalinkUrl.contains('/story_fbid')) {
            player.groupShareCount += 1;
            player.shareCount += 1;
          } else {
            player.personalShareCount += 1;
            player.shareCount += 1;
          }
        } else {
          final Player player = Player(
              uId: faceBookShareInfo.from?.id,
              name: faceBookShareInfo.from?.name,
              picture: faceBookShareInfo.from?.pictureLink,
              asuId: faceBookShareInfo.objectId);

          if (faceBookShareInfo.permalinkUrl.contains('/groups') &&
              !faceBookShareInfo.permalinkUrl.contains('/posts') &&
              !faceBookShareInfo.permalinkUrl.contains('/story_fbid')) {
            player.groupShareCount += 1;
            player.shareCount += 1;
          } else {
            player.personalShareCount += 1;
            player.shareCount += 1;
          }
          player.id = _players.length;
          _players.add(player);
        }
      }
    } else {
      _postSummary = await _tposApi.getSaleOnlineFacebookPostSummaryUser(
        _postId,
        crmTeamId: _crmTeam?.id,
      );

      _users = _postSummary.users;
      for (final Users user in _users) {
        _players.add(Player(
          asuId: user.id,
          commentCount: user.countComment,
          shareCount: user.countShare,
          hasOrder: user.hasOrder,
          uId: user.uId,
          picture: user.picture,
          id: _players.length,
          name: user.name,
        ));
      }
    }
  }

  Future<void> _loadWinners() async {
    final OdataListResult<TposFacebookWinner> odataListResult = await _tposFacebookApi.getFacebookWinner();

    _faceBookWinners = odataListResult.value;
    for (final TposFacebookWinner facebookWinner in _faceBookWinners) {
      _lastWinners.add(Player(
          picture: 'http://graph.facebook.com/${facebookWinner.facebookUId}/'
              'picture?width=${500}&access_token=$_accessToken',
          uId: facebookWinner.facebookUId,
          name: facebookWinner.facebookName,
          lastWinDate: facebookWinner.dateCreated,
          totalDays: facebookWinner.totalDays,
          asuId: facebookWinner.facebookASUId));
      final Player player =
          _players.firstWhere((Player player) => player.uId == facebookWinner.facebookUId, orElse: () {
        return null;
      });
      if (player != null) {
        player.isWinner = true;
        player.totalDays = facebookWinner.totalDays;
        if (player.picture == null || player.picture == '') {
          player.picture = 'http://graph.facebook.com/${facebookWinner.facebookUId}/'
              'picture?width=${500}&access_token=$_accessToken';
        }
      }
    }
  }

  Stream<GameLuckyWheelState> _load() async* {
    try {
      if (!_isLoadPlayer) {
        _players.clear();
        await _loadPlayers();
        _isLoadPlayer = true;
      }

      if (!_isLoadLastWinner) {
        await _loadWinners();
        _isLoadLastWinner = true;
      }

      _validPlayers.clear();
      for (final Player player in _players) {
        if (_luckyWheelSetting.isSkipWinner && player.isWinner) {
          continue;
        }

        if (_luckyWheelSetting.useShareApi) {
//          if (_luckyWheelSetting.hasShare && player.shareCount == 0) {
//            continue;
//          }
          if (player.shareCount < _luckyWheelSetting.minNumberShare && _luckyWheelSetting.isMinShare) {
            continue;
          }

          if (player.groupShareCount < _luckyWheelSetting.minNumberShareGroup && _luckyWheelSetting.isMinShareGroup) {
            continue;
          }
        } else {
//          if (_luckyWheelSetting.hasComment && player.commentCount == 0) {
//            continue;
//          }

          if (player.commentCount < _luckyWheelSetting.minNumberComment && _luckyWheelSetting.isMinComment) {
            continue;
          }
        }

        if (_luckyWheelSetting.hasOrder && !player.hasOrder) {
          continue;
        }

        _validPlayers.add(player);
      }

      yield GameLuckyWheelInitialSuccess(players: _validPlayers, setting: _luckyWheelSetting, winners: _lastWinners);
    } catch (e, stack) {
      _logger.e('GameLuckyWheelLoadFailure', e, stack);
      yield GameLuckyWheelLoadFailure(error: e.toString());
    }
  }
}
