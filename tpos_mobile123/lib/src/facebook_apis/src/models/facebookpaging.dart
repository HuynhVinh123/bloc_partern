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

  FacebookListPaging({this.previous, this.next});

  factory FacebookListPaging.fromMap(Map<String, dynamic> jsonMap) {
    if (jsonMap == null)
      return null;
    else
      return new FacebookListPaging(
        previous: jsonMap["previous"],
        next: jsonMap["next"],
      );
  }
}
