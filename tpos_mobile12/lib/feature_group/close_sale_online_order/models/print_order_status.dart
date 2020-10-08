import 'package:flutter/foundation.dart';

enum PrintOrderStatus {
  none,
  success,
  error,
  inQueue,
}

extension PrintOrderStatusExtensions on PrintOrderStatus {
  String get describe => describeEnum(this);
  String get description {
    switch (this) {
      case PrintOrderStatus.none:
        return 'Chưa in';
      case PrintOrderStatus.success:
        return 'Thành công';
      case PrintOrderStatus.error:
        return 'In lỗi';
      case PrintOrderStatus.inQueue:
        return 'Đang chờ';
      default:
        return 'N/A';
    }
  }
}
