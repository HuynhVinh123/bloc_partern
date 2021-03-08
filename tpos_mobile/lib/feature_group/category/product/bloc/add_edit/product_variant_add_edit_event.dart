import 'dart:io';

import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductVariantAddEditEvent {}

class ProductVariantAddEditStarted extends ProductVariantAddEditEvent {
  ProductVariantAddEditStarted({this.productVariantId});

  final int productVariantId;
}

class ProductVariantAddEditSaved extends ProductVariantAddEditEvent {
  ProductVariantAddEditSaved({this.productVariant});

  final Product productVariant;
}

class ProductVariantAddEditLocalUpdated extends ProductVariantAddEditEvent {
  ProductVariantAddEditLocalUpdated({this.productVariant});

  final Product productVariant;
}

class ProductVariantAddEditUploadImage extends ProductVariantAddEditEvent {
  ProductVariantAddEditUploadImage({this.file});

  final File file;
}
