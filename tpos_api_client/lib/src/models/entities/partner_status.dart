/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class PartnerStatus {
  PartnerStatus({this.text, this.value});
  PartnerStatus.fromJson(Map<String, dynamic> jsonMap) {
    text = jsonMap["text"];
    value = jsonMap["value"];
  }
  String text;
  String value;
}
