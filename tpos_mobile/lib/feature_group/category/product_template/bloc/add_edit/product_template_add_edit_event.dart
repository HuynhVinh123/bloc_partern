import 'dart:io';

import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductTemplateAddEditEvent {}

class ProductTemplateAddEditStarted extends ProductTemplateAddEditEvent {
  ProductTemplateAddEditStarted({this.productTemplate});

  final ProductTemplate productTemplate;
}

class ProductTemplateAddEditUpdateLocal extends ProductTemplateAddEditEvent {
  ProductTemplateAddEditUpdateLocal({this.productTemplate});

  final ProductTemplate productTemplate;
}

class ProductTemplateAddEditSaved extends ProductTemplateAddEditEvent {
  ProductTemplateAddEditSaved({this.productTemplate});

  final ProductTemplate productTemplate;
}

class ProductTemplateAddEditUploadImage extends ProductTemplateAddEditEvent {
  ProductTemplateAddEditUploadImage({this.file});

  final File file;
}

class ProductTemplateAddEditOnChangeUOM extends ProductTemplateAddEditEvent{
  ProductTemplateAddEditOnChangeUOM({this.productTemplate});
  final ProductTemplate productTemplate;
}