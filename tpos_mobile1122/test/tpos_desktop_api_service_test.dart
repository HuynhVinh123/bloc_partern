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
import 'package:tpos_mobile/services/tpos_desktop_api_service.dart';

void main() {
  testPrintSaleOnlineMain();

  test("test DateTime", () {
    print((new DateTime.now()).toString());
    print((new DateTime.now()).toIso8601String());
    var dateNow = DateTime.now();
    String format =
        DateFormat("yyyy-mm-ddThh:mm:ss+07:00", "en_US").format(dateNow);
    print(format);
  });

  test("testTime", () {
    String unixTimeStr = RegExp("\\d+").stringMatch(r"/Date(1552638156237)/");
    print(unixTimeStr);
    int unixTime = int.parse(unixTimeStr);
    DateTime invoiceDate = DateTime.fromMillisecondsSinceEpoch(unixTime);
    print(invoiceDate.toIso8601String());
  });
}

TPosDesktopService sv =
    new TPosDesktopService(computerIp: "192.168.1.31", computerPort: "8123");

void testPrintSaleOnlineMain() {
  test("test printSaleOnline", () async {
    var data = new PrintSaleOnlineData(
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
