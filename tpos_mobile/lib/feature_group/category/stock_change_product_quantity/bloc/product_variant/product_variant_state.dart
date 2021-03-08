import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductVariantState {
  ProductVariantState({this.products});

  final List<Product> products;
}

class ProductVariantLoading extends ProductVariantState {
  ProductVariantLoading({List<Product> products}) : super(products: products);
}

class ProductVariantLoadSuccess extends ProductVariantState {
  ProductVariantLoadSuccess({List<Product> products}) : super(products: products);
}
