/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:tpos_mobile/feature_group/sale_online/models/model_base.dart';

import 'facebook_user.dart';

class FacebookComment implements ModelBase {
  String id;
  int viewId;
  String message;
  DateTime createdTime;
  DateTime createdTimeConverted;
  FacebookUser from;
  bool isHidden;
  bool canHide;
  List<FacebookComment> comments;

  FacebookComment(
      {this.id,
      this.viewId,
      this.message,
      this.createdTime,
      this.createdTimeConverted,
      this.from,
      this.isHidden,
      this.canHide,
      this.comments});

  factory FacebookComment.fromMap(Map<String, dynamic> jsonMap) {
    return new FacebookComment(
      id: jsonMap["id"],
      message: jsonMap["message"],
      viewId: jsonMap['view_id'],
      createdTime: DateTime.parse(jsonMap["created_time"]),
      from: FacebookUser.fromMap(jsonMap["from"]),
      isHidden: jsonMap["is_hidden"],
      canHide: jsonMap["can_hide"],
      comments: jsonMap['comments'] != null
          ? (jsonMap['comments']["data"] as List).map((cm) {
              return FacebookComment.fromMap(cm);
            }).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "message": message,
      "created_time": createdTime?.toString(),
      "is_hidden": isHidden,
      "can_hide": canHide,
      "view_id": viewId,
      "from": from?.toMap(removeNullValue: true),
      "created_time_converted": createdTimeConverted?.toString(),
    }..removeWhere((key, value) => value == null);
  }
}
