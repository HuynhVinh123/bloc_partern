import 'package:facebook_api_client/facebook_api_client.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

/// Cấu hình cho comment
class CommentSetting {
  /// Thông tin bài đăng
  FacebookPost facebookPost;

  /// Kênh bán hàng
  CRMTeam crmTeam;

  /// Chiến dịch live
  LiveCampaign liveCampaign;

  /// Tỉ lệ lấy comment khi lấy bằng event source. Mặc định là [one_hundered_per_second]
  CommentRate commentRate = CommentRate.one_hundred_per_second;

  /// Cấu hình in đơn hàng
  PrintOrderSetting printOrderSetting;

  /// Thời gian tự động tải bình luận mặc định nếu như không kết nối được eventsource
  int fetchCommentTime = 3;

  /// Hiển thị thời gian bình luận kiểu '1 phút trước' hay '2020-08-13 :14:33:02'
  bool isShowTimeAgo = true;

  /// Tự động lưu bình luận sau mỗi 5 phút
  int timeToAutoSaveComment = 5;

  /// Bật tắt tính năng tự động lưu bình luận lên server
  bool isAutoSaveComment = true;

  /// Cấu hình ẩn comment trên facebook
  HideCommentOnFacebookConfig hideCommentOnFacebookSetting =
      HideCommentOnFacebookConfig();

  AutoCreateOrderConfig autoCreateOrderConfig = AutoCreateOrderConfig();
}

/// Cài đặt này dùng nếu in qua máy in tpos printer
class PrintOrderSetting {
  /// Cho phép in đơn hàng hay không
  bool printOrder = false;

  /// Chỉ cho phép in 1 lần đơn hàng nếu khách hàng đó đã được in trước đó
  bool printOrderOnlyOnePerPartner = false;

  /// Chỉ cho phép in 1 lần đơn hàng trên 1 comment;
  /// Cài đặt này còn phụ thuộc vào cài đặt [printOrderOnlyOnePerPartner]
  /// Nếu tùy chọn này =true thì comment đó có thể sẽ không được in lần nào nếu như khách hàng đã được in trước đó
  bool printOrderOnlyOnePerComment = false;

  /// Tên máy in dùng để in đơn hàng
  String printOrderPrinterName = '';

  /// Tên mẫu phiếu dùng để in đơn hàng
  /// Hiện tại hỗ trợ hai loại : "Image' và 'Raw'
  String printOrderTemplateName = '';

  /// Mẫu header tùy chỉnh phía trên nội dung in
  String printOrderCustomHeader;

  /// Mẫu in footer tùy chỉnh phía dưới nội dung in
  String printOrderCustomFooter;

  /// Thêm bình luận của comment vào ghi chú đơn hàng
  bool addCommentToOrderNote;
}

class HideCommentOnFacebookConfig {
  bool get enableHideComment =>
      isHideAllComment ||
      isHideCommentHasPhone ||
      isHideCommentHasEmail ||
      hideCommentStrings.isNotEmpty;

  /// Tự động ẩn tất cả bình luận, xuất hiện là ẩn
  /// Chỉ hiệu lực với các bình luận đã được tải sau khi cài đặt
  bool isHideAllComment = false;

  bool isHideCommentHasPhone = false;
  bool isHideCommentHasEmail = false;

  List<String> hideCommentStrings = <String>[];
}

/// Cấu hình chốt đơn tự động
class AutoCreateOrderConfig {
  bool enable = false;

  /// Tạo tự động khi comment có chứa số điện thoại và chỉ tạo 1 lần
  bool whenCommentHasPhone = false;
  bool whenCommentHasPhoneAndAddress = false;

  /// Nếu [whenCommentHasPhone] được bật  và tùy chọn này được bật thì comment có số phone đó sẽ được tạo nhiều lần nếu có nhiều comment mới
  bool forceIfCommentHasPhone = false;

  /// Nếu [forceIfCommentHasPhone =true]  và tùy chọn này được bật thì hệ thống sẽ ép buộc in nhiều lần
  bool forcePrintIfCommentHasPhone = false;

  /// Tạo đơn cho các bình luận không chứa nội dung trong danh sách
  List<String> commentWithoutContents;

  /// Chỉ tạo cho các bình luận có nội dung lớn hơn [commentGreaterNumber]. = 0 là không áp dụng
  int commentGreaterNumber = 0;

  /// Chỉ các bình luận có nội dung trùng khớp và sẽ tạo đơn hàng với sản phẩm được chỉ định
  List<AutoCreateOrderContent> contents = <AutoCreateOrderContent>[];
}

class AutoCreateOrderContent {
  AutoCreateOrderContent(
      {this.contents, this.productId, this.productName, this.price});

  /// Nội dung
  List<String> contents = <String>[];
  int productId;
  String productName;
  double price;
}

class HideCommentCondition {
  HideCommentCondition(
      {this.field, this.operator, this.value, this.enable = false});
  bool enable;
  String field;
  HideCommentOperator operator;
  dynamic value;
}

enum HideCommentOperator {
  contain,
  doesNotContain,
  equal,
  greater,
  less,
  lessOrEqual,
  greaterOrEqual,
}

enum HideCommentDefaultValue {
  phone,
  email,
  address,
}
