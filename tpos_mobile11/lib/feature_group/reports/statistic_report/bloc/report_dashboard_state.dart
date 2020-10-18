import 'package:tpos_api_client/tpos_api_client.dart';

class ReportDashboardState{}

class OrderFinancialLoading extends ReportDashboardState{}
class OrderFinancialLoadMoreLoading extends ReportDashboardState{}
class OrderFinancialLoadSuccess extends ReportDashboardState{
  OrderFinancialLoadSuccess({this.invoices});
  final List<OrderFinancial> invoices;

}
class OrderFinancialLoadFailure extends ReportDashboardState{
  OrderFinancialLoadFailure({this.title,this.content});
  final String title;
  final String content;
}