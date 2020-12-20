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

class ProductUomAddEditNameError extends ProductUomAddEditLoadSuccess {
  ProductUomAddEditNameError({ProductUOM productUom, this.error})
      : super(productUom: productUom);

  final String error;
}

class ProductUomAddEditLoading extends ProductUomAddEditState {}

class ProductUomAddEditDeleteSuccess extends ProductUomAddEditLoadSuccess {
  ProductUomAddEditDeleteSuccess({ProductUOM productUom}) : super(productUom: productUom);
}
class ProductUomAddEditDeleteError extends ProductUomAddEditState {
  ProductUomAddEditDeleteError({this.error});

  final String error;
}