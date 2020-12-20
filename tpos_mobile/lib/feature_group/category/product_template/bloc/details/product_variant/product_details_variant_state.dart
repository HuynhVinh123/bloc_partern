import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductDetailsVariantState {}

class ProductDetailsVariantLoadSuccess extends ProductDetailsVariantState {
  ProductDetailsVariantLoadSuccess({this.products});

  final List<Product> products;
}

class ProductDetailsVariantLoadNoMore extends ProductDetailsVariantLoadSuccess {
  ProductDetailsVariantLoadNoMore({List<Product> products}) : super(products: products);
}

class ProductDetailsVariantLoading extends ProductDetailsVariantState {}

class ProductDetailsVariantLoadFailure extends ProductDetailsVariantState {
  ProductDetailsVariantLoadFailure({this.error});

  final String error;
}
