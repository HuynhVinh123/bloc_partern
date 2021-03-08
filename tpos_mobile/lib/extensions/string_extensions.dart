import 'package:tpos_mobile/helpers/string_helper.dart';

extension StringExtensions on String {
  /// Whether the string contain the email.
  /// Example: Chot don 0908075555 contain a phone is '0908075555'.
  bool isContainEmail() {
    if (this == null) {
      return false;
    }
    const String pattern = '([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+)';
    return RegExp(pattern).hasMatch(this);
  }

  /// Whether the string contain the phone number.
  /// Example: Chot don 0908075555 contain a phone is '0908075555'.
  bool isContainPhone() {
    if (this == null) return false;
    final phone = getPhoneNumber(this);
    if (phone != null && phone != '') {
      return true;
    } else {
      return false;
    }
  }
}

extension BoolParsing on String {
  bool parseBool() {
    return toLowerCase() == 'true';
  }
}
