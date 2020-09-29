// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a vi locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'vi';

  static m0(hotline) => "Tổng đài hỗ trợ${hotline}";

  static m1(expiredDay) =>
      "Tài khoản của bạn còn ${expiredDay} nữa sẽ hết hạn. Vui lòng gia hạn sớm để công việc kinh doanh không bị gián đoạn.";

  static m2(channelId) => "Kênh facebook (${channelId}) đã tồn tại";

  final messages = _notInlinedMessages(_notInlinedMessages);

  static _notInlinedMessages(_) => <String, Function>{
        "aboutApplication":
            MessageLookupByLibrary.simpleMessage("Thông tin ứng dụng"),
        "add": MessageLookupByLibrary.simpleMessage("Thêm"),
        "addNewPage": MessageLookupByLibrary.simpleMessage("Thêm trang mới"),
        "appTitle":
            MessageLookupByLibrary.simpleMessage("TPOS Quản lý bán hàng"),
        "cancel": MessageLookupByLibrary.simpleMessage("Hủy bỏ"),
        "changePassword": MessageLookupByLibrary.simpleMessage("Đổi mật khẩu"),
        "checkForUpdate":
            MessageLookupByLibrary.simpleMessage("Kiểm tra phiên bản mới"),
        "close": MessageLookupByLibrary.simpleMessage("Đóng"),
        "config_SaleOnlineSetting":
            MessageLookupByLibrary.simpleMessage("Sale online settings"),
        "config_SaleSettings":
            MessageLookupByLibrary.simpleMessage("Cấu hình bán hàng"),
        "config_printers":
            MessageLookupByLibrary.simpleMessage("Danh sách máy in"),
        "connectedChannel":
            MessageLookupByLibrary.simpleMessage("Kênh đã kết nối"),
        "delete": MessageLookupByLibrary.simpleMessage("Xóa"),
        "dialogValidateFail": MessageLookupByLibrary.simpleMessage(
            "Vui lòng nhập đầy đủ thông tin"),
        "function": MessageLookupByLibrary.simpleMessage("Chức năng"),
        "history": MessageLookupByLibrary.simpleMessage("Lịch sử"),
        "homePage": MessageLookupByLibrary.simpleMessage("Trang chủ"),
        "hotline": m0,
        "introPage_loginButtonTitle":
            MessageLookupByLibrary.simpleMessage("Đăng nhập"),
        "introPage_page1Description": MessageLookupByLibrary.simpleMessage(
            "Tích hợp bán tại của hàng và bán online qua nhiều kênh như facebook..."),
        "introPage_page1Title":
            MessageLookupByLibrary.simpleMessage("Quản lý toàn diện"),
        "introPage_page2Description": MessageLookupByLibrary.simpleMessage(
            "Đẩy đơn trực tiếp tới nhiều nhà vận chuyển được liên kết tới TPos"),
        "introPage_page2Title": MessageLookupByLibrary.simpleMessage(
            "Tích hợp 12+ đơn vị vận chuyển"),
        "introPage_page3Description": MessageLookupByLibrary.simpleMessage(
            "Báo cáo doanh thu, lợi nhuận rõ ràng giúp chủ cửa hàng quản lý dòng tiền hiệu quả"),
        "introPage_page3Title":
            MessageLookupByLibrary.simpleMessage("Báo cáo đầy đủ, chi tiết"),
        "introPage_registerButtonTitle":
            MessageLookupByLibrary.simpleMessage("Đăng ký dùng thử"),
        "loadMore": MessageLookupByLibrary.simpleMessage("Tải thêm"),
        "login": MessageLookupByLibrary.simpleMessage("Đăng nhập"),
        "loginFacebook":
            MessageLookupByLibrary.simpleMessage("Đăng nhập facebook"),
        "loginPage_loginButtonTitle":
            MessageLookupByLibrary.simpleMessage("Đăng nhập"),
        "loginPage_loginFailTitle":
            MessageLookupByLibrary.simpleMessage("Sự cố đăng nhập!"),
        "loginPage_registerButtonTitle":
            MessageLookupByLibrary.simpleMessage("Bạn chưa có tài khoản?"),
        "logout": MessageLookupByLibrary.simpleMessage("Đăng xuất"),
        "menuGroupType_category":
            MessageLookupByLibrary.simpleMessage("Danh mục"),
        "menuGroupType_fastSaleOrder":
            MessageLookupByLibrary.simpleMessage("Bán hàng nhanh"),
        "menuGroupType_inventory":
            MessageLookupByLibrary.simpleMessage("Kho hàng"),
        "menuGroupType_posOrder":
            MessageLookupByLibrary.simpleMessage("Điểm bán hàng"),
        "menuGroupType_saleOnline":
            MessageLookupByLibrary.simpleMessage("Bán hàng online"),
        "menuGroupType_setting":
            MessageLookupByLibrary.simpleMessage("Cài đặt"),
        "menu_CloseOrderLivestram":
            MessageLookupByLibrary.simpleMessage("Chốt đơn livestream"),
        "menu_FacebookSaleChannel":
            MessageLookupByLibrary.simpleMessage("Kênh facebook"),
        "menu_LiveCampaign":
            MessageLookupByLibrary.simpleMessage("Chiến dịch live"),
        "menu_SaleOnlineOrder":
            MessageLookupByLibrary.simpleMessage("Đơn hàng facebook"),
        "menu_addCustomer":
            MessageLookupByLibrary.simpleMessage("Thêm khách hàng"),
        "menu_addProduct":
            MessageLookupByLibrary.simpleMessage("Thêm sản phẩm"),
        "menu_allFeature":
            MessageLookupByLibrary.simpleMessage("Tất cả tính năng"),
        "menu_cashReceipt": MessageLookupByLibrary.simpleMessage("Phiếu thu"),
        "menu_createFastSaleOrder":
            MessageLookupByLibrary.simpleMessage("Tạo hóa đơn bán"),
        "menu_customMenu": MessageLookupByLibrary.simpleMessage("Cá nhân"),
        "menu_customer": MessageLookupByLibrary.simpleMessage("Khách hàng"),
        "menu_customerGroup":
            MessageLookupByLibrary.simpleMessage("Nhóm khách hàng"),
        "menu_deliveryCarrier":
            MessageLookupByLibrary.simpleMessage("Đối tác giao hàng"),
        "menu_deliverySaleOrders":
            MessageLookupByLibrary.simpleMessage("HĐ giao hàng"),
        "menu_fastSaleOrders":
            MessageLookupByLibrary.simpleMessage("HĐ bán hàng"),
        "menu_import": MessageLookupByLibrary.simpleMessage("Phiếu mua hàng"),
        "menu_paymentReceipt":
            MessageLookupByLibrary.simpleMessage("Phiếu chi"),
        "menu_paymentType":
            MessageLookupByLibrary.simpleMessage("Loại phiếu thu"),
        "menu_posOfSale": MessageLookupByLibrary.simpleMessage("Điểm bán hàng"),
        "menu_product": MessageLookupByLibrary.simpleMessage("Sản phẩm"),
        "menu_productGroup":
            MessageLookupByLibrary.simpleMessage("Nhóm sản phẩm"),
        "menu_purchaseOrder":
            MessageLookupByLibrary.simpleMessage("Đơn đặt hàng"),
        "menu_quotation": MessageLookupByLibrary.simpleMessage("Báo giá"),
        "menu_receiptType":
            MessageLookupByLibrary.simpleMessage("Loại phiếu chi"),
        "menu_saleChannels":
            MessageLookupByLibrary.simpleMessage("Kênh bán hàng"),
        "menu_search": MessageLookupByLibrary.simpleMessage("Tìm kiếm"),
        "menu_settingPrinter":
            MessageLookupByLibrary.simpleMessage("Cấu hình in ấn"),
        "menu_settingSaleOrder":
            MessageLookupByLibrary.simpleMessage("Cấu hình bán hàng"),
        "menu_supplier": MessageLookupByLibrary.simpleMessage("Nhà cung cấp"),
        "notification": MessageLookupByLibrary.simpleMessage("Thông báo"),
        "notifyExpire": m1,
        "otherReport": MessageLookupByLibrary.simpleMessage("Báo cáo khác"),
        "password": MessageLookupByLibrary.simpleMessage("Mật khẩu"),
        "personal": MessageLookupByLibrary.simpleMessage("Cá nhân"),
        "printConfiguration":
            MessageLookupByLibrary.simpleMessage("Print configuration"),
        "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy policy"),
        "refresh": MessageLookupByLibrary.simpleMessage("Làm mới"),
        "saleOnline_checkboxOnlyTenComment":
            MessageLookupByLibrary.simpleMessage("Chỉ hiện > 10 bình luận"),
        "saleOnline_existsNotify": m2,
        "save": MessageLookupByLibrary.simpleMessage("Lưu"),
        "saveWithName": MessageLookupByLibrary.simpleMessage("Save with name"),
        "selectFacebookSaleChannel":
            MessageLookupByLibrary.simpleMessage("Chọn kênh facebook "),
        "selectLanguage": MessageLookupByLibrary.simpleMessage("Chọn ngôn ngữ"),
        "sendEmailFeedback":
            MessageLookupByLibrary.simpleMessage("Gửi email góp ý về sản phẩm"),
        "setting": MessageLookupByLibrary.simpleMessage("Cài đặt"),
        "statistics": MessageLookupByLibrary.simpleMessage("Báo cáo"),
        "thisMonth": MessageLookupByLibrary.simpleMessage("Tháng này"),
        "thisYear": MessageLookupByLibrary.simpleMessage("Năm này"),
        "today": MessageLookupByLibrary.simpleMessage("Hôm nay"),
        "type": MessageLookupByLibrary.simpleMessage("Loại"),
        "username": MessageLookupByLibrary.simpleMessage("Tên đăng nhập"),
        "version": MessageLookupByLibrary.simpleMessage("Phiên bản"),
        "voteForApp":
            MessageLookupByLibrary.simpleMessage("Bình chọn cho ứng dụng này"),
        "yesterday": MessageLookupByLibrary.simpleMessage("Hôm qua"),
        "loginPage_forgotPassword":
            MessageLookupByLibrary.simpleMessage("Quên mật khẩu?"),
        "changePassword_oldPassword":
            MessageLookupByLibrary.simpleMessage("Mật khẩu cũ"),
        "changePassword_newPassword":
            MessageLookupByLibrary.simpleMessage("Mật khẩu mới"),
        "changePassword_confirmPassword":
            MessageLookupByLibrary.simpleMessage("Xác nhận mật khẩu"),
        "changePassword_confirm":
            MessageLookupByLibrary.simpleMessage("Xác nhận"),
        "changePassword_changePassword":
            MessageLookupByLibrary.simpleMessage("Thay đổi mật khẩu"),
        "changePassword_isNotEmpty": MessageLookupByLibrary.simpleMessage(
            "Mật khẩu không được để trống!"),
        "changePassword_characterLength6": MessageLookupByLibrary.simpleMessage(
            "Mật khẩu phải lớn hơn 6 kí tự"),
        "changePassword_characterLength36":
            MessageLookupByLibrary.simpleMessage(
                "Mật khẩu phải nhỏ hơn 36 kí tự"),
        "changePassword_confirmPasswordError":
            MessageLookupByLibrary.simpleMessage("Xác nhận mật khẩu lỗi"),
        "forgotPassword_Send": MessageLookupByLibrary.simpleMessage("Gửi"),
        "forgotPassword_Notify": MessageLookupByLibrary.simpleMessage(
            "Nhập địa chỉ email liên kết với tài khoản của bạn, kiểm tra email gửi về và đổi mật khẩu mới."),
        "fbPostShare_Reverse":
            MessageLookupByLibrary.simpleMessage("Đảo ngược"),
        "fbPostShare_Total": MessageLookupByLibrary.simpleMessage("Tổng"),
        "fbPostShare_NumberOfSharingPeople":
            MessageLookupByLibrary.simpleMessage("Số người chia sẽ"),
        "fbPostShare_SharePersonally":
            MessageLookupByLibrary.simpleMessage("Chia sẽ cá nhân"),
        "fbPostShare_ShareToGroup":
            MessageLookupByLibrary.simpleMessage("Chia sẽ nhóm"),
        "fbPostShare_NumberOfShare":
            MessageLookupByLibrary.simpleMessage("Số lượt share"),
        "fbPostShare_Reload": MessageLookupByLibrary.simpleMessage("Tải lại"),
        "fbPostShare_NotFoundShare": MessageLookupByLibrary.simpleMessage(
            "Không tìm thấy lượt share. Hãy thử lại lại xem!"),
        "fbPostShare_CloseContinue":
            MessageLookupByLibrary.simpleMessage("ĐÓNG & TIẾP TỤC"),
        "reportOrder_invoiceStatistics":
            MessageLookupByLibrary.simpleMessage("Thống kê hóa đơn"),
        "reportOrder_Overview":
            MessageLookupByLibrary.simpleMessage("Tổng quan"),
        "reportOrder_Sell": MessageLookupByLibrary.simpleMessage("Bán hàng"),
        "reportOrder_promotionDiscount": MessageLookupByLibrary.simpleMessage("Khuyến mãi + Chiết khấu"),
        "reportOrder_amountTotal": MessageLookupByLibrary.simpleMessage("Tổng tiền"),
        "reportOrder_Discount": MessageLookupByLibrary.simpleMessage("Chiết khấu"),
        "reportOrder_Promotion": MessageLookupByLibrary.simpleMessage("Khuyến mãi"),
        "reportOrder_Detail": MessageLookupByLibrary.simpleMessage("Chi tiết"),
        "reportOrder_fastSaleOrder": MessageLookupByLibrary.simpleMessage("Bán hàng nhanh"),
        "reportOrder_Invoices": MessageLookupByLibrary.simpleMessage("Danh sách hóa đơn"),
        "reportOrder_Debt": MessageLookupByLibrary.simpleMessage("Nợ"),
        "reportOrder_Partner": MessageLookupByLibrary.simpleMessage("Khách hàng"),
        "reportOrder_Employee": MessageLookupByLibrary.simpleMessage("Nhân viên"),
        "reportOrder_Company": MessageLookupByLibrary.simpleMessage("Công ty"),
        "reportOrder_invoiceType": MessageLookupByLibrary.simpleMessage("Loại hóa đơn"),
    "reportOrder_deliveryStatistics": MessageLookupByLibrary.simpleMessage("Thống kê giao hàng"),
    "reportOrder_collectionAmount": MessageLookupByLibrary.simpleMessage("Tiền thu hộ"),
    "reportOrder_Paid": MessageLookupByLibrary.simpleMessage("Đã thanh toán"),
    "reportOrder_Delivering": MessageLookupByLibrary.simpleMessage("Đang giao"),
    "reportOrder_refundedOrder": MessageLookupByLibrary.simpleMessage("Trả hàng"),
    "reportOrder_controlFailed": MessageLookupByLibrary.simpleMessage("Đối soát  không thành công"),
    "reportOrder_Deposit": MessageLookupByLibrary.simpleMessage("Tổng tiền cọc"),
    "reportOrder_Invoice": MessageLookupByLibrary.simpleMessage("Hóa đơn"),
    "reportOrder_deliveryInvoices": MessageLookupByLibrary.simpleMessage("Hóa đơn giao hàng"),
    "reportOrder_deliveryControl": MessageLookupByLibrary.simpleMessage("Đối soát giao hàng"),
    "reportOrder_deliveryStatus": MessageLookupByLibrary.simpleMessage("Trạng thái giao hàng"),
    "reportOrder_controlStatus": MessageLookupByLibrary.simpleMessage("Trạng thái đối soát"),
    "reportOrder_deliveryPartner": MessageLookupByLibrary.simpleMessage("Đối tác giao hàng"),
    "reportOrder_deliveryPartnerType": MessageLookupByLibrary.simpleMessage("Loại đối tác giao hàng"),
      };
}
