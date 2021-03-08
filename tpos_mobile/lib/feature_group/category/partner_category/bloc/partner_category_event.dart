import 'package:tpos_api_client/tpos_api_client.dart';

abstract class PartnerCategoryEvent {}

class PartnerCategoriesLoaded extends PartnerCategoryEvent {}

class PartnerCategorySearched extends PartnerCategoryEvent {
  PartnerCategorySearched({this.search});

  String search;
}

class PartnerCategoryDeleted extends PartnerCategoryEvent {
  PartnerCategoryDeleted({this.partnerCategory});

  final PartnerCategory partnerCategory;
}

class PartnerCategoryAddEdited extends PartnerCategoryEvent {
  PartnerCategoryAddEdited({this.partnerCategory});

  final PartnerCategory partnerCategory;
}
