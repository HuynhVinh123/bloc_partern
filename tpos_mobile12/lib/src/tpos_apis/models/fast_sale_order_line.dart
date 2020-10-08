/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/16/19 5:56 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/16/19 1:08 PM
 *
 */

import 'package:tpos_mobile/src/tpos_apis/models/product.dart';
import 'package:tpos_mobile/src/tpos_apis/models/productUOM.dart';

import 'package:tpos_mobile/src/tpos_apis/models/account.dart';

class FastSaleOrderLine {
  int id;
  int productId;
  int productUOMId;
  int accountId;
  double productUOMQty;
  double priceUnit;
  double discount;
  double discountFixed;
  double weight;

  String productName;
  String productUomName;
  String productNameGet;
  String productBarcode;

  double priceSubTotal;
  double priceTotal;

  String type;
  Product product;
  ProductUOM productUOM;
  String note;

  Account account;

  /// Get name template from product
  String get nameTemplate => product?.nameTemplate;

  void calculateTotal() {
    double discountPercent = this.discount ?? 0;
    double discountFix = this.discountFixed ?? 0;
    double priceUnit = this.priceUnit ?? 0;
    double qty = this.productUOMQty ?? 0;

    this.priceSubTotal = priceUnit * qty;
    if (type == "percent") {
      this.priceTotal = (qty * (priceUnit * (100 - discountPercent) / 100));
    } else {
      this.priceTotal = (qty * (priceUnit - discountFix));
    }
  }

  FastSaleOrderLine({
    this.id,
    this.productId,
    this.productUOMId,
    this.productUOMQty,
    this.priceUnit,
    this.discount,
    this.discountFixed,
    this.weight,
    this.productName,
    this.productUomName,
    this.productNameGet,
    this.productBarcode,
    this.priceSubTotal,
    this.priceTotal,
    this.type,
    this.product,
    this.productUOM,
    this.note,
    this.accountId,
    this.account,
  });

  FastSaleOrderLine.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    productId = jsonMap["ProductId"];
    productUOMId = jsonMap["ProductUOMId"];
    accountId = jsonMap["AccountId"];
    productUOMQty = jsonMap["ProductUOMQty"]?.toDouble();
    priceUnit = jsonMap["PriceUnit"]?.toDouble();
    discount = jsonMap["Discount"]?.toDouble();
    discountFixed = jsonMap["Discount_Fixed"]?.toDouble();
    weight = jsonMap["Weight"]?.toDouble();

    productName = jsonMap["ProductName"];
    productUomName = jsonMap["ProductUOMName"];
    productNameGet = jsonMap["ProductNameGet"];
    productBarcode = jsonMap["ProductBarcode"];

    priceTotal = jsonMap["PriceTotal"];
    priceSubTotal = jsonMap["PriceSubTotal"];
    note = jsonMap["Note"];
    type = jsonMap["Type"];
    if (jsonMap["Account"] != null) {
      account = Account.fromJson(jsonMap["Account"]);
    }

    if (jsonMap["Product"] != null) {
      product = Product.fromJson(jsonMap["Product"]);
    }
  }

  Map<String, dynamic> toJson({bool removeIfNull = false}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data["Id"] = id;
    data["ProductId"] = productId;
    data["ProductUOMId"] = productUOMId;
    data["ProductUOMQty"] = productUOMQty;
    data["PriceUnit"] = priceUnit;
    data["Discount"] = discount;
    data["Discount_Fixed"] = discountFixed;
    data["Weight"] = weight;
    data["ProductName"] = productName;
    data["ProductNameGet"] = productNameGet;
    data["ProductBarcode"] = productBarcode;
    data["PriceSubTotal"] = priceSubTotal;
    data["PriceTotal"] = priceTotal;
    data["Type"] = type;
    data["ProductUOMName"] = productUomName;
    data["Note"] = note;
    data["AccountId"] = accountId;
    data["Account"] = account?.toJson(removeIfNull);

    data["ProductUOM"] = this.productUOM?.toJson();

    data["Product"] = this.product.toJson(removeIfNull: removeIfNull);
    if (removeIfNull == true) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }
}
