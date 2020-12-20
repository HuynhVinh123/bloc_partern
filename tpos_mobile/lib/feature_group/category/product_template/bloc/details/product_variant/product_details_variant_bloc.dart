import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/product_variant/product_details_variant_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/product_variant/product_details_variant_state.dart';

class ProductDetailsVariantBloc extends Bloc<ProductDetailsVariantEvent, ProductDetailsVariantState> {
  ProductDetailsVariantBloc({ProductTemplateApi productTemplateApi}) : super(ProductDetailsVariantLoading()) {
    _productTemplateApi = productTemplateApi ?? GetIt.I<ProductTemplateApi>();
  }

  ProductTemplateApi _productTemplateApi;
  final Logger _logger = Logger();
  List<Product> _products = [];
  int _count = 0;
  int _productTemplateId;

  @override
  Stream<ProductDetailsVariantState> mapEventToState(ProductDetailsVariantEvent event) async* {
    if (event is ProductDetailsVariantStarted) {
      try {
        yield ProductDetailsVariantLoading();
        _productTemplateId = event.productTemplateId;

        final OdataGetListQuery odataGetListQuery = OdataGetListQuery(top: 20, skip: 0, orderBy: null, expand: null, count: true);
        final OdataListResult<Product> result =
            await _productTemplateApi.getVariants(id: _productTemplateId, getListQuery: odataGetListQuery);
        _products = result.value;
        _count = result.count;

        yield ProductDetailsVariantLoadSuccess(products: _products);
      } catch (e, stack) {
        _logger.e('ProductDetailsVariantLoadFailure', e, stack);
        yield ProductDetailsVariantLoadFailure(error: e.toString());
      }
    } else if (event is ProductDetailsVariantRefreshed) {
      try {
        yield ProductDetailsVariantLoading();

        final OdataGetListQuery odataGetListQuery = OdataGetListQuery(top: 20, skip: 0, orderBy: null, expand: null , count: true);
        final OdataListResult<Product> result =
            await _productTemplateApi.getVariants(id: _productTemplateId, getListQuery: odataGetListQuery);
        _products = result.value;
        _count = result.count;

        yield ProductDetailsVariantLoadSuccess(products: _products);
      } catch (e, stack) {
        _logger.e('ProductDetailsVariantLoadFailure', e, stack);
        yield ProductDetailsVariantLoadFailure(error: e.toString());
      }
    } else if (event is ProductDetailsVariantLoadMore) {
      try {
        if (_products.length < _count) {
          final OdataGetListQuery odataGetListQuery =
              OdataGetListQuery(top: 20, skip: _products.length, orderBy: null, expand: null);
          final OdataListResult<Product> result =
              await _productTemplateApi.getVariants(id: _productTemplateId, getListQuery: odataGetListQuery);
          _products = result.value;

          yield ProductDetailsVariantLoadSuccess(products: _products);
        } else {
          yield ProductDetailsVariantLoadNoMore(products: _products);
        }
      } catch (e, stack) {
        _logger.e('ProductDetailsVariantLoadFailure', e, stack);
        yield ProductDetailsVariantLoadFailure(error: e.toString());
      }
    }
  }
}
