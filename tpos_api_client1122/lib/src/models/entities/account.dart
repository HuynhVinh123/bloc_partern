import 'package:tpos_api_client/tpos_api_client.dart';

class Account {
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

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['Code'] = code;
    data['UserTypeId'] = userTypeId;
    data['UserTypeName'] = userTypeName;
    data['Active'] = active;
    data['Note'] = note;
    data['CompanyId'] = companyId;
    data['CompanyName'] = companyName;
    data['CurrencyId'] = currencyId;
    data['InternalType'] = internalType;
    data['NameGet'] = nameGet;
    data['Reconcile'] = reconcile;

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
