import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductVariantAddEditState {}

class ProductVariantAddEditLoadSuccess extends ProductVariantAddEditState {
  ProductVariantAddEditLoadSuccess({this.productVariant, this.userPermission});

  final Product productVariant;
  final UserPermission userPermission;
}

class ProductVariantAddEditStartSuccess
    extends ProductVariantAddEditLoadSuccess {
  ProductVariantAddEditStartSuccess(
      {Product productVariant, UserPermission userPermission})
      : super(productVariant: productVariant, userPermission: userPermission);
}

class ProductVariantAddEditLoading extends ProductVariantAddEditState {}

class ProductVariantAddEditBusy extends ProductVariantAddEditState {}

class ProductVariantAddEditLoadFailure extends ProductVariantAddEditState {
  ProductVariantAddEditLoadFailure({this.error});

  final String error;
}

class ProductVariantAddEditSaveFailure extends ProductVariantAddEditState {
  ProductVariantAddEditSaveFailure({this.error});

  final String error;
}

class ProductVariantAddEditSaveSuccess
    extends ProductVariantAddEditLoadSuccess {
  ProductVariantAddEditSaveSuccess(
      {Product productVariant, UserPermission userPermission})
      : super(productVariant: productVariant, userPermission: userPermission);
}

class ProductVariantAddEditUploadImageSuccess
    extends ProductVariantAddEditLoadSuccess {
  ProductVariantAddEditUploadImageSuccess(
      {Product productVariant, UserPermission userPermission})
      : super(productVariant: productVariant, userPermission: userPermission);
}

class ProductVariantAddEditUploadImageError extends ProductVariantAddEditState {
  ProductVariantAddEditUploadImageError({this.error});

  final String error;
}
