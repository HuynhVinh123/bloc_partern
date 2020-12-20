class PartnerExt {
  PartnerExt(
      {this.id,
      this.name,
      this.active,
      this.phone,
      this.email,
      this.address,
      this.code,
      this.note,
      this.type,
      this.dateCreated,
      this.nameNoSign});

  PartnerExt.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    name = jsonMap["Name"];
    nameNoSign = jsonMap["NameNoSign"];
    code = jsonMap["Code"];
    type = jsonMap["Type"];
    address = jsonMap["Address"];
    phone = jsonMap["Phone"];
    email = jsonMap["Email"];
    active = jsonMap["Active"];
    note = jsonMap["Note"];
    dateCreated = jsonMap["DateCreated"] != null ? DateTime.parse(jsonMap["DateCreated"]) : null;
  }

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> map = <String, dynamic>{
      "Id": id,
      "Name": name,
      "NameNoSign": nameNoSign,
      "Code": code,
      "Type": type,
      "Address": address,
      "Phone": phone,
      "Email": email,
      "Active": active,
      "Note": note,
      "DateCreated": dateCreated != null ? dateCreated.toIso8601String() : null,
    };

    if (removeIfNull) {
      map.removeWhere((key, value) => value == null || value == "");
    }
    return map;
  }

  int id;
  String name;
  String nameNoSign;
  String code;
  String type;
  String address;
  String phone;
  String email;

  bool active;
  DateTime dateCreated;
  String note;
}
