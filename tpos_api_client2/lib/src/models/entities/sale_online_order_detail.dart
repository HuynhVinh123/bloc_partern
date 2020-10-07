/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class SaleOnlineOrderDetail {
  String id;
  int productId;
  String productName;
  int uomId;
  String uomName;
  double quantity;
  double price;

  SaleOnlineOrderDetail(
      {this.productId,
      this.productName,
      this.uomId,
      this.uomName,
      this.quantity,
      this.id,
      this.price});

  SaleOnlineOrderDetail.fromJson(Map<String, dynamic> jsonMap) {
    productId = jsonMap["ProductId"];
    productName = jsonMap["ProductName"];
    uomId = jsonMap["UOMId"];
    uomName = jsonMap["UOMName"];
    quantity = jsonMap["Quantity"];
    price = jsonMap["Price"];
    id = jsonMap["Id"];
  }

  Map toJson([bool removeIfNull = false]) {
    var data = {
      "ProductId": productId,
      "ProductName": productName,
      "UOMId": uomId,
      "UOMName": uomName,
      "Quantity": quantity,
      "Price": price,
      "Id": id,
    };

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }
}
