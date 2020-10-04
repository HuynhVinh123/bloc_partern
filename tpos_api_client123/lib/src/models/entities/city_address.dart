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
      code: jsonMap["code"] != null ? jsonMap["code"] : null,
      name: jsonMap["name"] != null ? jsonMap["name"] : null,
    );
  }

  String code;
  String name;

  Map toJson({bool removeIfNull = false}) {
    Map data = {"code": this.code, "name": this.name};
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }
}
