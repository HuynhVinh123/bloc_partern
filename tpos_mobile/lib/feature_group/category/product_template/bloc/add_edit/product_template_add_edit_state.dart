import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductTemplateAddEditState {
  ProductTemplateAddEditState({this.productTemplate, this.userPermission});

  final ProductTemplate productTemplate;
  final UserPermission userPermission;
}

class ProductTemplateAddEditLoadSuccess extends ProductTemplateAddEditState {
  ProductTemplateAddEditLoadSuccess({ProductTemplate productTemplate, UserPermission userRight})
      : super(productTemplate: productTemplate, userPermission: userRight);
}

class ProductTemplateAddEditBusy extends ProductTemplateAddEditState {
  ProductTemplateAddEditBusy({ProductTemplate productTemplate, UserPermission userRight})
      : super(productTemplate: productTemplate, userPermission: userRight);
}

class ProductTemplateAddEditLoadFailure extends ProductTemplateAddEditState {
  ProductTemplateAddEditLoadFailure({ProductTemplate productTemplate, this.error, UserPermission userRight})
      : super(productTemplate: productTemplate, userPermission: userRight);

  final String error;
}

class ProductTemplateAddEditSaveSuccess extends ProductTemplateAddEditState {
  ProductTemplateAddEditSaveSuccess({ProductTemplate productTemplate, UserPermission userRight})
      : super(productTemplate: productTemplate, userPermission: userRight);
}

class ProductTemplateAddEditUploadImageSuccess extends ProductTemplateAddEditState {
  ProductTemplateAddEditUploadImageSuccess({ProductTemplate productTemplate, UserPermission userRight})
      : super(productTemplate: productTemplate, userPermission: userRight);
}

class ProductTemplateAddEditSaveError extends ProductTemplateAddEditState {
  ProductTemplateAddEditSaveError({ProductTemplate productTemplate, this.error, UserPermission userRight})
      : super(productTemplate: productTemplate, userPermission: userRight);

  final String error;
}

class ProductTemplateAddEditNameEmpty extends ProductTemplateAddEditState {
  ProductTemplateAddEditNameEmpty({ProductTemplate productTemplate, UserPermission userRight})
      : super(productTemplate: productTemplate, userPermission: userRight);
}

class ProductTemplateAddEditLoading extends ProductTemplateAddEditState {
  ProductTemplateAddEditLoading({ProductTemplate productTemplate, UserPermission userRight})
      : super(productTemplate: productTemplate, userPermission: userRight);
}

class ProductTemplateAddEditUploadImageError extends ProductTemplateAddEditState {
  ProductTemplateAddEditUploadImageError({ProductTemplate productTemplate, this.error, UserPermission userRight})
      : super(productTemplate: productTemplate, userPermission: userRight);

  final String error;
}

class ProductTemplateAddEditChangeUOMError extends ProductTemplateAddEditState {
  ProductTemplateAddEditChangeUOMError({ProductTemplate productTemplate, this.error, UserPermission userRight})
      : super(productTemplate: productTemplate, userPermission: userRight);

  final String error;
}
