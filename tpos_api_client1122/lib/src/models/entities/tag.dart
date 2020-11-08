class Tag {
  Tag(
      {this.color,
      this.id,
      this.name,
      this.type,
      this.nameNosign,
      this.isSelect});
  Tag.fromJson(Map<String, dynamic> json) {
    color = json['Color'];
    id = json['Id'];
    name = json['Name'];
    nameNosign = json['NameNosign'];
    type = json['Type'];
  }
  String color;
  int id;
  String name;
  String nameNosign;
  String type;
  bool isSelect = false;

  Map<String, dynamic> toJson([bool isRemoveNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Color'] = color;
    data['Id'] = id;
    data['Name'] = name;
    data['NameNosign'] = nameNosign;
    data['Type'] = type;

    if(isRemoveNull){
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }
}
