import 'dart:io';

import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductCategoryAddEditEvent {}

class ProductCategoryAddEditStarted extends ProductCategoryAddEditEvent {
  ProductCategoryAddEditStarted({this.productCategory});

  final ProductCategory productCategory;
}

class ProductCategoryAddEditUpdateLocal extends ProductCategoryAddEditEvent {
  ProductCategoryAddEditUpdateLocal({this.productCategory});

  final ProductCategory productCategory;
}

class ProductCategoryAddEditSaved extends ProductCategoryAddEditEvent {
  ProductCategoryAddEditSaved({this.productCategory});

  final ProductCategory productCategory;
}

class ProductCategoryAddEditDeleteTemporary extends ProductCategoryAddEditEvent {
  ProductCategoryAddEditDeleteTemporary({this.productCategory});

  final ProductCategory productCategory;
}

class ProductCategoryAddEditDeleted extends ProductCategoryAddEditEvent {
  ProductCategoryAddEditDeleted({this.productCategory});

  final ProductCategory productCategory;
}
