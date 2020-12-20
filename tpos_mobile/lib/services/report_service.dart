import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sentry/sentry.dart';
import 'package:tpos_mobile/app.dart' as app;
import 'package:tpos_mobile/services/remote_config_service.dart';

import 'app_setting_service.dart';
import 'config_service/config_service.dart';

abstract class IReportService {
  Future<void> sendUncaughtError(dynamic error, StackTrace stackTrade);

  Future<void> sendUpgradeReport(String version);
}

class ReportService implements IReportService {
  ReportService() {
    // FirebaseCrashAnalytic.instance.enableInDevMode = false;
    // FirebaseCrashAnalytic.instance.setString("url", _setting.shopUrl);

    try {
      _sentry = SentryClient(
        dsn:
            "https://ddb34325d13a47f5b72515f34ef552d7:ee920b9a86d3482d8f7d822da130141c@sentry.io/1415075",
        environmentAttributes: Event(
          release: app.App.appVersion,
          tags: {
            "notify": "update_app",
            "shopUrl": GetIt.instance<ConfigService>().shopUrl,
          },
          userContext: User(
            id: GetIt.instance<ConfigService>().shopUrl,
            username: GetIt.instance<ConfigService>().shopUsername,
          ),
        ),
      );
    } catch (e) {
      _sentry = SentryClient(
        dsn:
            "https://ddb34325d13a47f5b72515f34ef552d7:ee920b9a86d3482d8f7d822da130141c@sentry.io/1415075",
        environmentAttributes: const Event(
          release: "error_release",
          tags: {"shopUrl": "error_release"},
        ),
      );
    }
  }

  SentryClient _sentry;
  final RemoteConfigService _remoteConfig = GetIt.I<RemoteConfigService>();
  final ConfigService _setting = GetIt.instance<ConfigService>();

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
          "shopUrl": GetIt.instance<ConfigService>().shopUrl,
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
