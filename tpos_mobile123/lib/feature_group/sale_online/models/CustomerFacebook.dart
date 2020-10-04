/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class CustomerFacebook {
  CustomerFacebook(
      {this.id,
      this.phone,
      this.street,
      this.facebookASIds,
      this.facebookId,
      this.statusText,
      this.statusStyle,
      this.hasPhone,
      this.hasAddress,
      this.status});
  factory CustomerFacebook.fromMap(Map<String, dynamic> jsonMap) {
    return CustomerFacebook(
      //id: jsonMap["FacebookASIds"] ?? jsonMap["FacebookId"],
      phone: jsonMap["Phone"],
      street: jsonMap["Street"],
      facebookASIds: jsonMap["FacebookASIds"],
      facebookId: jsonMap["FacebookId"],
      statusText: jsonMap["StatusText"],
      hasPhone: jsonMap["HasPhone"],
      hasAddress: jsonMap["HasAddress"],
      status: jsonMap["Status"],
    );
  }
  String id, phone, street, facebookASIds, facebookId, statusText, statusStyle;
  bool hasPhone, hasAddress;
  String status;
}
