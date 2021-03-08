import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductUomCategoryEvent {}

class ProductUomCategoryLoaded extends ProductUomCategoryEvent {}

class ProductUomCategoryStarted extends ProductUomCategoryEvent {}

class ProductUomCategorySearched extends ProductUomCategoryEvent {
  ProductUomCategorySearched({this.search});

  String search;
}

class ProductUomCategoryUpdated extends ProductUomCategoryEvent {
  ProductUomCategoryUpdated({this.productUomCategory});

  final ProductUomCategory productUomCategory;
}


class ProductUomCategoryDeleted extends ProductUomCategoryEvent {
  ProductUomCategoryDeleted({this.productUomCategory});

  final ProductUomCategory productUomCategory;
}


class ProductUomCategoryInserted extends ProductUomCategoryEvent {
  ProductUomCategoryInserted({this.productUomCategory});

  final ProductUomCategory productUomCategory;
}

class ProductUomCategoryRefreshed extends ProductUomCategoryEvent {}
