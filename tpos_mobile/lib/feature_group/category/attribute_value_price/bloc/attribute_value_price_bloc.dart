import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/attribute_value_price/bloc/attribute_value_price_event.dart';
import 'package:tpos_mobile/feature_group/category/attribute_value_price/bloc/attribute_value_price_state.dart';

class AttributeValuePriceBloc extends Bloc<AttributeValuePriceEvent, AttributeValuePriceState> {
  AttributeValuePriceBloc({ProductTemplateApi productTemplateApi, ProductAttributeValueApi productAttributeValueApi})
      : super(AttributeValuePriceLoading()) {
    _productTemplateApi = productTemplateApi ?? GetIt.I<ProductTemplateApi>();
    _productAttributeValueApi = productAttributeValueApi ?? GetIt.I<ProductAttributeValueApi>();
  }

  ProductTemplateApi _productTemplateApi;
  ProductAttributeValueApi _productAttributeValueApi;
  List<ProductAttributeValue> _productAttributeValues = [];
  final Logger _logger = Logger();

  @override
  Stream<AttributeValuePriceState> mapEventToState(AttributeValuePriceEvent event) async* {
    if (event is AttributeValuePriceInitial) {
      try {
        yield AttributeValuePriceLoading();
        final OdataGetListQuery odataGetListQuery = OdataGetListQuery(top: 1000, skip: 0, expand: 'Attribute');
        final OdataListResult<ProductAttributeValue> result =
            await _productTemplateApi.getAttributeValues(event.productTemplate.id, odataGetListQuery);
        _productAttributeValues = result.value;
        yield AttributeValuePriceLoadSuccess(productAttributeValues: _productAttributeValues);
      } catch (e, stack) {
        _logger.e('AttributeValuePriceLoadFailure', e, stack);
        yield AttributeValuePriceLoadFailure(error: e.toString());
      }
    } else if (event is AttributeValuePriceDelete) {
      try {
        yield AttributeValuePriceBusy();

        await _productAttributeValueApi.delete(event.productAttributeValue.id);
        _productAttributeValues.remove(event.productAttributeValue);

        yield AttributeValuePriceDeleteSuccess(productAttributeValues: _productAttributeValues);
      } catch (e, stack) {
        _logger.e('AttributeValuePriceDeleteFailure', e, stack);
        yield AttributeValuePriceDeleteFailure(error: e.toString());
      }
    }
  }
}
