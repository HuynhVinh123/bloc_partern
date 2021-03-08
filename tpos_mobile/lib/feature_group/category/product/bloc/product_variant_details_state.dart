import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductVariantDetailsState {}

class ProductVariantDetailsLoadSuccess extends ProductVariantDetailsState {
  ProductVariantDetailsLoadSuccess({this.product, this.userPermission});

  final Product product;
  final UserPermission userPermission;
}

class ProductVariantDetailsSetActiveSuccess
    extends ProductVariantDetailsLoadSuccess {
  ProductVariantDetailsSetActiveSuccess(
      {this.active, Product product, UserPermission userPermission})
      : super(product: product, userPermission: userPermission);

  final bool active;
}

class ProductVariantDetailsDeleteSuccess
    extends ProductVariantDetailsLoadSuccess {
  ProductVariantDetailsDeleteSuccess(
      {Product product, UserPermission userPermission})
      : super(product: product, userPermission: userPermission);
}

class ProductVariantDetailsStartSuccess
    extends ProductVariantDetailsLoadSuccess {
  ProductVariantDetailsStartSuccess(
      {Product product, UserPermission userPermission})
      : super(product: product, userPermission: userPermission);
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
