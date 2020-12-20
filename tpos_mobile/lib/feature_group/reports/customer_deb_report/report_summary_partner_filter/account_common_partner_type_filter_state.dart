import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';

class FilterState {}

class FilterLoading extends FilterState {}

/// Trả về dữ liệu khi thực hiện filter thành công
class FilterLoadSuccess extends FilterState {
  FilterLoadSuccess(
      {this.filterFromDate,
      this.filterToDate,
      this.isFilterByDate,
      this.filterDateRange,
      this.partner,
      this.companyOfUser,
      this.isFilterByPartner,
      this.isFilterByCompany,
      this.isFilterByStaff,
      this.isFilterByGroupPartner,
      this.isConfirm});

  final DateTime filterFromDate;
  final DateTime filterToDate;
  final bool isFilterByDate;
  final bool isFilterByStaff;
  final bool isFilterByCompany;
  final bool isFilterByPartner;
  final bool isFilterByGroupPartner;
  final AppFilterDateModel filterDateRange;
  final Partner partner;
  final CompanyOfUser companyOfUser;
  final bool isConfirm;
}
