import 'package:tpos_api_client/tpos_api_client.dart';

class ReportDeliveryFastSaleOrderState {}

class ReportDeliveryFastSaleOrderLoading
    extends ReportDeliveryFastSaleOrderState {}

class DeliveryReportCustomerLoading extends ReportDeliveryFastSaleOrderState {}

class DeliveryReportCustomerLoadMoreLoading extends ReportDeliveryFastSaleOrderState {}

class ReportDeliveryFastSaleOrderLoadSuccess
    extends ReportDeliveryFastSaleOrderState {
  ReportDeliveryFastSaleOrderLoadSuccess(
      {this.reportDeliveryFastSaleOrder, this.sumDeliveryReportFastSaleOrder});
  final ReportDeliveryFastSaleOrder reportDeliveryFastSaleOrder;
  final SumDeliveryReportFastSaleOrder sumDeliveryReportFastSaleOrder;
}

class DeliveryReportCustomerLoadSuccess
    extends ReportDeliveryFastSaleOrderState {
  DeliveryReportCustomerLoadSuccess({this.deliveryReportCustomers});
  final List<DeliveryReportCustomer> deliveryReportCustomers;
}

class ReportDeliveryFastSaleOrderLoadFailure
    extends ReportDeliveryFastSaleOrderState {
  ReportDeliveryFastSaleOrderLoadFailure({this.title, this.content});
  final String title;
  final String content;
}
