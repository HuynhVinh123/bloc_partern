import 'package:tpos_api_client/tpos_api_client.dart';

class FastReplyEvent {}

class FastReplyLoaded extends FastReplyEvent {}

class FastReplyDeleted extends FastReplyEvent {
  FastReplyDeleted({this.id});
  final int id;
}

class FastReplyUpdated extends FastReplyEvent {
  FastReplyUpdated({this.reply});
  final String reply;
}

class FastReplyStatusUpdated extends FastReplyEvent {
  FastReplyStatusUpdated({this.id});
  final int id;
}

class FastReplyAdded extends FastReplyEvent {
  FastReplyAdded({this.mailTemplateTPage});
  final MailTemplateTPage mailTemplateTPage;
}
