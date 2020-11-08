/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:tpos_api_client/src/models/entities/tpos_facebook_post.dart';

import 'live_campaign_detail.dart';

class LiveCampaign {
  LiveCampaign({
    this.id,
    this.name,
    this.facebookUserId,
    this.facebookUserName,
    this.facebookUserAvatar,
    this.facebookLiveId,
    this.note,
    this.isActive,
    this.dateCreated,
    this.details,
  });
  LiveCampaign.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    name = jsonMap["Name"];
    facebookUserName = jsonMap["Facebook_UserName"];
    facebookUserId = jsonMap["Facebook_UserId"];
    facebookUserAvatar = jsonMap["Facebook_UserAvatar"];
    facebookLiveId = jsonMap["Facebook_LiveId"];
    note = jsonMap["Note"];
    isActive = jsonMap["IsActive"];
    if (jsonMap["DateCreated"] != null)
      dateCreated = DateTime.parse(jsonMap["DateCreated"]);

    details = jsonMap["Details"] != null
        ? (jsonMap["Details"] as List)
            .map((value) => LiveCampaignDetail.fromJson(value))
            .toList()
        : null;

    if (jsonMap["Facebook_Post"] != null) {
      facebookPost = TposFacebookPost.fromJson(jsonMap["Facebook_Post"]);
    }
  }
  String id;
  String name;
  String facebookUserId;
  String facebookUserName;
  String facebookUserAvatar;
  String facebookLiveId;
  String note;
  bool isActive;
  DateTime dateCreated;
  List<LiveCampaignDetail> details;
  TposFacebookPost facebookPost;

  Map<String, dynamic> toJson({bool removeNullValue = false}) {
    final map = {
      "Id": id,
      "Name": name,
      "Facebook_UserName": facebookUserName,
      "Facebook_UserId": facebookUserId,
      "Facebook_UserAvatar": facebookUserAvatar,
      "Facebook_LiveId": facebookLiveId,
      "Note": note,
      "IsActive": isActive,
      "Details": details?.map((f) => f.toJson())?.toList(),
      "Facebook_Post": facebookPost?.toJson(removeNullValue: removeNullValue),
    };

    if (dateCreated != null) {
      map["DateCreated"] = dateCreated?.toIso8601String();
    }

    if (removeNullValue) {
      map.removeWhere((key, value) => value == null);
    }

    return map;
  }
}
