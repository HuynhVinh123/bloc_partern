/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import '../models.dart';

class FetchFacebookListResult<T> {
  T data;
  FacebookListPaging paging;

  FetchFacebookListResult({T data, FacebookListPaging paging});

  factory FetchFacebookListResult.fromMap(Map<String, dynamic> jsonMap) {
    return new FetchFacebookListResult();
  }
}
