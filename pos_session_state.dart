import 'package:tpos_api_client/tpos_api_client.dart';

class PosSessionState {}

class PosSessionLoading extends PosSessionState {}

class PosSessionLoadMoreLoading extends PosSessionState {}

class PosSessionLoadSuccess extends PosSessionState {
  PosSessionLoadSuccess({this.posSessions});
  final List<PosSession> posSessions;
}

class PosSessionLoadFailure extends PosSessionState {
  PosSessionLoadFailure({this.title, this.content});
  final String title;
  final String content;
}
