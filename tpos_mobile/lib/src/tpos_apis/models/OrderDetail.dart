/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class OrderDetail {
  OrderDetail({
    this.id,
    this.productName,
    this.productCode,
    this.uOMName,
    this.quantity,
    this.price,
    this.productId,
    this.uOMId,
  });

  factory OrderDetail.fromMap(Map<String, dynamic> jsonMap) {
    return OrderDetail(
      id: jsonMap["Id"],
      productName: jsonMap["ProductName"],
      quantity: jsonMap["Quantity"],
      productCode: jsonMap["ProductCode"],
      uOMName: jsonMap["UOMName"],
      price: jsonMap["Price"],
      uOMId: jsonMap["UOMId"],
      productId: jsonMap["ProductId"],
    );
  }
  String id;
  String productName, productCode, uOMName;
  int uOMId, productId;
  double quantity, price;

  Map<String, dynamic> toMap() {
    return {
      "Id": id,
      "ProductName": productName,
      "Quantity": quantity,
      "ProductCode": productCode,
      "UOMName": uOMName,
      "Price": price,
      "UOMId": uOMId,
      "ProductId": productId,
    };
  }
}
