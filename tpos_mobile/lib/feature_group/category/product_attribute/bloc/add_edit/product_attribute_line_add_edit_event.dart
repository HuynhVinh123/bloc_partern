import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductAttributeValueAddEditEvent {}

class ProductAttributeValueAddEditStarted extends ProductAttributeValueAddEditEvent {
  ProductAttributeValueAddEditStarted({this.productAttributeLine});

  final ProductAttributeValue productAttributeLine;
}

class ProductAttributeValueAddEditUpdateLocal extends ProductAttributeValueAddEditEvent {
  ProductAttributeValueAddEditUpdateLocal({this.productAttributeLine});

  final ProductAttributeValue productAttributeLine;
}

class ProductAttributeValueAddEditSaved extends ProductAttributeValueAddEditEvent {
  ProductAttributeValueAddEditSaved({this.productAttributeLine});

  final ProductAttributeValue productAttributeLine;
}


class ProductAttributeValueDelete extends ProductAttributeValueAddEditEvent {
  ProductAttributeValueDelete({this.productAttributeLine});

  final ProductAttributeValue productAttributeLine;
}

