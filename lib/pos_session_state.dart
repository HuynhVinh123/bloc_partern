import 'package:tpos_api_client/tpos_api_client.dart';

class PosSessionState {}

/// Loading khi lấy danh sách phiên bán hàng
class PosSessionLoading extends PosSessionState {}

/// Loading cho load more
class PosSessionLoadMoreLoading extends PosSessionState {}

/// Trả về dữ liệu khi xử lý hành động thành công
class PosSessionLoadSuccess extends PosSessionState {
  PosSessionLoadSuccess({this.posSessions});
  final List<PosSession> posSessions;
}

/// Trả về lỗi khi xử lý hành động thất bại
class PosSessionLoadFailure extends PosSessionState {
  PosSessionLoadFailure({this.title, this.content});
  final String title;
  final String content;
}

/// Xử lý xóa phiên bán hàng
class PosSessionDeleteSuccess extends PosSessionState{
  PosSessionDeleteSuccess({this.content,this.title});
  final String title;
  final String content;
}
