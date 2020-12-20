abstract class ProductAttributeEvent {}

class ProductAttributeStarted extends ProductAttributeEvent {
  ProductAttributeStarted({this.attributeId});

  final int attributeId;
}

class ProductAttributeSearched extends ProductAttributeEvent {
  ProductAttributeSearched({this.keyword});

  final String keyword;
}
