import 'package:get_it/get_it.dart';

import '../../tpos_api_client.dart';

class NotificationApiImpl implements NotificationApi {
  NotificationApiImpl({TPosApi apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }
  TPosApi _apiClient;

  @override
  Future<void> markRead(String key) async {
    assert(key != null);
    await _apiClient.httpPost("/api/notification/markread/$key");
  }

  @override
  Future<GetNotificationResult> getNotRead() async {
    final json = await _apiClient.httpGet("/api/notification/notread");
    return GetNotificationResult.fromJson(json);
  }

  @override
  Future<GetNotificationResult> getAll() async {
    final json = await _apiClient.httpGet("/api/notification/all");
    return GetNotificationResult.fromJson(json);
  }
}
