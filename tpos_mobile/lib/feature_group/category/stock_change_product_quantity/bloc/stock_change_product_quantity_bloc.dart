import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
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
      {IStockChangeProductQtyApi stockChangeProductQtyApi,
      ProductApi productApi,
      StockLocationApi stockLocationApi,
      StockProductionLotApi stockProductionLotApi})
      : super(StockChangeProductQuantityLoading()) {
    _stockChangeProductQtyApi = stockChangeProductQtyApi ?? locator<IStockChangeProductQtyApi>();
    _productApi = productApi ?? locator<ProductApi>();
    _stockLocationApi = stockLocationApi ?? locator<StockLocationApi>();
    _stockProductionLotApi = stockProductionLotApi ?? GetIt.I<StockProductionLotApi>();
  }

  final Logger _logger = Logger();
  ProductApi _productApi;
  StockLocationApi _stockLocationApi;
  StockProductionLotApi _stockProductionLotApi;

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
        final OdataListQuery query = OdataListQuery(
            top: null, skip: null, filter: 'ProductId eq ${_stockChangeProductQty.product?.id}', orderBy: null);
        final OdataListResult<StockProductionLot> result =
            await _stockProductionLotApi.getStockProductionLots(query: query);
        _stockProductionLots = result.value;
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
    } else if (event is StockChangeProductQuantityProductChanged) {
      _stockChangeProductQty = event.stockChangeProductQuantity;
      final Product oldProduct = Product.copyWith(_stockChangeProductQty.product);
      try {
        yield StockChangeProductQuantityBusy();

        _stockChangeProductQty.product = event.product;
        _stockChangeProductQty.productId = event.product?.id;

        final StockChangeProductQuantity stockChangeProductQty = await _stockChangeProductQtyApi
            .getOnChangedProduct(_stockChangeProductQty, expand: "ProductTmpl,Product,Location");

        final OdataListQuery query =
            OdataListQuery(top: null, skip: null, filter: 'ProductId eq ${event.product?.id}', orderBy: null);
        final OdataListResult<StockProductionLot> result =
            await _stockProductionLotApi.getStockProductionLots(query: query);
        _stockProductionLots = result.value;

        if (stockChangeProductQty != null) {
          _stockChangeProductQty = stockChangeProductQty;
        }

        yield StockChangeProductQuantityProductChangeSuccess(
            products: _products,
            locations: _locations,
            stockChangeProductQuantity: _stockChangeProductQty,
            stockProductionLots: _stockProductionLots);
      } catch (e, stack) {
        _stockChangeProductQty.product = oldProduct;
        _stockChangeProductQty.productId = oldProduct?.id;
        _logger.e('StockChangeProductQuantityProductChangeError', e, stack);
        yield StockChangeProductQuantityProductChangeError(error: e.toString());
      }
    }
  }
}
