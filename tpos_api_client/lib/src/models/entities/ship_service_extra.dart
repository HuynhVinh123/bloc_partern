class ShipServiceExtra {
  ShipServiceExtra({this.id, this.name, this.fee});
  ShipServiceExtra.fromJson(Map<String, dynamic> json) {
    id = json["Id"];
    name = json["Name"];
    fee = json["Fee"];
  }
  String id;
  String name;
  double fee;

  Map<String, dynamic> toJson({bool removeIfNull = false}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["Id"] = id;
    data["Name"] = name;
    data["Fee"] = fee;

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
