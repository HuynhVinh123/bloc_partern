/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:tpos_mobile/src/tpos_apis/models/tpos_facebook_from.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';

class TposFacebookPost {
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

  List<TposFacebookComment> comment;
  TposFacebookFrom from;

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
          .map((f) => TposFacebookComment.fromJson(f))
          .toList();
    }
  }

  Map toJson({bool removeNullValue = false}) {
    var jsonMap = {
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
