import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner.dart';
import 'package:tpos_mobile/src/tpos_apis/models/user_report_staff.dart';

class ReportOrderEvent {}

class ReportSaleGeneralLoaded extends ReportOrderEvent {
  ReportSaleGeneralLoaded({this.skip, this.limit});
  final int limit;
  final int skip;
}

class ReportSaleGeneralLoadMoreLoaded extends ReportOrderEvent {
  ReportSaleGeneralLoadMoreLoaded(
      {this.skip, this.limit, this.reportOrders, this.sumReportGeneral});
  final int limit;
  final int skip;
  List<ReportOrder> reportOrders;
  SumReportGeneral sumReportGeneral;
}

class ReportOrderDetailLoaded extends ReportOrderEvent {
  ReportOrderDetailLoaded({this.skip, this.limit});
  final int limit;
  final int skip;
}

class ReportOrderDetailLoadMoreLoaded extends ReportOrderEvent {
  ReportOrderDetailLoadMoreLoaded(
      {this.skip,
      this.limit,
      this.reportOrderDetails,
      this.sumReportGeneral,
      this.sumReportOrderDetail});
  final int limit;
  final int skip;
  final List<ReportOrderDetail> reportOrderDetails;
  final SumReportOrderDetail sumReportOrderDetail;
  final SumReportGeneral sumReportGeneral;
}

class ReportOrderPartnerLoaded extends ReportOrderEvent {
  ReportOrderPartnerLoaded({this.skip, this.limit});
  final int limit;
  final int skip;
}

class ReportOrderPartnerLoadMoreLoaded extends ReportOrderEvent {
  ReportOrderPartnerLoadMoreLoaded(
      {this.partnerSaleReports, this.skip, this.limit});
  final List<PartnerSaleReport> partnerSaleReports;
  final int limit;
  final int skip;
}

class ReportOrderStaffLoaded extends ReportOrderEvent {
  ReportOrderStaffLoaded({this.skip, this.limit});
  final int limit;
  final int skip;
}

class ReportOrderFilterSaved extends ReportOrderEvent {
  ReportOrderFilterSaved(
      {this.filterFromDate,
      this.filterToDate,
      this.isFilterByDate = false,
      this.filterDateRange,
      this.partner,
      this.companyOfUser,
      this.userReportStaffOrder,
      this.isFilterByStaff = false,
      this.isFilterByCompany = false,
      this.isFilterByPartner = false,
      this.isFilterByInvoiceType = false,
      this.orderType});

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
}
