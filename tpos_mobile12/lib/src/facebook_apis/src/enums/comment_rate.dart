import 'package:flutter/foundation.dart';

enum CommentRate {
  one_per_two_seconds,
  ten_per_second,
  one_hundred_per_second,
}

extension CommentRateExtensions on CommentRate {
  String get describe => describeEnum(this);
}
