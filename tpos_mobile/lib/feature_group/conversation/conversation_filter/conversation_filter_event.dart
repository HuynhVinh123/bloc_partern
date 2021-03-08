import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';

class ConversationFilterEvent {}

/// Load dữ liêu filter khi mới vào page
class ConversationFilterLoaded extends ConversationFilterEvent {}

/// Thực hiện thay đổi filter
class ConversationFilterChanged extends ConversationFilterEvent {
  ConversationFilterChanged(
      {this.isFilterHasPhone,
      this.isFilterHasAddress,
      this.isFilterConservationUnread,
      this.filterFromDate,
      this.filterToDate,
      this.isFilterByDate,
      this.filterDateRange,
      this.isHasOrder,
      this.isConfirm = false,
      this.isByStaff,
      this.isCheckStaff,
      this.applicationUserList,
      this.crmTagList,
      this.isCheckTag});

  /// Có số điện thoại
  final bool isFilterHasPhone;

  ///Có địa chỉ
  final bool isFilterHasAddress;

  /// Hội thoại chưa đọc
  final bool isFilterConservationUnread;

  ///Có đơn hàng
  final bool isHasOrder;

  /// Theo thời gian
  final DateTime filterFromDate;
  final DateTime filterToDate;
  final bool isFilterByDate;
  final AppFilterDateModel filterDateRange;
  final bool isConfirm;
  final bool isByStaff;
  final bool isCheckStaff;
  final bool isCheckTag;

  ///Danh sách người dùng
  List<ApplicationUser> applicationUserList;

  /// Danh sách tag
  List<CRMTag> crmTagList;
}
