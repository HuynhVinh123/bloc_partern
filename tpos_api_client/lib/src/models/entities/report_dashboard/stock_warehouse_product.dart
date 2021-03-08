

class StockWarehouseProduct {

  StockWarehouseProduct(
      {this.id,
        this.inventoryMax,
        this.inventoryMin,
        this.inventory,
        this.productTmplId,
        this.productTmplName,
        this.warehouseId,
        this.warehouseName,
        this.uOMName,
        this.virtualAvailable});

  StockWarehouseProduct.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    inventoryMax = json['InventoryMax'];
    inventoryMin = json['InventoryMin'];
    inventory = double.parse( json['Inventory'].toString());
    productTmplId = json['ProductTmplId'];
    productTmplName = json['ProductTmplName'];
    warehouseId = json['WarehouseId'];
    warehouseName = json['WarehouseName'];
    uOMName = json['UOMName'];
    virtualAvailable = double.parse(json['VirtualAvailable'].toString());
  }

  int id;
  double inventoryMax;
  double inventoryMin;
  double inventory;
  int productTmplId;
  String productTmplName;
  dynamic warehouseId;
  dynamic warehouseName;
  String uOMName;
  double virtualAvailable;



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['InventoryMax'] = inventoryMax;
    data['InventoryMin'] = inventoryMin;
    data['Inventory'] = inventory;
    data['ProductTmplId'] = productTmplId;
    data['ProductTmplName'] = productTmplName;
    data['WarehouseId'] = warehouseId;
    data['WarehouseName'] = warehouseName;
    data['UOMName'] = uOMName;
    data['VirtualAvailable'] = virtualAvailable;
    return data;
  }
}
