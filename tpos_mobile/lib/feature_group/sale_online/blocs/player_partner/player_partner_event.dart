abstract class PlayerPartnerEvent {}

class PlayerPartnerLoaded extends PlayerPartnerEvent {
  PlayerPartnerLoaded({this.crmTeamId, this.asuId});

  final int crmTeamId;
  final String asuId;
}
