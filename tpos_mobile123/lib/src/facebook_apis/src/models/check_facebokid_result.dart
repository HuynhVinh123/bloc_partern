/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';
import 'package:tpos_mobile/src/tpos_apis/models/Order.dart';

class CheckFacebookIdResult {
  bool success;
  String uid;
  List<Order> orders;
  List<Partner> customers;

  CheckFacebookIdResult.fromJson(Map<String, dynamic> jsonMap) {
    success = jsonMap["success"];
    uid = jsonMap["uid"];
    orders = (jsonMap["orders"] as List).map((f) => Order.fromMap(f)).toList();
    customers =
        (jsonMap["customers"] as List).map((f) => Partner.fromJson(f)).toList();
  }
}
