class StockMoveProduct {
  StockMoveProduct({this.odataContext, this.odataCount, this.value});

  StockMoveProduct.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'];
    odataCount = json['@odata.count'];
    if (json['value'] != null) {
      value = <StockMoveProductValue>[];
      json['value'].forEach((v) {
        value.add(StockMoveProductValue.fromJson(v));
      });
    }
  }

  String odataContext;
  int odataCount;
  List<StockMoveProductValue> value;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@odata.context'] = odataContext;
    data['@odata.count'] = odataCount;
    if (value != null) {
      data['value'] = value.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StockMoveProductValue {
  StockMoveProductValue(
      {this.origin,
      this.id,
      this.note,
      this.state,
      this.name,
      this.dateExpected,
      this.partnerId,
      this.productUOMId,
      this.productUOMName,
      this.productUOMQty,
      this.productId,
      this.productNameGet,
      this.productNameTemplate,
      this.productTmplId,
      this.locationId,
      this.locationNameGet,
      this.locationDestId,
      this.locationDestNameGet,
      this.date,
      this.priceUnit,
      this.companyId,
      this.showState,
      this.reservedAvailability,
      this.availability,
      this.pickingName,
      this.quantityAvailable,
      this.quantityDone,
      this.sequence,
      this.dateBackdating,
      this.hasTracking,
      this.isDone,
      this.restrictLotId,
      this.productionId,
      this.rawMaterialProductionId,
      this.type,
      this.productQty,
      this.orderName,
      this.partnerName});

  StockMoveProductValue.fromJson(Map<String, dynamic> json) {
    origin = json['Origin'];
    id = json['Id'];
    note = json['Note'];
    state = json['State'];
    name = json['Name'];
    dateExpected = json['DateExpected'];
    partnerId = json['PartnerId'];
    productUOMId = json['ProductUOMId'];
    productUOMName = json['ProductUOMName'];
    productUOMQty = json['ProductUOMQty'];
    productId = json['ProductId'];
    productNameGet = json['ProductNameGet'];
    productNameTemplate = json['ProductNameTemplate'];
    productTmplId = json['ProductTmplId'];
    locationId = json['LocationId'];
    locationNameGet = json['LocationNameGet'];
    locationDestId = json['LocationDestId'];
    locationDestNameGet = json['LocationDestNameGet'];
    date = json['Date'];
    priceUnit = json['PriceUnit'];
    companyId = json['CompanyId'];
    showState = json['ShowState'];
    reservedAvailability = json['ReservedAvailability'];
    availability = json['Availability'];
    pickingName = json['PickingName'];
    quantityAvailable = json['QuantityAvailable'];
    quantityDone = json['QuantityDone'];
    sequence = json['Sequence'];
    dateBackdating = json['DateBackdating'];
    hasTracking = json['HasTracking'];
    isDone = json['IsDone'];
    restrictLotId = json['RestrictLotId'];
    productionId = json['ProductionId'];
    rawMaterialProductionId = json['RawMaterialProductionId'];
    type = json['Type'];
    productQty = json['ProductQty'];
    orderName = json['OrderName'];
    partnerName = json['PartnerName'];
  }

  String origin;
  int id;
  String note;
  String state;
  String name;
  String dateExpected;
  dynamic partnerId;
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
  String date;
  dynamic priceUnit;
  int companyId;
  String showState;
  int reservedAvailability;
  dynamic availability;
  dynamic pickingName;
  dynamic quantityAvailable;
  int quantityDone;
  int sequence;
  dynamic dateBackdating;
  dynamic hasTracking;
  bool isDone;
  dynamic restrictLotId;
  dynamic productionId;
  dynamic rawMaterialProductionId;
  String type;
  double productQty;
  String orderName;
  String partnerName;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Origin'] = origin;
    data['Id'] = id;
    data['Note'] = note;
    data['State'] = state;
    data['Name'] = name;
    data['DateExpected'] = dateExpected;
    data['PartnerId'] = partnerId;
    data['ProductUOMId'] = productUOMId;
    data['ProductUOMName'] = productUOMName;
    data['ProductUOMQty'] = productUOMQty;
    data['ProductId'] = productId;
    data['ProductNameGet'] = productNameGet;
    data['ProductNameTemplate'] = productNameTemplate;
    data['ProductTmplId'] = productTmplId;
    data['LocationId'] = locationId;
    data['LocationNameGet'] = locationNameGet;
    data['LocationDestId'] = locationDestId;
    data['LocationDestNameGet'] = locationDestNameGet;
    data['Date'] = date;
    data['PriceUnit'] = priceUnit;
    data['CompanyId'] = companyId;
    data['ShowState'] = showState;
    data['ReservedAvailability'] = reservedAvailability;
    data['Availability'] = availability;
    data['PickingName'] = pickingName;
    data['QuantityAvailable'] = quantityAvailable;
    data['QuantityDone'] = quantityDone;
    data['Sequence'] = sequence;
    data['DateBackdating'] = dateBackdating;
    data['HasTracking'] = hasTracking;
    data['IsDone'] = isDone;
    data['RestrictLotId'] = restrictLotId;
    data['ProductionId'] = productionId;
    data['RawMaterialProductionId'] = rawMaterialProductionId;
    data['Type'] = type;
    data['ProductQty'] = productQty;
    data['OrderName'] = orderName;
    data['PartnerName'] = partnerName;
    return data;
  }
}
