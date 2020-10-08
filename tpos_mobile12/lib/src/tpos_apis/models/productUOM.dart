/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class ProductUOM {
  int id;
  String name;
  String nameNoSign;
  double rounding;
  bool active;
  double factor;
  double factorInv;
  String uOMType;
  int categoryId;
  String categoryName;
  String description;
  String showUOMType;
  String nameGet;
  double showFactor;

  ProductUOM(
      {this.id,
      this.name,
      this.nameNoSign,
      this.rounding,
      this.active,
      this.factor,
      this.factorInv,
      this.uOMType,
      this.categoryId,
      this.categoryName,
      this.description,
      this.showUOMType,
      this.nameGet,
      this.showFactor});

  ProductUOM.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    name = jsonMap["Name"];
    nameNoSign = jsonMap["NameNoSign"];
    rounding = jsonMap["Rounding"];
    active = jsonMap["Active"];
    factor = (jsonMap["Factor"] ?? 0).toDouble();
    factorInv = (jsonMap["FactorInv"] ?? 0).toDouble();
    uOMType = jsonMap["UOMType"];
    categoryId = jsonMap["CategoryId"];
    categoryName = jsonMap["CategoryName"];
    description = jsonMap["Description"];
    showUOMType = jsonMap["ShowUOMType"];
    nameGet = jsonMap["NameGet"];
    showFactor = (jsonMap["ShowFactor"] ?? 0).toDouble();
  }
  Map<String, dynamic> toJson([removeIfNull = false]) {
    var data = {
      "Id": this.id,
      "Name": this.name,
      "NameNoSign": this.nameNoSign,
      "Rounding": this.rounding,
      "Active": this.active,
      "Factor": this.factor,
      "FactorInv": this.factorInv,
      "UOMType": this.uOMType,
      "CategoryId": this.categoryId,
      "CategoryName": this.categoryName,
      "Description": this.description,
      "ShowUOMType": this.showUOMType,
      "NameGet": this.nameGet,
      "ShowFactor": this.showFactor,
    };

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }
}
