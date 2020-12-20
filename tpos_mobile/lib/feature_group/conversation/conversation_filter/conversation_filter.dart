import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';

class ConversationFilter {
  ConversationFilter(
      {this.dateFrom,
      this.dateTo,
      this.filterDateRange,
      this.isFilterHasPhone,
      this.isFilterHasAddress,
      this.isFilterConservationUnread,
      this.isHasOrder,
      this.filterFromDate,
      this.filterToDate,
      this.isFilterByDate = false,
      this.isByStaff,
      this.isConfirm,
      this.isCheckStaff = false,
      this.isCheckTag = false,
      this.applicationUserListSelect,
      this.crmTagListSelect});
  DateTime dateFrom;
  DateTime dateTo;
  AppFilterDateModel filterDateRange;

  /// Có số điện thoại
  bool isFilterHasPhone;

  ///Có địa chỉ
  bool isFilterHasAddress;

  /// Hội thoại chưa đọc
  bool isFilterConservationUnread;
  bool isCheckStaff;
  bool isCheckTag;

  ///Có đơn hàng
  bool isHasOrder;
  bool isByStaff;

  /// Theo thời gian
  DateTime filterFromDate;
  DateTime filterToDate;
  bool isFilterByDate;
  bool isConfirm;

  List<ApplicationUser> applicationUserListSelect;
  List<CRMTag> crmTagListSelect;
}
