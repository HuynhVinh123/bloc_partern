class StockPickingTypeFPO {
  int id;
  String code;
  int sequence;
  int defaultLocationDestId;
  int warehouseId;
  String warehouseName;
  int iRSequenceId;
  bool active;
  String name;
  int defaultLocationSrcId;
  int returnPickingTypeId;
  bool useCreateLots;
  bool useExistingLots;
  bool inverseOperation;
  String nameGet;
  int countPickingReady;
  int countPickingDraft;
  int countPicking;
  int countPickingWaiting;
  int countPickingLate;
  int countPickingBackOrders;

  StockPickingTypeFPO(
      {this.id,
      this.code,
      this.sequence,
      this.defaultLocationDestId,
      this.warehouseId,
      this.warehouseName,
      this.iRSequenceId,
      this.active,
      this.name,
      this.defaultLocationSrcId,
      this.returnPickingTypeId,
      this.useCreateLots,
      this.useExistingLots,
      this.inverseOperation,
      this.nameGet,
      this.countPickingReady,
      this.countPickingDraft,
      this.countPicking,
      this.countPickingWaiting,
      this.countPickingLate,
      this.countPickingBackOrders});

  StockPickingTypeFPO.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    code = json['Code'];
    sequence = json['Sequence'];
    defaultLocationDestId = json['DefaultLocationDestId'];
    warehouseId = json['WarehouseId'];
    warehouseName = json['WarehouseName'];
    iRSequenceId = json['IRSequenceId'];
    active = json['Active'];
    name = json['Name'];
    defaultLocationSrcId = json['DefaultLocationSrcId'];
    returnPickingTypeId = json['ReturnPickingTypeId'];
    useCreateLots = json['UseCreateLots'];
    useExistingLots = json['UseExistingLots'];
    inverseOperation = json['InverseOperation'];
    nameGet = json['NameGet'];
    countPickingReady = json['CountPickingReady'];
    countPickingDraft = json['CountPickingDraft'];
    countPicking = json['CountPicking'];
    countPickingWaiting = json['CountPickingWaiting'];
    countPickingLate = json['CountPickingLate'];
    countPickingBackOrders = json['CountPickingBackOrders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Code'] = this.code;
    data['Sequence'] = this.sequence;
    data['DefaultLocationDestId'] = this.defaultLocationDestId;
    data['WarehouseId'] = this.warehouseId;
    data['WarehouseName'] = this.warehouseName;
    data['IRSequenceId'] = this.iRSequenceId;
    data['Active'] = this.active;
    data['Name'] = this.name;
    data['DefaultLocationSrcId'] = this.defaultLocationSrcId;
    data['ReturnPickingTypeId'] = this.returnPickingTypeId;
    data['UseCreateLots'] = this.useCreateLots;
    data['UseExistingLots'] = this.useExistingLots;
    data['InverseOperation'] = this.inverseOperation;
    data['NameGet'] = this.nameGet;
    data['CountPickingReady'] = this.countPickingReady;
    data['CountPickingDraft'] = this.countPickingDraft;
    data['CountPicking'] = this.countPicking;
    data['CountPickingWaiting'] = this.countPickingWaiting;
    data['CountPickingLate'] = this.countPickingLate;
    data['CountPickingBackOrders'] = this.countPickingBackOrders;
    return data;
  }
}
