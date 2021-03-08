import 'package:tpos_api_client/tpos_api_client.dart';

abstract class PartnerCategoryAddEditEvent {}

class PartnerCategoryAddEditLoaded extends PartnerCategoryAddEditEvent {
  PartnerCategoryAddEditLoaded({this.partnerCategory});

  final PartnerCategory partnerCategory;
}

class PartnerCategoryAddEditSaved extends PartnerCategoryAddEditEvent {
  PartnerCategoryAddEditSaved({this.partnerCategory});

  final PartnerCategory partnerCategory;
}

class PartnerCategoryAddEditRefreshed extends PartnerCategoryAddEditEvent {}
