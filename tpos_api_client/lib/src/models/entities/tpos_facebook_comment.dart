/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:tpos_api_client/src/model.dart';

class TPosFacebookComment {
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
    return TPosFacebookComment(
      id: jsonMap["id"],
      message: jsonMap["message"],
      viewId: jsonMap['view_id'],
      createdTime: DateTime.parse(jsonMap["created_time"]),
      from: jsonMap["from"] != null
          ? TposFacebookFrom.fromJson(jsonMap["from"])
          : null,
      isHidden: jsonMap["is_hidden"],
      canHide: jsonMap["can_hide"],
      comments: jsonMap['comments'] != null
          ? (jsonMap['comments']["data"] as List).map((cm) {
              return TPosFacebookComment.fromMap(cm);
            }).toList()
          : null,
    );
  }

  String id;
  int viewId;
  String message;
  DateTime createdTime;
  DateTime createdTimeConverted;
  TposFacebookFrom from;
  bool isHidden;
  bool canHide;
  List<TPosFacebookComment> comments;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "message": message,
      "created_time": createdTime?.toString(),
      "is_hidden": isHidden,
      "can_hide": canHide,
      "view_id": viewId,
      "from": from?.toJson(true),
      "created_time_converted": createdTimeConverted?.toString(),
    }..removeWhere((key, value) => value == null);
  }
}
