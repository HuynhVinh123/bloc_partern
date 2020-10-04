/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:58 AM
 *
 */

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:tpos_mobile/new_app.dart';
import 'package:tpos_mobile/widgets/app_wrapper.dart';
import 'app.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    Bloc.observer = MyBlocObserver();
  }

  // Loging seting
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen(
    (record) {
      //test
      // debugPrint(
      //'${record.level.name}: ${record.time}| ${record.loggerName} | message:  ${record.message} ${record.error != null ? "|error: " + record.error.toString() : ""} ${record.stackTrace != null ? "\n|||||stackTrace>>>>>>>>>: " + record.stackTrace.toString() : ""}');

      if (kDebugMode) {
        debugPrint(
            '${record.level.name}: ${record.time}| ${record.loggerName} | message:  ${record.message} ${record.error != null ? "|error: " + record.error.toString() : ""} ${record.stackTrace != null ? "\n|||||stackTrace>>>>>>>>>: " + record.stackTrace.toString() : ""}');
      } else {
        if (record.level == Level.SEVERE) {
          //sendReport(record.error, record.stackTrace);
        }
      }
    },
  );

  // Capture error on flutter
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (kDebugMode) {
      // In development mode simplyflu print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone to report to
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  runZonedGuarded(() {
    runApp(AppWrapper(child: NewApp()));
  }, onError);
}

void onError(Object error, StackTrace stack) {
  print(error);
  print(stack);
}

class MyBlocObserver extends BlocObserver {
  @override
  void onChange(Cubit cubit, Change change) {
    print(change);
    super.onChange(cubit, change);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(cubit, error, stackTrace);
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    print('event: $bloc => $event');
    super.onEvent(bloc, event);
  }
}
