import 'package:tpos_api_client/tpos_api_client.dart';

abstract class PartnerCategoryAddEditState {}

class PartnerCategoryAddEditLoading extends PartnerCategoryAddEditState {}

class PartnerCategoryAddEditLoadSuccess extends PartnerCategoryAddEditState {
  PartnerCategoryAddEditLoadSuccess({this.partnerCategory});

  final PartnerCategory partnerCategory;
}

class PartnerCategoryAddEditLoadFailure extends PartnerCategoryAddEditState {
  PartnerCategoryAddEditLoadFailure({this.title, this.message});

  final String title;
  final String message;
}

class PartnerCategoryAddEditBusy extends PartnerCategoryAddEditState {}

class PartnerCategoryEditSaveSuccess extends PartnerCategoryAddEditLoadSuccess {
  PartnerCategoryEditSaveSuccess({PartnerCategory partnerCategory})
      : super(partnerCategory: partnerCategory);
}

class PartnerCategoryAddSaveSuccess extends PartnerCategoryAddEditLoadSuccess {
  PartnerCategoryAddSaveSuccess({PartnerCategory partnerCategory})
      : super(partnerCategory: partnerCategory);
}

class PartnerCategoryAddEditSaveError extends PartnerCategoryAddEditState {
  PartnerCategoryAddEditSaveError({this.title, this.message});

  final String title;
  final String message;
}

class PartnerCategoryAddEditNameError
    extends PartnerCategoryAddEditLoadSuccess {
  PartnerCategoryAddEditNameError({PartnerCategory partnerCategory, this.error})
      : super(partnerCategory: partnerCategory);

  final String error;
}
