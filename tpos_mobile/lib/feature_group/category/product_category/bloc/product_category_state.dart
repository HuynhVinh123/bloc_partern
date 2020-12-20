import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductCategoryState {}

class ProductCategoryLoading extends ProductCategoryState {}

class ProductCategoryBusy extends ProductCategoryState {}

class ProductCategoryLoadSuccess extends ProductCategoryState {
  ProductCategoryLoadSuccess({this.productCategories, this.total});

  final List<ProductCategory> productCategories;
  final int total;
}

class ProductCategoryDeleteSuccess extends ProductCategoryLoadSuccess {
  ProductCategoryDeleteSuccess({List<ProductCategory> productCategories, int total})
      : super(productCategories: productCategories, total: total);
}

class ProductCategoryLoadFailure extends ProductCategoryState {
  ProductCategoryLoadFailure({this.error});

  final String error;
}

class ProductCategoryDeleteFailure extends ProductCategoryState {
  ProductCategoryDeleteFailure({this.error});

  final String error;
}
