import 'package:flutter/cupertino.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

abstract class AttributeValuePriceEvent {}

class AttributeValuePriceInitial extends AttributeValuePriceEvent {
  AttributeValuePriceInitial({@required this.productTemplate});

  final ProductTemplate productTemplate;
}

class AttributeValuePriceDelete extends AttributeValuePriceEvent {
  AttributeValuePriceDelete({@required this.productAttributeValue});

  final ProductAttributeValue productAttributeValue;
}
