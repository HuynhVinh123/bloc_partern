import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product/bloc/product_variant_details_event.dart';
import 'package:tpos_mobile/feature_group/category/product/bloc/product_variant_details_state.dart';

class ProductVariantDetailsBloc extends Bloc<ProductVariantDetailsEvent, ProductVariantDetailsState> {
  ProductVariantDetailsBloc({ProductVariantApi productApi}) : super(ProductVariantDetailsLoading()) {
    _productApi = productApi ?? GetIt.I<ProductVariantApi>();
  }

  ProductVariantApi _productApi;
  final Logger _logger = Logger();
  Product _product;
  int _productId;

  @override
  Stream<ProductVariantDetailsState> mapEventToState(ProductVariantDetailsEvent event) async* {
    if (event is ProductVariantDetailsStarted) {
      try {
        yield ProductVariantDetailsLoading();
        _productId = event.productId;
        _product = await _productApi.getById(_productId, expand: 'UOM,Categ,UOMPO,POSCateg,AttributeValues');
        yield ProductVariantDetailsLoadSuccess(product: _product);
      } catch (e, stack) {
        _logger.e('ProductVariantDetailsLoadFailure', e, stack);
        yield ProductVariantDetailsLoadFailure(error: e.toString());
      }
    } else if (event is ProductVariantDetailsActiveSet) {
      try {
        yield ProductVariantDetailsBusy();
        await _productApi.setActive(!_product.active, [_product?.id]);

        _product.active = !_product.active;
        yield ProductVariantDetailsSetActiveSuccess(product: _product, active: _product.active);
      } catch (e, stack) {
        _logger.e('ProductVariantDetailsSetActiveFailure', e, stack);
        yield ProductVariantDetailsSetActiveFailure(error: e.toString());
      }
    } else if (event is ProductVariantDetailsDelete) {
      try {
        yield ProductVariantDetailsBusy();

        await _productApi.delete(_product?.id);

        yield ProductVariantDetailsDeleteSuccess(product: _product);
      } catch (e, stack) {
        _logger.e('ProductVariantDetailsDeleteFailure', e, stack);
        yield ProductVariantDetailsDeleteFailure(error: e.toString());
      }
    }
  }
}
