import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductAttributeValueAddEditState {
  ProductAttributeValueAddEditState({this.productAttributeLine});

  final ProductAttributeValue productAttributeLine;
}

class ProductAttributeValueAddEditLoadSuccess extends ProductAttributeValueAddEditState {
  ProductAttributeValueAddEditLoadSuccess({ProductAttributeValue productAttributeLine}) : super(productAttributeLine: productAttributeLine);
}

class ProductAttributeValueAddEditBusy extends ProductAttributeValueAddEditState {
  ProductAttributeValueAddEditBusy({ProductAttributeValue productAttributeLine}) : super(productAttributeLine: productAttributeLine);
}


class ProductAttributeValueAddEditLoadFailure extends ProductAttributeValueAddEditState {
  ProductAttributeValueAddEditLoadFailure({ProductAttributeValue productAttributeLine, this.error})
      : super(productAttributeLine: productAttributeLine);

  final String error;
}

class ProductAttributeValueAddEditSaveSuccess extends ProductAttributeValueAddEditState {
  ProductAttributeValueAddEditSaveSuccess({ProductAttributeValue productAttributeLine}) : super(productAttributeLine: productAttributeLine);
}
class ProductAttributeValueDeleteSuccess extends ProductAttributeValueAddEditState {
  ProductAttributeValueDeleteSuccess({ProductAttributeValue productAttributeLine}) : super(productAttributeLine: productAttributeLine);
}


class ProductAttributeValueDeleteError extends ProductAttributeValueAddEditState {
  ProductAttributeValueDeleteError({ProductAttributeValue productAttributeLine, this.error})
      : super(productAttributeLine: productAttributeLine);

  final String error;
}

class ProductAttributeValueAddEditSaveError extends ProductAttributeValueAddEditState {
  ProductAttributeValueAddEditSaveError({ProductAttributeValue productAttributeLine, this.error})
      : super(productAttributeLine: productAttributeLine);

  final String error;
}

class ProductAttributeValueAddEditLoading extends ProductAttributeValueAddEditState {
  ProductAttributeValueAddEditLoading({ProductAttributeValue productAttributeLine}) : super(productAttributeLine: productAttributeLine);
}

