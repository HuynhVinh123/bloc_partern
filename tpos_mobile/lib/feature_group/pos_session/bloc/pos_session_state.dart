import 'package:tpos_api_client/tpos_api_client.dart';

class PosSessionState {}

/// Loading khi lấy danh sách phiên bán hàng
class PosSessionLoading extends PosSessionState {}

/// Loading cho load more
class PosSessionLoadMoreLoading extends PosSessionState {}

/// Trả về dữ liệu khi xử lý hành động thành công
class PosSessionLoadSuccess extends PosSessionState {
  PosSessionLoadSuccess({this.posSessions, this.company});
  final List<PosSession> posSessions;
  final GetCompanyCurrentResult company;
}

/// Trả về lỗi khi xử lý hành động thất bại
class PosSessionActionFailure extends PosSessionState {
  PosSessionActionFailure({this.title, this.content});
  final String title;
  final String content;
}

/// Xử lý xóa phiên bán hàng
class PosSessionActionSuccess extends PosSessionState {
  PosSessionActionSuccess(
      {this.content,
      this.title,
      this.isDelete = false,
      this.countSessions = 0});
  final String title;
  final String content;
  final bool isDelete;
  final int countSessions;
}
