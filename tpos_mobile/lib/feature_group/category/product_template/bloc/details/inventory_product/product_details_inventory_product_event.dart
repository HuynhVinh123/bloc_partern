abstract class ProductDetailsInventoryProductEvent {}

class ProductDetailsInventoryProductStarted extends ProductDetailsInventoryProductEvent {
  ProductDetailsInventoryProductStarted({this.productTemplateId});

  final int productTemplateId;
}

class ProductDetailsInventoryProductLoadMore extends ProductDetailsInventoryProductEvent {}
class ProductDetailsInventoryProductRefresh extends ProductDetailsInventoryProductEvent {}
