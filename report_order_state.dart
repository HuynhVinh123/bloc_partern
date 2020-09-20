import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/src/tpos_apis/models/report_order.dart';

class ReportOrderState {}

class ReportOrderLoading extends ReportOrderState {}

class ReportOrderLoadSuccess extends ReportOrderState {
  ReportOrderLoadSuccess({this.filterFromDate,this.filterToDate,this.isFilterByDate,this.filterDateRange});
  final DateTime filterFromDate;
  final DateTime filterToDate;
  final bool isFilterByDate;
  final AppFilterDateModel filterDateRange;
}

class ReportSaleGeneralLoadSuccess extends ReportOrderState {
  ReportSaleGeneralLoadSuccess(
      {this.reportOrders, this.sumReportGeneral, this.userCompanies});
  final List<ReportOrder> reportOrders;
  final SumReportGeneral sumReportGeneral;
  final List<UserCompany> userCompanies;
}

class ReportOrderDetailLoadSuccess extends ReportOrderState {
  ReportOrderDetailLoadSuccess(
      {this.reportOrderDetails,
      this.sumReportOrderDetail,
      this.userCompanies,
      this.userReportStaffOrders});
  final List<ReportOrderDetail> reportOrderDetails;
  final SumReportOrderDetail sumReportOrderDetail;
  final List<UserCompany> userCompanies;
  final List<UserReportStaffOrder> userReportStaffOrders;
}

class ReportOrderPartnerLoadSuccess extends ReportOrderState {
  ReportOrderPartnerLoadSuccess({this.partnerSaleReports});
  final List<PartnerSaleReport> partnerSaleReports;
}

class ReportOrderStaffLoadSuccess extends ReportOrderState {
  ReportOrderStaffLoadSuccess({this.staffSaleReports});
  final List<PartnerSaleReport> staffSaleReports;
}

class ReportOrderLoadFailure extends ReportOrderState {
  ReportOrderLoadFailure({this.title, this.content});

  final String title;
  final String content;
}
