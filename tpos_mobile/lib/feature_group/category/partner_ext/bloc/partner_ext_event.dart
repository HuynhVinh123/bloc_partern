abstract class PartnerExtEvent {}

class PartnerExtStarted extends PartnerExtEvent {
  PartnerExtStarted({this.keyword = ''});

  final String keyword;
}

class PartnerExtSearched extends PartnerExtEvent {
  PartnerExtSearched({this.keyword});

  final String keyword;
}