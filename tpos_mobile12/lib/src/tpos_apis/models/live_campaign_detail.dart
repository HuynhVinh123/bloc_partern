/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class LiveCampaignDetail {
  String id;
  int index;
  double price;
  int productId;
  String productName;
  double quantity;
  int uomId;
  String uomName;
  String note;
  double usedQuantity;

  LiveCampaignDetail({
    this.id,
    this.index,
    this.price,
    this.productId,
    this.productName,
    this.quantity,
    this.uomId,
    this.uomName,
    this.note,
    this.usedQuantity,
  });

  LiveCampaignDetail.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    index = jsonMap["Index"];
    price = jsonMap["Price"];
    productId = jsonMap["ProductId"];
    productName = jsonMap["ProductName"];
    quantity = jsonMap["Quantity"];
    uomId = jsonMap["UOMId"];
    uomName = jsonMap["UOMName"];
    note = jsonMap["Note"];
    usedQuantity = jsonMap["UsedQuantity"];
  }

  Map<String, dynamic> toJson({bool removeIfNull = true}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
//      "Id": id,
    data["Index"] = index;
      data["Price"]= price;
      data["ProductId"]= productId;
      data["ProductName"]= productName;
      data["Quantity"]= quantity;
      data["UOMId"]= uomId;
      data["UOMName"]= uomName;
      data["Note"]= note;
      data["UsedQuantity"]= usedQuantity;
    if (removeIfNull == true) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
