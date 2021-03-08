/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class TposUser {
  TposUser({this.id, this.fullName, this.userName, this.avatar});

  TposUser.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    fullName = jsonMap["FullName"];
    userName = jsonMap["UserName"];
    avatar = jsonMap["Avatar"];
    company = jsonMap["Company"];
    if (jsonMap["Company"] != null) {
      companyName = jsonMap["Company"]["Name"];
    }
  }
  String id;
  String fullName;
  String userName;
  String avatar;
  Map company;
  String companyName;
}
