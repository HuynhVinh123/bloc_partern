import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductCategoryEvent {}

class ProductCategoryStarted extends ProductCategoryEvent {
  ProductCategoryStarted({this.current});

  final ProductCategory current;
}

class ProductCategorySearched extends ProductCategoryEvent {
  ProductCategorySearched({this.keyword});

  final String keyword;
}

class ProductCategoryDeleted extends ProductCategoryEvent {
  ProductCategoryDeleted({this.productCategory});

  final ProductCategory productCategory;
}

class ProductCategoryTemporaryDeleted extends ProductCategoryEvent {
  ProductCategoryTemporaryDeleted({this.productCategories, this.selectAll = false, this.isDelete = true});

  final List<ProductCategory> productCategories;
  final bool selectAll;
  final bool isDelete;
}

class ProductCategoryFiltered extends ProductCategoryEvent {
  ProductCategoryFiltered({this.filter});

  final bool filter;
}

class ProductCategoryRefreshed extends ProductCategoryEvent {}
