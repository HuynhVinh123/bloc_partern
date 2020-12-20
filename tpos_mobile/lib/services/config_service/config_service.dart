import 'package:flutter/cupertino.dart';
import 'package:tpos_mobile/application/menu_v2/model.dart';

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

  HomeMenuV2FavoriteModel get favoriteMenu;

  bool get showAllMenuOnStart;
  String get languageCode;
  String get countryCode;

  /// Định dạng tiền tệ viêt nam
  String get currencyFormat;

  /// Định dạng ngày
  String get dateFormat;

  /// Định dạng ngày tháng
  String get dateTimeFormat;

  /// Phiên bản phần mềm trước khi cài đặt phiên bản này
  String get previousVersion;

  String get homePageStyle;

/*  // LUCKY WHEEL GAME SETTING*/
  /// Lấy giá trị xác định khách hàng có bình luận vào bài viết
  bool get luckyWheelHasComment;

  /// Lấy giá trị xác định KHách hàng có chia sẻ bài viết
  bool get luckyWheelHasShare;

  /// Lấy giá trị xác định Khách hàng có mua hàng trong bài viết
  bool get luckyWheelHasOrder;

  /// Lấy giá trị xác định Bỏ qua người đã từng được giải trong quá khứ
  bool get luckyWheelIgnoreWinnerPlayer;

  /// Lấy giá trị xác định Ưu tiên cho người chia sẻ
  bool get luckyWheelPrioritySharers;

  /// Lấy giá trị xác định Ưu tiên người chia sẻ nhóm
  bool get luckyWheelPriorityGroupSharers;

  /// Lấy giá trị xác định Ưu tiên người chia sẻ cá nhân
  bool get luckyWheelPriorityPersonalSharers;

  /// Lấy giá trị xác định Ưu tiên những người có nhiều comment
  bool get luckyWheelPriorityCommentPlayers;

  /// Lấy giá trị xác định Không ưu tiên người đã thắng cuộc gần đây.
  bool get luckyWheelPriorityIgnoreWinner;

  /// SỐ ngày bỏ qua không ưu tiên người thắng
  bool get luckyWheelIgnoreWinnerDay;

  /// Thời gian 1 vòng quay nếu ở chế độ tự động.
  int get luckyWheelTimeInSecond;

  /// Số ngày để cho người chơi đã trúng được tham gia giải nếu [luckyWheelIgnoreWinnerPlayer] được được [false]
  int get luckyWheelSkipDays;

  ///Cài đặt xem có ưu tiên không
  bool get luckyWheelIsPriority;

  /// Lưu giá trị xác định cài đặt xem có ưu tiên hay không
  void setLuckyWheelIsPriority(bool value);

  /// Lưu giá trị xác định đối tượng tham gia có comment hay không
  void setLuckyWheelHasComment(bool value);

  /// Lưu giá trị xác định đối tượng tham giá có chia sẻ bài viết hay không
  void setLuckyWheelHasShare(bool value);

  /// Lưu giá trị xác định đối tượng tham gia có mua hàng trong bài viết hay không
  void setLuckyWheelHasOrder(bool value);

  /// Lưu giá trị xác định cài đặt có bỏ qua người đã từng thắng cuộc trong game hay không
  void setLuckyWheelIgnoreWinnerPlayer(bool value);

  /// Lưu giá trị xác định có ưu tiên cho những người đã chia sẻ hay không
  void setLuckyWheelPrioritySharers(bool value);

  /// Lưu giá tị xác định có ưu tiên cho những người đã chia sẻ nhóm hay không
  void setLuckyWheelPriorityGroupSharers(bool value);

  /// Lưu giá trị xác định có ưu tiên cho những người chia sẻ cá nhân hay không
  void setLuckyWheelPriorityPersonalSharers(bool value);

  /// Lưu giá trị xác định có bỏ qua những người đã thắng cuộc gần đây hay không
  void setLuckyWheelPriorityIgnoreWinner(bool value);

  /// Lưu giá trị số ngày bỏ qua không ưu tiên người thắng cuộc. Dùng chung với [setLuckyWheelPriorityPersonalSharers]
  void setLuckyWheelPriorityIgnoreWinnerDay(int value);

  /// Lưu giá trị xác định thời gian một vòng quay nếu ở chế độ thời gian tự động
  void setLuckyWheelTimeInSecond(int value);

  /// Lưu giá trị số ngày để cho người chơi đã trúng được tham gia giải nếu [luckyWheelIgnoreWinnerPlayer] được được [false]
  void setLuckyWheelSkipDays(int value);

  /*END LUCKY WHEEL GAME CONFIG*/

  void setShopUrl(String value);
  void setShopUsername(String value);
  void setLoginCount(int value);
  void setShowAllMenuOnStart(bool value);
  void setLanguageCode(String value);
  void setCountryCode(String value);
  void setUserMenu(HomeMenuConfig config);
  void setCompanyName(String value);
  void setFavoriteMenu(HomeMenuV2FavoriteModel value);

  /// Khởi tạo dịch vụ. Bắt buộc phải gọi 1 lần trước khi có thể sử dụng dịch vụ này
  Future<void> init();

  /// Hàm được gọi khi cập nhật lên phiên bản mới và có các hoạt động nâng cấp cần thiết để đảm bảo các cấu hình hoạt động đúng như cũ.
  void startMigration();

  void setHomePageStyle(String value);
}

abstract class SecureConfigService {
  Future<String> get shopToken;
  Future<String> get refreshToken;
  Future<void> setShopToken(String value);
  Future<void> setRefreshToken(String value);
}

abstract class ConfigMigration {
  void up();
}
