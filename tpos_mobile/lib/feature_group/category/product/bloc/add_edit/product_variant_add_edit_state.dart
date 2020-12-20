import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductVariantAddEditState {}

class ProductVariantAddEditLoadSuccess extends ProductVariantAddEditState {
  ProductVariantAddEditLoadSuccess({this.productVariant});

  final Product productVariant;
}

class ProductVariantAddEditStartSuccess extends ProductVariantAddEditLoadSuccess {
  ProductVariantAddEditStartSuccess({Product productVariant}) : super(productVariant: productVariant);
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

class ProductVariantAddEditSaveSuccess extends ProductVariantAddEditLoadSuccess {
  ProductVariantAddEditSaveSuccess({Product productVariant}) : super(productVariant: productVariant);
}

class ProductVariantAddEditUploadImageSuccess extends ProductVariantAddEditLoadSuccess {
  ProductVariantAddEditUploadImageSuccess({Product productVariant}) : super(productVariant: productVariant);
}


class ProductVariantAddEditUploadImageError extends ProductVariantAddEditState {
  ProductVariantAddEditUploadImageError({this.error});

  final String error;
}


