import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductCategoryState {}

class ProductCategoryLoading extends ProductCategoryState {}

class ProductCategoryBusy extends ProductCategoryState {}

class ProductCategoryLoadSuccess extends ProductCategoryState {
  ProductCategoryLoadSuccess({this.productCategories, this.total, this.allProductCategories});

  final List<ProductCategory> productCategories;
  final List<ProductCategory> allProductCategories;
  final int total;
}

class ProductCategoryDeleteSuccess extends ProductCategoryLoadSuccess {
  ProductCategoryDeleteSuccess({List<ProductCategory> productCategories, int total, List<
      ProductCategory> allProductCategories, @required this.productCategory,})
      : super(productCategories: productCategories, total: total, allProductCategories: allProductCategories);

  final ProductCategory productCategory;
}

class ProductCategoryFilterSuccess extends ProductCategoryLoadSuccess {
  ProductCategoryFilterSuccess(
      {List<ProductCategory> productCategories, int total, List<ProductCategory> allProductCategories})
      : super(productCategories: productCategories, total: total, allProductCategories: allProductCategories);
}


class ProductCategoryDeleteTemporarySuccess extends ProductCategoryLoadSuccess {
  ProductCategoryDeleteTemporarySuccess(
      {List<ProductCategory> productCategories, int total, List<ProductCategory> allProductCategories})
      : super(productCategories: productCategories, total: total, allProductCategories: allProductCategories);
}

class ProductCategoryLoadFailure extends ProductCategoryState {
  ProductCategoryLoadFailure({this.error});

  final String error;
}

class ProductCategoryDeleteFailure extends ProductCategoryState {
  ProductCategoryDeleteFailure({this.error});

  final String error;
}
