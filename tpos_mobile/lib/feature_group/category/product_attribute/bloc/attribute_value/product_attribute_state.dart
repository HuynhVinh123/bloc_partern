import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductAttributeState {
  ProductAttributeState({this.productAttributes});

  final List<ProductAttributeValue> productAttributes;
}

class ProductAttributeLoading extends ProductAttributeState {
  ProductAttributeLoading({List<ProductAttributeValue> productAttributes}) : super(productAttributes: productAttributes);
}

class ProductAttributeBusy extends ProductAttributeState {
  ProductAttributeBusy({List<ProductAttributeValue> productAttributes}) : super(productAttributes: productAttributes);
}

class ProductAttributeLoadSuccess extends ProductAttributeState {
  ProductAttributeLoadSuccess({List<ProductAttributeValue> productAttributes}) : super(productAttributes: productAttributes);
}

class ProductAttributeLoadFailure extends ProductAttributeState {
  ProductAttributeLoadFailure({List<ProductAttributeValue> productAttributes, this.error})
      : super(productAttributes: productAttributes);
  final String error;
}
