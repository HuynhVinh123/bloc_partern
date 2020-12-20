import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

/// Danh sách loại nhãn
List<Type> tagTypeHelpers() {
  // Bán hàng nhanh
  final List<Type> types = <Type>[
    Type(key: "saleonline", value: "Sale Online"),
    Type(key: "fastsaleorder", value: S.current.fastSale),
    Type(key: "producttemplate", value: S.current.product),
    Type(key: "product", value: S.current.productVariation),
    Type(key: "partner", value: S.current.customer),
  ];

  return types;
}

/// Convert tên nhãn từ keu sang value
String convertTypeTagToName(String keyTag) {
  String nameTag = "";
  if (keyTag == "saleonline") {
    nameTag = "Sale Online";
  } else if (keyTag == "fastsaleorder") {
    nameTag = S.current.fastSale;
  } else if (keyTag == "producttemplate") {
    nameTag = S.current.product;
  } else if (keyTag == "product") {
    nameTag = S.current.productVariation;
  } else if (keyTag == "partner") {
    nameTag = S.current.customer;
  }
  return nameTag;
}

class Type {
  Type({this.value, this.isSelected = false, this.key});
  final String key;
  final String value;
  bool isSelected;
}
