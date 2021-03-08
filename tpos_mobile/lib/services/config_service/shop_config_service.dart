import 'package:tpos_mobile/application/menu_v2/model.dart';

import 'config_model/home_menu_config.dart';
import 'h_adapters/h_printer_config.dart';
import 'h_adapters/h_sale_online_config.dart';
import 'h_adapters/new_lucky_wheel_game_config.dart';
import 'h_adapters/old_lucky_wheel_game_config.dart';

/// Lưu cấu hình local cho shop
/// Cấu hình sẽ được lưu theo tên miền shop + Tên người dùng
abstract class ShopConfigService {
  HomeMenuV2FavoriteModel get favoriteMenu;
  String get shopUsername;
  String get shopUrl;
  String get companyName;
  String get locale;

  NewLuckyWheelGameConfig get luckyWheelConfig;
  OldLuckyWheelGameConfig get oldLuckyWheelConfig;
  HSaleOnlineConfig get saleFacebookConfig;
  HPrinterConfig get printerConfig;

  /// Định dạng tiền tệ viêt nam
  String get currencyFormat;

  /// Định dạng ngày tháng
  String get dateTimeFormat;
  String get homePageStyle;

  /// Danh sách menu của nhiều người dùng
  List<HomeMenuConfig> get userMenus;

  void setFavoriteMenu(HomeMenuV2FavoriteModel value);
  void setCompanyName(String value);
  void setCurrencyFormat(String value);
  void setDateTimeFormat(String value);
  void setHomePageStyle(String value);
  void setLocale(String value);
  void setUserMenu(HomeMenuConfig config);

  Future<void> init();

  /// Chuyển cấu hình sang json để lưu lên máy chủ
  Map<String, dynamic> toJson();

  /// Đọc cấu hình từ dạng json và lưu vào cấu hình trên máy
  void fromJson(Map<String, dynamic> json);

  /// Khôi phục mặc định giống như lúc mới cài phần mềm
  Future<void> resetDefault();

  /*  // LUCKY WHEEL GAME SETTING*/

  HomeMenuConfig getUserDefaultMenu();
/*END LUCKY WHEEL GAME CONFIG*/

}
