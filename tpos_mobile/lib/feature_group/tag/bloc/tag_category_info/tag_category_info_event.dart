import 'package:tpos_api_client/tpos_api_client.dart';

class TagCategoryInfoEvent {}

/// Event xóa nhãn
class TagCategoryInfoDeleted extends TagCategoryInfoEvent {
  TagCategoryInfoDeleted({this.tagId});
  final int tagId;
}

/// Event load lại thông tin nhãn
class TagCategoryInfoLoaded extends TagCategoryInfoEvent {
  TagCategoryInfoLoaded({this.id});
  final int id;
}

/// Event cập nhật thông tin nhãn từ list
class TagCategoryLoadLocal extends TagCategoryInfoEvent {
  TagCategoryLoadLocal({this.tag});
  final Tag tag;
}
