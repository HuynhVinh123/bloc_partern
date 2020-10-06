class ServiceCustom {
  bool isDefault;
  String name;
  String serviceId;

  ServiceCustom({this.isDefault, this.name, this.serviceId});

  ServiceCustom.fromJson(Map<String, dynamic> map) {
    if (map != null) {
      if (map["IsDefault"] != null) {
        isDefault = map["IsDefault"];
      }
      name = map["Name"];
      serviceId = map["ServiceId"];
    }
  }

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map["IsDefault"] = this.isDefault;
    map["Name"] = this.name;
    map["ServiceId"] = this.serviceId;
    return map;
  }
}
