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

/// Validate một địa chỉ Url hợp lệ. Dùng trong TextFormField
String validateUrl(String value) {
  if (value == null) {
    return null;
  }

  return value.isUrl() ? null : 'Địa chỉ url không hợp lệ'; //TODO(namnv): Dịch
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
