import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductUomCategoryState {}

class ProductUomCategoryLoading extends ProductUomCategoryState {}

class ProductUomCategoryBusy extends ProductUomCategoryState {}

class ProductUomCategoryLoadFailure extends ProductUomCategoryState {
  ProductUomCategoryLoadFailure({this.error});

  final String error;
}

class ProductUomCategoryActionFailure extends ProductUomCategoryState {
  ProductUomCategoryActionFailure({this.error});

  final String error;
}

class ProductUomCategoryLoadSuccess extends ProductUomCategoryState {
  ProductUomCategoryLoadSuccess({this.productUomCategories});

  final List<ProductUomCategory> productUomCategories;
}

class ProductUomCategoryDeleteSuccess extends ProductUomCategoryLoadSuccess {
  ProductUomCategoryDeleteSuccess({List<ProductUomCategory> productUomCategories})
      : super(productUomCategories: productUomCategories);
}

class ProductUomCategoryInsertSuccess extends ProductUomCategoryLoadSuccess {
  ProductUomCategoryInsertSuccess({List<ProductUomCategory> productUomCategories})
      : super(productUomCategories: productUomCategories);
}

class ProductUomCategoryUpdateSuccess extends ProductUomCategoryLoadSuccess {
  ProductUomCategoryUpdateSuccess({List<ProductUomCategory> productUomCategories})
      : super(productUomCategories: productUomCategories);
}
