import 'package:tpos_api_client/tpos_api_client.dart';

class ProductAttributeValue {
  ProductAttributeValue(
      {this.id,
      this.name,
      this.code,
      this.sequence,
      this.createVariant,
      this.attributeName,
      this.priceExtra,
      this.nameGet});

  ProductAttributeValue.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    name = jsonMap["Name"];
    code = jsonMap["Code"];
    sequence = jsonMap["Sequence"];
    createVariant = jsonMap["CreateVariant"];
    attributeName = jsonMap["AttributeName"];
    priceExtra = jsonMap["PriceExtra"] != null ? jsonMap["PriceExtra"].toDouble() : null;
    nameGet = jsonMap["NameGet"];
    attributeId = jsonMap["AttributeId"];
    productAttribute = jsonMap["Attribute"] != null ? ProductAttribute.fromJson(jsonMap["Attribute"]) : null;
  }

  int id;
  String name;
  String code;
  int sequence;
  bool createVariant;
  String attributeName;
  int attributeId;
  double priceExtra;
  String nameGet;
  ProductAttribute productAttribute;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> map = {
      "Id": id,
      "Name": name,
      "Code": code,
      "Sequence": sequence,
      "CreateVariant": createVariant,
      "AttributeName": attributeName,
      "PriceExtra": priceExtra,
      "NameGet": nameGet,
      "AttributeId": attributeId,
      'Attribute': productAttribute?.toJson(removeIfNull)
    };

    if (removeIfNull) {
      map.removeWhere((key, value) => value == null || value == "");
    }

    return map;
  }

  void clone(ProductAttributeValue other) {
    name = other.name;
    id = other.id;
    code = other.code;
    sequence = other.sequence;
    createVariant = other.createVariant;
    attributeName = other.attributeName;
    priceExtra = other.priceExtra;
    nameGet = other.nameGet;
    attributeId = other.attributeId;
  }
}
