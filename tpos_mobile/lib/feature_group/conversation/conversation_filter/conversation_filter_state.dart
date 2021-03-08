import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';

class ConversationFilterState {}

class ConversationFilterLoading extends ConversationFilterState {}

/// Trả về dữ liệu khi thực hiện filter thành công
class ConversationFilterLoadSuccess extends ConversationFilterState {
  ConversationFilterLoadSuccess(
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
      this.applicationUsers,
      this.applicationUserSelect,
      this.crmTags,
      this.crmTagSelect,
      this.isCheckTag});

  /// Có số điện thoại
  final bool isFilterHasPhone;

  ///Có địa chỉ
  final bool isFilterHasAddress;

  /// Hội thoại chưa đọc
  final bool isFilterConservationUnread;

  ///Có đơn hàng
  final bool isHasOrder;

  final bool isByStaff;
  final bool isCheckTag;

  /// Theo thời gian
  final DateTime filterFromDate;
  final DateTime filterToDate;
  final bool isFilterByDate;
  final AppFilterDateModel filterDateRange;
  final bool isConfirm;
  List<ApplicationUser> applicationUserSelect;
  OdataListResult<ApplicationUser> applicationUsers;
  OdataListResult<CRMTag> crmTags;
  List<CRMTag> crmTagSelect;
}
