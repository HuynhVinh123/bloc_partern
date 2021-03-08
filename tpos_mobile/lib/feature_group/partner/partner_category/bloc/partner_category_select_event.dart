abstract class PartnerCategorySelectEvent {}

class PartnerCategorySelectLoaded extends PartnerCategorySelectEvent {}

class PartnerCategorySelectSearched extends PartnerCategorySelectEvent {
  PartnerCategorySelectSearched({this.txtSearch});

  final String txtSearch;
}
