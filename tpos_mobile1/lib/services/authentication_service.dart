import 'package:flutter/material.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/authentication_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_client.dart';

import 'app_setting_service.dart';

/// Dịch vụ chịu trách nhiệm các hoạt động xác thực ứng dụng và tài khoản
abstract class IAuthenticationService {
  /// Đăng nhập
  Future<bool> login(
      {@required shopUrl,
      @required String username,
      @required String password});

  Future<bool> refreshToken();

  /// Đăng xuất
  Future<bool> logout();
}

class AuthenticationService implements IAuthenticationService {
  IAuthenticationApi _authenticationApi;
  ISettingService _settingService;
  TposApiClient _tposApiClient;

  AuthenticationService(
      {IAuthenticationApi authenticationApi,
      ISettingService settingService,
      TposApiClient tposApiClient}) {
    _authenticationApi = authenticationApi ?? locator<IAuthenticationApi>();
    _settingService = settingService ?? locator<ISettingService>();
    _tposApiClient = tposApiClient ?? locator<TposApiClient>();
  }
  @override
  Future<bool> login({shopUrl, String username, String password}) async {
    _settingService.shopUrl = shopUrl;
    var loginInfo =
        await _authenticationApi.login(username: username, password: password);

    // Lưu thông tin đăng nhập
    _settingService.shopUsername = username;
    _settingService.shopAccessToken = loginInfo.accessToken;
    _settingService.shopRefreshAccessToken = loginInfo.refreshToken;
    _settingService.shopAccessTokenExpire = loginInfo.expires;
    // Khởi tạo Api Client
    _tposApiClient.initClient();
    return true;
  }

  @override
  Future<bool> logout() async {
    // Xóa thông tin đăng nhập
    _settingService.shopAccessToken = null;
    _settingService.shopRefreshAccessToken = null;
    _settingService.shopAccessTokenExpire = null;
    // Đăng kí lại các dịch vụ
    await resetLocator();

    return true;
  }

  @override
  Future<bool> refreshToken() async {
    var loginInfo = await _authenticationApi.refreshToken(
        refreshToken: _settingService.shopRefreshAccessToken);
    // save login info
    _settingService.shopAccessToken = loginInfo.accessToken;
    _settingService.shopRefreshAccessToken = loginInfo.refreshToken;
    _settingService.shopAccessTokenExpire = loginInfo.expires;
    // Reset locator
    return true;
  }
}
