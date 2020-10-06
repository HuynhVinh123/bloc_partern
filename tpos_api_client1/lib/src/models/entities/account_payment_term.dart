class AccountPaymentTerm {
  AccountPaymentTerm(
      {this.id, this.name, this.active, this.note, this.companyId});
  AccountPaymentTerm.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    name = jsonMap["Name"];
    active = jsonMap["Active"];
    note = jsonMap["Note"];
    companyId = jsonMap["CompanyId"];
  }
  int id;
  String name;
  bool active;
  String note;
  int companyId;

  Map<String, dynamic> toJson() {
    return {
      "Id": id,
      "Name": name,
      "Active": active,
      "Note": note,
      "CompanyId": companyId,
    };
  }
}
