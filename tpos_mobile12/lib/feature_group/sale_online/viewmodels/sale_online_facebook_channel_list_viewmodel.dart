import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_command.dart';
import 'package:tpos_mobile/feature_group/sale_online/services/service.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';

import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/dialog_service/new_dialog_service.dart';
import 'package:tpos_mobile/services/remote_config_service.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile/src/facebook_apis/facebook_api.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

class SaleOnlineFacebookChannelListViewModel extends ViewModel {
  SaleOnlineFacebookChannelListViewModel(
      {IFacebookApiService fbApi,
      ITposApiService tposApi,
      ISettingService setting,
      RemoteConfigService remoteConfig,
      DialogService dialog,
      CrmTeamApi crmTeamApi,
      NewDialogService dialogService}) {
    _fbApi = fbApi ?? locator<IFacebookApiService>();
    _tposApi = tposApi ?? locator<ITposApiService>();
    _setting = setting ?? locator<ISettingService>();
    _remoteConfig = remoteConfig ?? GetIt.I<RemoteConfigService>();
    _dialog = dialog ?? locator<DialogService>();
    _newDialog = dialogService ?? GetIt.I<NewDialogService>();
    _crmTeamApi = crmTeamApi ?? GetIt.I<CrmTeamApi>();
    _initCommand =
        ViewModelCommand(name: "Init", executeFunction: (param) => _init());

    _refreshCommand = ViewModelCommand(
        name: "Refresh", executeFunction: (param) => _refresh());

    _deleteFacebookChannelCommand = ViewModelCommand(
        name: "Delete facebook channel",
        executeFunction: (param) => _deleteFacebookChannel(param));

    _facebookLogin = FacebookLogin();
  }
  IFacebookApiService _fbApi;
  ITposApiService _tposApi;
  CrmTeamApi _crmTeamApi;
  ISettingService _setting;
  RemoteConfigService _remoteConfig;
  DialogService _dialog;
  NewDialogService _newDialog;
  final Logger _log = Logger("SaleOnlineFacebookChannelListViewModel");

  List<CRMTeam> _crmTeams;
  FacebookUser _loginedFacebookUser;
  FacebookLogin _facebookLogin;

  ViewModelCommand _initCommand;
  ViewModelCommand _refreshCommand;
  ViewModelCommand _addPageCommand;
  ViewModelCommand _deleteFacebookChannelCommand;

  List<CRMTeam> get crmTeams => _crmTeams;
  ViewModelCommand get initCommand => _initCommand;
  ViewModelCommand get refreshCommand => _refreshCommand;
  ViewModelCommand get addPageCommand => _addPageCommand;

  ViewModelCommand get deleteFacebookChannelCommand =>
      _deleteFacebookChannelCommand;

  bool get isFacebookLoggined => _setting.facebookAccessToken != null;
  bool get isFacebookNotInCrmteams {
    if (_crmTeams == null) {
      return true;
    }

    return !_crmTeams
            .any((f) => f.facebookASUserId == _loginedFacebookUser?.id) &&
        isFacebookLoggined == true;
  }

  FacebookUser get loginedFacebookUser => _loginedFacebookUser;
  Future<void> _init() async {
    onStateAdd(true);
    try {
      await _refreshFacebookChannel();
      await _refreshFacebookLoginUser();

      notifyListeners();
    } catch (e, s) {
      _log.severe("init", e, s);
      _dialog.showError(error: e, isRetry: true).then(
        (result) {
          if (result != null && result.type == DialogResultType.RETRY) {
            _init();
          } else if (result != null && result.type == DialogResultType.GOBACK) {
            onEventAdd("GO_BACK", null);
          }
        },
      );
    }
    onStateAdd(false);
  }

  Future<void> _refresh() async {
    onStateAdd(true);
    try {
      await _refreshFacebookChannel();
      await _refreshFacebookLoginUser();
      notifyListeners();
    } catch (e, s) {
      _log.severe("init", e, s);
      _newDialog.showDialog(
        type: AlertDialogType.error,
        title: 'Đa xảy ra lỗi',
        content: e.toString(),
      );
    }
    onStateAdd(false);
  }

  /// Refresh Facebook channel
  Future<void> _refreshFacebookChannel() async {
    final result = await _crmTeamApi.getAllFacebook();
    _crmTeams = result.value;
  }

  Future<void> _refreshFacebookLoginUser() async {
    if (_setting.facebookAccessToken != null) {
      _loginedFacebookUser = await _fbApi.getFacebookUserInfo(
          accessToken: _setting.facebookAccessToken);
    }
  }

  Future<void> _tryRefreshFacebookLoginUser() async {
    try {
      await _refreshFacebookLoginUser();
      notifyListeners();
    } catch (e, s) {
      _log.severe("", e, s);
    }
  }

  Future<void> logoutFacebook() async {
    await _logoutFacebook();
  }

  Future<void> loginFacebook(bool native) async {
    try {
      await _logoutFacebook();

      _facebookLogin = FacebookLogin();
      if (native == false) {
        _facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
      } else {
        _facebookLogin.loginBehavior = FacebookLoginBehavior.nativeOnly;
      }
      final result = await _facebookLogin.logIn(
        _remoteConfig.facebookOption.permissions,
      );

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          _setting.facebookAccessToken = result.accessToken.token;
          _tryRefreshFacebookLoginUser();
          notifyListeners();
          break;
        case FacebookLoginStatus.cancelledByUser:
          break;
        case FacebookLoginStatus.error:
          _newDialog.showDialog(
            type: AlertDialogType.error,
            content: result.errorMessage,
          );
          break;
      }
    } catch (e, s) {
      _log.severe("login facebook", e, s);
      _newDialog.showDialog(
        type: AlertDialogType.error,
        content: e.toString(),
      );
    }
  }

  Future<void> addFacebookChannel([String name]) async {
    assert(loginedFacebookUser != null);
    assert(_setting.facebookAccessToken != null);

    if (_loginedFacebookUser == null) {
      return;
    }
    onStateAdd(true, message: "Đang lưu...");

    try {
      //Check condition
      final checkResult = await _crmTeamApi.checkFacebookAccount(
        facebookId: _loginedFacebookUser.id,
        facebookName: _loginedFacebookUser.name,
        facebookAvatar: _loginedFacebookUser.pictureLink,
        token: _setting.facebookAccessToken,
      );

      if (checkResult) {
        final result = await _crmTeamApi.insert(
          CRMTeam(
            id: null,
            name: _loginedFacebookUser.name,
            active: true,
            type: "Facebook",
            // facebookUserId: _loginedFacebookUser.id,
            facebookTypeId: "User",
            facebookUserAvatar: _loginedFacebookUser.pictureLink,
            facebookUserToken: _setting.facebookAccessToken,
            facebookASUserId: _loginedFacebookUser.id,
          ),
        );

        if (result != null) {
          await _refreshFacebookChannel();
          onDialogMessageAdd(
            OldDialogMessage.flashMessage("Kênh facebook ${result.name}"),
          );
        }
      } else {
        onDialogMessageAdd(
          OldDialogMessage.info(
              "Kênh ${_loginedFacebookUser.name} đã tồn tại trong hệ thống."),
        );
      }
    } catch (e, s) {
      _log.severe("insert facebook channel", e, s);
      _dialog.showError(error: e);
    }
    onStateAdd(false);
    notifyListeners();
  }

  Future<void> addFacebookPageChannel(
      {@required FacebookAccount page,
      @required String name,
      @required CRMTeam crmTeam}) async {
    assert(page != null);
    assert(name != null);
    assert(crmTeam != null);
    assert(crmTeam.id != null);
    onStateAdd(true);
    try {
      final checkResult = await _crmTeamApi.checkFacebookAccount(
        facebookId: page.id,
        facebookName: page.name,
        facebookAvatar: page.pictureString,
        token: page.accessToken,
      );

      if (checkResult) {
        final result = await _crmTeamApi.insert(
          CRMTeam(
            id: null,
            name: name ?? page.name,
            active: true,
            type: "Facebook",
            // facebookUserId: _loginedFacebookUser.id,
            facebookASUserId: crmTeam.facebookASUserId,
            parentId: crmTeam.id,
            facebookTypeId: "Page",
            facebookPageId: page.id,
            facebookPageLogo: page.pictureString,
            facebookPageName: page.name,
            facebookPageToken: page.accessToken,
            facebookPageCover: page.pictureString,
          ),
        );

        if (result != null) {
          await _refreshFacebookChannel();
          _newDialog.showToast(
              message: S.current.facebookChannel_notifyAddChannelSuccess(name));
        }
      } else {
        _dialog.showError(
            title: 'Cảnh báo',
            content:
                "Kênh ${_loginedFacebookUser.name} đã tồn tại trong hệ thống.");
      }
    } catch (e, s) {
      _log.severe("insert facebook page channle", e, s);
      _dialog.showError(error: e);
    }

    onStateAdd(false);
    notifyListeners();
  }

  Future<void> _deleteFacebookChannel(CRMTeam crmTeam) async {
    assert(crmTeam != null);
    onStateAdd(true, message: S.current.deletingDotDotDot);
    try {
      await _crmTeamApi.deleteCRMTeam(crmTeam.id);
      _newDialog.showToast(
          message: S.current
              .facebookChannel_notifyDeleteChannelSuccess(crmTeam.name));
      _refresh();

      notifyListeners();
    } catch (e, s) {
      _log.severe("", e, s);
      _newDialog.showDialog(
        type: AlertDialogType.error,
        content: e.toString(),
      );
    }
    onStateAdd(false);
  }

  String canRefreshToken(CRMTeam crmTeam) {
    if (!isFacebookLoggined || _loginedFacebookUser == null) {
      return S.current.facebookChannel_notifyMustLoginFacebook;
    }

    if (crmTeam.facebookASUserId == loginedFacebookUser.id ||
        crmTeam.parent?.facebookASUserId == loginedFacebookUser.id) {
      return null;
    }
    return 'Bạn cần đăng nhập tài khoản facebook (${crmTeam.parent?.name ?? crmTeam.name}) để thực làm mới';
  }

  /// Làm mới token facebook.
  Future<void> refreshFacebookToken(CRMTeam crmTeam) async {
    /// Validate và thông báo
    ///

    assert(isFacebookLoggined);
    assert(_loginedFacebookUser != null);

    onStateAdd(true, message: "Đang cập nhật...");
    try {
      if (crmTeam.facebookTypeId == "User") {
        await _crmTeamApi.checkFacebookAccount(
            token: _setting.facebookAccessToken,
            facebookId: _loginedFacebookUser.id,
            facebookName: _loginedFacebookUser.name,
            facebookAvatar: _loginedFacebookUser.pictureLink);
        _newDialog.showToast(
            message: "Đã làm mới đăng nhập cho ${crmTeam.name}");
      } else if (crmTeam.facebookTypeId == "Page") {
        //Get page info
        final pages = await _fbApi.getFacebookAccount(
            accessToken: _setting.facebookAccessToken);
        if (pages != null) {
          final page = pages.firstWhere((f) => f.id == crmTeam.facebookPageId,
              orElse: () => null);
          if (page != null) {
            // update
            await _crmTeamApi.patch(
              CRMTeam(
                facebookPageLogo: page.pictureString,
                id: crmTeam.id,
                facebookPageToken: page.accessToken,
              ),
            );
            _newDialog.showToast(
                message: "Đã làm mới đăng nhập cho ${crmTeam.name}");
          } else {
            throw Exception(
                "Không tìm thấy Page này trong tài khoản người dùng");
          }
        }
      }

      // Tải lại
      initCommand.execute(null);
    } catch (e, s) {
      _log.severe("refresh facebook token", e, s);
      _newDialog.showDialog(
        type: AlertDialogType.error,
        title: 'Đã xảy ra lỗi!',
        content: e.toString(),
      );
    }
    onStateAdd(false);
  }

  Future<void> _logoutFacebook() async {
    _setting.facebookAccessToken = null;
    _loginedFacebookUser = null;
    await _facebookLogin.logOut();
    notifyListeners();
  }
}
