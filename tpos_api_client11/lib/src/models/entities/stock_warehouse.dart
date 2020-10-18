class StockWareHouse {
  StockWareHouse(
      {this.id,
      this.code,
      this.name,
      this.companyId,
      this.nameGet,
      this.companyName});
  StockWareHouse.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    code = json['Code'];
    name = json['Name'];
    companyId = json['CompanyId'];
    nameGet = json['NameGet'];
    companyName = json['CompanyName'];
  }

  int id;
  String code;
  String name;
  int companyId;
  String nameGet;
  String companyName;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Code'] = code;
    data['Name'] = name;
    data['CompanyId'] = companyId;
    data['NameGet'] = nameGet;
    data['CompanyName'] = companyName;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
