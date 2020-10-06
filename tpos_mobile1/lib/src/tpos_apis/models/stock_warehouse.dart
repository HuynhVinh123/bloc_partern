class StockWareHouse {
  int id;
  String code;
  String name;
  int companyId;
  String nameGet;
  String companyName;

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

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Code'] = this.code;
    data['Name'] = this.name;
    data['CompanyId'] = this.companyId;
    data['NameGet'] = this.nameGet;
    data['CompanyName'] = this.companyName;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
