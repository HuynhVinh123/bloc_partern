import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/reports/thong_ke_giao_hang/report_delivery.dart';

class ReportDeliveryOrderState {}

/// Loading khi lây thông tin trang tổng quan
class ReportDeliveryFastSaleOrderLoading extends ReportDeliveryOrderState {}

/// Loading khi thực load more thông tin trang tổng quan
class ReportDeliveryFastSaleOrderLoadMoreLoading
    extends ReportDeliveryOrderState {}

/// Loading khi lấy thông tin trang khách hàng
class DeliveryReportCustomerLoading extends ReportDeliveryOrderState {}

/// Loading khi thực load more thông tin trang khách hàng
class DeliveryReportCustomerLoadMoreLoading extends ReportDeliveryOrderState {}

/// Loading khi lấy thông tin nhân viên, khách hàng
class DeliveryReportStaffLoading extends ReportDeliveryOrderState {}

/// Loading khi thực load more thông tin nhân viên
class DeliveryReportStaffLoadMoreLoading extends ReportDeliveryOrderState {}

/// Trả về dữ liệu khi thực hiện lấy thông tin trang tổng quan thành công
class ReportDeliveryFastSaleOrderLoadSuccess extends ReportDeliveryOrderState {
  ReportDeliveryFastSaleOrderLoadSuccess(
      {this.reportDeliveryFastSaleOrder, this.sumDeliveryReportFastSaleOrder});
  final DeliveryOrderReport reportDeliveryFastSaleOrder;
  final SumDeliveryReportFastSaleOrder sumDeliveryReportFastSaleOrder;
}

/// Trả về dữ liệu khi thực hiện lấy thông tin khách hàng thành công
class DeliveryReportCustomerLoadSuccess extends ReportDeliveryOrderState {
  DeliveryReportCustomerLoadSuccess({this.deliveryReportCustomers});
  final List<ReportDeliveryCustomer> deliveryReportCustomers;
}

/// Trả về dữ liệu khi thực hiện lấy thông tin nhân viên thành công
class DeliveryReportStaffLoadSuccess extends ReportDeliveryOrderState {
  DeliveryReportStaffLoadSuccess({this.deliveryReportStaffs});
  final List<ReportDeliveryCustomer> deliveryReportStaffs;
}

/// Lấy dữ liệu thông tin hóa đơn trang thông quan
class DeliveryReportOrderLinesLoadSuccess extends ReportDeliveryOrderState {
  DeliveryReportOrderLinesLoadSuccess({this.orderLines});
  final List<ReportDeliveryOrderLine> orderLines;
}

/// Lấy dữ liệu thông tin hóa đơn chi tiết nhân viên
class DetailDeliveryReportStaffLoadSuccess extends ReportDeliveryOrderState {
  DetailDeliveryReportStaffLoadSuccess({this.detailReportStaffs});
  final List<ReportDeliveryOrderDetail> detailReportStaffs;
}

/// Lấy dữ liệu thông tin hóa đơn chi tiết nhân viên
class DetailDeliveryReportCustomerLoadSuccess extends ReportDeliveryOrderState {
  DetailDeliveryReportCustomerLoadSuccess({this.invoices});
  final List<ReportDeliveryOrderDetail> invoices;
}

/// Trả về lỗi khi thực hiện lấy thông tin thất bại
class ReportDeliveryFastSaleOrderLoadFailure extends ReportDeliveryOrderState {
  ReportDeliveryFastSaleOrderLoadFailure({this.title, this.content});
  final String title;
  final String content;
}
