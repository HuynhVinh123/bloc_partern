import 'package:tpos_api_client/tpos_api_client.dart';

class FastReplyState {}

/// Loading
class FastReplyLoading extends FastReplyState {}

/// State khi load dữ liệu thành công
class FastReplyLoadSuccess extends FastReplyState {
  FastReplyLoadSuccess({this.mailTemplates});
  final List<MailTemplate> mailTemplates;
}

/// State khi thực thi các hành động thêm,sửa,xóa... thành công
class ActionSuccess extends FastReplyState {
  ActionSuccess({this.title, this.content});
  final String title;
  final String content;
}

/// State khi thực thi các hành động thêm,sửa,xóa... thất bại
class ActionFailed extends FastReplyState {
  ActionFailed({this.title, this.content});
  final String title;
  final String content;
}

/// State khi load dữ liệu thất bại
class FastReplyLoadFailure extends FastReplyState {
  FastReplyLoadFailure({this.title, this.content});
  final String title;
  final String content;
}
