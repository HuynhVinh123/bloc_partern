import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/inventory_min/inventory_min_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/inventory_min/inventory_min_state.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_stock.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class InventoryMinBloc extends Bloc<InventoryMinEvent, InventoryMinState> {
  InventoryMinBloc({ReportStockApi reportStockApi})
      : super(InventoryMinLoading()) {
    _apiClient = reportStockApi ?? GetIt.instance<ReportStockApi>();
    _stockFilter = StockFilter();
  }

  ReportStockApi _apiClient;
  StockFilter _stockFilter;

  @override
  Stream<InventoryMinState> mapEventToState(InventoryMinEvent event) async* {
    if (event is InventoryMinLoaded) {
      /// Lấy danh sách sản phẩm hết hạn
      yield InventoryMinLoading();
      yield* _getInventoryMin(event);
    } else if (event is InventoryMinLoadMoreLoaded) {
      /// Thực hiện loadmore danh sách sản phảm hết hạn
      yield InventoryMinLoadMoreLoading();
      yield* _getInventoryMinLoadMore(event);
    } else if (event is InventoryMinFilterSaved) {
      /// Lưu filter và lấy danh sách sản phẩm
      yield InventoryMinLoading();
      _stockFilter = event.stockFilter;
      yield* _getInventoryMin(
          InventoryMinLoaded(skip: event.skip, limit: event.limit),
          isFilter: event.isFilter);
    } else if (event is InventoryMinLocalFilterSaved) {
      /// Lưu filter
      _stockFilter = event.stockFilter;
    }
  }

  Stream<InventoryMinState> _getInventoryMin(InventoryMinLoaded event,
      {bool isFilter = false}) async* {
    try {
      final List<StockWarehouseProduct> products =
          await _apiClient.reportInventoryMinStock(
              limit: event.limit,
              skip: event.skip,
              categId: _stockFilter.isFilterByProductCategory
                  ? _stockFilter.productCategory.id
                  : null,
              id: _stockFilter.isFilterByWarehouseStock
                  ? _stockFilter.wareHouseStock.id
                  : null);
      if (products.length == event.limit) {
        products.add(tempProduct);
      }
      yield InventoryMinLoadSuccess(products: products, isFilter: isFilter);
    } catch (e) {
      yield InventoryMinLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<InventoryMinState> _getInventoryMinLoadMore(
      InventoryMinLoadMoreLoaded event) async* {
    try {
      event.products
          .removeWhere((element) => element.uOMName == tempProduct.uOMName);
      final List<StockWarehouseProduct> productLoadMores =
          await _apiClient.reportInventoryMinStock(
              limit: event.limit,
              skip: event.skip,
              categId: _stockFilter.isFilterByProductCategory
                  ? _stockFilter.productCategory.id
                  : null,
              id: _stockFilter.isFilterByWarehouseStock
                  ? _stockFilter.wareHouseStock.id
                  : null);

      if (productLoadMores.length == event.limit) {
        productLoadMores.add(tempProduct);
      }
      event.products.addAll(productLoadMores);
      yield InventoryMinLoadSuccess(products: event.products);
    } catch (e) {
      yield InventoryMinLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }
}

var tempProduct = StockWarehouseProduct(uOMName: "temp");
