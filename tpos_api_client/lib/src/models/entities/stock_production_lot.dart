class StockProductionLot {
  StockProductionLot.fromJson(Map<String, dynamic> jsonMap) {
    name = jsonMap["Name"];
    id = jsonMap["Id"];
    productId = jsonMap["ProductId"];
    productNameGet = jsonMap["ProductNameGet"];
    qtyAvailable = jsonMap["QtyAvailable"]?.toDouble();
  }

  int id;
  String name;
  int productId;
  String productNameGet;
  double qtyAvailable;

  Map<String, dynamic> toJson({bool removeIfNull = false}) {
    final Map<String, dynamic> data = {
      "Name": name,
      "Id": id,
      "ProductId": productId,
      "ProductNameGet": productNameGet,
      "QtyAvailable": qtyAvailable,
    };

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }

  @override
  String toString() {
    return name ?? '';
  }
}
