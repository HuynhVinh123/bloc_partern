import 'package:tpos_api_client/tpos_api_client.dart';

abstract class PlayerPartnerState {}

class PlayerPartnerLoadSuccess extends PlayerPartnerState {
  PlayerPartnerLoadSuccess({this.partner});

  final Partner partner;
}

class PlayerPartnerLoading extends PlayerPartnerState {}

class PlayerPartnerLoadError extends PlayerPartnerState {
  PlayerPartnerLoadError({this.error});

  final String error;
}
