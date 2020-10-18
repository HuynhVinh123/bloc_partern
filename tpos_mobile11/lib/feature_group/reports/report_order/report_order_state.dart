import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';

class ReportOrderState {}

/// Chạy loading khi load trang tổng quan
class ReportSaleGeneralLoading extends ReportOrderState {}

/// Chạy loading khi thực hiện load more trang tổng quan
class ReportSaleGeneralLoadMoreLoading extends ReportOrderState {}

/// Chạy  loading khi thực hiện load chi tiết hóa đơn trang tổng quan
class DetailReportCustomerTypeSaleLoading extends ReportOrderState {}

/// Chạy  loading khi thực hiện load  more chi tiết hóa đơn trang tổng quan
class DetailReportCustomerTypeSaleLoadMoreLoading extends ReportOrderState {}

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

/// Chạy loading khi thực hiện load more trang nhân viên
class ReportOrderStaffLoadMoreLoading extends ReportOrderState {}

/// Trả về dữ liệu khi thực hiện load filter thành công
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

/// Trả về dữ liệu khi load trang tổng quan thành công
class ReportSaleGeneralLoadSuccess extends ReportOrderState {
  ReportSaleGeneralLoadSuccess({this.reportOrders, this.sumReportGeneral});
  final List<ReportOrder> reportOrders;
  final SumReportGeneral sumReportGeneral;
}

/// Trả về dữ liệu khi thực hiện load trang chi tiết thành công
class ReportOrderDetailLoadSuccess extends ReportOrderState {
  ReportOrderDetailLoadSuccess(
      {this.reportOrderDetails,
      this.sumReportOrderDetail,
      this.sumReportGeneral,
      this.countInvoies});
  final List<ReportOrderDetail> reportOrderDetails;
  final SumDataSale sumReportOrderDetail;
  final SumReportGeneral sumReportGeneral;
  final int countInvoies;
}

/// Trả về dữ liệu khi load danh sách khách hàng thành công
class ReportOrderPartnerLoadSuccess extends ReportOrderState {
  ReportOrderPartnerLoadSuccess({this.partnerSaleReports});
  final List<PartnerSaleReport> partnerSaleReports;
}

/// Trả về dữ liệu khi load danh sách nhân viên thanh công
class ReportOrderStaffLoadSuccess extends ReportOrderState {
  ReportOrderStaffLoadSuccess({this.staffSaleReports});
  final List<PartnerSaleReport> staffSaleReports;
}

/// Trả về dữ liệu khi load danh sách nhân viên thanh công
class DetailReportCustomerTypeSaleLoadSuccess extends ReportOrderState {
  DetailReportCustomerTypeSaleLoadSuccess({this.detailReportCustomerTypeSales});
  List<DetailReportCustomerTypeSale> detailReportCustomerTypeSales;
}

/// Báo lỗi khi thực hiện lấy danh sách dữ liệu thất bại
class ReportOrderLoadFailure extends ReportOrderState {
  ReportOrderLoadFailure({this.title, this.content});

  final String title;
  final String content;
}
