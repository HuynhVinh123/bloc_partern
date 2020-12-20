abstract class ProductDetailsVariantEvent {}

class ProductDetailsVariantStarted extends ProductDetailsVariantEvent {
  ProductDetailsVariantStarted({this.productTemplateId});

  final int productTemplateId;
}

class ProductDetailsVariantLoadMore extends ProductDetailsVariantEvent {}

class ProductDetailsVariantRefreshed extends ProductDetailsVariantEvent {}
