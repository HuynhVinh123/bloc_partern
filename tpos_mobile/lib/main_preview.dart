/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:58 AM
 *
 */

import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tpos_mobile/tpos_app.dart';
import 'package:tpos_mobile/widgets/app_wrapper.dart';

import 'main.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    Bloc.observer = MyBlocObserver();
  }

  setupLogger();

  runZonedGuarded(() async {
    await Hive.initFlutter();
    await Firebase.initializeApp();
    runApp(
      DevicePreview(
        enabled: true,
        builder: (context) => const AppWrapper(
          child: TPosAppPreview(),
        ),
      ),
    );
  }, onError);
}

void onError(Object error, StackTrace stack) {
  print(error);
  print(stack);
}
