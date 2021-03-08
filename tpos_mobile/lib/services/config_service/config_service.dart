import 'config_model/home_menu_config.dart';

abstract class ConfigService {
  /// Đếm số lần đăng nhập thành công
  int get loginCount;
  String get lastFcmToken;
  HomeMenuConfig get homeMenuDefault;

  /// Lịch sử phiên bản. Bị reset khi ứng dụng được cài lại
  List<String> get historyVersions;
  void updateVersion(String version);

  // HomeMenuV2FavoriteModel get favoriteMenu;

  bool get showAllMenuOnStart;

  String get languageCode;

  String get countryCode;

  /// Phiên bản phần mềm trước khi cài đặt phiên bản này
  String get previousVersion;
  bool get isUpdated;

  void setLoginCount(int value);

  void setShowAllMenuOnStart(bool value);

  void setLanguageCode(String value);

  void setCountryCode(String value);
  void setLastFcmToken(String value);

  /// Khởi tạo dịch vụ. Bắt buộc phải gọi 1 lần trước khi có thể sử dụng dịch vụ này
  Future<void> init();

  /// Hàm được gọi khi cập nhật lên phiên bản mới và có các hoạt động nâng cấp cần thiết để đảm bảo các cấu hình hoạt động đúng như cũ.
  void startMigration();

  Map<String, dynamic> toJon([removeIfNull = false]);

  void fromJson(Map<String, dynamic> jsonMap);
}

abstract class SecureConfigService {
  Future<void> init();
  String get shopUsername;
  String get shopUrl;
  String get shopToken;
  String get refreshToken;
  int get loginCount;
  void setShopToken(String value);
  void setRefreshToken(String value);

  void setShopUrl(String value);
  void setShopUsername(String value);
  void setLoginCount(int value);
}
