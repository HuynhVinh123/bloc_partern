/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class ProductCategory {
  int id;
  String name;
  String completeName;
  int parentId;
  String parentCompleteName;
  int parentLeft;
  int parentRight;
  int sequence;
  String type;
  int accountIncomeCategId;
  int accountExpenseCategId;
  int stockJournalId;
  int stockAccountInputCategId;
  int stockAccountOutputCategId;
  int stockValuationAccountId;
  String propertyValuation;
  String propertyCostMethod;
  String nameNoSign;
  bool isPos;
  int version;

  ProductCategory parent;

  ProductCategory(
      {this.id,
      this.parent,
      this.name,
      this.completeName,
      this.parentId,
      this.parentCompleteName,
      this.parentLeft,
      this.parentRight,
      this.sequence,
      this.type,
      this.accountIncomeCategId,
      this.accountExpenseCategId,
      this.stockJournalId,
      this.stockAccountInputCategId,
      this.stockAccountOutputCategId,
      this.stockValuationAccountId,
      this.propertyValuation,
      this.propertyCostMethod,
      this.nameNoSign,
      this.isPos,
      this.version});

  ProductCategory.fromJson(Map<String, dynamic> jsonMap) {
    ProductCategory detail;
    var detailMap = jsonMap["Parent"];
    if (detailMap != null) {
      detail = ProductCategory.fromJson(detailMap);
    }

    parent = detail;
    id = jsonMap["Id"];
    name = jsonMap["Name"];
    completeName = jsonMap["CompleteName"];
    parentId = jsonMap["ParentId"];
    parentCompleteName = jsonMap["ParentCompleteName"];
    parentLeft = jsonMap["ParentLeft"];
    parentRight = jsonMap["ParentRight"];
    sequence = jsonMap["Sequence"];
    type = jsonMap["Type"];
    accountIncomeCategId = jsonMap["AccountIncomeCategId"];
    accountExpenseCategId = jsonMap["AccountExpenseCategId"];
    stockJournalId = jsonMap["StockJournalId"];
    stockAccountInputCategId = jsonMap["StockAccountInputCategId"];
    stockAccountOutputCategId = jsonMap["StockAccountOutputCategId"];
    stockValuationAccountId = jsonMap["StockValuationAccountId"];
    propertyValuation = jsonMap["PropertyValuation"];
    propertyCostMethod = jsonMap["PropertyCostMethod"];
    nameNoSign = jsonMap["NameNoSign"];
    isPos = jsonMap["IsPos"];
    version = jsonMap["Version"];
  }

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    var data = {
      "Parent": parent != null ? parent.toJson() : null,
      "Id": this.id,
      "Name": this.name,
      "CompleteName": this.completeName,
      "ParentId": this.parentId,
      "ParentCompleteName": this.parentCompleteName,
      "ParentLeft": this.parentLeft,
      "ParentRight": this.parentRight,
      "Sequence": this.sequence,
      "Type": this.type,
      "AccountIncomeCategId": this.accountIncomeCategId,
      "AccountExpenseCategId": this.accountExpenseCategId,
      "StockJournalId": this.stockJournalId,
      "StockAccountInputCategId": this.stockAccountInputCategId,
      "StockAccountOutputCategId": this.stockAccountOutputCategId,
      "StockValuationAccountId": this.stockValuationAccountId,
      "PropertyValuation": this.propertyValuation,
      "PropertyCostMethod": this.propertyCostMethod,
      "NameNoSign": this.nameNoSign,
      "IsPos": this.isPos,
      "Version": this.version,
    };

    if (removeIfNull == true) data.removeWhere((key, value) => value == null);

    return data;
  }
}
