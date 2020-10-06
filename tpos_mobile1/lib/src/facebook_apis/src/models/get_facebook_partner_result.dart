/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class GetFacebookPartnerResult {
  String code;
  String facebookId;
  String facebookAsid;
  bool hasAddress;
  bool hasPhone;
  int id;
  String phone;
  String status;
  String statusStyle;
  String statusText;
  String street;

  GetFacebookPartnerResult(
      {this.code,
      this.facebookId,
      this.facebookAsid,
      this.hasAddress,
      this.hasPhone,
      this.id,
      this.phone,
      this.status,
      this.statusStyle,
      this.statusText,
      this.street});

  GetFacebookPartnerResult.fromJson(Map<String, dynamic> jsonMap) {
    code = jsonMap["Code"];
    facebookAsid = jsonMap["FacebookASIds"];
    facebookId = jsonMap["FacebookId"];
    hasAddress = jsonMap["HasAddress"];
    hasPhone = jsonMap["HasPhone"];
    id = jsonMap["Id"];
    phone = jsonMap["Phone"];
    status = jsonMap["Status"];
    statusStyle = jsonMap["StatusStyle"];
    statusText = jsonMap["StatusText"];
    street = jsonMap["Street"];
  }
}
