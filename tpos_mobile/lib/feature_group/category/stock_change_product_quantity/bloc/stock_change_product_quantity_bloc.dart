import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/bloc/stock_change_product_quantity_event.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/bloc/stock_change_product_quantity_state.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/models/stock_change_product_quantity.dart';
import 'package:tpos_mobile/src/tpos_apis/models/stock_location.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/product_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/stock_change_product_qty_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/stock_location_api.dart';

class StockChangeProductQuantityBloc extends Bloc<StockChangeProductQuantityEvent, StockChangeProductQuantityState> {
  StockChangeProductQuantityBloc(
      {IStockChangeProductQtyApi stockChangeProductQtyApi, ProductApi productApi, StockLocationApi stockLocationApi})
      : super(StockChangeProductQuantityLoading()) {
    _stockChangeProductQtyApi = stockChangeProductQtyApi ?? locator<IStockChangeProductQtyApi>();
    _productApi = productApi ?? locator<ProductApi>();
    _stockLocationApi = stockLocationApi ?? locator<StockLocationApi>();
  }

  final Logger _logger = Logger();
  ProductApi _productApi;
  StockLocationApi _stockLocationApi;
  List<StockLocation> _locations;
  List<Product> _products;
  List<StockProductionLot> _stockProductionLots;
  IStockChangeProductQtyApi _stockChangeProductQtyApi;
  StockChangeProductQuantity _stockChangeProductQty;
  int _productTemplateId;

  @override
  Stream<StockChangeProductQuantityState> mapEventToState(StockChangeProductQuantityEvent event) async* {
    if (event is StockChangeProductQuantityInitial) {
      try {
        yield StockChangeProductQuantityLoading();
        _productTemplateId = event.productTemplateId;
        _locations = await _stockLocationApi.getAll();
        _stockChangeProductQty = await _stockChangeProductQtyApi.defaultGet(_productTemplateId);
        _products = await _productApi.getByTemplateId(_productTemplateId);
        yield StockChangeProductQuantityLoadSuccess(
            products: _products,
            locations: _locations,
            stockChangeProductQuantity: _stockChangeProductQty,
            stockProductionLots: _stockProductionLots);
      } catch (e, stack) {
        _logger.e('StockChangeProductQuantityLoadFailure', e, stack);
        yield StockChangeProductQuantityLoadFailure(error: e.toString());
      }
    } else if (event is StockChangeProductQuantitySaved) {
      try {
        yield StockChangeProductQuantityBusy();
        _stockChangeProductQty.locationId = _stockChangeProductQty.location?.id;
        _stockChangeProductQty.productId = _stockChangeProductQty.product?.id;
        _stockChangeProductQty.productTmplId = _stockChangeProductQty.productTmpl?.id;
        final StockChangeProductQuantity result = await _stockChangeProductQtyApi.insert(_stockChangeProductQty);
        await _stockChangeProductQtyApi.changeProductQuantity(result.id);
        yield StockChangeProductQuantitySaveSuccess(
            products: _products,
            locations: _locations,
            stockChangeProductQuantity: _stockChangeProductQty,
            stockProductionLots: _stockProductionLots);
      } catch (e, stack) {
        _logger.e('StockChangeProductQuantitySaveError', e, stack);
        yield StockChangeProductQuantitySaveError(error: e.toString());
        yield StockChangeProductQuantityLoadSuccess(
            products: _products,
            locations: _locations,
            stockChangeProductQuantity: _stockChangeProductQty,
            stockProductionLots: _stockProductionLots);
      }
    } else if (event is StockChangeProductQuantityUpdateLocal) {
      _stockChangeProductQty = event.stockChangeProductQuantity;
    }
  }
}
