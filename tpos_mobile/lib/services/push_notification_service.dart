import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';

import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/navigation_service.dart';

/// This service using firebase FCM to push notification to user
/// This using [NavigationService] to handled Navigation and
/// TODO Setup this notification service to Locator
class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final NavigationService _navigation = GetIt.I<NavigationService>();

  /// Initialise
  Future<void> init() async {
    _fcm.configure(
      // ignore: missing_return
      onLaunch: (Map<String, dynamic> message) {},
      // ignore: missing_return
      onResume: (Map<String, dynamic> message) {},
    );
  }

  /// Handled received [message] and navigate to right page via [NavigationService]
  void _handledMessage(Map<String, dynamic> message) {
    var messageData = message["data"];
    var requestedView = messageData["view"];

    if (requestedView != null) {
      switch (requestedView) {
        // case AppRouteOld.home:
        //   _navigation.navigateTo(AppRouteOld.home);
        //   break;
        default:
          break;
      }
    }
  }
}
