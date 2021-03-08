import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/stock_move/stock_move_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/stock_move/stock_move_state.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_stock.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class StockMoveBloc extends Bloc<StockMoveEvent, StockMoveState> {
  StockMoveBloc({ReportStockApi reportStockApi}) : super(StockMoveLoading()) {
    _apiClient = reportStockApi ?? GetIt.instance<ReportStockApi>();
    _stockFilter = StockFilter();
  }

  ReportStockApi _apiClient;
  StockFilter _stockFilter;

  @override
  Stream<StockMoveState> mapEventToState(StockMoveEvent event) async* {
    if (event is StockMoveLoaded) {
      _stockFilter = event.stockFilter;

      /// Lấy chi tiết báo cáo xuất nhập tồn phát sinh
      yield StockMoveLoading();
      yield* _getStockMove(event);
    } else if (event is StockMoveLoadMoreLoaded) {
      /// Loadmore danh sách trong báo cáo xuất nhập tồn phát sinh
      yield StockMoveLoadMoreLoading();
      yield* _getStockMoveLoadMore(event);
    }
  }

  Stream<StockMoveState> _getStockMove(StockMoveLoaded event,
      {bool isFilter = false}) async* {
//    try {
    final StockMoveProduct stockMoveProduct =
        await _apiClient
            .getStockMoveProduct(
                fromDate: _stockFilter.dateFrom,
                toDate: _stockFilter.dateTo,
                limit: event.limit,
                skip: event.skip,
                productTmplId: event.productTmplId,
                isIncludeCanceled: _stockFilter.includeCancelled,
                isIncludeReturned: _stockFilter.includeReturned,
                wareHouseId: _stockFilter.isFilterByWarehouseStock
                    ? _stockFilter.wareHouseStock?.id
                    : null,
                productCategoryId: _stockFilter.isFilterByProductCategory
                    ? _stockFilter.productCategory?.id
                    : null,
                keyWord: _stockFilter.isFilterByKeyWord
                    ? _stockFilter.keyWord
                    : null);

    if (stockMoveProduct.value.length == event.limit) {
      stockMoveProduct.value.add(tempReportStockData);
    }
    yield StockMoveLoadSuccess(stockMoveProduct: stockMoveProduct);
//    } catch (e) {
//      yield StockMoveLoadFailure(
//          title: S.current.notification, content: e.toString());
//    }
  }

  Stream<StockMoveState> _getStockMoveLoadMore(
      StockMoveLoadMoreLoaded event) async* {
    try {
      event.stockMoveProduct.value
          .removeWhere((element) => element.name == tempReportStockData.name);
      final StockMoveProduct stockMoveProductLoadMores =
          await _apiClient.getStockMoveProduct(
              fromDate: _stockFilter.dateFrom,
              toDate: _stockFilter.dateTo,
              limit: event.limit,
              skip: event.skip,
              productTmplId: event.productTmplId,
              isIncludeCanceled: _stockFilter.includeCancelled,
              isIncludeReturned: _stockFilter.includeReturned,
              wareHouseId: _stockFilter.isFilterByWarehouseStock
                  ? _stockFilter.wareHouseStock?.id
                  : null,
              productCategoryId: _stockFilter.isFilterByProductCategory
                  ? _stockFilter.productCategory?.id
                  : null,
              keyWord:
                  _stockFilter.isFilterByKeyWord ? _stockFilter.keyWord : null);
      if (stockMoveProductLoadMores.value.length == event.limit) {
        stockMoveProductLoadMores.value.add(tempReportStockData);
      }
      event.stockMoveProduct.value.addAll(stockMoveProductLoadMores.value);
      yield StockMoveLoadSuccess(stockMoveProduct: event.stockMoveProduct);
    } catch (e) {
      yield StockMoveLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }
}

var tempReportStockData = StockMoveProductValue(name: "temp");
