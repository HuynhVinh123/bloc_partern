import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/attribute_value/product_attribute_event.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/attribute_value/product_attribute_state.dart';

class ProductAttributeBloc extends Bloc<ProductAttributeEvent, ProductAttributeState> {
  ProductAttributeBloc({ProductAttributeValueApi productAttributeApi})
      : super(ProductAttributeLoading(productAttributes: [])) {
    _productAttributeApi = productAttributeApi ?? GetIt.I<ProductAttributeValueApi>();
  }

  ProductAttributeValueApi _productAttributeApi;

  List<ProductAttributeValue> _productAttributes = [];
  final Logger _logger = Logger();

  @override
  Stream<ProductAttributeState> mapEventToState(ProductAttributeEvent event) async* {
    if (event is ProductAttributeStarted) {
      try {
        yield ProductAttributeLoading(productAttributes: _productAttributes);
        if (event.attributeId != null) {
          final GetProductAttributeForSearchQuery query =
              GetProductAttributeForSearchQuery(attributeId: event.attributeId);

          final OdataListResult<ProductAttributeValue> result = await _productAttributeApi.getList(query: query);
          _productAttributes = result.value;
        } else {
          final GetProductAttributeForSearchQuery query = GetProductAttributeForSearchQuery(keyword: '');

          final OdataListResult<ProductAttributeValue> result = await _productAttributeApi.getList(query: query);
          _productAttributes = result.value;
        }

        yield ProductAttributeLoadSuccess(productAttributes: _productAttributes);
      } catch (e, stack) {
        _logger.e('ProductAttributeLoadFailure', e, stack);
        yield ProductAttributeLoadFailure(error: e.toString(), productAttributes: _productAttributes);
      }
    } else if (event is ProductAttributeSearched) {
      try {
        yield ProductAttributeLoading(productAttributes: _productAttributes);
        final GetProductAttributeForSearchQuery query = GetProductAttributeForSearchQuery(keyword: '');

        final OdataListResult<ProductAttributeValue> result = await _productAttributeApi.getList(query: query);
        _productAttributes = result.value;
        yield ProductAttributeLoadSuccess(productAttributes: _productAttributes);
      } catch (e, stack) {
        _logger.e('ProductAttributeLoadFailure', e, stack);
        yield ProductAttributeLoadFailure(error: e.toString(), productAttributes: _productAttributes);
      }
    }
  }
}
