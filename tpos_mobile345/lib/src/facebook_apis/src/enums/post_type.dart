/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:flutter/foundation.dart';

enum FacebookPostType {
  link,
  status,
  photo,
  video,
  offer,
  all,
}

extension FacebookPostTypeExtensions on FacebookPostType {
  String describle() {
    return describeEnum(this);
  }
}
