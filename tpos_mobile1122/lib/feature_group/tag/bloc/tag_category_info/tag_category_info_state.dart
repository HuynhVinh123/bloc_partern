import 'package:tpos_api_client/tpos_api_client.dart';

class TagCategoryInfoState{}

class TagCategoryInfoLoading extends TagCategoryInfoState{}


class TagCategoryInfoLoadSuccess extends TagCategoryInfoState{
  TagCategoryInfoLoadSuccess({this.tag});
  final Tag tag;
}

class TagCategoryInfoActionSuccess extends TagCategoryInfoState{
  TagCategoryInfoActionSuccess({this.message, this.title});
  final String title;
  final String message;
}

class TagCategoryInfoActionFailure extends TagCategoryInfoState{
  TagCategoryInfoActionFailure({this.message, this.title});
  final String title;
  final String message;
}