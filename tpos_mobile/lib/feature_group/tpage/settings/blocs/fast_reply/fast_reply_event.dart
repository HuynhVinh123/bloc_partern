import 'package:tpos_api_client/tpos_api_client.dart';

class FastReplyEvent {}

/// Event lấy dữ liệu
class FastReplyLoaded extends FastReplyEvent {}

/// Event xóa 1 item
class FastReplyDeleted extends FastReplyEvent {
  FastReplyDeleted({this.id});
  final int id;
}

/// Event cập nhật thông tin item
class FastReplyUpdated extends FastReplyEvent {
  FastReplyUpdated({this.reply});
  final String reply;
}

/// Event cập nhật trạng thái item
class FastReplyStatusUpdated extends FastReplyEvent {
  FastReplyStatusUpdated({this.id});
  final int id;
}

/// Event thêm  1 item
class FastReplyAdded extends FastReplyEvent {
  FastReplyAdded({this.mailTemplateTPage});
  final MailTemplate mailTemplateTPage;
}
