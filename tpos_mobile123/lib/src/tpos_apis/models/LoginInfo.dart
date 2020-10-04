/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:intl/intl.dart';

class LoginInfo {
  String accessToken = "";
  String refreshToken = "";
  DateTime expires;

  factory LoginInfo.fromJson(Map<String, dynamic> json) {
    return LoginInfo(
      accessToken: json["access_token"],
    );
  }

  LoginInfo.getFromJson(Map<String, dynamic> json) {
    this.accessToken = json["access_token"];
    this.refreshToken = json["refresh_token"];
    if (json[".expires"] != null) {
      this.expires =
          DateFormat("EE, dd MMM yyyy HH:mm:ss").parse(json[".expires"]);
    }

    print(this.expires);
  }

  LoginInfo({this.accessToken, this.refreshToken, this.expires});
}
