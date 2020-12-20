import 'package:tpos_api_client/tpos_api_client.dart';

class ProductUomCategory {
  ProductUomCategory({this.id, this.name});

  ProductUomCategory.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    name = jsonMap["Name"];
  }

  ProductUomCategory.cloneWith(ProductUomCategory other) {
    id = other.id;
    name = other.name;
  }

  int id;
  String name;

  ///dach sách dùng cho chức năng gom nhóm các đơn vị tính có cùng nhóm đơn vị tính
  List<ProductUOM> productUoms = [];

  Map<String, dynamic> toJson([removeIfNull = false]) {
    final Map<String, dynamic> data = {"Id": id, "Name": name};

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }
}
