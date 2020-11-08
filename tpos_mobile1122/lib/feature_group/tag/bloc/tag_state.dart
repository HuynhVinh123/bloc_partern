import 'package:tpos_api_client/tpos_api_client.dart';

class TagState {}

class TagLoading extends TagState {}

class TagRefreshLoading extends TagState {}

class TagActionLoading extends TagState{}

class TagLoadMoreLoading extends TagState {}

class TagLoadSuccess extends TagState {
  TagLoadSuccess({this.odataTag});
  final OdataListResult<Tag> odataTag;
}

class TagLoadFailure extends TagState {
  TagLoadFailure({this.message, this.title});
  final String title;
  final String message;
}

class ActionSuccess extends TagState {
  ActionSuccess({this.message, this.title});
  final String title;
  final String message;
}

class ActionFailure extends TagState {
  ActionFailure({this.message, this.title});
  final String title;
  final String message;
}
