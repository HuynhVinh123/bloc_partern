import 'package:tpos_api_client/tpos_api_client.dart';

class TagEvent {}

/// Event load thông tin dữ liệu
class TagLoaded extends TagEvent {}

/// Event xóa 1 tag
class TagDeleted extends TagEvent {
  TagDeleted({this.id});
  final String id;
}

/// Event cập nhật 1 tag
class TagUpdated extends TagEvent {
  TagUpdated({this.tag});
  final CRMTag tag;
}

/// Event cập nhật thông tin trạng thái của 1 tag
class TagUpdatedStatus extends TagEvent {
  TagUpdatedStatus({this.tagId});
  final String tagId;
}

/// Event add thêm 1 tag
class TagAdded extends TagEvent {
  TagAdded({this.tag});
  final CRMTag tag;
}
