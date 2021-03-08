import 'package:tpos_api_client/src/models/entities/product/product_attribute_value.dart';

class ProductAttribute {

  ProductAttribute(
      {this.id,
      this.productTmplId,
      this.attributeId,
      this.productAttribute,
      this.attributeValues,
      this.name,
      this.createVariant,
      this.code,
      this.sequence});


  ProductAttribute.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    productTmplId = jsonMap["ProductTmplId"];
    attributeId = jsonMap["AttributeId"];
    name = jsonMap["Name"];
    code = jsonMap["Code"];
    sequence = jsonMap["Sequence"];
    createVariant = jsonMap["CreateVariant"];
    nameGet = jsonMap["NameGet"];
    productAttribute = jsonMap["Attribute"] != null ? ProductAttributeValue.fromJson(jsonMap["Attribute"]) : null;

    List<ProductAttributeValue> values = [];

    if (jsonMap["Values"] != null) {
      values = (jsonMap["Values"] as List).map((map) {
        return ProductAttributeValue.fromJson(map);
      }).toList();
    }

    attributeValues = values;
  }

  int id;
  int productTmplId;
  int attributeId;
  String name;
  String nameGet;
  String code;
  bool createVariant;

  int sequence;
  ProductAttributeValue productAttribute;
  List<ProductAttributeValue> attributeValues;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = {
      "Id": id,
      "Name": name,
      "Code": code,
      "Sequence": sequence,
      "ProductTmplId": productTmplId,
      "AttributeId": attributeId,
      "CreateVariant": createVariant,
      "Attribute": productAttribute?.toJson(removeIfNull),
      "Values": attributeValues != null ? attributeValues.map((f) => f.toJson(removeIfNull)).toList() : null,
    };

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
