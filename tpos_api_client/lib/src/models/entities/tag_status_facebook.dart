class TagStatusFacebook {
  TagStatusFacebook(
      {this.id, this.name, this.colorClass, this.colorCode, this.icon});
  TagStatusFacebook.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    colorClass = json['color_class'];
    colorCode = json['color_code'];
  }
  String id;
  String name;
  String colorClass;
  String colorCode;
  String icon;
  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['color_class'] = colorClass;
    data['color_code'] = colorCode;
    data['icon'] = icon;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
