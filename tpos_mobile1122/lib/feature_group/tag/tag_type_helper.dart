List<Type> tagTypeHelpers() {
  final List<Type> types = <Type>[
    Type(key: "saleonline", value: "Sale Online"),
    Type(key: "fastsaleorder", value: "Bán hàng nhanh"),
    Type(key: "producttemplate", value: "Sản phẩm"),
    Type(key: "product", value: "Biến thể sản phẩm"),
    Type(key: "partner", value: "Khách hàng"),
  ];

  return types;
}

String convertTypeTagToName(String keyTag) {
  String nameTag = "";
  if (keyTag == "saleonline") {
    nameTag = "Sale Online";
  } else if (keyTag == "fastsaleorder") {
    nameTag = "Bán hàng nhanh";
  } else if (keyTag == "producttemplate") {
    nameTag = "Sản phẩm";
  } else if (keyTag == "product") {
    nameTag = "Biến thể sản phẩm";
  } else if (keyTag == "partner") {
    nameTag = "Khách hàng";
  }
  return nameTag;
}

class Type {
  Type({this.value, this.isSelected = false, this.key});
  final String key;
  final String value;
  bool isSelected;
}
