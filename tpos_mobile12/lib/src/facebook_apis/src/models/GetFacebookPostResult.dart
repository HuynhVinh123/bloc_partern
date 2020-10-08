/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:tpos_mobile/src/facebook_apis/facebook_api.dart';

class GetFacebookPostResult {
  FacebookApiError error;
  List<FacebookPost> data;
  FacebookListPaging paging;

  GetFacebookPostResult({this.data, this.paging});

  GetFacebookPostResult.fromMap(Map<String, dynamic> jsonMap) {
    if (jsonMap["data"] != null) {
      data = (jsonMap["data"] as List)
          .map((f) => FacebookPost.fromMap(f))
          .toList();
    }

    if (jsonMap["paging"] != null) {
      paging = FacebookListPaging.fromMap(
        jsonMap["paging"],
      );
    }

    if (jsonMap["error"] != null) {
      error = FacebookApiError.fromJson(jsonMap["error"]);
    }
  }
}
