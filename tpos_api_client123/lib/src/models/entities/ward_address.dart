/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class WardAddress {
  WardAddress(
      {this.cityCode,
      this.cityName,
      this.code,
      this.name,
      this.districtCode,
      this.districtName});
  String cityCode, cityName, code, name, districtCode, districtName;

  factory WardAddress.fromMap(Map<String, dynamic> jsonMap) {
    return WardAddress(
      code: jsonMap["code"],
      name: jsonMap["name"],
      cityCode: jsonMap["cityCode"],
      cityName: jsonMap["cityName"],
      districtCode: jsonMap["districtCode"],
      districtName: jsonMap["districtName"],
    );
  }

  Map toJson({bool removeIfNull = false}) {
    Map data = {
      "cityCode": cityCode,
      "cityName": cityName,
      "code": code,
      "name": name,
      "districtCode": districtCode,
      "districtName": districtName,
    };

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }
}
