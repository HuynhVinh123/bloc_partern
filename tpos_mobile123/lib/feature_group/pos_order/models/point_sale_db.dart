class PointSaleDB {
  PointSaleDB({
    this.id,
    this.name,
    this.nameGet,
    this.companyId,
    this.pOSSessionUserName,
    this.lastSessionClosingDate,
    this.vatPc,
  });

  PointSaleDB.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    nameGet = json['NameGet'];
    companyId = json['CompanyId'];
    pOSSessionUserName = json['POSSessionUserName'];
    lastSessionClosingDate = json['LastSessionClosingDate'];
    vatPc = json['VatPc'];
  }
  int id;
  String name;
  String nameGet;
  int companyId;
  String pOSSessionUserName;
  String lastSessionClosingDate;
  int vatPc;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['NameGet'] = nameGet;
    data['CompanyId'] = companyId;
    data['POSSessionUserName'] = pOSSessionUserName;
    data['LastSessionClosingDate'] = lastSessionClosingDate;
    data['VatPc'] = vatPc;
    return data;
  }
}
