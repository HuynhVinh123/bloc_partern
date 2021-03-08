abstract class OriginCountryEvent {}

class OriginCountryStarted extends OriginCountryEvent {}

class OriginCountrySearched extends OriginCountryEvent {
  OriginCountrySearched({this.keyword});

  final String keyword;
}
