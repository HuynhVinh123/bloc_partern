class PaymentTerm {
  int id;
  String name;
  bool active;
  String note;
  int companyId;

  PaymentTerm({this.id, this.name, this.active, this.note, this.companyId});

  PaymentTerm.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    active = json['Active'];
    note = json['Note'];
    companyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['Active'] = this.active;
    data['Note'] = this.note;
    data['CompanyId'] = this.companyId;
    return data;
  }
}
