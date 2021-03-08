import 'package:tpos_api_client/tpos_api_client.dart';

class FacebookPageSelectEvent {}

class FacebookPageSelectLoaded extends FacebookPageSelectEvent {
  FacebookPageSelectLoaded(this.crmTeam);

  final CRMTeam crmTeam;
}

class FacebookPageSelectSearch extends FacebookPageSelectEvent {
  FacebookPageSelectSearch({this.search, this.crmTeam});

  String search;
  final CRMTeam crmTeam;
}
