/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'facebook_user.dart';

class FacebookPost {
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
    this.updatedTime,
  });
  String id;
  String caption;

  /// Thời gian bài viết được tạo. Đôi khi trường này sẽ bị null và thay vào đó là updatedTime
  DateTime createdTime;

  /// Thời gian bài viết được chỉnh sửa. Dùng thay thế cho [createdTime] khi không có giá trị
  DateTime updatedTime;
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

  factory FacebookPost.fromMap(Map<String, dynamic> jsonMap) {
    return FacebookPost(
      id: jsonMap["id"],
      name: jsonMap["name"],
      createdTime: jsonMap['created_time'] != null
          ? DateTime.parse(jsonMap["created_time"])
          : null,
      updatedTime: jsonMap['updated_time'] != null
          ? DateTime.parse(jsonMap['updated_time'])
          : null,
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
      "id": id,
      "facebook_id": id,
      "name": name,
      "created_time": createdTime?.toIso8601String(),
      "updated_time": updatedTime?.toIso8601String(),
      "description": description,
      "caption": caption,
      "picture": picture,
      "message": message,
      "type": type,
      "from": from?.toMap(removeNullValue: removeNullValue),
      "source": source,
      "story": story,
    };

    if (removeNullValue) {
      result.removeWhere((key, value) {
        return value == null;
      });
    }

    return result;
  }
}
