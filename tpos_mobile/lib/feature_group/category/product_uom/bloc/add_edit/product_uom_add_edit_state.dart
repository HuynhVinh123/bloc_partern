import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductUomAddEditState {}

class ProductUomAddEditLoadSuccess extends ProductUomAddEditState {
  ProductUomAddEditLoadSuccess({this.productUom});

  final ProductUOM productUom;
}

class ProductUomAddEditBusy extends ProductUomAddEditState {}

class ProductUomAddEditLoadFailure extends ProductUomAddEditState {
  ProductUomAddEditLoadFailure({this.error});

  final String error;
}

class ProductUomAddEditSaveSuccess extends ProductUomAddEditLoadSuccess {
  ProductUomAddEditSaveSuccess({ProductUOM productUom}) : super(productUom: productUom);
}

class ProductUomAddEditSaveError extends ProductUomAddEditState {
  ProductUomAddEditSaveError({this.error});

  final String error;
}

class ProductUomAddEditVerifiedError extends ProductUomAddEditState {
  ProductUomAddEditVerifiedError({this.error});

  final String error;
}

class ProductUomAddEditNameError extends ProductUomAddEditVerifiedError {
  ProductUomAddEditNameError({String error}) : super(error: error);
}

class ProductUomAddEditCategoryError extends ProductUomAddEditVerifiedError {
  ProductUomAddEditCategoryError({String error}) : super(error: error);
}

class ProductUomAddEditLoading extends ProductUomAddEditState {}

class ProductUomAddEditDeleteSuccess extends ProductUomAddEditLoadSuccess {
  ProductUomAddEditDeleteSuccess({ProductUOM productUom}) : super(productUom: productUom);
}

class ProductUomAddEditDeleteError extends ProductUomAddEditState {
  ProductUomAddEditDeleteError({this.error});

  final String error;
}
