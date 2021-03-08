class CRMTag {
  CRMTag(
      {this.id,
      this.icon,
      this.colorClassName,
      this.name,
      this.isDeleted,
      this.dateCreated});

  CRMTag.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    icon = json['Icon'];
    colorClassName = json['ColorClassName'];
    name = json['Name'];
    isDeleted = json['IsDeleted'];
    dateCreated = json['DateCreated'];
  }
  String id;
  dynamic icon;
  String colorClassName;
  String name;
  bool isDeleted;
  String dateCreated;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Icon'] = icon;
    data['ColorClassName'] = colorClassName;
    data['Name'] = name;
    data['IsDeleted'] = isDeleted;
    data['DateCreated'] = dateCreated;

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
