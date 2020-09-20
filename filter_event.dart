import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner.dart';

class FilterEvent {}

class FilterLoaded extends FilterEvent {}

class FilterChanged extends FilterEvent {
  FilterChanged({
    this.filterFromDate,
    this.filterToDate,
    this.isFilterByDate,
    this.filterDateRange,
    this.partner,
    this.companyOfUser,
    this.userReportStaffOrder,
    this.isFilterByStaff,this.isFilterByCompany,this.isFilterByPartner,this.isFilterByInvoiceType,this.orderType
  });

  final DateTime filterFromDate;
  final DateTime filterToDate;
  final bool isFilterByDate;
  final bool isFilterByStaff;
  final bool isFilterByCompany;
  final bool isFilterByPartner;
  final bool isFilterByInvoiceType;
  final AppFilterDateModel filterDateRange;
  final Partner partner;
  final UserCompany companyOfUser;
  final UserReportStaffOrder userReportStaffOrder;
  final String orderType;
}
