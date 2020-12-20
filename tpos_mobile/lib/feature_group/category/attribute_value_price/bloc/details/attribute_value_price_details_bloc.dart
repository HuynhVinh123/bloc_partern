import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/attribute_value_price/bloc/details/attribute_value_price_details_event.dart';
import 'package:tpos_mobile/feature_group/category/attribute_value_price/bloc/details/attribute_value_price_details_state.dart';

class AttributeValuePriceDetailsBloc extends Bloc<AttributeValuePriceDetailsEvent, AttributeValuePriceDetailsState> {
  AttributeValuePriceDetailsBloc({ProductTemplateApi productTemplateApi}) : super(AttributeValuePriceDetailsLoading()) {
    _productTemplateApi = productTemplateApi ?? GetIt.I<ProductTemplateApi>();
  }

  final Logger _logger = Logger();
  ProductTemplateApi _productTemplateApi;
  ProductAttributeValue _productAttributeValue;
  int _productTemplateId;

  @override
  Stream<AttributeValuePriceDetailsState> mapEventToState(AttributeValuePriceDetailsEvent event) async* {
    if (event is AttributeValuePriceDetailsInitial) {
      try {
        yield AttributeValuePriceDetailsLoading();
        _productTemplateId = event.productTemplateId;
        if (event.productAttributeValueId != null) {
          _productAttributeValue = await _productTemplateApi.getVariantPrice(
              id: event.productTemplateId, attributeValueId: event.productAttributeValueId, expand: 'Attribute');
          _productAttributeValue.productAttribute?.attributeValues = null;
        } else {
          _productAttributeValue = ProductAttributeValue();
        }

        yield AttributeValuePriceDetailsLoadSuccess(productAttributeValue: _productAttributeValue);
      } catch (e, stack) {
        _logger.e('AttributeValuePriceDetailsLoadFailure', e, stack);
        yield AttributeValuePriceDetailsLoadFailure(error: e.toString());
      }
    } else if (event is AttributeValuePriceDetailsSaved) {
      try {
        yield AttributeValuePriceDetailsBusy();
        _productAttributeValue = event.productAttributeValue;

        if (_productAttributeValue.id != null) {
          await _productTemplateApi.updateVariantPrice(
              id: _productTemplateId, productAttributeValue: event.productAttributeValue);
        } else {
          final ProductAttributeValue result = await _productTemplateApi.insertVariantPrice(
              id: _productTemplateId, productAttributeValue: event.productAttributeValue);
          _productAttributeValue.id = result.id;
        }

        yield AttributeValuePriceDetailsSaveSuccess(productAttributeValue: _productAttributeValue);
      } catch (e, stack) {
        _logger.e('AttributeValuePriceDetailsSaveFailure', e, stack);
        yield AttributeValuePriceDetailsSaveFailure(error: e.toString());
      }
    } else if (event is AttributeValuePriceDetailsUpdateLocal) {
      _productAttributeValue = event.productAttributeValue;
    }
  }
}
