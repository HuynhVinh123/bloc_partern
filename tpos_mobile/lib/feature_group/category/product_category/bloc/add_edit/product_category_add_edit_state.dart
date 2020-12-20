import 'package:tpos_api_client/tpos_api_client.dart';


abstract class ProductCategoryAddEditState {}

class ProductCategoryAddEditLoadSuccess extends ProductCategoryAddEditState {
  ProductCategoryAddEditLoadSuccess({this.productCategory});
  final ProductCategory productCategory;
}

class ProductCategoryAddEditBusy extends ProductCategoryAddEditState {}

class ProductCategoryAddEditLoadFailure extends ProductCategoryAddEditState {
  ProductCategoryAddEditLoadFailure({this.error});

  final String error;
}


class ProductCategoryAddEditSaveSuccess extends ProductCategoryAddEditLoadSuccess {
  ProductCategoryAddEditSaveSuccess({ProductCategory productCategory}) : super(productCategory: productCategory);
}

class ProductCategoryAddEditSaveError extends ProductCategoryAddEditState {
  ProductCategoryAddEditSaveError({this.error});

  final String error;
}


class ProductCategoryAddEditNameError extends ProductCategoryAddEditLoadSuccess {
  ProductCategoryAddEditNameError({ProductCategory productCategory, this.error})
      : super(productCategory: productCategory);

  final String error;
}


class ProductCategoryAddEditLoading extends ProductCategoryAddEditState {}

class ProductCategoryAddEditDeleteSuccess extends ProductCategoryAddEditLoadSuccess {
  ProductCategoryAddEditDeleteSuccess({ProductCategory productCategory}) : super(productCategory: productCategory);
}
class ProductCategoryAddEditDeleteError extends ProductCategoryAddEditState {
  ProductCategoryAddEditDeleteError({this.error});

  final String error;
}

