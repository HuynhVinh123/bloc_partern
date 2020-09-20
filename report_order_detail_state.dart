import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/report_order_detail_page.dart';

class ReportOrderDetailState {}

class ReportOrderDetailLoading extends ReportOrderDetailState {}

class ReportOrderDetailLoadSuccess extends ReportOrderDetailState {
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

class ReportSaleGeneralLoadFailure extends ReportOrderDetailState {
  ReportSaleGeneralLoadFailure({this.title, this.content});

  final String title;
  final String content;
}
