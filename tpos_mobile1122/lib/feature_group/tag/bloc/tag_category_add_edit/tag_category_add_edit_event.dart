import 'package:tpos_api_client/tpos_api_client.dart';

class TagCategoryAddEditEvent{}

class TagCategoryUpdated extends TagCategoryAddEditEvent{
  TagCategoryUpdated({this.tag});
  final Tag tag;
}

class TagCategoryAdded extends TagCategoryAddEditEvent{
  TagCategoryAdded({this.tag});
  final Tag tag;
}