/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'tpos_facebook_user.dart';

class TPosFacebookComment {
  String id;
  int viewId;
  String message;
  DateTime createdTime;
  DateTime createdTimeConverted;
  TPosFacebookUser from;
  bool isHidden;
  bool canHide;
  List<TPosFacebookComment> comments;

  TPosFacebookComment(
      {this.id,
      this.viewId,
      this.message,
      this.createdTime,
      this.createdTimeConverted,
      this.from,
      this.isHidden,
      this.canHide,
      this.comments});

  factory TPosFacebookComment.fromMap(Map<String, dynamic> jsonMap) {
    return new TPosFacebookComment(
      id: jsonMap["id"],
      message: jsonMap["message"],
      viewId: jsonMap['view_id'],
      createdTime: DateTime.parse(jsonMap["created_time"]),
      from: TPosFacebookUser.fromMap(jsonMap["from"]),
      isHidden: jsonMap["is_hidden"],
      canHide: jsonMap["can_hide"],
      comments: jsonMap['comments'] != null
          ? (jsonMap['comments']["data"] as List).map((cm) {
              return TPosFacebookComment.fromMap(cm);
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
