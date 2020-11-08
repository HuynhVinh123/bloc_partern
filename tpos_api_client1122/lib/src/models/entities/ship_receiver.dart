/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:tpos_api_client/tpos_api_client.dart';

class ShipReceiver {
  ShipReceiver(
      {this.name,
      this.phone,
      this.street,
      this.city,
      this.district,
      this.ward});
  ShipReceiver.fromJson(Map jsonMap) {
    name = jsonMap["Name"];
    phone = jsonMap["Phone"];
    street = jsonMap["Street"];
    if (jsonMap["City"] != null) {
      city = CityAddress.fromMap(jsonMap["City"]);
    }
    if (jsonMap["District"] != null) {
      district = DistrictAddress.fromMap(jsonMap["District"]);
    }
    if (jsonMap["Ward"] != null) {
      ward = WardAddress.fromMap(jsonMap["Ward"]);
    }
  }
  String name;
  String phone;
  String street;
  CityAddress city;
  DistrictAddress district;
  WardAddress ward;

  Map toJson({bool removeIfNull = false}) {
    final Map data = {
      "Name": name,
      "Phone": phone,
      "Street": street,
      "City": city?.toJson(removeIfNull: removeIfNull),
      "District": district?.toJson(removeIfNull: removeIfNull),
      "Ward": ward?.toJson(removeIfNull: removeIfNull),
    };

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
