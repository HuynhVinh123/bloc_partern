class OriginCountry {
  OriginCountry({this.name, this.code, this.nameNoSign, this.dateCreated, this.note, this.id, this.lastUpdated});

  OriginCountry.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    name = jsonMap["Name"];
    nameNoSign = jsonMap["NameNoSign"];
    code = jsonMap["Code"];
    note = jsonMap["Note"];
    dateCreated = jsonMap["DateCreated"] != null ? DateTime.parse(jsonMap["DateCreated"]) : null;
    lastUpdated = jsonMap["LastUpdated"] != null ? DateTime.parse(jsonMap["LastUpdated"]) : null;
  }

  String code;
  DateTime dateCreated;
  int id;
  DateTime lastUpdated;
  String name;
  String nameNoSign;
  String note;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> map = <String, dynamic>{
      "Id": id,
      "Name": name,
      "NameNoSign": nameNoSign,
      "Code": code,
      "Note": note,
      "DateCreated": dateCreated != null ? dateCreated.toIso8601String() : null,
      "LastUpdated": lastUpdated != null ? lastUpdated.toIso8601String() : null,
    };

    if (removeIfNull) {
      map.removeWhere((key, value) => value == null || value == "");
    }
    return map;
  }
}
