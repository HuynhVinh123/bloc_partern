import 'package:tpos_api_client/tpos_api_client.dart';

class PosAddEditDetailAccountState {}

/// Loading khi lấy danh sách phiên bán hàng
class PosSessionDetailAccountLoading extends PosAddEditDetailAccountState {}

/// Trả về lỗi khi xử lý hành động thất bại
class PosSessionActionFailure extends PosAddEditDetailAccountState {
  PosSessionActionFailure({this.title, this.content});
  final String title;
  final String content;
}

/// Trả về dữ liệu khi xử lý hành động thành công
class PosSessionDetailAccountLoadSuccess extends PosAddEditDetailAccountState {
  PosSessionDetailAccountLoadSuccess(
      {this.posAccountBankDetail, this.posAccountBankLines});

  final PosAccountBank posAccountBankDetail;
  final List<PosAccountBankLine> posAccountBankLines;
}
