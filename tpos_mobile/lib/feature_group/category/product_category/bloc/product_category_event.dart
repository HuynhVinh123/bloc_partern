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
  ProductCategoryTemporaryDeleted({this.productCategories, this.selectAll});

  final List<ProductCategory> productCategories;
  final bool selectAll;
}

class ProductCategoryRefreshed extends ProductCategoryEvent {}
