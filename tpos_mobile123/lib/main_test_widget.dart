/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:58 AM
 *
 */

import 'package:flutter/material.dart';

import 'application/intro_slide/app_intro_page.dart';
import 'feature_group/reports/report_delivey/uis/report_delivery_order_page.dart';
import 'feature_group/reports/report_order/ui/report_order_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      home: ReportDeliveryOrderPage(),
    ),
  );
}
