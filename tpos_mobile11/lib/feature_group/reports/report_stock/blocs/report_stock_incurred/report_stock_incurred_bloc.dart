import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/report_stock_incurred/report_stock_incurred_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/report_stock_incurred/report_stock_incurred_state.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_stock.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../../../../../locator.dart';

class ReportStockIncurredBloc
    extends Bloc<ReportStockIncurredEvent, ReportStockIncurredState> {
  ReportStockIncurredBloc(
      {DialogService dialogService, ReportStockApi reportStockApi})
      : super(ReportStockIncurredLoading()) {
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
  Stream<ReportStockIncurredState> mapEventToState(
      ReportStockIncurredEvent event) async* {
    if (event is ReportStockIncurredLoaded) {
      /// Lấy báo cáo xuất nhập tồn phát sinh
      yield ReportStockIncurredLoading();
      yield* _getReportStockIncurred(event);
    } else if (event is ReportStockIncurredLoadMoreLoaded) {
      /// Loadmore danh sách trong báo cáo xuất nhập tồn phát sinh
      yield ReportStockIncurredLoadMoreLoading();
      yield* _getReportStockIncurredLoadMore(event);
    } else if (event is ReportStockIncurredFilterSaved) {
      /// Lưu filter và load lại báo cáo
      yield ReportStockIncurredLoading();
      _stockFilter = event.stockFilter;
      yield* _getReportStockIncurred(
          ReportStockIncurredLoaded(skip: event.skip, limit: event.limit),
          isFilter: event.isFilter);
    } else if (event is ReportStockIncurredLocalFilterSaved) {
      /// Lưu filter
      _stockFilter = event.stockFilter;
    }
  }

  Stream<ReportStockIncurredState> _getReportStockIncurred(
      ReportStockIncurredLoaded event,
      {bool isFilter = false}) async* {
    print(isFilter);
    try {
      final ReportStock reportStockIncurred =
          await _apiClient.getReportStockExt(
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
      if (reportStockIncurred.data.length == event.limit) {
        reportStockIncurred.data.add(tempReportStockData);
      }
      yield ReportStockIncurredLoadSuccess(
          reportStockIncurred: reportStockIncurred,
          isFilter: isFilter,
          stockFilter: _stockFilter);
    } catch (e) {
      yield ReportStockIncurredLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<ReportStockIncurredState> _getReportStockIncurredLoadMore(
      ReportStockIncurredLoadMoreLoaded event) async* {
    try {
      event.reportStockIncurred.data.removeWhere(
          (element) => element.productName == tempReportStockData.productName);
      final ReportStock reportStockLoadMores =
          await _apiClient.getReportStockExt(
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
      event.reportStockIncurred.data.addAll(reportStockLoadMores.data);
      yield ReportStockIncurredLoadSuccess(
          reportStockIncurred: event.reportStockIncurred,
          stockFilter: _stockFilter);
    } catch (e) {
      yield ReportStockIncurredLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }
}

var tempReportStockData = ReportStockData(productName: "temp");
