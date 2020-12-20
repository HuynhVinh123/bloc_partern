import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductUomState {}

class ProductUomLoading extends ProductUomState {}

class ProductUomBusy extends ProductUomState {}

class ProductUomLoadFailure extends ProductUomState {
  ProductUomLoadFailure({this.error});

  final String error;
}

class ProductUomLoadSuccess extends ProductUomState {
  ProductUomLoadSuccess({this.productUomCategories});

  final List<ProductUomCategory> productUomCategories;
}
