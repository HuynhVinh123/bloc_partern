import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_report_delivery.dart';

class ReportDeliveryOrderEvent {}

/// Láy danh sách hóa đơn trang tổng quan hóa đơn giao hàng
class ReportDeliveryFastSaleOrderLoaded extends ReportDeliveryOrderEvent {
  ReportDeliveryFastSaleOrderLoaded({this.skip, this.limit});

  final int limit;
  final int skip;
}

///Event Load more danh sách hóa đơn trang tổng quan hóa đơn giao hàng
class ReportDeliveryFastSaleOrderLoadMoreLoaded
    extends ReportDeliveryOrderEvent {
  ReportDeliveryFastSaleOrderLoadMoreLoaded(
      {this.skip,
      this.limit,
      this.reportDeliveryFastSaleOrder,
      this.sumDeliveryReportFastSaleOrder});

  final int limit;
  final int skip;
  final DeliveryOrderReport reportDeliveryFastSaleOrder;
  final SumDeliveryReportFastSaleOrder sumDeliveryReportFastSaleOrder;
}

/// Lấy danh sách khách hàng trong thống kê hóa đơn giao hàng
class DeliveryReportCustomerLoaded extends ReportDeliveryOrderEvent {
  DeliveryReportCustomerLoaded({this.skip, this.limit});

  final int limit;
  final int skip;
}

/// Event load more  Lấy danh sách khách hàng trong thống kê hóa đơn giao hàng
class DeliveryReportCustomerLoadMoreLoaded extends ReportDeliveryOrderEvent {
  DeliveryReportCustomerLoadMoreLoaded(
      {this.skip, this.limit, this.deliveryReportCustomers});

  final int limit;
  final int skip;
  List<ReportDeliveryCustomer> deliveryReportCustomers;
}

/// Lấy danh sách nhân viên trong thống kê hóa đơn giao hàng
class DeliveryReportStaffLoaded extends ReportDeliveryOrderEvent {
  DeliveryReportStaffLoaded({this.skip, this.limit});
  final int limit;
  final int skip;
}

/// Event load more danh sách nhân viên thống kê hóa đơn
class DeliveryReportStaffLoadMoreLoaded extends ReportDeliveryOrderEvent {
  DeliveryReportStaffLoadMoreLoaded(
      {this.skip, this.limit, this.deliveryReportStaffs});
  final int limit;
  final int skip;
  List<ReportDeliveryCustomer> deliveryReportStaffs;
}

/// Event cập nhật thông tin danh sách hóa đơn cho trang tổng quan
class ReportDeliveryFastSaleOrderInvoiceFromLocalLoaded
    extends ReportDeliveryOrderEvent {
  ReportDeliveryFastSaleOrderInvoiceFromLocalLoaded(
      {this.reportDeliveryFastSaleOrder, this.sumDeliveryReportFastSaleOrder});
  final DeliveryOrderReport reportDeliveryFastSaleOrder;
  final SumDeliveryReportFastSaleOrder sumDeliveryReportFastSaleOrder;
}

/// Event lưu thông tin filter
class ReportDeliveryFastSaleOrderFilterSaved extends ReportDeliveryOrderEvent {
  ReportDeliveryFastSaleOrderFilterSaved({this.filterReportDelivery});
  final FilterReportDelivery filterReportDelivery;
}

/// Event lấy thông tin chi tiết cho hóa đơn
class DeliveryReportOrderLinesLoaded extends ReportDeliveryOrderEvent {
  DeliveryReportOrderLinesLoaded({this.id});
  final int id;
}

/// Event lấy thông tin chi tiết cho nhân viên
class DetailDeliveryReportStaffLoaded extends ReportDeliveryOrderEvent {
  DetailDeliveryReportStaffLoaded({this.skip, this.limit, this.userId});
  final int limit;
  final int skip;
  final String userId;
}

/// Event lấy thông tin chi tiết cho nhân viên(Xử lý load more)
class DetailDeliveryReportStaffLoadMoreLoaded extends ReportDeliveryOrderEvent {
  DetailDeliveryReportStaffLoadMoreLoaded(
      {this.skip, this.limit, this.detailReportStaffs, this.userId});
  final int limit;
  final int skip;
  final List<ReportDeliveryOrderDetail> detailReportStaffs;
  final String userId;
}

/// Event lấy thông tin chi tiết cho khách hàng
class DetailDeliveryReportCustomerLoaded extends ReportDeliveryOrderEvent {
  DetailDeliveryReportCustomerLoaded({this.skip, this.limit, this.partnerId});
  final int limit;
  final int skip;
  final int partnerId;
}

/// Event lấy thông tin chi tiết cho khách hàng(Xử lý load more)
class DetailDeliveryReportCustomerLoadMoreLoaded
    extends ReportDeliveryOrderEvent {
  DetailDeliveryReportCustomerLoadMoreLoaded(
      {this.skip, this.limit, this.invoices, this.partnerId});
  final int limit;
  final int skip;
  final List<ReportDeliveryOrderDetail> invoices;
  final int partnerId;
}
