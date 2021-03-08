import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';
import 'package:tpos_mobile/services/navigation_service.dart';
import 'package:tpos_mobile/services/notification_service/fcm_service.dart';

/// This notification channel for show notification receiver from fcm when app is on the backgorund.
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
  enableVibration: true,
  playSound: true,
);

/// Handle on background message.
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message ${message.messageId}");
}

const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('launch_background');

class FcmServiceImpl implements FcmService {
  final Logger _logger = Logger();
  bool _hasCallPushToken = false;

  /// Save token to the server. This method will be executed only once.
  /// Many call to this will be ignore. To start again, close the app and reopen.
  @override
  Future<void> pushToken() async {
    // Ask permission on ios
    if (_hasCallPushToken) {
      return;
    }

    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true);
    }
    // Get token and save.
    final String token = await FirebaseMessaging.instance.getToken();

    await _saveToken(token);
    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      _saveToken(token);
    });

    try {
      await _startListen();
    } catch (e, s) {
      _logger.e('', e, s);
    }

    _hasCallPushToken = true;
  }

  /// Save new token.
  /// if (token) is different from the token saved in the config this action is execute. Otherwise,it will be ignored.
  Future<void> _saveToken(String token) async {
    final ConfigService _config = GetIt.I<ConfigService>();
    final SecureConfigService _secureConfig = GetIt.I<SecureConfigService>();

    if (_config.lastFcmToken == token) {
      return;
    }
    try {
      //  print(token);

      final existsUser = await FirebaseFirestore.instance
          .collection('users')
          .doc(_secureConfig.shopUrl.replaceAll('https://', ''))
          .get();

      if (existsUser != null && existsUser.exists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_secureConfig.shopUrl.replaceAll('https://', ''))
            .update({
          'tokens': FieldValue.arrayUnion(
            [token],
          ),
          'platform': Platform.operatingSystem,
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_secureConfig.shopUrl.replaceAll('https://', ''))
            .set({
          'tokens': FieldValue.arrayUnion([token]),
          'platform': Platform.operatingSystem,
        });
      }

      _config.setLastFcmToken(token);
      ;
    } catch (e, s) {
      _logger.e('', e, s);
    }
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _startListen() async {
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );

    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((event) {
      final RemoteNotification notification = event.notification;
      final AndroidNotification android = event.notification?.android;
      print('show Local notification');

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              playSound: channel.playSound,
              importance: Importance.max,
              priority: Priority.max,

              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
          payload: 'payload',
        );
      }
    });

    final _navigate = GetIt.I<NavigationService>();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Navigator.pushNamed(context, '/message',
      //     arguments: MessageArguments(message, true));
    });
  }

  static Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    //TODO(namnv): Implement this action on ios.
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    }
    print('Need navigation to ne screen');
  }

  Future<void> _config() async {}
}
