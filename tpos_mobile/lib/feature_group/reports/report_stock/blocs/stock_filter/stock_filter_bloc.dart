import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/stock_filter/stock_filter_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/stock_filter/stock_filter_state.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_stock.dart';

class StockFilterBloc extends Bloc<StockFilterEvent, StockFilterState> {
  StockFilterBloc() : super(StockFilterLoading()) {
    _stockFilter.filterDateRange = getTodayDateFilter();
    _stockFilter.dateTo = _stockFilter.filterDateRange.toDate;
    _stockFilter.dateFrom = _stockFilter.filterDateRange.fromDate;
    _stockFilter.dateToCache = _stockFilter.filterDateRange.toDate;
    _stockFilter.dateFromCache = _stockFilter.filterDateRange.fromDate;
    _stockFilter.filterDateRangeCache = _stockFilter.filterDateRange;

    _stockFilter.productCategory = ProductCategory();
    _stockFilter.wareHouseStock = WareHouseStock();
    _stockFilter.wareHouseStockCache = WareHouseStock();
    _stockFilter.productCategoryCache = ProductCategory();
  }

  final StockFilter _stockFilter = StockFilter();
  // Cập nhật số liệu khi thực hiện confirm filter
  int _countFilter;
  // Mỗi lần thêm giảm 1 đối tượng filter
  int _count;

  @override
  Stream<StockFilterState> mapEventToState(StockFilterEvent event) async* {
    if (event is StockFilterLoaded) {
      _countFilter = countFilter(_stockFilter, false);

      ///  Load dữ liệu khi load page lần đầu
      yield StockFilterLoadSuccess(
          stockFilter: _stockFilter, countFilter: _countFilter);
    } else if (event is StockFilterChanged) {
      if (event.isConfirm) {
        _countFilter = countFilter(event.stockFilter, event.isConfirm);
      } else {
        _count = countFilter(event.stockFilter, event.isConfirm);
      }

      /// update lại dữ liệu mỗi lần thay đổi filter
      yield StockFilterLoadSuccess(
          stockFilter: event.stockFilter,
          countFilter: _countFilter,
          count: _count);
    }
  }

  int countFilter(StockFilter filter, bool isConfirm) {
    int count = 1;

    if (filter.isFilterByProductCategory) {
      count++;
    }
    if (filter.isFilterByWarehouseStock) {
      count++;
    }
    if (filter.includeCancelled) {
      count++;
    }
    if (filter.includeReturned) {
      count++;
    }
    if (filter.isFilterByKeyWord) {
      count++;
    }

    return count;
  }
}
