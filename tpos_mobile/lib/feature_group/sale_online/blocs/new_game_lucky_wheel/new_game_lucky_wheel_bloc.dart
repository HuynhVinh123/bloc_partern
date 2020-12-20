import 'dart:math';

import 'package:facebook_api_client/facebook_api_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/new_game_lucky_wheel/new_game_lucky_wheel_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/new_game_lucky_wheel/new_game_lucky_wheel_state.dart';
import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/lucky_wheel_setting.dart';
import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/player.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/FacebookWinner.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';

class GameLuckyWheelBloc extends Bloc<GameLuckyWheelEvent, GameLuckyWheelState> {
  GameLuckyWheelBloc({ITposApiService tposApi, ConfigService configService, FacebookApi facebookApi})
      : super(GameLuckyWheelLoading()) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _configService = configService ?? GetIt.I<ConfigService>();
    _facebookApi = facebookApi ?? GetIt.I<FacebookApi>();
  }

  FacebookApi _facebookApi;
  ITposApiService _tposApi;
  final Logger _logger = Logger();
  ConfigService _configService;
  final List<Player> _players = [
    Player(
        name: 'Đào Duy Trọng Hậu',
        commentCount: 100,
        shareCount: 0,
        picture:
            'https://platform-lookaside.fbsbx.com/platform/profilepic/?psid=3750045531693723&height=50&width=50&ext=1608351293&hash=AeRd5Bk-SrFA4y2Xufc',
        id: 11,
        uId: '3750045531693723',
        hasOrder: false,
        isWinner: true,
        groupShareCount: 0,
        personalShareCount: 0,
        dateCreated: DateTime.now()),
    Player(
        name: 'Huỳnh Vinh',
        commentCount: 150,
        shareCount: 0,
        picture:
            'https://platform-lookaside.fbsbx.com/platform/profilepic/?psid=3810276275669237&height=50&width=50&ext=1608351293&hash=AeS2d2BgSlxI-oCbpgk',
        id: 12,
        uId: '3810276275669237',
        hasOrder: false,
        isWinner: true,
        groupShareCount: 0,
        personalShareCount: 0,
        dateCreated: DateTime.now()),
    Player(
        name: 'Hoa súng',
        commentCount: 0,
        shareCount: 10,
        picture: 'https://image2.baonghean.vn/w607/Uploaded/2020/reeaekxlxk/2018_01_04/34617298_412018.jpg',
        id: 2,
        uId: '2',
        hasOrder: false,
        groupShareCount: 5,
        personalShareCount: 5,
        dateCreated: DateTime.now()),
    Player(
        name: 'Hoa súng',
        commentCount: 0,
        shareCount: 10,
        picture: 'https://image2.baonghean.vn/w607/Uploaded/2020/reeaekxlxk/2018_01_04/34617298_412018.jpg',
        id: 3,
        uId: '3',
        hasOrder: true,
        groupShareCount: 5,
        personalShareCount: 5,
        dateCreated: DateTime.now()),
    Player(
        name: 'Sang',
        commentCount: 10,
        shareCount: 10,
        picture: 'https://icapi.org/wp-content/uploads/2019/11/hinh-anh-trai-tim-52.jpg',
        id: 4,
        uId: '4',
        isWinner: true,
        hasOrder: true,
        groupShareCount: 5,
        personalShareCount: 5,
        dateCreated: DateTime.now()),
    Player(
        name: 'Vanss',
        commentCount: 20,
        isWinner: false,
        shareCount: 20,
        picture: 'https://znews-photo.zadn.vn/w1024/Uploaded/qhj_yvobvhfwbv/2018_07_18/Nguyen_Huy_Binh1.jpg',
        id: 5,
        uId: '5',
        groupShareCount: 10,
        personalShareCount: 10,
        dateCreated: DateTime.now().subtract(const Duration(days: 10))),
    Player(
        id: 6,
        name: 'Hau',
        commentCount: 30,
        shareCount: 30,
        uId: '6',
        groupShareCount: 30,
        personalShareCount: 0,
        picture: 'https://tamnhinrong.org/tnr-9-hinh-anh-dep-ve-bien.jpg',
        dateCreated: DateTime.now().subtract(const Duration(days: 10))),
    Player(
        id: 7,
        name: 'Vinh',
        commentCount: 40,
        shareCount: 40,
        uId: '7',
        groupShareCount: 30,
        personalShareCount: 10,
        picture: 'https://tamnhinrong.org/tnr-9-hinh-anh-dep-ve-bien.jpg',
        dateCreated: DateTime.now().subtract(const Duration(days: 10))),
    Player(
      id: 8,
      name: 'A Nam',
      commentCount: 50,
      shareCount: 50,
      uId: '8',
      groupShareCount: 30,
      personalShareCount: 20,
      picture: 'https://tamnhinrong.org/tnr-9-hinh-anh-dep-ve-bien.jpg',
      dateCreated: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Player(
      id: 9,
      name: 'Test 1',
      commentCount: 60,
      shareCount: 60,
      groupShareCount: 40,
      uId: '9',
      personalShareCount: 20,
      lastWinDate: DateTime.now().add(const Duration(days: 2)),
      picture: 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcR6D4Exfd2VITC4bOMaRITxSKjZYHQUVZSgUQ&usqp=CAU',
      dateCreated: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Player(
      id: 10,
      name: 'Nguời chơi pro',
      commentCount: 60,
      shareCount: 60,
      uId: '10',
      groupShareCount: 40,
      personalShareCount: 20,
      lastWinDate: DateTime.now().add(const Duration(days: 2)),
      picture: 'https://ttol.vietnamnetjsc.vn/images/2018/05/25/13/40/net-cuoi-be-gai-9-1527053440039156820618.jpg',
      dateCreated: DateTime.now().subtract(const Duration(days: 20)),
    ),
  ];

  List<Player> _lastWinners = [];
  final List<Player> _validPlayers = [];
  Player _winPlayer;

  LuckyWheelSetting _luckyWheelSetting;
  String _accessToken;

  @override
  Stream<GameLuckyWheelState> mapEventToState(GameLuckyWheelEvent event) async* {
    if (event is GameLuckyWheelLoaded) {
      try {
        _accessToken = event.token;
        yield GameLuckyWheelLoading();
        _luckyWheelSetting = LuckyWheelSetting(
          hasComment: _configService.luckyWheelHasComment,
          isPriorityComment: _configService.luckyWheelPriorityCommentPlayers,
          isPriorityShare: _configService.luckyWheelPrioritySharers,
          hasOrder: _configService.luckyWheelHasOrder,
          isIgnorePriorityWinner: _configService.luckyWheelPriorityIgnoreWinner,
          hasShare: _configService.luckyWheelHasShare,
          isPriorityShareGroup: _configService.luckyWheelPriorityGroupSharers,
          isPrioritySharePersonal: _configService.luckyWheelPriorityPersonalSharers,
          isSkipWinner: _configService.luckyWheelIgnoreWinnerPlayer,
          numberSkipDays: _configService.luckyWheelSkipDays,
          timeInSecond: _configService.luckyWheelTimeInSecond,
          isPriority: _configService.luckyWheelIsPriority,
        );

        ///TODO(sangcv): thêm dòng này để test chức năng gửi tin nhắn, sẽ xóa sau
        _lastWinners.add(Player(
            name: 'Đào Duy Trọng Hậu',
            commentCount: 100,
            shareCount: 0,
            totalDays: 10,
            picture:
                'https://platform-lookaside.fbsbx.com/platform/profilepic/?psid=3750045531693723&height=50&width=50&ext=1608351293&hash=AeRd5Bk-SrFA4y2Xufc',
            id: 11,
            uId: '3750045531693723',
            hasOrder: false,
            isWinner: true,
            lastWinDate: DateTime.now(),
            groupShareCount: 0,
            personalShareCount: 0,
            dateCreated: DateTime.now()));
        _lastWinners.add(Player(
            name: 'Huỳnh Vinh',
            commentCount: 150,
            shareCount: 0,
            totalDays: 15,
            picture:
                'https://platform-lookaside.fbsbx.com/platform/profilepic/?psid=3810276275669237&height=50&width=50&ext=1608351293&hash=AeS2d2BgSlxI-oCbpgk',
            id: 12,
            uId: '3810276275669237',
            hasOrder: false,
            lastWinDate: DateTime.now(),
            isWinner: true,
            groupShareCount: 0,
            personalShareCount: 0,
            dateCreated: DateTime.now()));

        final List<FacebookWinner> faceBookWinners = await _tposApi.getFacebookWinner();
        for (final FacebookWinner facebookWinner in faceBookWinners) {
          _lastWinners.add(Player(
              picture: 'http://graph.facebook.com/${facebookWinner.facebookUId}/'
                  'picture?width=${500}&access_token=${event.token}',
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
          }
        }

        _validPlayers.clear();
        for (final Player player in _players) {
          if (_luckyWheelSetting.isSkipWinner && player.isWinner) {
            continue;
          }

          if (_luckyWheelSetting.hasComment && player.commentCount == 0) {
            continue;
          }

          if (_luckyWheelSetting.hasShare && player.shareCount == 0) {
            continue;
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

          if (differentDays < _luckyWheelSetting.numberSkipDays) {
            continue;
          }
        }

        ///Nếu có chọn share thì ta thêm tỉ lệ tương ứng với số lượng share
        if (_luckyWheelSetting.isPriorityShare && player.shareCount > 0) {
          if (_luckyWheelSetting.isPrioritySharePersonal) {
            allNumbers.addAll(List.generate(player.personalShareCount, (genIndex) => player.id));
          }

          if (_luckyWheelSetting.isPriorityShareGroup) {
            allNumbers.addAll(List.generate(player.groupShareCount, (genIndex) => player.id));
          }
        }

        ///Nếu có chọn comment thì ta thêm tỉ lệ tương ứng với số lượng comment
        if (_luckyWheelSetting.isPriorityComment && player.commentCount > 0) {
          allNumbers.addAll(List.generate(player.commentCount, (genIndex) => player.id));
        }
      }

      if (_validPlayers.isNotEmpty) {
        ///random index trong danh sách
        final int randomIndex = Random().nextInt(allNumbers.length);
        _winPlayer = _validPlayers.firstWhere((element) => element.id == allNumbers[randomIndex]);
      } else {
        yield GameLuckyWheelGameStartError(error: 'Không có người chơi');
      }

      yield GameLuckyWheelFinished(
          players: _validPlayers, winPlayer: _winPlayer, setting: _luckyWheelSetting, winners: _lastWinners);
    } else if (event is GameLuckyWheelPlayerInserted) {
      final Player player = event.player;
      if ((_luckyWheelSetting.isSkipWinner && player.lastWinDate != null) ||
          (_luckyWheelSetting.hasComment && player.commentCount == 0) ||
          (_luckyWheelSetting.hasShare && player.shareCount == 0) ||
          (_luckyWheelSetting.hasOrder && !player.hasOrder)) {
        yield GameLuckyWheelGameError(error: 'Người chơi không có đủ điều kiện');
        yield GameLuckyWheelLoadSuccess(players: _validPlayers, setting: _luckyWheelSetting, winners: _lastWinners);
      } else {
        _validPlayers.add(player);
        yield GameLuckyWheelInsertSuccess(players: _validPlayers, setting: _luckyWheelSetting, winners: _lastWinners);
      }
    } else if (event is GameLuckyWheelSaveConfig) {
      try {
        yield GameLuckyWheelBusy();
        _luckyWheelSetting = event.luckyWheelSetting;
        _configService.setLuckyWheelHasComment(_luckyWheelSetting.hasComment);
        _configService.setLuckyWheelIsPriority(_luckyWheelSetting.isPriority);
        _configService.setLuckyWheelHasShare(_luckyWheelSetting.hasShare);
        _configService.setLuckyWheelHasOrder(_luckyWheelSetting.hasOrder);
        _configService.setLuckyWheelIgnoreWinnerPlayer(_luckyWheelSetting.isIgnorePriorityWinner);
        _configService.setLuckyWheelPrioritySharers(_luckyWheelSetting.isPriorityShare);
        _configService.setLuckyWheelPriorityGroupSharers(_luckyWheelSetting.isPriorityShareGroup);
        _configService.setLuckyWheelPriorityPersonalSharers(_luckyWheelSetting.isPrioritySharePersonal);
        _configService.setLuckyWheelPriorityIgnoreWinner(_luckyWheelSetting.isIgnorePriorityWinner);
        _configService.setLuckyWheelPriorityIgnoreWinnerDay(_luckyWheelSetting.numberSkipDays);
        _configService.setLuckyWheelTimeInSecond(_luckyWheelSetting.timeInSecond);
        _configService.setLuckyWheelSkipDays(_luckyWheelSetting.numberSkipDays);

        _validPlayers.clear();
        for (final Player player in _players) {
          if (_luckyWheelSetting.isSkipWinner && player.isWinner) {
            continue;
          }

          if (_luckyWheelSetting.hasComment && player.commentCount == 0) {
            continue;
          }

          if (_luckyWheelSetting.hasShare && player.shareCount == 0) {
            continue;
          }

          if (_luckyWheelSetting.hasOrder && !player.hasOrder) {
            continue;
          }
          _validPlayers.add(player);
        }

        yield GameLuckyWheelLoadSuccess(players: _validPlayers, setting: _luckyWheelSetting, winners: _lastWinners);
      } catch (e, stack) {
        _logger.e('GameLuckyWheelGameError', e, stack);
        yield GameLuckyWheelGameError(error: e.toString());
        yield GameLuckyWheelLoadSuccess(players: _validPlayers, setting: _luckyWheelSetting, winners: _lastWinners);
      }
    } else if (event is GameLuckyWheelWinnerUpdateLocal) {
      _lastWinners = event.players;
      yield GameLuckyWheelLoadSuccess(players: _validPlayers, setting: _luckyWheelSetting, winners: _lastWinners);
    } else if (event is GameLuckyWheelPlayerShared) {
      try {
        yield GameLuckyWheelBusy();
        // await _facebookApi.postMessage(
        //     message: 'Người thắng cuộc trong vòng quay may mắn là ${event.winner.name}', accessToken: _accessToken);
        yield GameLuckyWheelShareSuccess(players: _validPlayers, setting: _luckyWheelSetting, winners: _lastWinners);
      } catch (e, stack) {
        _logger.e('GameLuckyWheelGameError', e, stack);
        yield GameLuckyWheelGameError(error: e.toString());
        yield GameLuckyWheelLoadSuccess(players: _validPlayers, setting: _luckyWheelSetting, winners: _lastWinners);
      }
    }else if(event is GameLuckyWheelRefreshed){
      try {
        yield GameLuckyWheelLoading();
        _luckyWheelSetting = LuckyWheelSetting(
          hasComment: _configService.luckyWheelHasComment,
          isPriorityComment: _configService.luckyWheelPriorityCommentPlayers,
          isPriorityShare: _configService.luckyWheelPrioritySharers,
          hasOrder: _configService.luckyWheelHasOrder,
          isIgnorePriorityWinner: _configService.luckyWheelPriorityIgnoreWinner,
          hasShare: _configService.luckyWheelHasShare,
          isPriorityShareGroup: _configService.luckyWheelPriorityGroupSharers,
          isPrioritySharePersonal: _configService.luckyWheelPriorityPersonalSharers,
          isSkipWinner: _configService.luckyWheelIgnoreWinnerPlayer,
          numberSkipDays: _configService.luckyWheelSkipDays,
          timeInSecond: _configService.luckyWheelTimeInSecond,
          isPriority: _configService.luckyWheelIsPriority,
        );

        ///TODO(sangcv): thêm dòng này để test chức năng gửi tin nhắn, sẽ xóa sau
        _lastWinners.add(Player(
            name: 'Đào Duy Trọng Hậu',
            commentCount: 100,
            shareCount: 0,
            totalDays: 10,
            picture:
            'https://platform-lookaside.fbsbx.com/platform/profilepic/?psid=3750045531693723&height=50&width=50&ext=1608351293&hash=AeRd5Bk-SrFA4y2Xufc',
            id: 11,
            uId: '3750045531693723',
            hasOrder: false,
            isWinner: true,
            lastWinDate: DateTime.now(),
            groupShareCount: 0,
            personalShareCount: 0,
            dateCreated: DateTime.now()));
        _lastWinners.add(Player(
            name: 'Huỳnh Vinh',
            commentCount: 150,
            shareCount: 0,
            totalDays: 15,
            picture:
            'https://platform-lookaside.fbsbx.com/platform/profilepic/?psid=3810276275669237&height=50&width=50&ext=1608351293&hash=AeS2d2BgSlxI-oCbpgk',
            id: 12,
            uId: '3810276275669237',
            hasOrder: false,
            lastWinDate: DateTime.now(),
            isWinner: true,
            groupShareCount: 0,
            personalShareCount: 0,
            dateCreated: DateTime.now()));

        final List<FacebookWinner> faceBookWinners = await _tposApi.getFacebookWinner();
        for (final FacebookWinner facebookWinner in faceBookWinners) {
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
          }
        }

        _validPlayers.clear();
        for (final Player player in _players) {
          if (_luckyWheelSetting.isSkipWinner && player.isWinner) {
            continue;
          }

          if (_luckyWheelSetting.hasComment && player.commentCount == 0) {
            continue;
          }

          if (_luckyWheelSetting.hasShare && player.shareCount == 0) {
            continue;
          }

          if (_luckyWheelSetting.hasOrder && !player.hasOrder) {
            continue;
          }

          _validPlayers.add(player);
        }

        yield GameLuckyWheelLoadSuccess(players: _validPlayers, setting: _luckyWheelSetting, winners: _lastWinners);
      } catch (e, stack) {
        _logger.e('GameLuckyWheelLoadFailure', e, stack);
        yield GameLuckyWheelLoadFailure(error: e.toString());
      }

    }
  }
}
