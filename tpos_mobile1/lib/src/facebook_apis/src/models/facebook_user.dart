/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class FacebookUser {
  String id;
  String name;
  FacebookPictureData picture;
  String pictureLink;
  String email;
  FacebookUser({this.id, this.name, this.picture});

  FacebookUser.fromMap(Map<String, dynamic> jsonMap) {
    id = jsonMap["id"];
    name = jsonMap['name'];
    email = jsonMap["email"];

    if (jsonMap["picture"] is String) {
      pictureLink = jsonMap["picture"];
    } else {
      if (jsonMap["picture"] != null) {
        if (jsonMap["picture"]["data"] != null)
          pictureLink = jsonMap["picture"]["data"]["url"];
        picture = FacebookPictureData.fromJson(jsonMap['picture']);
      }
    }
  }

  Map<String, dynamic> toMap({bool removeNullValue = false}) {
    var jsonMap = {
      "id": id,
      "name": name,
      "picture": picture != null
          ? picture.toJson(removeNullValue: removeNullValue)
          : pictureLink,
    };

    if (removeNullValue) {
      jsonMap.removeWhere((key, value) => value == null);
    }
    return jsonMap;
  }
}

class FacebookPictureData {
  int height;
  int width;
  bool isSilhouette;
  String url;

  FacebookPictureData({this.height, this.width, this.isSilhouette, this.url});
  FacebookPictureData.fromJson(Map jsonMap) {
    height = jsonMap["height"];
    width = jsonMap["width"];
    isSilhouette = jsonMap["is_silhoutte"];
    url = jsonMap["url"];
  }

  Map toJson({bool removeNullValue = false}) {
    var jsonMap = {
      "height": height,
      "width": width,
      "url": url,
    };

    if (removeNullValue) {
      jsonMap.removeWhere((key, value) => value == null);
    }
    return jsonMap;
  }
}
