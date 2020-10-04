/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:tpos_mobile/src/tpos_apis/models/OrderDetail.dart';

class Order {
  String note;
  int partnerId;
  bool checked = false;
  double totalAmount;
  DateTime dateCreated;
  String id,
      code,
      facebookUserId,
      facebookUserName,
      address,
      name,
      email,
      partnerName,
      telephone,
      facebookPostId;

  List<OrderDetail> details;

  Order(
      {this.note,
      this.partnerId,
      this.checked,
      this.id,
      this.code,
      this.facebookUserId,
      this.facebookUserName,
      this.address,
      this.name,
      this.email,
      this.telephone,
      this.partnerName,
      this.dateCreated,
      this.totalAmount,
      this.facebookPostId,
      this.details});

  factory Order.fromMap(Map<String, dynamic> jsonMap) {
    List<OrderDetail> orderDetails;
    var detailMap = jsonMap["Details"] as List;
    orderDetails = detailMap.map((map) {
      return OrderDetail.fromMap(map);
    }).toList();

    return new Order(
      id: jsonMap["Id"],
      name: jsonMap["Name"],
      partnerId: jsonMap["PartnerId"],
      address: jsonMap["Address"],
      email: jsonMap["Email"],
      telephone: jsonMap["Telephone"],
      code: jsonMap["Code"],
      partnerName: jsonMap["PartnerName"],
      facebookUserName: jsonMap["Facebook_UserName"],
      dateCreated: DateTime.parse(jsonMap["DateCreated"]),
      facebookPostId: jsonMap["Facebook_PostId"],
      totalAmount: jsonMap["TotalAmount"],
      details: orderDetails,
      note: jsonMap["Note"],
    );
  }
}

//class Order {
//  final String id;
//  final List<OrderDetail> orderDetails;
//
//  Order({this.id, this.orderDetails});
//
//  factory Order.fromMap(Map<String, dynamic> parsedJson) {
//    var list = parsedJson['Details'] as List;
//    print(list.runtimeType);
//    List<OrderDetail> orderDetails =
//        list.map((i) => OrderDetail.fromMap(i)).toList();
//
//    return Order(id: parsedJson['id'], orderDetails: orderDetails);
//  }
//}
//
//class OrderDetail {
//  final String id;
//
//  OrderDetail({this.id});
//
//  factory OrderDetail.fromMap(Map<String, dynamic> parsedJson) {
//    return OrderDetail(
//      id: parsedJson['id'],
//    );
//  }
//}
