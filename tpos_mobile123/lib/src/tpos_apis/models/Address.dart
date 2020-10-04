/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class Address {
  String cityCode, cityName, code, name, districtCode, districtName;

  Address(
      {this.code,
      this.name,
      this.cityCode,
      this.cityName,
      this.districtCode,
      this.districtName});

  factory Address.fromMap(Map<String, dynamic> jsonMap) {
    return new Address(
      code: jsonMap["code"],
      name: jsonMap["name"],
      cityCode: jsonMap["cityCode"],
      cityName: jsonMap["cityName"],
      districtCode: jsonMap["districtCode"],
      districtName: jsonMap["districtName"],
    );
  }
}
