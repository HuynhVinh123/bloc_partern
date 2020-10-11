import 'package:tpos_api_client/tpos_api_client.dart';

abstract class NotificationEvent {}

class NotificationLoaded extends NotificationEvent {}

class NotificationRefreshed extends NotificationEvent {}

class NotificationMarkRead extends NotificationEvent {
  NotificationMarkRead(this.notification) : assert(notification != null);
  final TPosNotification notification;
}
