/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class OrderDetail {
  String id;

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

  String productName, productCode, uOMName;
  int uOMId, productId;
  double quantity, price;

  factory OrderDetail.fromMap(Map<String, dynamic> jsonMap) {
    return new OrderDetail(
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

  Map<String, dynamic> toMap() {
    return {
      "Id": this.id,
      "ProductName": this.productName,
      "Quantity": this.quantity,
      "ProductCode": this.productCode,
      "UOMName": this.uOMName,
      "Price": this.price,
      "UOMId": this.uOMId,
      "ProductId": this.productId,
    };
  }
}
