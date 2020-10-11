/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class TposFacebookUserSimple {
  String id;
  String name;
  String picture;

  TposFacebookUserSimple({this.id, this.name, this.picture});

  TposFacebookUserSimple.fromJson(Map jsonMap) {
    id = jsonMap["id"];
    name = jsonMap["name"];
    picture = jsonMap['picture'];
  }

  Map toJson({bool removeNullValue}) {
    Map jsonMap = {
      "id": id,
      "name": name,
      "picture": picture,
    };

    if (removeNullValue) {
      jsonMap.removeWhere((key, value) => value == null);
    }
    return jsonMap;
  }
}
