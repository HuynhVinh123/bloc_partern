class AssignedToFacebook {
  AssignedToFacebook(
      {this.avatar, this.id, this.name, this.username, this.nameFb});
  AssignedToFacebook.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    avatar = json['Avatar'];
    name = json['Name'];
    username = json['UserName'];
    nameFb = json['name'];
    picture =
        json['picture'] != null ? Picture.fromJson(json['picture']) : null;
  }
  String avatar;
  String id;
  String name;
  String username;
  String nameFb;
  Picture picture;
  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Avatar'] = avatar;
    data['Name'] = name;
    data['name'] = nameFb;
    data['UserName'] = username;
    data['picture'] = picture;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}

class Picture {
  Picture({this.dataImageFacebook});
  Picture.fromJson(Map<String, dynamic> json) {
    dataImageFacebook =
        json['data'] != null ? DataImageFacebook.fromJson(json['data']) : null;
  }
  DataImageFacebook dataImageFacebook;
}

class DataImageFacebook {
  DataImageFacebook({this.url, this.width, this.height});
  DataImageFacebook.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }
  String url;
  int width;
  int height;
  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['width'] = width;
    data['height'] = height;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
