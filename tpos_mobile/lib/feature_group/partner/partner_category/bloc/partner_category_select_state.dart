import 'package:tpos_api_client/tpos_api_client.dart';

abstract class PartnerCategorySelectState {}

class PartnerCategorySelectInitial extends PartnerCategorySelectState {}

class PartnerCategorySelectLoading extends PartnerCategorySelectState {}

class PartnerCategorySelectBusy extends PartnerCategorySelectState {}

class PartnerCategorySelectLoadSuccess extends PartnerCategorySelectState {
  PartnerCategorySelectLoadSuccess({this.partnerCategories});

  final List<PartnerCategory> partnerCategories;
}

class PartnerCategorySelectLoadFailure extends PartnerCategorySelectState {
  PartnerCategorySelectLoadFailure({this.title, this.content});

  final String title;
  final String content;
}

class PartnerCategorySelectDeleteFailure extends PartnerCategorySelectState {
  PartnerCategorySelectDeleteFailure({this.error});

  final String error;
}

class PartnerCategorySelectDeleteSuccess
    extends PartnerCategorySelectLoadSuccess {
  PartnerCategorySelectDeleteSuccess({List<PartnerCategory> partnerCategories})
      : super(partnerCategories: partnerCategories);
}
