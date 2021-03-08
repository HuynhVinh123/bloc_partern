/*
  * *
  *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
  *  * Copyright (c) 2019 . All rights reserved.
  *  * Last modified 4/9/19 9:58 AM
  *
  */

import 'package:flutter/material.dart';

import 'feature_group/fast_sale_order/ui/setting_product_default_page.dart';

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
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    title: const Text("Cài đặt sản phẩm mặc định"),
                    content: const SettingProductDefaultPage(),
                    actions: const <Widget>[],
                  ),
                );

                // final result = await Navigator.push(context,
                //     MaterialPageRoute(builder: (context) {
                //   return BarcodeScan();
                // }));
                // setState(() {
                //   if (result != null) {
                //     barcode = result;
                //   }
                // });
              })
        ],
      ),
      body: Center(child: Text(barcode)),
    );
  }
}
