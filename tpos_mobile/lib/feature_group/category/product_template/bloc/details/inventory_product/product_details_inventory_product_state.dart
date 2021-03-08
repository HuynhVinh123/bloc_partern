import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductDetailsInventoryProductState {}

class ProductDetailsInventoryProductLoadSuccess extends ProductDetailsInventoryProductState {
  ProductDetailsInventoryProductLoadSuccess({this.inventoryProducts});

  final List<InventoryProduct> inventoryProducts;
}

class ProductDetailsInventoryProductLoadNoMore extends ProductDetailsInventoryProductLoadSuccess {
  ProductDetailsInventoryProductLoadNoMore({List<InventoryProduct> inventoryProducts}) : super(inventoryProducts: inventoryProducts);
}

class ProductDetailsInventoryProductLoadFailure extends ProductDetailsInventoryProductState {
  ProductDetailsInventoryProductLoadFailure({this.error});

  final String error;
}

class ProductDetailsInventoryProductLoading extends ProductDetailsInventoryProductState {}
