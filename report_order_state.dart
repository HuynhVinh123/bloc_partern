import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/src/tpos_apis/models/report_order.dart';

class ReportOrderState {}

/// Chạy loading khi load trang tổng quan
class ReportSaleGeneralLoading extends ReportOrderState {}

/// Chạy loading khi thực hiện load more trang tổng quan
class ReportSaleGeneralLoadMoreLoading extends ReportOrderState {}

/// Chạy  loading khi thực hiện load trang Chi tiết
class ReportOrderDetailLoading extends ReportOrderState {}

/// Chạy  loading khi thực hiện load more trang Chi tiết
class ReportOrderDetailLoadMoreLoading extends ReportOrderState {}

/// Chạy loading khi thực hiện load  trang khách hàng
class ReportOrderPartnerLoading extends ReportOrderState {}

/// Chạy loading khi thực hiện load more trang khách hàng
class ReportOrderPartnerLoadMoreLoading extends ReportOrderState {}

/// Chạy loading khi thực hiện load trang nhân viên
class ReportOrderStaffLoading extends ReportOrderState {}

class ReportOrderLoadSuccess extends ReportOrderState {
  ReportOrderLoadSuccess(
      {this.filterFromDate,
      this.filterToDate,
      this.isFilterByDate,
      this.filterDateRange});
  final DateTime filterFromDate;
  final DateTime filterToDate;
  final bool isFilterByDate;
  final AppFilterDateModel filterDateRange;
}

class ReportSaleGeneralLoadSuccess extends ReportOrderState {
  ReportSaleGeneralLoadSuccess({this.reportOrders, this.sumReportGeneral});
  final List<ReportOrder> reportOrders;
  final SumReportGeneral sumReportGeneral;
}

class ReportOrderDetailLoadSuccess extends ReportOrderState {
  ReportOrderDetailLoadSuccess(
      {this.reportOrderDetails, this.sumReportOrderDetail,this.sumReportGeneral});
  final List<ReportOrderDetail> reportOrderDetails;
  final SumReportOrderDetail sumReportOrderDetail;
  final SumReportGeneral sumReportGeneral;
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
