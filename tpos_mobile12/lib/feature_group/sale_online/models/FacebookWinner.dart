/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:intl/intl.dart';

class FacebookWinner {
  FacebookWinner(
      {this.facebookPostId,
      this.facebookASUId,
      this.facebookUId,
      this.facebookName,
      this.dateCreated});
  factory FacebookWinner.fromMap(Map<String, dynamic> jsonMap) {
    return FacebookWinner(
      facebookPostId: jsonMap["FacebookPostId"],
      facebookASUId: jsonMap["FacebookASUId"],
      facebookUId: jsonMap["FacebookUId"],
      facebookName: jsonMap["FacebookName"],
      dateCreated: DateTime.parse(jsonMap["DateCreated"]),
    );
  }
  String facebookPostId, facebookASUId, facebookUId, facebookName;
  DateTime dateCreated;

  Map<String, dynamic> toMap({bool removeIfNull = true}) {
    final data = {
      "FacebookPostId": facebookPostId,
      "FacebookASUId": facebookASUId,
      "FacebookName": facebookName,
      "facebookUId": facebookUId,
      "DateCreated": dateCreated != null
          ? DateFormat("yyyy-MM-ddTHH:mm:ss'+07:00'").format(dateCreated)
          : null,
    };
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
