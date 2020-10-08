import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/DashboardReport.dart';
import 'package:tpos_mobile/src/tpos_apis/models/Order.dart';

class ReportDashboardEvent {}

class OrderFinancialLoaded extends ReportDashboardEvent{
  OrderFinancialLoaded({this.data,this.limit,this.skip,this.isRefund});
  final DashboardReportDataOverviewOption data;
  final int limit;
  final int skip;
  final bool isRefund;
}

class OrderFinancialLoadMoreLoaded extends ReportDashboardEvent{
  OrderFinancialLoadMoreLoaded({this.data,this.limit,this.skip,this.invoices,this.isRefund});
  final DashboardReportDataOverviewOption data;
  final List<OrderFinancial> invoices;
  final int limit;
  final int skip;
  final bool isRefund;
}