import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductVariantDetailsState {}

class ProductVariantDetailsLoadSuccess extends ProductVariantDetailsState {
  ProductVariantDetailsLoadSuccess({this.product});

  final Product product;
}

class ProductVariantDetailsSetActiveSuccess extends ProductVariantDetailsLoadSuccess {
  ProductVariantDetailsSetActiveSuccess({this.active, Product product}) : super(product: product);

  final bool active;
}

class ProductVariantDetailsDeleteSuccess extends ProductVariantDetailsLoadSuccess {
  ProductVariantDetailsDeleteSuccess({Product product}) : super(product: product);
}

class ProductVariantDetailsBusy extends ProductVariantDetailsState {}

class ProductVariantDetailsLoading extends ProductVariantDetailsState {}

class ProductVariantDetailsSetActiveFailure extends ProductVariantDetailsState {
  ProductVariantDetailsSetActiveFailure({this.error});

  final String error;
}

class ProductVariantDetailsDeleteFailure extends ProductVariantDetailsState {
  ProductVariantDetailsDeleteFailure({this.error});

  final String error;
}


class ProductVariantDetailsLoadFailure extends ProductVariantDetailsState {
  ProductVariantDetailsLoadFailure({this.error});

  final String error;
}
