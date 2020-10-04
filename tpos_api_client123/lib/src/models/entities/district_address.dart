/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class DistrictAddress {
  DistrictAddress({this.cityCode, this.cityName, this.code, this.name});

  factory DistrictAddress.fromMap(Map<String, dynamic> jsonMap) {
    return DistrictAddress(
      code: jsonMap["code"],
      name: jsonMap["name"],
      cityCode: jsonMap["cityCode"],
      cityName: jsonMap["cityName"],
    );
  }
  String cityCode, cityName, code, name;
  Map toJson({bool removeIfNull = false}) {
    Map data = {
      "code": code,
      "name": name,
      "cityCode": cityCode,
      "cityName": cityName,
    };

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }
}
