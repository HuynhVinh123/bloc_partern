import 'package:tpos_api_client/tpos_api_client.dart';

abstract class AttributeValuePriceState {}

class AttributeValuePriceLoading extends AttributeValuePriceState {}

class AttributeValuePriceBusy extends AttributeValuePriceState {}


class AttributeValuePriceLoadFailure extends AttributeValuePriceState {
  AttributeValuePriceLoadFailure({this.error});

  final String error;
}

class AttributeValuePriceDeleteFailure extends AttributeValuePriceState {
  AttributeValuePriceDeleteFailure({this.error});

  final String error;
}

class AttributeValuePriceLoadSuccess extends AttributeValuePriceState {
  AttributeValuePriceLoadSuccess({this.productAttributeValues});

  final List<ProductAttributeValue> productAttributeValues;
}

class AttributeValuePriceDeleteSuccess extends AttributeValuePriceLoadSuccess {
  AttributeValuePriceDeleteSuccess({List<ProductAttributeValue> productAttributeValues})
      : super(productAttributeValues: productAttributeValues);
}
