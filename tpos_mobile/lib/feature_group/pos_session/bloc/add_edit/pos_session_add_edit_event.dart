import 'package:tpos_api_client/tpos_api_client.dart';

class PosSessionAddEditEvent {}

/// Lấy dữ liệu có phiên bán hàng
class PosSessionInfoLoaded extends PosSessionAddEditEvent {
  PosSessionInfoLoaded({this.id});
  final int id;
}

/// Lấy dữ liệu có phiên bán hàng
class PosSessionSaved extends PosSessionAddEditEvent {
  PosSessionSaved({this.posSession});
  final PosSession posSession;
}

/// Kết thúc phiên
class PosSessionAddEditClosed extends PosSessionAddEditEvent {
  PosSessionAddEditClosed({this.sessionId});
  final int sessionId;
}
