/*
  * *
  *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
  *  * Copyright (c) 2019 . All rights reserved.
  *  * Last modified 4/9/19 9:58 AM
  *
  */

import 'package:flutter/material.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/report_product_page.dart';
import 'package:tpos_mobile/helpers/barcode.dart';
import 'package:tpos_mobile/helpers/barcode_scan.dart';
import 'application/intro_slide/app_intro_page.dart';
import 'feature_group/category/tag_list_page.dart';
import 'feature_group/reports/report_delivey/uis/report_delivery_order_page.dart';
import 'feature_group/reports/report_order/ui/report_order_page.dart';
import 'feature_group/tag/uis/tag_category_list_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      home: TestBarcode(),
    ),
  );
}

class TestBarcode extends StatefulWidget {
  @override
  _TestBarcodeState createState() => _TestBarcodeState();
}

class _TestBarcodeState extends State<TestBarcode> {
  String barcode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const Icon(Icons.qr_code),
              onPressed: () async {
                final result = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return BarcodeScan();
                }));
                setState(() {
                  if (result != null) {
                    barcode = result;
                  }
                });
              })
        ],
      ),
      body: Center(child: Text(barcode)),
    );
  }
}
