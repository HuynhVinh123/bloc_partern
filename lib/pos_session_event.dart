import 'package:tpos_api_client/tpos_api_client.dart';

class PosSessionEvent {}
/// Lấy dữ liệu có phiên bán hàng
class PosSessionLoaded extends PosSessionEvent {
  PosSessionLoaded({this.skip, this.limit});

  final int limit;
  final int skip;
}

/// Xử lý lấy dữ liệu load mroe cho phiên bán hàng
class PosSessionLoadMoreLoaded extends PosSessionEvent {
  PosSessionLoadMoreLoaded({this.posSessions,this.skip,this.limit});

  final int limit;
  final int skip;
  final List<PosSession> posSessions;
}

class PosSessionDeleted extends PosSessionEvent{
  PosSessionDeleted({this.id});
  final int id;
}
