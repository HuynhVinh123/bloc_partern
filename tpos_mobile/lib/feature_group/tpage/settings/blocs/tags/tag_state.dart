import 'package:tpos_api_client/tpos_api_client.dart';

class TagState {}

/// Loading
class TagLoading extends TagState {}

/// State khi load thành công dữ liệu
class TagLoadSuccess extends TagState {
  TagLoadSuccess({this.tagTPages});
  final List<CRMTag> tagTPages;
}

/// State khi thực thi 1 hành động thêm, sửa, xóa thành công
class ActionSuccess extends TagState {
  ActionSuccess({this.title, this.content});
  final String title;
  final String content;
}

/// State khi thực thi 1 hành động thêm, sửa, xóa thất bại
class TagLoadFailure extends TagState {
  TagLoadFailure({this.title, this.content});
  final String title;
  final String content;
}
