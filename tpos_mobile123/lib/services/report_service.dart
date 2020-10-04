import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sentry/sentry.dart';
import 'package:tpos_mobile/app.dart' as app;
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/remote_config_service.dart';

import 'app_setting_service.dart';

abstract class IReportService {
  Future<void> sendUncaughtError(dynamic error, StackTrace stackTrade);

  Future<void> sendUpgradeReport(String version);
}

class ReportService implements IReportService {
  SentryClient _sentry;
  RemoteConfigService _remoteConfig = locator<RemoteConfigService>();
  ISettingService _setting = locator<ISettingService>();

  ReportService() {
    Crashlytics.instance.enableInDevMode = false;
    Crashlytics.instance.setString("url", _setting.shopUrl);

    try {
      _sentry = new SentryClient(
        dsn:
            "https://ddb34325d13a47f5b72515f34ef552d7:ee920b9a86d3482d8f7d822da130141c@sentry.io/1415075",
        environmentAttributes: new Event(
          release: app.App.appVersion,
          tags: {
            "notify": "update_app",
            "shopUrl": locator<ISettingService>().shopUrl,
          },
          userContext: new User(
            id: locator<ISettingService>().shopUrl,
            username: locator<ISettingService>().shopUsername,
          ),
        ),
      );
    } catch (e) {
      _sentry = new SentryClient(
        dsn:
            "https://ddb34325d13a47f5b72515f34ef552d7:ee920b9a86d3482d8f7d822da130141c@sentry.io/1415075",
        environmentAttributes: new Event(
          release: "error_release",
          tags: {"shopUrl": "error_release"},
        ),
      );
    }
  }

  /// send report error to server
  Future<void> sendUncaughtError(dynamic error, StackTrace stackTrade,
      {Event sentryEvent}) async {
    if (kDebugMode) {
      debugPrint(error.toString());
      debugPrint(stackTrade.toString());
    }
    if (_remoteConfig.crashReportServerName == "sentry") {
      if (kDebugMode) {
        return;
      }
      try {
        // In dev mode, send log to server
        final SentryResponse response = await _sentry.captureException(
          exception: error,
          stackTrace: stackTrade,
        );

        if (response.isSuccessful) {
          print('Success! Event ID: ${response.eventId}');
        } else {
          print('Failed to report to Sentry.io: ${response.error}');
        }
      } catch (e) {
        print("send failed");
      }
    } else if (_remoteConfig.crashReportServerName == "crashlytics") {
      try {
        Crashlytics.instance.recordError(error, stackTrade);
      } catch (e) {}
    }
  }

  @override
  Future<void> sendUpgradeReport(String version) async {
    try {
      // In dev mode, send log to server
      final SentryResponse response = await _sentry.capture(
          event: Event(
        release: app.App.appVersion,
        tags: {
          "shopUrl": locator<ISettingService>().shopUrl,
        },
      ));

      if (response.isSuccessful) {
        print('Success! Event ID: ${response.eventId}');
      } else {
        print('Failed to report to Sentry.io: ${response.error}');
      }
    } catch (e) {
      print("send failed");
    }
  }
}
