/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:tpos_api_client/src/model.dart';

class ProductUOM {

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

  ProductUOM.cloneWith(ProductUOM other){
    id = other.id;
    name = other.name;
    nameNoSign = other.nameNoSign;
    rounding = other.rounding;
    active = other.active;
    factor = other.factor;
    factorInv = other.factorInv;
    uOMType = other.uOMType;
    categoryId = other.categoryId;
    categoryName = other.categoryName;
    description = other.description;
    showUOMType = other.showUOMType;
    showUOMType = other.showUOMType;
    nameGet = other.nameGet;
    showFactor = other.showFactor;
    productUomCategory = other.productUomCategory;
  }

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
    productUomCategory = jsonMap["Category"] != null ? ProductUomCategory.fromJson(jsonMap["Category"]): null;
  }

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
  ProductUomCategory productUomCategory;


  Map<String, dynamic> toJson([removeIfNull = false]) {
    final Map<String, dynamic> data = {
      "Id": id,
      "Name": name,
      "NameNoSign": nameNoSign,
      "Rounding": rounding,
      "Active": active,
      "Factor": factor,
      "FactorInv": factorInv?.toInt(),
      "UOMType": uOMType,
      "CategoryId": categoryId,
      "CategoryName": categoryName,
      "Description": description,
      "ShowUOMType": showUOMType,
      "NameGet": nameGet,
      "ShowFactor": showFactor,
    };

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }


}
