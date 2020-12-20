class StockMove {
  StockMove(
      {this.name,
      this.id,
      this.sequence,
      this.type,
      this.date,
      this.companyId,
      this.dateExpected,
      this.isDone,
      this.locationDestId,
      this.locationDestNameGet,
      this.locationId,
      this.locationNameGet,
      this.orderName,
      this.pickingName,
      this.productId,
      this.productNameGet,
      this.productNameTemplate,
      this.productQty,
      this.productTmplId,
      this.productUOMId,
      this.productUOMName,
      this.productUOMQty,
      this.quantityDone,
      this.reservedAvailability,
      this.showState});

  factory StockMove.fromJson(Map<String, dynamic> jsonMap) {
    return StockMove(
      name: jsonMap["Name"],
      id: jsonMap["Id"],
      type: jsonMap["Type"],
      sequence: jsonMap["Sequence"],
      companyId: jsonMap["CompanyId"],
      date: jsonMap["Date"] != null ? DateTime.tryParse(jsonMap["Date"]) : null,
      dateExpected: jsonMap["DateExpected"] != null ? DateTime.tryParse(jsonMap["DateExpected"]) : null,
      isDone: jsonMap["IsDone"],
      locationDestId: jsonMap["LocationDestId"],
      locationDestNameGet: jsonMap["LocationDestNameGet"],
      locationId: jsonMap["LocationId"],
      locationNameGet: jsonMap["LocationNameGet"],
      orderName: jsonMap["OrderName"],
      pickingName: jsonMap["PickingName"],
      productId: jsonMap["ProductId"],
      productNameGet: jsonMap["ProductNameGet"],
      productNameTemplate: jsonMap["ProductNameTemplate"],
      productQty: jsonMap["ProductQty"],
      productTmplId: jsonMap["ProductTmplId"],
      productUOMId: jsonMap["ProductUOMId"],
      productUOMName: jsonMap["ProductUOMName"],
      productUOMQty: jsonMap["ProductUOMQty"],
      quantityDone: jsonMap["QuantityDone"],
      reservedAvailability: jsonMap["ReservedAvailability"],
      showState: jsonMap["ShowState"],
    );
  }

  String name;
  int id;

  DateTime dateExpected;
  int productUOMId;
  String productUOMName;
  double productUOMQty;
  int productId;

  String productNameGet;
  String productNameTemplate;
  int productTmplId;
  int locationId;

  String locationNameGet;

  int locationDestId;

  String locationDestNameGet;

  DateTime date;
  int companyId;

  String showState;

  int reservedAvailability;
  String pickingName;
  int quantityDone;
  int sequence;

  bool isDone;
  String type;

  double productQty;
  String orderName;

  Map<String,dynamic> toJson({bool removeIfNull = false}) {
    final Map<String, dynamic> data = {
      "Name": name,
      "Id": id,
      "Type": type,
      "Sequence": sequence,
      "CompanyId": companyId,
      "Date": date != null ? date.toIso8601String() : null,
      "DateExpected": dateExpected != null ? dateExpected.toIso8601String() : null,
      "IsDone": isDone,
      "LocationDestId": locationDestId,
      "LocationDestNameGet": locationDestNameGet,
      "LocationId": locationId,
      "LocationNameGet": locationNameGet,
      "OrderName": orderName,
      "ProductId": productId,
      "ProductNameGet": productNameGet,
      "ProductNameTemplate": productNameTemplate,
      "ProductQty": productQty,
      "ProductTmplId": productTmplId,
      "ProductUOMId": productUOMId,
      "ProductUOMName": productUOMName,
      "ProductUOMQty": productUOMQty,
      "QuantityDone": quantityDone,
      "ReservedAvailability": reservedAvailability,
      "ShowState": showState,
    };

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }
}
