/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class ProductCategory {
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
    final Map<String, dynamic> detailMap = jsonMap["Parent"];
    if (detailMap != null) {
      detail = ProductCategory.fromJson(detailMap);
    }
    children = [];
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
    isDelete = jsonMap["IsDelete"];
  }

  ProductCategory.clone(ProductCategory productCategory) {
    parent = productCategory.parent != null ? ProductCategory.clone(productCategory) : null;
    children = [];
    if (productCategory.children != null) {
      for (final ProductCategory child in productCategory.children) {
        final ProductCategory cloneChild = ProductCategory.clone(child);
        children.add(cloneChild);
      }
    }
    id = productCategory.id;
    name = productCategory.name;
    completeName = productCategory.completeName;
    parentId = productCategory.id;
    parentCompleteName = productCategory.parentCompleteName;
    parentLeft = productCategory.parentLeft;
    parentRight = productCategory.parentRight;
    sequence = productCategory.sequence;
    type = productCategory.type;
    accountIncomeCategId = productCategory.accountIncomeCategId;
    accountExpenseCategId = productCategory.accountExpenseCategId;
    stockJournalId = productCategory.stockJournalId;
    stockAccountInputCategId = productCategory.stockAccountInputCategId;
    stockAccountOutputCategId = productCategory.stockAccountOutputCategId;
    stockValuationAccountId = productCategory.stockValuationAccountId;
    propertyValuation = productCategory.propertyValuation;
    propertyCostMethod = productCategory.propertyCostMethod;
    nameNoSign = productCategory.nameNoSign;
    isPos = productCategory.isPos;
    version = productCategory.version;
    isDelete = productCategory.isDelete;
  }

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = {
      "Parent": parent != null ? parent.toJson() : null,
      "Id": id,
      "Name": name,
      "CompleteName": completeName,
      "ParentId": parentId,
      "ParentCompleteName": parentCompleteName,
      "ParentLeft": parentLeft,
      "ParentRight": parentRight,
      "Sequence": sequence,
      "Type": type,
      "AccountIncomeCategId": accountIncomeCategId,
      "AccountExpenseCategId": accountExpenseCategId,
      "StockJournalId": stockJournalId,
      "StockAccountInputCategId": stockAccountInputCategId,
      "StockAccountOutputCategId": stockAccountOutputCategId,
      "StockValuationAccountId": stockValuationAccountId,
      "PropertyValuation": propertyValuation,
      "PropertyCostMethod": propertyCostMethod,
      "NameNoSign": nameNoSign,
      "IsPos": isPos,
      "Version": version,
    };

    if (removeIfNull == true) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }

  ProductCategory parent;
  List<ProductCategory> children;
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
  bool isDelete;
  int version;
}
