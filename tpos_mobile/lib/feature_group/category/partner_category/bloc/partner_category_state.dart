import 'package:tpos_api_client/tpos_api_client.dart';

abstract class PartnerCategoryState {}

class PartnerCategoryLoading extends PartnerCategoryState {}

class PartnerCategoryBusy extends PartnerCategoryState {}

class PartnerCategoryLoadFailure extends PartnerCategoryState {
  PartnerCategoryLoadFailure({this.title, this.content});
  final String title;
  final String content;
}

class PartnerCategoryActionFailure extends PartnerCategoryState {
  PartnerCategoryActionFailure({this.error});

  final String error;
}

class PartnerCategoryLoadSuccess extends PartnerCategoryState {
  PartnerCategoryLoadSuccess({this.partnerCategories});

  final List<PartnerCategory> partnerCategories;
}

class PartnerCategoryDeleteSuccess extends PartnerCategoryLoadSuccess {
  PartnerCategoryDeleteSuccess({List<PartnerCategory> partnerCategories})
      : super(partnerCategories: partnerCategories);
}

class PartnerCategoryInsertSuccess extends PartnerCategoryLoadSuccess {
  PartnerCategoryInsertSuccess({List<PartnerCategory> partnerCategories})
      : super(partnerCategories: partnerCategories);
}
