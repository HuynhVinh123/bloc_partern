import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductAttributeLineEvent {}

class ProductAttributeLineStarted extends ProductAttributeLineEvent {
  ProductAttributeLineStarted({this.productTemplate, this.keyword = ''});

  final ProductTemplate productTemplate;
  final String keyword;
}

class ProductAttributeLineRefreshed extends ProductAttributeLineEvent {}

class ProductAttributeLineSearched extends ProductAttributeLineEvent {
  ProductAttributeLineSearched({this.keyword});

  final String keyword;
}

class ProductAttributeLineSaved extends ProductAttributeLineEvent {
  ProductAttributeLineSaved({this.productAttributeLine});

  final ProductAttribute productAttributeLine;
}

class ProductAttributeInserted extends ProductAttributeLineEvent {
  ProductAttributeInserted({this.productAttribute});

  final ProductAttribute productAttribute;
}

class ProductAttributeUpdated extends ProductAttributeLineEvent {
  ProductAttributeUpdated({this.productAttribute});

  final ProductAttribute productAttribute;
}

class ProductAttributeDeleted extends ProductAttributeLineEvent {
  ProductAttributeDeleted({this.productAttributeLine});

  final ProductAttribute productAttributeLine;
}

class ProductAttributeValueDeleted extends ProductAttributeLineEvent {
  ProductAttributeValueDeleted({this.productAttributeValue});

  final ProductAttributeValue productAttributeValue;
}
