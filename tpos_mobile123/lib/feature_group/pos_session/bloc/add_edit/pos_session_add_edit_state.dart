import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_order.dart';

class PosSessionAddEditState {}

/// Loading khi lấy danh sách phiên bán hàng
class PosSessionInfoLoading extends PosSessionAddEditState {}

/// Trả về lỗi khi xử lý hành động thất bại
class PosSessionInfoLoadFailure extends PosSessionAddEditState {
  PosSessionInfoLoadFailure({this.title, this.content});
  final String title;
  final String content;
}

/// Trả về dữ liệu khi xử lý hành động thành công
class PosSessionInfoLoadSuccess extends PosSessionAddEditState {
  PosSessionInfoLoadSuccess({this.posSession, this.posAccountBanks});
  final PosSession posSession;
  final List<PosAccountBank> posAccountBanks;
}

/// Trả về thông báo khi xử lý hành động thành công
class PosSessionActionSuccess extends PosSessionAddEditState {
  PosSessionActionSuccess({this.title, this.content});
  final String title;
  final String content;
}
