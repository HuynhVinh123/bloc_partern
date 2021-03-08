/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:53 AM
 *
 */

import 'package:intl/intl.dart';
import "package:test/test.dart";
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_desktop/print_sale_online_data.dart';

void main() {
  testPrintSaleOnlineMain();

  test("test DateTime", () {
    print(DateTime.now().toString());
    print(DateTime.now().toIso8601String());
    final dateNow = DateTime.now();
    final String format =
        DateFormat("yyyy-mm-ddThh:mm:ss+07:00", "en_US").format(dateNow);
    print(format);
  });

  test("testTime", () {
    final String unixTimeStr =
        RegExp("\\d+").stringMatch(r"/Date(1552638156237)/");
    print(unixTimeStr);
    final int unixTime = int.parse(unixTimeStr);
    final DateTime invoiceDate = DateTime.fromMillisecondsSinceEpoch(unixTime);
    print(invoiceDate.toIso8601String());
  });
}

void testPrintSaleOnlineMain() {
  test("test printSaleOnline", () async {
    final data = PrintSaleOnlineData(
        uid: "10000023049934",
        name: "Nguyễn văn nam",
        code: "KH000001",
        header: "Công ty Trường Minh Thịnh",
        index: 100001,
        time: DateTime.now().toString(),
        partnerCode: "KH000001",
        note: "",
        phone: "0908075555",
        product: "Keo dán ABC");

    data.toString();
  });
}
