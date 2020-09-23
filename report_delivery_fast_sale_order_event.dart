import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_report_delivery.dart';

class ReportDeliveryFastSaleOrderEvent {}

/// Láy danh sách hóa đơn trang tổng quan hóa đơn giao hàng
class ReportDeliveryFastSaleOrderLoaded
    extends ReportDeliveryFastSaleOrderEvent {}

class ReportDeliveryFastSaleOrderInvoiceFromLocalLoaded
    extends ReportDeliveryFastSaleOrderEvent {
  ReportDeliveryFastSaleOrderInvoiceFromLocalLoaded({this.reportDeliveryFastSaleOrder,this.sumDeliveryReportFastSaleOrder});
  final ReportDeliveryFastSaleOrder reportDeliveryFastSaleOrder;
  final SumDeliveryReportFastSaleOrder sumDeliveryReportFastSaleOrder;
}

/// Lấy danh sách khách hàng trong thống kê hóa đơn giao hàng
class DeliveryReportCustomerLoaded extends ReportDeliveryFastSaleOrderEvent {
  DeliveryReportCustomerLoaded({this.skip, this.limit});

  final int limit;
  final int skip;
}

class DeliveryReportCustomerLoadMoreLoaded
    extends ReportDeliveryFastSaleOrderEvent {
  DeliveryReportCustomerLoadMoreLoaded(
      {this.skip, this.limit, this.deliveryReportCustomers});

  final int limit;
  final int skip;
  List<DeliveryReportCustomer> deliveryReportCustomers;
}

class ReportDeliveryFastSaleOrderFilterSaved
    extends ReportDeliveryFastSaleOrderEvent {
  ReportDeliveryFastSaleOrderFilterSaved({this.filterReportDelivery});

  final FilterReportDelivery filterReportDelivery;
}
