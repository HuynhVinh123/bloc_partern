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
  PosSessionLoadMoreLoaded({this.posSessions, this.skip, this.limit});

  final int limit;
  final int skip;
  final List<PosSession> posSessions;
}

class PosSessionDeleted extends PosSessionEvent {
  PosSessionDeleted({this.id,this.posSessions,this.index});
  final int id;
  final List<PosSession> posSessions;
  final int index;
}

/// Kết thúc phiên
class PosSessionClosed extends PosSessionEvent {
  PosSessionClosed({this.sessionId, this.posSessions});
  final int sessionId;
  final List<PosSession> posSessions;
}

/// cập lại lại số lượng phiên sau khi xóa
class PosSessionUpdated extends PosSessionEvent {}
