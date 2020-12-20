import 'package:tpos_api_client/tpos_api_client.dart';

class TagCategoryInfoState {}

/// State loading nhãn
class TagCategoryInfoLoading extends TagCategoryInfoState {}

/// State khi thực hiện load thông tin nhãn thành công
class TagCategoryInfoLoadSuccess extends TagCategoryInfoState {
  TagCategoryInfoLoadSuccess({this.tag});
  final Tag tag;
}

/// State khi thực hiện xóa nhãn thành công
class TagCategoryInfoActionSuccess extends TagCategoryInfoState {
  TagCategoryInfoActionSuccess({this.message, this.title});
  final String title;
  final String message;
}

/// State khi thực hiện 1 hành động thất bại
class TagCategoryInfoActionFailure extends TagCategoryInfoState {
  TagCategoryInfoActionFailure({this.message, this.title});
  final String title;
  final String message;
}
