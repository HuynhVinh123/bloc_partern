import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductUomEvent {}

class ProductUomStarted extends ProductUomEvent {
  ProductUomStarted({this.categoryId, this.search});

  final int categoryId;
  final String search;
}

class ProductUomSearched extends ProductUomEvent {
  ProductUomSearched({this.search});

  String search;
}

class ProductUomRefreshed extends ProductUomEvent {}
class ProductUomDeleted extends ProductUomEvent {
  ProductUomDeleted({this.productUom});

  final ProductUOM productUom;
}
