import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductTemplateAddEditState {
  ProductTemplateAddEditState({this.productTemplate});

  final ProductTemplate productTemplate;
}

class ProductTemplateAddEditLoadSuccess extends ProductTemplateAddEditState {
  ProductTemplateAddEditLoadSuccess({ProductTemplate productTemplate}) : super(productTemplate: productTemplate);
}

class ProductTemplateAddEditBusy extends ProductTemplateAddEditState {
  ProductTemplateAddEditBusy({ProductTemplate productTemplate}) : super(productTemplate: productTemplate);
}


class ProductTemplateAddEditLoadFailure extends ProductTemplateAddEditState {
  ProductTemplateAddEditLoadFailure({ProductTemplate productTemplate, this.error})
      : super(productTemplate: productTemplate);

  final String error;
}

class ProductTemplateAddEditSaveSuccess extends ProductTemplateAddEditState {
  ProductTemplateAddEditSaveSuccess({ProductTemplate productTemplate}) : super(productTemplate: productTemplate);
}

class ProductTemplateAddEditUploadImageSuccess extends ProductTemplateAddEditState {
  ProductTemplateAddEditUploadImageSuccess({ProductTemplate productTemplate}) : super(productTemplate: productTemplate);
}


class ProductTemplateAddEditSaveError extends ProductTemplateAddEditState {
  ProductTemplateAddEditSaveError({ProductTemplate productTemplate, this.error})
      : super(productTemplate: productTemplate);

  final String error;
}

class ProductTemplateAddEditNameError extends ProductTemplateAddEditState {
  ProductTemplateAddEditNameError({ProductTemplate productTemplate, this.error})
      : super(productTemplate: productTemplate);

  final String error;
}

class ProductTemplateAddEditLoading extends ProductTemplateAddEditState {
  ProductTemplateAddEditLoading({ProductTemplate productTemplate}) : super(productTemplate: productTemplate);
}

class ProductTemplateAddEditUploadImageError extends ProductTemplateAddEditState {
  ProductTemplateAddEditUploadImageError({ProductTemplate productTemplate, this.error})
      : super(productTemplate: productTemplate);

  final String error;
}


