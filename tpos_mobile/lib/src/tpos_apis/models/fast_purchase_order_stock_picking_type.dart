class StockPickingTypeFPO {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Code'] = code;
    data['Sequence'] = sequence;
    data['DefaultLocationDestId'] = defaultLocationDestId;
    data['WarehouseId'] = warehouseId;
    data['WarehouseName'] = warehouseName;
    data['IRSequenceId'] = iRSequenceId;
    data['Active'] = active;
    data['Name'] = name;
    data['DefaultLocationSrcId'] = defaultLocationSrcId;
    data['ReturnPickingTypeId'] = returnPickingTypeId;
    data['UseCreateLots'] = useCreateLots;
    data['UseExistingLots'] = useExistingLots;
    data['InverseOperation'] = inverseOperation;
    data['NameGet'] = nameGet;
    data['CountPickingReady'] = countPickingReady;
    data['CountPickingDraft'] = countPickingDraft;
    data['CountPicking'] = countPicking;
    data['CountPickingWaiting'] = countPickingWaiting;
    data['CountPickingLate'] = countPickingLate;
    data['CountPickingBackOrders'] = countPickingBackOrders;
    return data;
  }
}
