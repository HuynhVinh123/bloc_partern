abstract class ProductDetailsImageEvent {}

class ProductDetailsImageStarted extends ProductDetailsImageEvent {
  ProductDetailsImageStarted({this.productTemplateId});

  final int productTemplateId;
}

class ProductDetailsImageRefreshed extends ProductDetailsImageEvent {}
