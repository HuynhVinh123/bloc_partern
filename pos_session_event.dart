import 'package:tpos_api_client/tpos_api_client.dart';

class PosSessionEvent {}

class PosSessionLoaded extends PosSessionEvent {
  PosSessionLoaded({this.skip, this.limit});

  final int limit;
  final int skip;
}

class PosSessionLoadMoreLoaded extends PosSessionEvent {
  PosSessionLoadMoreLoaded({this.posSessions,this.skip,this.limit});

  final int limit;
  final int skip;
  final List<PosSession> posSessions;
}
