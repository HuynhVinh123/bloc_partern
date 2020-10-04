import '../../tpos_api_client.dart';

abstract class NotificationApi {
  Future<void> markRead(String key);
  Future<GetNotificationResult> getAll();
  Future<GetNotificationResult> getNotRead();
}
