import 'package:tpos_api_client/tpos_api_client.dart';

class TagEvent {}

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

class TagLoadLocal extends TagEvent {
  TagLoadLocal({this.odataTag});
  final OdataListResult<Tag> odataTag;

}

class TagLoadMoreLoaded extends TagEvent {
  TagLoadMoreLoaded(
      {this.skip, this.top, this.odataTag, this.tagTypes, this.keyWord});

  final OdataListResult<Tag> odataTag;
  final int skip;
  final int top;
  final List<String> tagTypes;
  final String keyWord;
}

class TagDeleted extends TagEvent {
  TagDeleted({this.tagId});

  final int tagId;
}

class TagDeleteLocal extends TagEvent {
  TagDeleteLocal({this.tag, this.odataTag});

  final Tag tag;
  final OdataListResult<Tag> odataTag;
}

class TagUpdated extends TagEvent {
  TagUpdated({this.tag});

  final Tag tag;
}

class TagAdded extends TagEvent {
  TagAdded({this.tag});

  final Tag tag;
}
