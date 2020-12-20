import 'package:tpos_api_client/tpos_api_client.dart';

class TagEvent {}

/// Event load danh sách nhãn
class TagLoaded extends TagEvent {
  TagLoaded(
      {this.skip,
      this.top,
      this.tagTypes,
      this.keyWord,
      this.isReload = false});

  final int skip;
  final int top;
  final List<String> tagTypes;
  final String keyWord;
  final bool isReload;
}

/// Event cập nhật lại danh sách nhãn ko sử dụng API
class TagLoadLocal extends TagEvent {
  TagLoadLocal({this.odataTag});
  final OdataListResult<Tag> odataTag;
}

/// Event Thực hiện loadmore danh sách nhãn
class TagLoadMoreLoaded extends TagEvent {
  TagLoadMoreLoaded(
      {this.skip, this.top, this.odataTag, this.tagTypes, this.keyWord});

  final OdataListResult<Tag> odataTag;
  final int skip;
  final int top;
  final List<String> tagTypes;
  final String keyWord;
}

/// EventThực hiện xóa nhãn
class TagDeleted extends TagEvent {
  TagDeleted({this.tag, this.odataTag});
  final Tag tag;
  final OdataListResult<Tag> odataTag;
}

/// Event xóa nhãn trong list
class TagDeleteLocal extends TagEvent {
  TagDeleteLocal({this.tag, this.odataTag});

  final Tag tag;
  final OdataListResult<Tag> odataTag;
}

/// Event Cập nhật lại nhãn
class TagUpdated extends TagEvent {
  TagUpdated({this.tag});

  final Tag tag;
}

/// Event thêm nhãn
class TagAdded extends TagEvent {
  TagAdded({this.tag});

  final Tag tag;
}
