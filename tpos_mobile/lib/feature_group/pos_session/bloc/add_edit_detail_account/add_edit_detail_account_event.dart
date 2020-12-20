class PosAddEditDetailAccountEvent {}

/// Lấy dữ liệu có phiên bán hàng
class PosSessionDetailLoaded extends PosAddEditDetailAccountEvent {
  PosSessionDetailLoaded({this.id});
  final int id;
}
