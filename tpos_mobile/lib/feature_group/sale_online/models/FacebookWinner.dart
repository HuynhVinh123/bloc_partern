/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class FacebookWinner {
  FacebookWinner(
      {this.facebookPostId,
      this.facebookASUId,
      this.facebookUId,
      this.facebookName,
      this.dateCreated,
      this.totalDays});

  factory FacebookWinner.fromMap(Map<String, dynamic> jsonMap) {
    return FacebookWinner(
      facebookPostId: jsonMap["FacebookPostId"],
      facebookASUId: jsonMap["FacebookASUId"],
      facebookUId: jsonMap["FacebookUId"],
      facebookName: jsonMap["FacebookName"],
      totalDays: jsonMap["TotalDays"],
      dateCreated: DateTime.parse(jsonMap["DateCreated"]),
    );
  }

  String facebookPostId, facebookASUId, facebookUId, facebookName;
  DateTime dateCreated;
  double totalDays;

  Map<String, dynamic> toMap({bool removeIfNull = true}) {
    final data = {
      "FacebookPostId": facebookPostId,
      "FacebookASUId": facebookASUId,
      "FacebookName": facebookName,
      "facebookUId": facebookUId,
      "TotalDays": totalDays,
      "DateCreated": dateCreated?.toIso8601String(),
    };
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
