/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class CityAddress {
  CityAddress({this.code, this.name});
  factory CityAddress.fromMap(Map<String, dynamic> jsonMap) {
    return CityAddress(
      code: jsonMap["code"],
      name: jsonMap["name"],
    );
  }

  String code;
  String name;

  Map<String, dynamic> toJson({bool removeIfNull = false}) {
    final Map<String, dynamic> data = {"code": code, "name": name};
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }
}
