import 'package:tpos_api_client/tpos_api_client.dart';

class FastReplyState {}

/// Loading
class FastReplyLoading extends FastReplyState {}

/// Loading
class FastReplyLoadSuccess extends FastReplyState {
  FastReplyLoadSuccess({this.mailTemplates});
  final List<MailTemplateTPage> mailTemplates;
}

class ActionSuccess extends FastReplyState {
  ActionSuccess({this.title, this.content});
  final String title;
  final String content;
}
class ActionFailed extends FastReplyState {
  ActionFailed({this.title, this.content});
  final String title;
  final String content;
}

class FastReplyLoadFailure extends FastReplyState {
  FastReplyLoadFailure({this.title, this.content});
  final String title;
  final String content;
}
