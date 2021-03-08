import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';

/// Hỗ trợ các vấn đề liên quan tới xử lý chuỗi trong ứng dụng
///
///
/// Kiểm tra email hợp lệ
String validateEmail(String value) {
  if (value == null) {
    return null;
  }

  return value.isEmail()
      ? null
      : 'Địa chỉ email không hợp lệ'; //TODO(namnv): Dịch
}

String validatePhone(String value, [String message]) {
  if (value.isNotNullOrEmpty() && !value.isPhoneNumber()) {
    return message ?? 'Số điện thoại không hợp lệ';
  }
  return null;
}

/// Validate một địa chỉ Url hợp lệ. Dùng trong TextFormField
String validateUrl(String value) {
  if (value == null) {
    return null;
  }

  return value.isUrl() ? null : 'Địa chỉ url không hợp lệ'; //TODO(namnv): Dịch
}

String validateName(String value) {
  if (value == null || value.isEmpty) {
    return 'Tên không hợp lệ';
  }
  return null;
}

String validateNumberRange(double value, [double from, double to]) {
  if (value.toDouble() < from || value.toDouble() > to) {
    return 'Giá trị số phải lớn hơn $from và nhỏ hơn $to';
  }
  return null;
}

/// Lấy số điện thoại trong một chuỗi
String getPhoneNumber(String textInput) {
  if (textInput != null) {
    textInput = textInput
        .replaceAll("o", "0")
        .replaceAll("i", "1")
        .replaceAll("O", "0")
        .replaceAll("I", "1");
    final String result = RegExp(RegexLibrary.phoneNumberPattern)
            .firstMatch(textInput)
            ?.group(1) ??
        "";

    return result.replaceAll(".", "").replaceAll("-", "").replaceAll(" ", "");
  } else {
    return "";
  }
}

/// Validate Ip hợp lệ
bool validateIpV4Address(String ip) {
  bool isResult = false;
  if (ip != null) {
    isResult = RegExp(RegexLibrary.ipV4Pattern).hasMatch(ip);
  }
  return isResult;
}
