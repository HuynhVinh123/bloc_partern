import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductVariantEvent {}

class ProductVariantStarted extends ProductVariantEvent {
  ProductVariantStarted({this.products});

  final List<Product> products;
}

class ProductVariantSearched extends ProductVariantEvent {
  ProductVariantSearched({this.search});

  final String search;
}
