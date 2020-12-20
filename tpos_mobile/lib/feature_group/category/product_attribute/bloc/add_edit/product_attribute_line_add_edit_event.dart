import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductAttributeLineAddEditEvent {}

class ProductAttributeLineAddEditStarted extends ProductAttributeLineAddEditEvent {
  ProductAttributeLineAddEditStarted({this.productAttributeLine});

  final ProductAttribute productAttributeLine;
}

class ProductAttributeLineAddEditUpdateLocal extends ProductAttributeLineAddEditEvent {
  ProductAttributeLineAddEditUpdateLocal({this.productAttributeLine});

  final ProductAttribute productAttributeLine;
}

class ProductAttributeLineAddEditSaved extends ProductAttributeLineAddEditEvent {
  ProductAttributeLineAddEditSaved({this.productAttributeLine});

  final ProductAttribute productAttributeLine;
}


class ProductAttributeValueDelete extends ProductAttributeLineAddEditEvent {
  ProductAttributeValueDelete({this.productAttributeLine});

  final ProductAttribute productAttributeLine;
}

