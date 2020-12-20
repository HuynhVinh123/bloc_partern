import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductAttributeLineAddEditState {
  ProductAttributeLineAddEditState({this.productAttributeLine});

  final ProductAttribute productAttributeLine;
}

class ProductAttributeLineAddEditLoadSuccess extends ProductAttributeLineAddEditState {
  ProductAttributeLineAddEditLoadSuccess({ProductAttribute productAttributeLine}) : super(productAttributeLine: productAttributeLine);
}

class ProductAttributeLineAddEditBusy extends ProductAttributeLineAddEditState {
  ProductAttributeLineAddEditBusy({ProductAttribute productAttributeLine}) : super(productAttributeLine: productAttributeLine);
}


class ProductAttributeLineAddEditLoadFailure extends ProductAttributeLineAddEditState {
  ProductAttributeLineAddEditLoadFailure({ProductAttribute productAttributeLine, this.error})
      : super(productAttributeLine: productAttributeLine);

  final String error;
}

class ProductAttributeLineAddEditSaveSuccess extends ProductAttributeLineAddEditState {
  ProductAttributeLineAddEditSaveSuccess({ProductAttribute productAttributeLine}) : super(productAttributeLine: productAttributeLine);
}
class ProductAttributeValueDeleteSuccess extends ProductAttributeLineAddEditState {
  ProductAttributeValueDeleteSuccess({ProductAttribute productAttributeLine}) : super(productAttributeLine: productAttributeLine);
}


class ProductAttributeValueDeleteError extends ProductAttributeLineAddEditState {
  ProductAttributeValueDeleteError({ProductAttribute productAttributeLine, this.error})
      : super(productAttributeLine: productAttributeLine);

  final String error;
}

class ProductAttributeLineAddEditSaveError extends ProductAttributeLineAddEditState {
  ProductAttributeLineAddEditSaveError({ProductAttribute productAttributeLine, this.error})
      : super(productAttributeLine: productAttributeLine);

  final String error;
}

class ProductAttributeLineAddEditLoading extends ProductAttributeLineAddEditState {
  ProductAttributeLineAddEditLoading({ProductAttribute productAttributeLine}) : super(productAttributeLine: productAttributeLine);
}

