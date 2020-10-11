/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class CheckAddress {
  String telephone, address, shortAddress, cityName, districtName, wardName;
  String cityCode, districtCode, wardCode;
  int score;

  CheckAddress(
      {this.telephone,
      this.address,
      this.shortAddress,
      this.cityName,
      this.districtName,
      this.wardName,
      this.cityCode,
      this.districtCode,
      this.wardCode,
      this.score});

  factory CheckAddress.fromMap(Map<String, dynamic> jsonMap) {
    return new CheckAddress(
      telephone: jsonMap["Telephone"],
      address: jsonMap["Address"],
      shortAddress: jsonMap["ShortAddress"],
      cityName: jsonMap["CityName"],
      districtName: jsonMap["DistrictName"],
      wardName: jsonMap["WardName"],
      cityCode: jsonMap["CityCode"],
      districtCode: jsonMap["DistrictCode"],
      wardCode: jsonMap["WardCode"],
      score: jsonMap["Score"],
    );
  }
}
