import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum PageStateType {
  listEmpty,
  dataEmpty,
  dataError,
}

extension PageStateTypeExtensions on PageStateType {
  String get describe => describeEnum(this);

  Widget get icon {
    switch (this) {
      case PageStateType.listEmpty:
        return Icon(
          Icons.info,
          color: Colors.grey.shade300,
          size: 70,
        );
      case PageStateType.dataEmpty:
        return Icon(
          Icons.info,
          color: Colors.grey.shade300,
          size: 70,
        );
      case PageStateType.dataError:
        return Icon(
          Icons.info,
          color: Colors.grey.shade300,
          size: 70,
        );
      default:
        return Icon(
          Icons.info,
          color: Colors.grey.shade300,
          size: 70,
        );
    }
  }

  String get title {
    switch (this) {
      case PageStateType.listEmpty:
        return 'Danh sách hiện đang trống.!';
      case PageStateType.dataEmpty:
        return 'Không có dữ liệu!';
      case PageStateType.dataError:
        return 'Đã xảy ra lỗi!';
        break;
    }
  }

  String get message {
    switch (this) {
      case PageStateType.listEmpty:
        return 'Vui lòng kiểm tra lại điều kiện lọc và từ khóa tìm kiếm. Nhấn thêm mới để thêm một đối tượng.!';
      case PageStateType.dataEmpty:
        return '';
      case PageStateType.dataError:
        return 'Chúng tôi đã cố gắng lấy dữ liệu cho bạn nhưng không thành công';
    }
  }
}
