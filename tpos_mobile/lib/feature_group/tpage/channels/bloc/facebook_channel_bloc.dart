import 'package:facebook_api_client/facebook_api_client.dart';
import 'package:facebook_api_client/src/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/tpage/channels/bloc/facebook_channel_event.dart';
import 'package:tpos_mobile/feature_group/tpage/channels/bloc/facebook_channel_state.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/services/remote_config_service.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class FacebookChannelBloc extends Bloc<FbChannelEvent, FbChannelState> {
  FacebookChannelBloc(
      {FacebookApi fbApi,
      CrmTeamApi crmApi,
      ISettingService setting,
      RemoteConfigService remoteConfig})
      : super(FbChannelLoading()) {
    _fbApi = fbApi ?? GetIt.instance<FacebookApi>();
    _crmApi = crmApi ?? GetIt.instance<CrmTeamApi>();
    _setting = setting ?? locator<ISettingService>();
    _remoteConfig = remoteConfig ?? GetIt.I<RemoteConfigService>();
    _facebookLogin = FacebookLogin();
  }

  FacebookApi _fbApi;
  CrmTeamApi _crmApi;
  final Logger _logger = Logger();
  CRMTeam crm;
  List<CRMTeam> crms = [];
  ISettingService _setting;
  FacebookUser _loginedFacebookUser;
  FacebookLogin _facebookLogin;
  RemoteConfigService _remoteConfig;
  bool isFacebookUserConnected = false;

  @override
  Stream<FbChannelState> mapEventToState(FbChannelEvent event) async* {
    if (event is FbChannelLoaded) {
      yield* _getFacebookChannel();
    } else if (event is FbChannelConnected) {
      yield* _connectFacebookChanel(event);
    } else if (event is FbChannelDisconnected) {
      yield* _disconnectFacebookChanel(event);
    } else if (event is FbChannelTokenRefreshed) {
      yield* _refreshToken(event);
    } else if (event is FbChannelAccountLogged) {
      yield* _loginFacebook(event, false);
    } else if (event is FbChannelAccountLogout) {
      yield* _logoutFacebook(event);
    }
  }

  Stream<FbChannelState> _getFacebookChannel() async* {
    yield FbChannelLoading();
    List<FacebookAccount> fbAccounts;
    List<CRMTeam> crmTeams = [];
    try {
      await _tryRefreshFacebookLoginUser();
      final crmTeamsResult = await _crmApi.getAllFacebook();
      if (crmTeamsResult.value.isNotEmpty) {
        crmTeams = crmTeamsResult.value;
        checkUserConnected(crmTeams);
        yield FbChannelLoadSuccess(
            crmTeams: crmTeams,
            token: _setting.facebookAccessToken,
            isFacebookUserConnected: isFacebookUserConnected,
            facebookUser: _loginedFacebookUser);
        yield FbChannelLoading();
        for (final crmTeam in crmTeams) {
          try {
            fbAccounts = await _fbApi.getFacebookAccount(
                accessToken: crmTeam.facebookUserToken);
          } catch (e, s) {
            _logger.e("getFbChannel", e, s);
          }
          if (crmTeam.parentId == null &&
              crmTeam.parent == null &&
              fbAccounts != null) {
            for (final fb in fbAccounts) {
              if (!crmTeam.childs.any((f) => f.facebookPageId == fb.id)) {
                final CRMTeam child = CRMTeam();
                child.active = false;
                child.name = fb.name;
                child.facebookPageId = fb.id;
                child.facebookPageLogo = fb.picture.url;
                child.parentName = crmTeam.name;
                child.facebookASUserId = crmTeam.facebookASUserId;
                child.facebookLink = "https://www.facebook.com/" + fb.id;
                child.facebookPageName = fb.name;
                child.facebookPageToken = fb.accessToken;
                child.facebookUserAvatar = crmTeam.facebookUserAvatar;
                child.facebookUserName = crmTeam.facebookUserName;
                child.facebookUserToken = crmTeam.facebookUserToken;
                child.parentId = crmTeam.id;
                child.type = crmTeam.type;
                child.facebookTypeId = "Page";
                crmTeam.childs.add(child);
              }
            }
          }
          crms.add(crmTeam);
        }
      }
      yield FbChannelLoadSuccess(
          crmTeams: crms,
          token: _setting.facebookAccessToken,
          isFacebookUserConnected: isFacebookUserConnected,
          facebookUser: _loginedFacebookUser,
          isFinished: true);
    } catch (e, s) {
      _logger.e("_getFacebookChannel", e, s);
      yield FbChannelLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<FbChannelState> _connectFacebookChanel(
      FbChannelConnected event) async* {
    yield FbChannelEditLoading();
    try {
      final result = await _crmApi.insert(event.crmTeam);
      if (result != null) {
        if (result.facebookPageId == null) {
          try {
            final fbAccounts = await _fbApi.getFacebookAccount(
                accessToken: result.facebookUserToken);
            for (final fb in fbAccounts) {
              result.childs ??= [];
              if (!result.childs.any((f) => f.facebookPageId == fb.id)) {
                final CRMTeam child = CRMTeam();
                child.active = false;
                child.name = fb.name;
                child.facebookPageId = fb.id;
                child.facebookPageLogo = fb.picture.url;
                child.parentName = result.name;
                child.facebookASUserId = result.facebookASUserId;
                child.facebookLink = "https://www.facebook.com/" + fb.id;
                child.facebookPageName = fb.name;
                child.facebookPageToken = fb.accessToken;
                child.facebookUserAvatar = result.facebookUserAvatar;
                child.facebookUserName = result.facebookUserName;
                child.facebookUserToken = result.facebookUserToken;
                child.parentId = result.id;
                child.type = result.type;
                result.childs.add(child);
              }
            }
            crms.add(result);
          } catch (e, s) {
            _logger.e("getFacebookAccount", e, s);
          }
        } else
          for (final CRMTeam crm in crms) {
            for (final CRMTeam child in crm.childs) {
              if (child.facebookPageId == event.crmTeam.facebookPageId) {
                child.id = result.id;
                child.active = true;
                child.name = result.name;
              }
            }
          }
      }
      checkUserConnected(crms);
      yield FbChannelConnectSuccess(
          title: S.current.notification, content: S.current.channelConSuccess);
      yield FbChannelLoadSuccess(
          crmTeams: crms,
          token: _setting.facebookAccessToken,
          facebookUser: _loginedFacebookUser,
          title: S.current.notification,
          isFacebookUserConnected: isFacebookUserConnected,
          content: S.current.addSuccessful,
          isFinished: true);
    } catch (e, s) {
      _logger.e("_connectFacebookChanel", e, s);
      yield FbChannelConnectFailure(
          title: S.current.notification, content: e.toString());
      yield FbChannelLoadSuccess(
          crmTeams: crms,
          token: _setting.facebookAccessToken,
          isFacebookUserConnected: isFacebookUserConnected,
          facebookUser: _loginedFacebookUser,
          isFinished: true);
    }
  }

  void checkUserConnected(List<CRMTeam> crms) {
    if (_loginedFacebookUser != null) {
      final crm = crms.firstWhere(
          (element) =>
              element.facebookASUserId == _loginedFacebookUser.id &&
              element.facebookPageId == null,
          orElse: () => null);
      if (crm != null)
        isFacebookUserConnected = true;
      else
        isFacebookUserConnected = false;
    }
  }

  Stream<FbChannelState> _disconnectFacebookChanel(
      FbChannelDisconnected event) async* {
    yield FbChannelEditLoading();
    try {
      final result = await _crmApi.deleteCRMTeam(event.crmTeam.id);
      if (result) {
        if (event.crmTeam.facebookPageId == null)
          crms.remove(event.crmTeam);
        else
          for (final CRMTeam crm in crms) {
            for (final CRMTeam child in crm.childs) {
              if (child.facebookPageId == event.crmTeam.facebookPageId) {
                child.active = false;
                child.name = event.crmTeam.facebookPageName;
              }
            }
          }
      }
      checkUserConnected(crms);
      yield FbChannelDisconnectSuccess(
          title: S.current.notification, content: S.current.channelDisSuccess);
      yield FbChannelLoadSuccess(
          crmTeams: crms,
          token: _setting.facebookAccessToken,
          title: S.current.notification,
          isFacebookUserConnected: isFacebookUserConnected,
          content: S.current.addSuccessful,
          facebookUser: _loginedFacebookUser,
          isFinished: true);
    } catch (e, s) {
      _logger.e("_disconnectFacebookChanel", e, s);
      yield FbChannelConnectFailure(
          title: S.current.unableToDeleteThisChannel, content: e.toString());
      yield FbChannelLoadSuccess(
          crmTeams: crms,
          isFacebookUserConnected: isFacebookUserConnected,
          token: _setting.facebookAccessToken,
          facebookUser: _loginedFacebookUser,
          isFinished: true);
    }
  }

  Stream<FbChannelState> _refreshToken(FbChannelTokenRefreshed event) async* {
    yield FbChannelEditLoading();
    try {
      await _crmApi.refreshToken(event.crmTeam);
      yield FbChannelRefreshTokenSuccess(
          title: S.current.notification, content: "Cập nhật token thành công");
      yield FbChannelLoadSuccess(
          crmTeams: crms,
          token: _setting.facebookAccessToken,
          isFacebookUserConnected: isFacebookUserConnected,
          facebookUser: _loginedFacebookUser,
          isFinished: true);
    } catch (e, s) {
      _logger.e("_refreshToken", e, s);
      yield FbChannelConnectFailure(
          title: S.current.notification, content: e.toString());
      yield FbChannelLoadSuccess(
          crmTeams: crms,
          token: _setting.facebookAccessToken,
          isFacebookUserConnected: isFacebookUserConnected,
          facebookUser: _loginedFacebookUser,
          isFinished: true);
    }
  }

  Future<void> logoutFacebook() async {
    _setting.facebookAccessToken = null;
    _loginedFacebookUser = null;
    await _facebookLogin.logOut();
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
    } catch (e, s) {
      _logger.e("", e, s);
    }
  }

  Stream<FbChannelState> _loginFacebook(
      FbChannelAccountLogged event, bool native) async* {
    yield FbChannelEditLoading();
    try {
      await logoutFacebook();
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
          await _tryRefreshFacebookLoginUser();
          checkUserConnected(crms);
          break;
        case FacebookLoginStatus.cancelledByUser:
          break;
        case FacebookLoginStatus.error:
          yield FbChannelActionFailure(
              title: S.current.notification, content: result.errorMessage);
          break;
      }
      yield FbChannelLoadSuccess(
          crmTeams: crms,
          facebookUser: _loginedFacebookUser,
          isFacebookUserConnected: isFacebookUserConnected,
          token: _setting.facebookAccessToken,
          isFinished: true);
    } catch (e, s) {
      _logger.e("", e, s);
      yield FbChannelActionFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<FbChannelState> _logoutFacebook(FbChannelAccountLogout event) async* {
    yield FbChannelEditLoading();
    try {
      await logoutFacebook();
      yield FbChannelLoadSuccess(
          crmTeams: crms,
          facebookUser: _loginedFacebookUser,
          isFacebookUserConnected: isFacebookUserConnected,
          token: _setting.facebookAccessToken,
          isFinished: true);
    } catch (e, s) {
      _logger.e("", e, s);
      yield FbChannelActionFailure(
          title: S.current.notification, content: e.toString());
    }
  }
}
