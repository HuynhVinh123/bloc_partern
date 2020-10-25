import 'package:tpos_api_client/tpos_api_client.dart';

class TagState {}

/// Loading
class TagLoading extends TagState {}

/// Loading
class TagLoadSuccess extends TagState {
  TagLoadSuccess({this.tagTPages});
  final List<TagTPage> tagTPages;
}

class ActionSuccess extends TagState {
  ActionSuccess({this.title, this.content});
  final String title;
  final String content;
}

class TagLoadFailure extends TagState {
  TagLoadFailure({this.title, this.content});
  final String title;
  final String content;
}
