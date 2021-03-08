/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/5/19 4:54 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/5/19 4:22 PM
 *
 */

import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';

class NotificationListViewModel extends ScopedViewModel {
  NotificationListViewModel({
    NotificationApi noticationApi,
  }) {
    _noticationApi = noticationApi ?? GetIt.instance<NotificationApi>();
  }
  NotificationApi _noticationApi;

  bool _isInit = false;
  int get notReadCount => _notReadNotification?.length ?? 0;

  Future<void> initCommand() async {
    setBusy(true);
    if (_isInit == false) {
      await _getNotificationList();
    }

    setBusy(false);
    _isInit = true;
  }

  Future<void> refreshCommand() async {
    await _getNotificationList();
  }

  List<TPosNotification> _notifications;
  List<TPosNotification> _notReadNotification;
  List<TPosNotification> get notifications => _notifications;
  Future<void> _getNotificationList() async {
    final getResult = await _noticationApi.getAll();
    if (getResult != null) {
      _notifications = getResult.items;
      notifyListeners();
    }
  }
}
