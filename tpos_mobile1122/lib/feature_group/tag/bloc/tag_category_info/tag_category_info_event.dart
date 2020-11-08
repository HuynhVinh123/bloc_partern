import 'package:tpos_api_client/tpos_api_client.dart';

class TagCategoryInfoEvent{}

class TagCategoryInfoDeleted extends TagCategoryInfoEvent{
  TagCategoryInfoDeleted({this.tagId});
  final int tagId;
}

class TagCategoryInfoLoaded extends TagCategoryInfoEvent{
  TagCategoryInfoLoaded({this.id});
  final int id;
}

class TagCategoryLoadLocal extends TagCategoryInfoEvent{
  TagCategoryLoadLocal({this.tag});
  final Tag tag;
}
