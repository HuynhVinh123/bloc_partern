/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:tpos_mobile/src/facebook_apis/facebook_api.dart';

import 'facebook_user.dart';

class FacebookPost {
  String id;
  String caption;
  DateTime createdTime;
  String description;
  String name;
  String picture;
  FacebookUser from;
  String message;
  int totalComment;
  int toltalLike;
  String type;
  String source;
  String story;

  // Add
  String liveCampaignId;
  String liveCampaignName;
  bool isSave = false;

  String get idForEventSource {
    if (id.contains("_")) {
      return id.split("_")[1];
    } else {
      return id;
    }
  }

  bool isLive = false;
  bool isVideo = false;

  FacebookPost({
    this.id,
    this.caption,
    this.createdTime,
    this.description,
    this.name,
    this.picture,
    this.message,
    this.totalComment,
    this.toltalLike,
    this.from,
    this.type,
    this.source,
    this.story,
  });

  factory FacebookPost.fromMap(Map<String, dynamic> jsonMap) {
    return FacebookPost(
      id: jsonMap["id"],
      name: jsonMap["name"],
      createdTime: DateTime.parse(jsonMap["created_time"]),
      description: jsonMap["description"],
      caption: jsonMap["caption"],
      picture: jsonMap["picture"],
      message: jsonMap["message"],
      type: jsonMap["type"],
      source: jsonMap['source'],
      story: jsonMap["story"],
      totalComment:
          jsonMap["comments"] != null && jsonMap["comments"]["summary"] != null
              ? jsonMap["comments"]["summary"]["total_count"]
              : 0,
      toltalLike: jsonMap["reactions"] != null &&
              jsonMap["reactions"]["summary"] != null
          ? jsonMap["reactions"]["summary"]["total_count"]
          : 0,
      from: FacebookUser.fromMap(jsonMap["from"]),
    );
  }

  Map toJson({bool removeNullValue = false}) {
    Map<String, dynamic> result = {
      "id": this.id,
      "facebook_id": this.id,
      "name": this.name,
      "created_time": this.createdTime.toIso8601String() + "+07:00",
      "description": this.description,
      "caption": this.caption,
      "picture": this.picture,
      "message": this.message,
      "type": this.type,
      "from": this.from?.toMap(removeNullValue: removeNullValue),
      "source": this.source,
      "story": this.story,
    };

    if (removeNullValue) {
      result.removeWhere((key, value) {
        return value == null;
      });
    }

    return result;
  }
}
