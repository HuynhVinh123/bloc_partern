import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/FacebookWinner.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/config_service/shop_config_service.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/dialog_service/new_dialog_service.dart';
import 'package:tpos_mobile/services/print_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/sale_online_facebook_post_summary_user.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';

import 'new_facebook_post_comment_viewmodel.dart';

class LuckyWheelViewModel extends ScopedViewModel {
  LuckyWheelViewModel({
    ITposApiService tposApi,
    PrintService printService,
    PartnerApi partnerApi,
    DialogService dialog,
    ShopConfigService shopConfigService,
    NewDialogService newDialog,
  }) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _dialog = dialog ?? locator<DialogService>();
    _print = printService ?? locator<PrintService>();
    _partnerApi = partnerApi ?? GetIt.I<PartnerApi>();
    _shopConfig = shopConfigService ?? GetIt.I<ShopConfigService>();
    _newDialog = newDialog ?? GetIt.I<NewDialogService>();
  }
  //log
  final log = Logger("LuckyWheelViewModel");
  ShopConfigService _shopConfig;
  ITposApiService _tposApi;
  PartnerApi _partnerApi;
  DialogService _dialog;
  NewDialogService _newDialog;
  PrintService _print;

  NewFacebookPostCommentViewModel _commentViewmodel;
  String _postId;

  CRMTeam _crmTeam;

  /// Đang chơi
  bool isPlaying = false;

  /// Đang chuẩn bị
  bool isPrepaing = false;

  String _winnerAvatar;

  String get winnerAvatar => _winnerAvatar;

  int get playerShareCount {
    if (_players == null || _players.length == 0) return 0;
    return _players.map((f) => f.countShare).reduce((p1, p2) => p1 + p2);
  }

  int get playerCommentCount {
    if (_players == null || _players.length == 0) return 0;
    return _players.map((f) => f.countComment).reduce((p1, p2) => p1 + p2);
  }

  static const String REFRESH_PLAYER_EVENT = "REFRESH_PLAYER_EVENT";

  /// Thời gian chơi game tính bằng giây
  int get gameDurationSecond =>
      _shopConfig.oldLuckyWheelConfig.gameDurationInSecond ?? 12;

  /// Khởi tạo dữ liệu ban đầu và nhận tham số
  void init({
    @required String postId,
    @required String facebookUid,
    @required CRMTeam crmTeam,
    @required NewFacebookPostCommentViewModel commentVM,
  }) {
    assert(postId != null);
    assert(facebookUid != null);

    this._postId = postId;
    this._crmTeam = crmTeam;
    this._commentViewmodel = commentVM;
  }

  SaleOnlineFacebookPostSummaryUser postSummary =
      new SaleOnlineFacebookPostSummaryUser();

  /// Danh sách người chơi được phép tham dự
  List<Users> _players;

  List<Users> get players => _players;
  Users _winPlayer;

  int get winPlayerIndex {
    if (_winPlayer != null) {
      return _players.indexOf(_winPlayer);
    } else
      return 0;
  }

  Users get winPlayer => _winPlayer;
  List<FacebookWinner> _facebookWinners = new List<FacebookWinner>();
  FacebookWinner facebookWinner = new FacebookWinner();

  List<FacebookWinner> get facebookWinners => _facebookWinners;
  BehaviorSubject<List<FacebookWinner>> _facebookWinnersController =
      new BehaviorSubject();

  Stream<List<FacebookWinner>> get facebookWinnersStream =>
      _facebookWinnersController.stream;

  BehaviorSubject<List<Users>> _playersController = new BehaviorSubject();

  Stream<List<Users>> get playersStream => _playersController.stream;

  List<int> allNumbers = [];
  List<Users> tempUsers = [];
  List<Users> fbSharedUsers = [];
  List<Users> fbCommentUsers = [];
  List<AvailableInsertPartners> _partner;

  /// Lấy danh sách toàn bộ người chơi
  Future<void> _fetchPlayers() async {
    postSummary = await _tposApi.getSaleOnlineFacebookPostSummaryUser(
      _postId,
      crmTeamId: _crmTeam?.id,
    );
    fbCommentUsers = postSummary.users;
    _partner = postSummary.availableInsertPartners;
  }

  /// Lấy danh sách những người đã trúng thưởng trong quá khứ
  Future<void> _fetchFacebookWinners() async {
    _facebookWinners?.clear();
    var facebookWinners = await _tposApi.getFacebookWinner();
    if (facebookWinners != null) _facebookWinners.addAll(facebookWinners);
  }

  Future<void> printWin(String name, String uid,
      {String phone, String partnerCode}) async {
    try {
      await _print.printGame(
          name: name, uid: uid, phone: phone, partnerCode: partnerCode);
    } catch (e, s) {
      _dialog.showNotify(message: "In lỗi: ${e.toString()}");
      log.severe("", e, s);
    }
  }

  /// Lưu người thắng cuộc
  Future<void> updateFacebookWinner() async {
    try {
      if (_winPlayer != null) {
        facebookWinner.facebookName = _winPlayer.name;
//        facebookWinner.facebookUId = playerWin.uId;
        facebookWinner.facebookPostId = _postId;
        facebookWinner.facebookASUId = _winPlayer.id;
        //facebookWinner.dateCreated = DateTime.now();

        await _tposApi.updateFacebookWinner(facebookWinner);

        var partnerWin = await _partnerApi.checkPartner(
            asuid: _winPlayer.id, crmTeamId: _crmTeam?.id);

        var customer;
        if (partnerWin != null && partnerWin.value.isNotEmpty)
          customer = partnerWin?.value?.first;

        _dialog.showNotify(message: "Đã lưu người trúng");
        await _fetchFacebookWinners();
        _dialog.showNotify(message: "Đã cập nhật lại danh sách người trúng");
        await printWin(
          _winPlayer.name,
          _winPlayer.uId,
          phone: customer?.phone,
          partnerCode: customer?.ref,
        );
      }
    } catch (ex, stack) {
      log.severe("loadPlayers failed", ex, stack);
      var dialogResult = await _dialog.showError(
          title: "Đã có lỗi xảy ra", error: ex, isRetry: true);

      if (dialogResult != null && dialogResult.type == DialogResultType.RETRY) {
        updateFacebookWinner();
      }
    }
  }

  /// Cập nhật lại danh sách người chơi phù hợp với cấu hình
  Future<void> _refreshPlayer() async {
    if (tempUsers == null) return;
    if (_shopConfig.oldLuckyWheelConfig.isShareGame) {
      _shopConfig.oldLuckyWheelConfig.isOrderGame = false;
    }
    if (_shopConfig.oldLuckyWheelConfig.isShareGame &&
        !_shopConfig.oldLuckyWheelConfig.isCommentGame) {
      tempUsers = fbSharedUsers;
    } else if (!_shopConfig.oldLuckyWheelConfig.isShareGame &&
        !_shopConfig.oldLuckyWheelConfig.isCommentGame) {
      _players = null;
      return;
    } else {
      tempUsers = fbCommentUsers;
    }

    tempUsers ??= [];

    _players = tempUsers.where((f) {
      return (_shopConfig.oldLuckyWheelConfig.isOrderGame && f.hasOrder ||
              !_shopConfig.oldLuckyWheelConfig.isOrderGame) &&
          (!_shopConfig.oldLuckyWheelConfig.isWinGame &&
                  !_facebookWinners.any((s) => s.facebookASUId == f.id) ||
              _shopConfig.oldLuckyWheelConfig.isWinGame);
    }).toList();

    if (_players.length <= 1) {
      _players = [];
      //_newDialog.showToast(message: "Không đủ số người chơi");
      return;
    }

    if (_players.length < 3) {
      List<Users> temp = [];
      temp.addAll(_players);
      for (int i = 0; i <= _players.length - 1; i++) {
        Users newPlayer = Users();
        newPlayer.id = _players[i].id;
        newPlayer.countComment = _players[i].countComment;
        newPlayer.picture = _players[i].picture;
        newPlayer.name = _players[i].name;
        newPlayer.numbers = i == 0 ? [0, 1, 2] : [3, 4, 5];
        newPlayer.uId = "${_players[i].uId + '$i'}";
        newPlayer.hasOrder = _players[i].hasOrder;
        newPlayer.countShare = _players[i].countShare;
        temp.add(newPlayer);
      }
      _players = temp;
    }

    print(_players);
    print(_players.map((e) => e.id));
    print(_facebookWinners.map((e) => e.facebookASUId));
  }

  Future<void> startGame() async {
    // Những người đã trúng giải gần đây theo ngày được cài đặt
    final recentWinters = _facebookWinners
        .where(
          (f) => f.dateCreated.isAfter(
            DateTime.now().add(
              Duration(days: _shopConfig.oldLuckyWheelConfig.ignoreDays),
            ),
          ),
        )
        .toList();
    allNumbers = <int>[];
    int index = 0;
    for (int i = 0; i < _players.length; i++) {
      index = allNumbers.length - 1; // Khởi đầu = Chiều dài của [allNumber];
      _players[i].numbers.clear();
      // Bỏ qua người đã trúng thường gần đây
      if (_shopConfig.oldLuckyWheelConfig.isIgnoreRecentWinner) {
        if (recentWinters.any((f) => f.facebookUId == _players[i].uId)) {
          _players[i].numbers.add(index + 1);
          allNumbers.addAll(_players[i].numbers);
          continue;
        } else {
          _players[i].numbers.add(index + 1);
        }
      } else {
        _players[i].numbers.add(index + 1);
      }
      switch (_shopConfig.oldLuckyWheelConfig.isPriorGame) {
        case "comment":
          if (_players[i].countComment > 0) {
            _players[i].numbers.addAll(List.generate(
                _players[i].countComment, (genIndex) => genIndex + 2 + index));
          }
          break;
        case "share":
          if (_players[i].countShare > 0) {
            _players[i].numbers.addAll(List.generate(
                _players[i].countShare, (genIndex) => genIndex + 2 + index));
          }
          break;
        case "share_comment":
          _players[i].numbers.addAll(List.generate(
              _players[i].countComment + _players[i].countShare,
              (genIndex) => genIndex + 2 + index));

          break;
        default:
          _players[i].numbers.add(index + 2);

          break;
      }

      allNumbers.addAll(_players[i].numbers);
    }

//    print('''
////    Players: $_players
////    AllNumbers: $allNumbers
//    ''');
    if (allNumbers.length > 0) {
      var randomNumber = Random().nextInt(allNumbers.length);
      _winPlayer = players.firstWhere((f) => f.numbers.contains(randomNumber),
          orElse: () => null);
    }
  }

  Future<void> _tryGetShare() async {
    final int retry = 3;
    for (int i = 0; i < 3; i++) {
      try {
        final result = await _tposApi.getSharedFacebook(
            _postId, _crmTeam.userUidOrPageId,
            teamId: _crmTeam.id, mapUid: true);
        if (result.isNotEmpty) {
          fbSharedUsers = [];
          for (var item in result) {
            Users user = Users(
                name: item.from.name,
                id: item.from.id,
                picture: item.from.pictureLink,
                countShare: 1,
                countComment: 0,
                numbers: [],
                hasOrder: false,
                uId: item.from.id);
            if (result.any((element) => element.from.id == item.from.id)) {
              user.countShare = user.countShare + 1;
            }

            if (!fbSharedUsers.any((element) => element.id == item.from.id)) {
              fbSharedUsers.add(user);
            }
          }

          setBusy(true, message: "Đã thấy ${result.length} chia sẻ");
          _dialog.showNotify(message: "Đã thấy ${result.length} chia sẻ");
          break;
        }
      } catch (e, s) {
        logger.error("", e, s);
        _dialog.showNotify(type: AlertDialogType.error, message: e.toString());
      }
    }
  }

  Future<void> initCommand() async {
    setBusy(true, message: "Đang tải dữ liệu...");
    try {
      // Lưu bình luận
      setBusy(true, message: "Lưu bình luận...");
      await _commentViewmodel.saveComment();
      // Cập nhật share
      setBusy(true, message: "Cập nhật chia sẻ...");
      await _tryGetShare();
      // Tải dữ liệu
      setBusy(true, message: "Tìm người chơi...");
      await Future.wait([
        _fetchFacebookWinners(),
        _fetchPlayers(),
      ]);

      // Lọc người chơi theo cấu hình
      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));
      await _refreshPlayer();
      await Future.delayed(const Duration(seconds: 1));
      notifyListeners();
    } catch (e, s) {
      log.severe("initCommand", e, s);
      final dialogResult = await _dialog.showError(
        title: "Đã có lỗi xảy ra!",
        error: e,
        isRetry: true,
      );
      setBusy(false, message: "Đang tải dữ liệu...");
      if (dialogResult != null && dialogResult.type == DialogResultType.RETRY) {
        this.initCommand();
      }
    }
    setBusy(false, message: "Đang tải dữ liệu...");
    notifyListeners();
  }

  Future<void> refreshPlayer() async {
    print("refrsh palyers");
    try {
      await _refreshPlayer();
      notifyListeners();
      onEventAdd(REFRESH_PLAYER_EVENT, null);
    } catch (e, s) {
      log.severe("refresh player", e, s);
      _dialog.showError(title: "Đã xảy ra lỗi!", error: e);
    }
  }

  Future<void> fetchWinnerAvatar() async {
    try {
      print("fetchWinnerAvatar");
      print(_winPlayer?.id);
      //save winner avatar
      Directory tempDir = await getTemporaryDirectory();
      var fileName =
          "${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jfif";
      await Dio().download(
          "https://graph.facebook.com/${_winPlayer.id}/picture?height=320&width=320&access_token=${_crmTeam.userOrPageToken}",
          "$fileName");
      _winnerAvatar = fileName;
      print(_winnerAvatar);
    } catch (e, s) {
      logger.error("", e, s);
    }
  }

  @override
  void dispose() {
    _playersController?.close();
    _facebookWinnersController?.close();
    super.dispose();
  }
}
