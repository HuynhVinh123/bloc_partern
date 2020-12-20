abstract class ProductVariantDetailsEvent {}

class ProductVariantDetailsStarted extends ProductVariantDetailsEvent {
  ProductVariantDetailsStarted({this.productId});

  final int productId;
}

class ProductVariantDetailsActiveSet extends ProductVariantDetailsEvent {}

class ProductVariantDetailsDelete extends ProductVariantDetailsEvent {}
