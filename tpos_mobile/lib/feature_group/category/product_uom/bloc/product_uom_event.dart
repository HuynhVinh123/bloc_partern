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
