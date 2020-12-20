class ProductImage {
  ProductImage({this.name, this.type, this.url, this.mineType, this.resModel});

  ProductImage.fromJson(Map<String, dynamic> jsonMap) {
    mineType = jsonMap["MineType"];
    name = jsonMap["Name"];
    resModel = jsonMap["ResModel"];
    type = jsonMap["Type"];
    url = jsonMap["Url"];
  }

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> map = <String, dynamic>{
      "Name": name,
      "Type": type,
      "MineType": mineType,
      "ResModel": resModel,
      "Url": url,
    };

    if (removeIfNull) {
      map.removeWhere((key, value) => value == null || value == "");
    }
    return map;
  }

  String mineType;
  String name;
  String resModel;
  String type;
  String url;
}
