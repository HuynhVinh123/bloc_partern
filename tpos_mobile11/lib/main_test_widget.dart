/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:58 AM
 *
 */

import 'package:flutter/material.dart';
import 'package:tpos_mobile/feature_group/account_payment/uis/account_payment_info_page.dart';
import 'package:tpos_mobile/helpers/test_page.dart';

import 'application/intro_slide/app_intro_page.dart';
import 'feature_group/reports/report_delivey/uis/report_delivery_order_page.dart';
import 'feature_group/reports/report_order/ui/report_order_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      home:testpage(),
    ),
  );
}

class testpage extends StatefulWidget {
  @override
  _testpageState createState() => _testpageState();
}

class _testpageState extends State<testpage> {
  String balue = "123";
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),body:  RaisedButton(child: Text("$balue"),onPressed: (){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CameraApp()),
      ).then((value) {
        if(value != null){
          setState(() {
            balue  = value;
          });
        }
      });
    },),);
  }
}
