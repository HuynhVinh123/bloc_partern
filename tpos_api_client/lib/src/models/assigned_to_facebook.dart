class AssignedToFacebook {
  AssignedToFacebook({this.avatar, this.id, this.name, this.username});
  AssignedToFacebook.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    avatar = json['Avatar'];
    name = json['Name'];
    username = json['UserName'];
  }
  String avatar;
  String id;
  String name;
  String username;
  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Avatar'] = avatar;
    data['Name'] = name;
    data['UserName'] = username;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
