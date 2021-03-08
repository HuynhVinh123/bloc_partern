import 'package:tpos_api_client/tpos_api_client.dart';

class TagState {}

/// State loading khi load danh sách nhãn
class TagLoading extends TagState {}

///State loading khi thực hiện load lại danh sách nhãn
class TagRefreshLoading extends TagState {}

/// State loading khi thực hiện 1 hành động
class TagActionLoading extends TagState {}

/// State loading khi loadmor
class TagLoadMoreLoading extends TagState {}

/// State khi load danh sách nhãn thành công
class TagLoadSuccess extends TagState {
  TagLoadSuccess({this.odataTag});
  final OdataListResult<Tag> odataTag;
}

/// State khi load danh sách nhãn thất bại
class TagLoadFailure extends TagState {
  TagLoadFailure({this.message, this.title});
  final String title;
  final String message;
}

/// State khi thực hiện 1 hành động thành công
class ActionSuccess extends TagState {
  ActionSuccess({this.message, this.title, this.tag, this.odataTag});
  final String title;
  final String message;
  final Tag tag;
  final OdataListResult<Tag> odataTag;
}

/// State khi thực hiện 1 hành động thất bại
class ActionFailure extends TagState {
  ActionFailure({this.message, this.title});
  final String title;
  final String message;
}
