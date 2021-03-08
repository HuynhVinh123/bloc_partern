import 'package:tpos_api_client/tpos_api_client.dart';

abstract class AttributeValuePriceDetailsState {}

class AttributeValuePriceDetailsLoadSuccess extends AttributeValuePriceDetailsState {
  AttributeValuePriceDetailsLoadSuccess({this.productAttributeValue});

  final ProductAttributeValue productAttributeValue;
}

class AttributeValuePriceDetailsSaveSuccess extends AttributeValuePriceDetailsLoadSuccess {
  AttributeValuePriceDetailsSaveSuccess({ProductAttributeValue productAttributeValue})
      : super(productAttributeValue: productAttributeValue);
}

class AttributeValuePriceDetailsLoading extends AttributeValuePriceDetailsState {}

class AttributeValuePriceDetailsBusy extends AttributeValuePriceDetailsState {}

class AttributeValuePriceDetailsLoadFailure extends AttributeValuePriceDetailsState {
  AttributeValuePriceDetailsLoadFailure({this.error});

  final String error;
}

class AttributeValuePriceDetailsSaveFailure extends AttributeValuePriceDetailsState {
  AttributeValuePriceDetailsSaveFailure({this.error});

  final String error;
}
