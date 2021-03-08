import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///format textfeild khi nhập dựa vào regex truyền vào
class RegExInputFormatter implements TextInputFormatter {
  RegExInputFormatter._(this._regExp);

  factory RegExInputFormatter.withRegex(String regexString) {
    try {
      final RegExp regex = RegExp(regexString);
      return RegExInputFormatter._(regex);
    } catch (e) {
      // Something not right with regex string.
      assert(false, e.toString());
      return null;
    }
  }

  final RegExp _regExp;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final bool oldValueValid = _isValid(oldValue.text);
    final bool newValueValid = _isValid(newValue.text);

    if (oldValueValid && !newValueValid) {
      if(isNumeric(newValue.text)){

        if (newValue.text.length > 1) {
          if (isInteger(double.tryParse(newValue.text))) {
            final String value = int.tryParse(newValue.text).toString();
            final int cursorPosition = value.length;
            final TextSelection selection = TextSelection.fromPosition(TextPosition(offset: cursorPosition));
            return newValue.copyWith(text: value , selection: selection);
          } else {
            final String value = double.tryParse(newValue.text).toString();
            final int cursorPosition = value.length;
            final TextSelection selection = TextSelection.fromPosition(TextPosition(offset: cursorPosition));
            return newValue.copyWith(text: value , selection: selection);
          }
        }
      }


      return oldValue;
    }

    return newValue;
  }

  bool isInteger(num value) =>
      value is int || value == value.roundToDouble();

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null || int.parse(s, onError: (e) => null) != null;
  }

  bool _isValid(String value) {
    try {
      final Iterable<RegExpMatch> matches = _regExp.allMatches(value);
      for (final Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}