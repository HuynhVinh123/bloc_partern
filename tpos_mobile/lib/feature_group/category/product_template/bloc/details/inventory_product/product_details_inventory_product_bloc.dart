import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/inventory_product/product_details_inventory_product_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/inventory_product/product_details_inventory_product_state.dart';

class ProductDetailsInventoryProductBloc
    extends Bloc<ProductDetailsInventoryProductEvent, ProductDetailsInventoryProductState> {
  ProductDetailsInventoryProductBloc({ProductTemplateApi productTemplateApi})
      : super(ProductDetailsInventoryProductLoading()) {
    _productTemplateApi = productTemplateApi ?? GetIt.I<ProductTemplateApi>();
  }

  ProductTemplateApi _productTemplateApi;

  final Logger _logger = Logger();
  List<InventoryProduct> _inventoryProducts = [];
  int _countInventoryProduct = 0;
  int _productTemplateId;

  @override
  Stream<ProductDetailsInventoryProductState> mapEventToState(ProductDetailsInventoryProductEvent event) async* {
    if (event is ProductDetailsInventoryProductStarted) {
      try {
        yield ProductDetailsInventoryProductLoading();
        _productTemplateId = event.productTemplateId;

        ///lấy danh sách inventoryProducts
        final GetProductTemplateInventoryQuery inventoryProductQuery =
            GetProductTemplateInventoryQuery(top: 20, skip: 0, productTmplId: _productTemplateId);

        final OdataListResult<InventoryProduct> inventoryResult =
            await _productTemplateApi.getInventoryProducts(inventoryProductQuery);
        _countInventoryProduct = inventoryResult.count;
        _inventoryProducts = inventoryResult.value;

        yield ProductDetailsInventoryProductLoadSuccess(inventoryProducts: _inventoryProducts);
      } catch (e, stack) {
        _logger.e('ProductDetailsInventoryProductLoadFailure', e, stack);
        yield ProductDetailsInventoryProductLoadFailure(error: e.toString());
      }
    } else if (event is ProductDetailsInventoryProductLoadMore) {
      try {
        ///lấy danh sách inventoryProducts
        if (_inventoryProducts.length < _countInventoryProduct) {
          final GetProductTemplateInventoryQuery inventoryProductQuery = GetProductTemplateInventoryQuery(
              top: 20, skip: _inventoryProducts.length, productTmplId: _productTemplateId);

          final OdataListResult<InventoryProduct> inventoryResult =
              await _productTemplateApi.getInventoryProducts(inventoryProductQuery);

          _inventoryProducts.addAll(inventoryResult.value);

          yield ProductDetailsInventoryProductLoadSuccess(inventoryProducts: _inventoryProducts);
        } else {
          yield ProductDetailsInventoryProductLoadNoMore(inventoryProducts: _inventoryProducts);
        }
      } catch (e, stack) {
        _logger.e('ProductDetailsInventoryProductLoadFailure', e, stack);
        yield ProductDetailsInventoryProductLoadFailure(error: e.toString());
      }
    } else if (event is ProductDetailsInventoryProductRefresh) {
      try {
        yield ProductDetailsInventoryProductLoading();

        ///lấy danh sách inventoryProducts
        final GetProductTemplateInventoryQuery inventoryProductQuery =
            GetProductTemplateInventoryQuery(top: 20, skip: 0, productTmplId: _productTemplateId);

        final OdataListResult<InventoryProduct> inventoryResult =
            await _productTemplateApi.getInventoryProducts(inventoryProductQuery);
        _countInventoryProduct = inventoryResult.count;
        _inventoryProducts = inventoryResult.value;

        yield ProductDetailsInventoryProductLoadSuccess(inventoryProducts: _inventoryProducts);
      } catch (e, stack) {
        _logger.e('ProductDetailsInventoryProductLoadFailure', e, stack);
        yield ProductDetailsInventoryProductLoadFailure(error: e.toString());
      }
    }
  }
}
