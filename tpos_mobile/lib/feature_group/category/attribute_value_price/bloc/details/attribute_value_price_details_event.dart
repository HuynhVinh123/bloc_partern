import 'package:flutter/cupertino.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

abstract class AttributeValuePriceDetailsEvent {}

class AttributeValuePriceDetailsInitial extends AttributeValuePriceDetailsEvent {
  AttributeValuePriceDetailsInitial({@required this.productTemplateId, @required this.productAttributeValueId});

  final int productTemplateId;
  final int productAttributeValueId;
}

class AttributeValuePriceDetailsSaved extends AttributeValuePriceDetailsEvent {
  AttributeValuePriceDetailsSaved({this.productAttributeValue});

  final ProductAttributeValue productAttributeValue;
}

class AttributeValuePriceDetailsUpdateLocal extends AttributeValuePriceDetailsEvent {
  AttributeValuePriceDetailsUpdateLocal({this.productAttributeValue});

  final ProductAttributeValue productAttributeValue;
}
