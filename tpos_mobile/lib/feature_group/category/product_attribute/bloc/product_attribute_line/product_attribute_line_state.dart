import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductAttributeLineState {
  ProductAttributeLineState({this.productAttributes});

  final List<ProductAttribute> productAttributes;
}

class ProductAttributeLineLoading extends ProductAttributeLineState {
  ProductAttributeLineLoading({List<ProductAttribute> productAttributes})
      : super(productAttributes: productAttributes);
}

class ProductAttributeLineBusy extends ProductAttributeLineState {
  ProductAttributeLineBusy({List<ProductAttribute> productAttributes})
      : super(productAttributes: productAttributes);
}

class ProductAttributeLineLoadSuccess extends ProductAttributeLineState {
  ProductAttributeLineLoadSuccess({List<ProductAttribute> productAttributes})
      : super(productAttributes: productAttributes);
}


class ProductAttributeLineLoadFailure extends ProductAttributeLineState {
  ProductAttributeLineLoadFailure({List<ProductAttribute> productAttributes, this.error})
      : super(productAttributes: productAttributes);
  final String error;
}

class ProductAttributeInsertSuccess extends ProductAttributeLineState {
  ProductAttributeInsertSuccess({List<ProductAttribute> productAttributes})
      : super(productAttributes: productAttributes);
}

class ProductAttributeInsertFailure extends ProductAttributeLineState {
  ProductAttributeInsertFailure({List<ProductAttribute> productAttributes, this.error})
      : super(productAttributes: productAttributes);
  final String error;
}

class ProductAttributeUpdateSuccess extends ProductAttributeLineState {
  ProductAttributeUpdateSuccess({List<ProductAttribute> productAttributes})
      : super(productAttributes: productAttributes);
}

class ProductAttributeUpdateFailure extends ProductAttributeLineState {
  ProductAttributeUpdateFailure({List<ProductAttribute> productAttributes, this.error})
      : super(productAttributes: productAttributes);
  final String error;
}


class ProductAttributeDeleteSuccess extends ProductAttributeLineState {
  ProductAttributeDeleteSuccess({List<ProductAttribute> productAttributes})
      : super(productAttributes: productAttributes);
}

class ProductAttributeValueDeleteSuccess extends ProductAttributeLineState {
  ProductAttributeValueDeleteSuccess({List<ProductAttribute> productAttributes})
      : super(productAttributes: productAttributes);
}

class ProductAttributeDeleteFailure extends ProductAttributeLineState {
  ProductAttributeDeleteFailure({List<ProductAttribute> productAttributes, this.error})
      : super(productAttributes: productAttributes);
  final String error;
}
