import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/report_stock_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/report_stock_state.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_stock.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class ReportStockBloc extends Bloc<ReportStockEvent, ReportStockState> {
  ReportStockBloc({DialogService dialogService, ReportStockApi reportStockApi})
      : super(ReportStockLoading()) {
    _dialog = dialogService ?? locator<DialogService>();
    _apiClient = reportStockApi ?? GetIt.instance<ReportStockApi>();
    _stockFilter = StockFilter();
    _stockFilter.filterDateRange = getTodayDateFilter();
    _stockFilter.dateTo = _stockFilter.filterDateRange.toDate;
    _stockFilter.dateFrom = _stockFilter.filterDateRange.fromDate;
  }
  DialogService _dialog;
  ReportStockApi _apiClient;
  StockFilter _stockFilter;

  @override
  Stream<ReportStockState> mapEventToState(ReportStockEvent event) async* {
    if (event is ReportStockLoaded) {
      /// Lấy danh sách báo cáo xuất nhập tồn
      yield ReportStockLoading();
      yield* _getReportStock(event);
    } else if (event is ReportStockLoadMoreLoaded) {
      /// Thực hiện load more danh sách xuất nhập tồn
      yield ReportStockLoadMoreLoading();
      yield* _getReportStockLoadMore(event);
    } else if (event is ReportStockFilterSaved) {
      /// Lưu filter và load danh sách xuất nhập tồn
      yield ReportStockLoading();
      _stockFilter = event.stockFilter;
      yield* _getReportStock(
          ReportStockLoaded(
            skip: event.skip,
            limit: event.limit,
          ),
          isFilter: event.isFilter);
    } else if (event is ReportStockLocalFilterSaved) {
      /// Lưu filter
      _stockFilter = event.stockFilter;
    }
  }

  Stream<ReportStockState> _getReportStock(ReportStockLoaded event,
      {bool isFilter = false}) async* {
    try {
      final ReportStock reportStock = await _apiClient.getReportStock(
          fromDate: _stockFilter.dateFrom,
          toDate: _stockFilter.dateTo,
          limit: event.limit,
          skip: event.skip,
          page: 1,
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
      if (reportStock.data.length == event.limit) {
        reportStock.data.add(tempReportStockData);
      }
      yield ReportStockLoadSuccess(
          reportStock: reportStock,
          isFilter: isFilter,
          stockFilter: _stockFilter);
    } catch (e) {
      yield ReportStockLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<ReportStockState> _getReportStockLoadMore(
      ReportStockLoadMoreLoaded event) async* {
    try {
      event.reportStock.data.removeWhere(
          (element) => element.productName == tempReportStockData.productName);
      final ReportStock reportStockLoadMores = await _apiClient.getReportStock(
          fromDate: _stockFilter.dateFrom,
          toDate: _stockFilter.dateTo,
          limit: event.limit,
          skip: event.skip,
          page: 1,
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
      if (reportStockLoadMores.data.length == event.limit) {
        reportStockLoadMores.data.add(tempReportStockData);
      }
      event.reportStock.data.addAll(reportStockLoadMores.data);
      yield ReportStockLoadSuccess(
          reportStock: event.reportStock, stockFilter: _stockFilter);
    } catch (e) {
      yield ReportStockLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }
}

var tempReportStockData = ReportStockData(productName: "temp");
