import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/reports/statistic_report/bloc/report_dashboard_event.dart';
import 'package:tpos_mobile/feature_group/reports/statistic_'
    'report/bloc/report_dashboard_state.dart';

class ReportDashboardBloc
    extends Bloc<ReportDashboardEvent, ReportDashboardState> {
  ReportDashboardBloc() : super(OrderFinancialLoading()) {
    _apiClient = GetIt.instance<AlertApi>();
  }

  AlertApi _apiClient;

  @override
  Stream<ReportDashboardState> mapEventToState(
      ReportDashboardEvent event) async* {
    if (event is OrderFinancialLoaded) {
      yield OrderFinancialLoading();
      try{
        List<OrderFinancial> invoices  ;
        if(event.isRefund){
          invoices= await _apiClient.getOrderFinancialRefund(
              limit: event.limit,
              skip: event.skip,
              overViewValue: event.data.value
          );
        }else{
          invoices= await _apiClient.getOrderFinancial(
              limit: event.limit,
              skip: event.skip,
              overViewValue: event.data.value
          );
        }


        if (invoices.length >= event.limit) {
          invoices.add(tempReportOrderDetail);
        }

        yield OrderFinancialLoadSuccess(invoices: invoices);
      }catch(e){
        print(e.toString());
          yield OrderFinancialLoadFailure(title: "Lỗi",content: e.toString());
      }
    }else if(event is OrderFinancialLoadMoreLoaded){
      yield OrderFinancialLoadMoreLoading();
      try{
        event.invoices
            .removeWhere((element) => element.orderCode == tempReportOrderDetail.orderCode);

         List<OrderFinancial> invoicesLoadMore ;

          if(event.isRefund){
            invoicesLoadMore = await _apiClient.getOrderFinancialRefund(
                limit: event.limit,
                skip: event.skip,
                overViewValue: event.data.value
            );
          }else{
            invoicesLoadMore = await _apiClient.getOrderFinancial(
                limit: event.limit,
                skip: event.skip,
                overViewValue: event.data.value
            );
          }


        if (invoicesLoadMore.length >= event.limit) {
          invoicesLoadMore.add(tempReportOrderDetail);
        }

        event.invoices.addAll(invoicesLoadMore);
        yield OrderFinancialLoadSuccess(invoices:  event.invoices);
      }catch(e){
        yield OrderFinancialLoadFailure(title: "Lỗi",content: e.toString());
      }
    }
  }
}

var tempReportOrderDetail = OrderFinancial(orderCode: "temp");