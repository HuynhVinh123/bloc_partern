class ProductAttributeLine {
  int id;
  int productTmplId;
  int attributeId;
  ProductAttribute productAttribute;
  List<ProductAttribute> attributeValues;

  ProductAttributeLine({
    this.id,
    this.productTmplId,
    this.attributeId,
    this.productAttribute,
    this.attributeValues,
  });

  ProductAttributeLine.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    productTmplId = jsonMap["ProductTmplId"];
    attributeId = jsonMap["AttributeId"];
    productAttribute = jsonMap["Attribute"] != null
        ? ProductAttribute.fromJson(jsonMap["Attribute"])
        : null;

    List<ProductAttribute> values;
    var valuesMap = jsonMap["Values"] as List;
    values = valuesMap.map((map) {
      return ProductAttribute.fromJson(map);
    }).toList();
    attributeValues = values;
  }

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    var data = {
      "Id": id,
      "ProductTmplId": productTmplId,
      "AttributeId": attributeId,
      "Attribute": productAttribute != null ? productAttribute.toJson() : null,
      "Values": attributeValues != null
          ? attributeValues.map((f) => f.toJson()).toList()
          : null,
    };

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}

class ProductAttribute {
  int id;
  String name;
  String code;
  int sequence;
  bool createVariant;
  String attributeName;
  double priceExtra;
  String nameGet;

  ProductAttribute(
      {this.id,
      this.name,
      this.code,
      this.sequence,
      this.createVariant,
      this.attributeName,
      this.priceExtra,
      this.nameGet});

  ProductAttribute.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    name = jsonMap["Name"];
    code = jsonMap["Code"];
    sequence = jsonMap["Sequence"];
    createVariant = jsonMap["CreateVariant"];
    attributeName = jsonMap["AttributeName"];
    priceExtra = jsonMap["PriceExtra"];
    nameGet = jsonMap["NameGet"];
  }

  Map<String, dynamic> toJson() {
    var map = {
      "Id": id,
      "Name": name,
      "Code": code,
      "Sequence": sequence,
      "CreateVariant": createVariant,
      "AttributeName": attributeName,
      "PriceExtra": priceExtra,
      "NameGet": nameGet,
    };
    map.removeWhere((key, value) => value == null || value == "");

    return map;
  }
}
