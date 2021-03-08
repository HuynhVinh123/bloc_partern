import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/inventory_max/inventory_max_event.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_stock.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import 'inventory_max_state.dart';

class InventoryMaxBloc extends Bloc<InventoryMaxEvent, InventoryMaxState> {
  InventoryMaxBloc({ReportStockApi reportStockApi})
      : super(InventoryMaxLoading()) {
    _apiClient = reportStockApi ?? GetIt.instance<ReportStockApi>();
    _stockFilter = StockFilter();
  }

  ReportStockApi _apiClient;
  StockFilter _stockFilter;

  @override
  Stream<InventoryMaxState> mapEventToState(InventoryMaxEvent event) async* {
    if (event is InventoryMaxLoaded) {
      /// Lấy danh sách sản phẩm vượt tồn
      yield InventoryMaxLoading();
      yield* _getInventoryMax(event);
    } else if (event is InventoryMaxLoadMoreLoaded) {
      /// Thực hiện loadmore danh sách sản phảm vượt tồn
      yield InventoryMaxLoadMoreLoading();
      yield* _getInventoryMaxLoadMore(event);
    } else if (event is InventoryMaxFilterSaved) {
      /// Lưu filter và lấy danh sách sản phẩm
      yield InventoryMaxLoading();
      _stockFilter = event.stockFilter;
      yield* _getInventoryMax(
          InventoryMaxLoaded(skip: event.skip, limit: event.limit),
          isFilter: event.isFilter);
    } else if (event is InventoryMaxLocalFilterSaved) {
      /// Lưu filter
      _stockFilter = event.stockFilter;
    }
  }

  Stream<InventoryMaxState> _getInventoryMax(InventoryMaxLoaded event,
      {bool isFilter = false}) async* {
    try {
      final List<StockWarehouseProduct> products =
          await _apiClient.reportInventoryMaxStock(
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
      yield InventoryMaxLoadSuccess(products: products, isFilter: isFilter);
    } catch (e) {
      yield InventoryMaxLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  Stream<InventoryMaxState> _getInventoryMaxLoadMore(
      InventoryMaxLoadMoreLoaded event) async* {
    try {
      event.products
          .removeWhere((element) => element.uOMName == tempProduct.uOMName);
      final List<StockWarehouseProduct> productLoadMores =
          await _apiClient.reportInventoryMaxStock(
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
      yield InventoryMaxLoadSuccess(products: event.products);
    } catch (e) {
      yield InventoryMaxLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }
}

var tempProduct = StockWarehouseProduct(uOMName: "temp");
