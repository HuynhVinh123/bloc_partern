/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:tpos_mobile/src/facebook_apis/facebook_api.dart';

class FetchFacebookCommentResult {
  List<FacebookComment> data;
  FacebookListPaging paging;

  FetchFacebookCommentResult({this.data, this.paging});

  factory FetchFacebookCommentResult.fromMap(Map<String, dynamic> jsonMap) {
    return FetchFacebookCommentResult(
      data: jsonMap["data"] != null
          ? (jsonMap["data"] as List)
              .map(
                (cm) => FacebookComment.fromMap(cm),
              )
              .toList()
          : null,
      paging: FacebookListPaging.fromMap(jsonMap["paging"]),
    );
  }
}
