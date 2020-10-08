import 'package:tpos_api_client/tpos_api_client.dart';


class Account {
  int id;
  String name;
  String code;
  int userTypeId;
  String userTypeName;
  bool active;
  String note;
  int companyId;
  String companyName;
  int currencyId;
  String internalType;
  String nameGet;
  bool reconcile;
  Company company;

  Account(
      {this.id,
      this.name,
      this.code,
      this.userTypeId,
      this.userTypeName,
      this.active,
      this.note,
      this.companyId,
      this.companyName,
      this.currencyId,
      this.internalType,
      this.nameGet,
      this.reconcile,
      this.company});

  Account.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    code = json['Code'];
    userTypeId = json['UserTypeId'];
    userTypeName = json['UserTypeName'];
    active = json['Active'];
    note = json['Note'];
    companyId = json['CompanyId'];
    companyName = json['CompanyName'];
    currencyId = json['CurrencyId'];
    internalType = json['InternalType'];
    nameGet = json['NameGet'];
    reconcile = json['Reconcile'];
    if (json['Company'] != null) {
      company = Company.fromJson(json['Company']);
    }
  }

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['Code'] = this.code;
    data['UserTypeId'] = this.userTypeId;
    data['UserTypeName'] = this.userTypeName;
    data['Active'] = this.active;
    data['Note'] = this.note;
    data['CompanyId'] = this.companyId;
    data['CompanyName'] = this.companyName;
    data['CurrencyId'] = this.currencyId;
    data['InternalType'] = this.internalType;
    data['NameGet'] = this.nameGet;
    data['Reconcile'] = this.reconcile;

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
