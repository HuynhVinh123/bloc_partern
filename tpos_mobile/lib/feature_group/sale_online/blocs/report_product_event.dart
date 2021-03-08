import 'package:tpos_api_client/tpos_api_client.dart';

class ReportProductEvent {}

class ReportProductLoaded extends ReportProductEvent {
  ReportProductLoaded({this.saleOnlineOrders});
  final List<SaleOnlineOrder> saleOnlineOrders;
}
