import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/helpers/string_helper.dart';

extension StringExtensions on String {
  bool isContainEmail() {
    if (this == null) {
      return false;
    }
    const String pattern = '([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+)';
    return RegExp(pattern).hasMatch(this);
  }

  bool isContainPhone() {
    if (this == null) return false;
    var phone = getPhoneNumber(this);
    if (phone != null && phone != '') {
      return true;
    } else {
      return false;
    }
  }
}
