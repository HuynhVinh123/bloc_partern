import 'package:tpos_api_client/tpos_api_client.dart';

class TagCategoryAddEditEvent {}

/// Event cập nhật nhãn
class TagCategoryUpdated extends TagCategoryAddEditEvent {
  TagCategoryUpdated({this.tag});
  final Tag tag;
}

/// Event thêm nhãn
class TagCategoryAdded extends TagCategoryAddEditEvent {
  TagCategoryAdded({this.tag});
  final Tag tag;
}
