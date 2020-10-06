import 'package:flutter/cupertino.dart';

import 'config_model/home_menu_config.dart';

abstract class ConfigService {
  String get shopUrl;
  String get shopUsername;
  String get companyName;

  /// Đếm số lần đăng nhập thành công
  int get loginCount;
  HomeMenuConfig get homeMenuDefault;

  /// Danh sách menu của nhiều người dùng
  List<HomeMenuConfig> get userMenus;

  /// Hàm lấy menu cá nhân của tài khoản a thuộc tên miền b
  HomeMenuConfig getUserMenu(
      {@required String shopUrl, @required String username});

  /// Lấy menu cá nhân theo tên đăng nhập hiện tại
  HomeMenuConfig getUserDefaultMenu();

  bool get showAllMenuOnStart;
  String get languageCode;
  String get countryCode;

  /// Định dạng tiền tệ viêt nam
  String get currencyFormat;

  /// Định dạng ngày
  String get dateFormat;

  /// Định dạng ngày tháng
  String get dateTimeFormat;

  void setShopUrl(String value);
  void setShopUsername(String value);
  void setLoginCount(int value);

  void setShowAllMenuOnStart(bool value);

  void setLanguageCode(String value);
  void setCountryCode(String value);
  void setUserMenu(HomeMenuConfig config);
  void setCompanyName(String value);

  Future<void> init();
}

abstract class SecureConfigService {
  Future<String> get shopToken;
  Future<String> get refreshToken;
  Future<void> setShopToken(String value);
  Future<void> setRefreshToken(String value);
}
