/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'facebook_user.dart';

class FacebookAccount {
  String accessToken;
  String category;
  String name;
  String id;
  FacebookPictureData picture;
  bool isPage;
  String pictureString;

  FacebookAccount(
      {this.accessToken,
      this.category,
      this.name,
      this.id,
      this.picture,
      this.isPage = true});

  factory FacebookAccount.fromMap(Map<String, dynamic> jsonMap) {
    var fbAccount = FacebookAccount(
      name: jsonMap["name"],
      accessToken: jsonMap["access_token"],
      category: jsonMap["category"],
      id: jsonMap["id"],
    );

    if (jsonMap["picture"] != null) {
      if (jsonMap["picture"] is String) {
        fbAccount.pictureString = jsonMap["picture"];
      } else {
        fbAccount.picture =
            FacebookPictureData.fromJson(jsonMap["picture"]['data']);
        fbAccount.pictureString = fbAccount.picture.url;
      }
    }

    return fbAccount;
  }
}
