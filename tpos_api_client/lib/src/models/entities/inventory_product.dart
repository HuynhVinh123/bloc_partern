class InventoryProduct {
  InventoryProduct({this.nameGet, this.quantity, this.productTmpId, this.name, this.id});

  factory InventoryProduct.fromJson(Map<String, dynamic> jsonMap) {
    return InventoryProduct(
      name: jsonMap["Name"],
      nameGet: jsonMap["NameGet"],
      quantity: jsonMap["Quantity"] != null ? jsonMap["Quantity"].toDouble(): 0.0,
      id: jsonMap["Id"],
      productTmpId: jsonMap["ProductTmpId"],
    );
  }

  String nameGet, name;
  int id;
  double quantity;
  int productTmpId;

  Map<String,dynamic> toJson({bool removeIfNull = false}) {
    final Map<String, dynamic> data = {
      "NameGet": nameGet,
      "Name": name,
      "Quantity": quantity,
      "ProductTmpId": productTmpId,
      "Id": id,
    };

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }
}
