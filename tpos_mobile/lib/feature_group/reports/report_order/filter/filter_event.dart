import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/user_report_staff.dart';

class FilterEvent {}

/// Load dữ liêu filter khi mới vào page
class FilterLoaded extends FilterEvent {}

/// Thực hiện thay đổi filter
class FilterChanged extends FilterEvent {
  FilterChanged(
      {this.filterFromDate,
      this.filterToDate,
      this.isFilterByDate,
      this.filterDateRange,
      this.partner,
      this.companyOfUser,
      this.userReportStaffOrder,
      this.isFilterByStaff,
      this.isFilterByCompany,
      this.isFilterByPartner,
      this.isFilterByInvoiceType,
      this.orderType,
      this.isConfirm = false});

  final DateTime filterFromDate;
  final DateTime filterToDate;
  final bool isFilterByDate;
  final bool isFilterByStaff;
  final bool isFilterByCompany;
  final bool isFilterByPartner;
  final bool isFilterByInvoiceType;
  final AppFilterDateModel filterDateRange;
  final Partner partner;
  final CompanyOfUser companyOfUser;
  final UserReportStaff userReportStaffOrder;
  final String orderType;
  final bool isConfirm;
}
