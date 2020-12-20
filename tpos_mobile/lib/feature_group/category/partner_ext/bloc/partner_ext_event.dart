abstract class PartnerExtEvent {}

class PartnerExtStarted extends PartnerExtEvent {}

class PartnerExtSearched extends PartnerExtEvent {
  PartnerExtSearched({this.keyword});

  final String keyword;
}
