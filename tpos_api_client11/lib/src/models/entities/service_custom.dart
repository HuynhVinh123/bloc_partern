class ServiceCustom {
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
  bool isDefault;
  String name;
  String serviceId;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["IsDefault"] = isDefault;
    map["Name"] = name;
    map["ServiceId"] = serviceId;
    return map;
  }
}
