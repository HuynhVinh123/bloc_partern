/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:intl/intl.dart';
import 'package:tpos_mobile/src/tpos_apis/models/tpos_facebook_post.dart';

import 'package:tpos_mobile/src/tpos_apis/models/live_campaign_detail.dart';

class LiveCampaign {
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
      dateCreated = DateTime.parse(jsonMap["DateCreated"]).toLocal();

    details = jsonMap["Details"] != null
        ? (jsonMap["Details"] as List)
            .map((value) => LiveCampaignDetail.fromJson(value))
            .toList()
        : null;

    if (jsonMap["Facebook_Post"] != null) {
      facebookPost = TposFacebookPost.fromJson(jsonMap["Facebook_Post"]);
    }
  }

  Map<String, dynamic> toJson({bool removeNullValue = false}) {
    var map = {
      "Id": this.id,
      "Name": this.name,
      "Facebook_UserName": this.facebookUserName,
      "Facebook_UserId": this.facebookUserId,
      "Facebook_UserAvatar": this.facebookUserAvatar,
      "Facebook_LiveId": this.facebookLiveId,
      "Note": this.note,
      "IsActive": this.isActive,
      "Details": this.details?.map((f) => f.toJson())?.toList(),
      "Facebook_Post": facebookPost?.toJson(removeNullValue: removeNullValue),
    };

    if (dateCreated != null) {
      map["DateCreated"] = DateFormat(
              "yyyy-MM-ddTHH:mm:ss.SSS+${dateCreated.timeZoneOffset.inHours.toString().padLeft(2, "0")}:00")
          .format(dateCreated);
    }

    if (removeNullValue) {
      map.removeWhere((key, value) => value == null);
    }

    return map;
  }
}
