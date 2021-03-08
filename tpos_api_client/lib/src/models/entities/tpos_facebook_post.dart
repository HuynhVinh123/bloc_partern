/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:tpos_api_client/src/model.dart';

import 'tpos_facebook_from.dart';

class TposFacebookPost {
  TposFacebookPost(
      {this.createdTime,
      this.facebookId,
      this.fullPicture,
      this.message,
      this.picture,
      this.source,
      this.story,
      this.from,
      this.description,
      this.caption,
      this.comment});
  TposFacebookPost.fromJson(Map jsonMap) {
    createdTime = DateTime.parse(jsonMap["created_time"]);
    id = jsonMap["id"];
    facebookId = jsonMap["facebook_id"];
    fullPicture = jsonMap["fullPicture"];
    message = jsonMap["message"];
    picture = jsonMap["picture"];
    source = jsonMap["source"];
    story = jsonMap["story"];
    description = jsonMap["description"];
    caption = jsonMap["caption"];
    if (jsonMap["from"] != null) {
      from = TposFacebookFrom.fromJson(jsonMap["from"]);
    }

    if (jsonMap["comments"] != null) {
      comment = (jsonMap["comments"] as List)
          .map((f) => TPosFacebookComment.fromMap(f))
          .toList();
    }
  }
  String id;
  String facebookId;
  String message;
  String source;
  String story;
  String description;
  String link;
  String caption;
  DateTime createdTime;
  String fullPicture;
  String picture;

  List<TPosFacebookComment> comment;
  TposFacebookFrom from;

  Map toJson({bool removeNullValue = false}) {
    final jsonMap = {
      "created_time": createdTime?.toIso8601String(),
      "facebook_id": facebookId,
      "id": id,
      "full_picture": fullPicture,
      "message": message,
      "picture": picture,
      "source": source,
      "story": story,
      "from": from?.toJson(),
      "caption": caption,
      "description": description,
      "comments":
          comment != null ? comment.map((f) => f.toJson()).toList() : null,
    };

    if (removeNullValue) {
      jsonMap.removeWhere((key, value) => value == null);
    }

    return jsonMap;
  }
}
