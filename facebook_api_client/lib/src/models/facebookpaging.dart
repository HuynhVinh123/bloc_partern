/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class FacebookListPaging {
  String previous;
  String next;

  FacebookListCursor cursors;

  FacebookListPaging({this.previous, this.next, this.cursors});

  factory FacebookListPaging.fromMap(Map<String, dynamic> jsonMap) {
    if (jsonMap == null)
      return null;
    else
      return new FacebookListPaging(
        previous: jsonMap["previous"],
        next: jsonMap["next"],
        cursors: jsonMap['cursors'] != null
            ? FacebookListCursor.fromJson(jsonMap['cursors'])
            : null,
      );
  }
}

class FacebookListCursor {
  FacebookListCursor({this.before, this.after});
  FacebookListCursor.fromJson(Map<String, dynamic> json) {
    before = json["before"];
    after = json['after'];
  }
  String before;
  String after;
}
