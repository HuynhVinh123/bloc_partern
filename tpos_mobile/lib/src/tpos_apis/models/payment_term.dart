class PaymentTerm {
  PaymentTerm({this.id, this.name, this.active, this.note, this.companyId});

  PaymentTerm.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    active = json['Active'];
    note = json['Note'];
    companyId = json['CompanyId'];
  }
  int id;
  String name;
  bool active;
  String note;
  int companyId;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['Active'] = active;
    data['Note'] = note;
    data['CompanyId'] = companyId;
    return data;
  }
}
