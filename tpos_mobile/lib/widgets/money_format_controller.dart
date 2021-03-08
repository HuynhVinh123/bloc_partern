import 'package:flutter/material.dart';

class CustomMoneyMaskedTextController extends TextEditingController {
  CustomMoneyMaskedTextController({
    this.decimalSeparator = ',',
    this.thousandSeparator = '.',
    this.rightSymbol = '',
    this.leftSymbol = '',
    this.precision = 2,
    this.maxLength = 16,
    this.minValue,
    this.maxValue = double.infinity,
    this.defaultValue,
    this.allowNagative = false,
  }) {
    _validateConfig();
    if (defaultValue != null) {
      text = defaultValue.toStringAsFixed(precision);
    } else {
      minValue = double.negativeInfinity;
    }

    addListener(() {
      if (text != null && text != '') {
        if (allowNagative) {
          updateValueString(stringValue);
        } else {
          updateValue(numberValue);
        }

        //afterChange(text, numberValue);
      } else {
        text = '';
      }
    });
  }

  final String decimalSeparator;
  final String thousandSeparator;
  final String rightSymbol;
  final String leftSymbol;
  final int precision;
  final int maxLength;
  final double defaultValue;
  final bool allowNagative;
  double maxValue;
  double minValue;

  Function afterChange = (String maskedValue, double rawValue) {};

  double _lastValue = 0.0;
  String _lastValueString = '0';

  bool isInteger(String s) {
    if (s == null) {
      return false;
    }
    final num value = num.tryParse(s);
    return value is int || value == value.roundToDouble();
  }

  void updateValueString(String value) {
    double valueToUse = double.tryParse(value);

    if (valueToUse != null) {
      if (valueToUse > maxValue) {
        valueToUse = maxValue;
      }
      if (valueToUse < minValue) {
        valueToUse = minValue;
      }

      if (value.length > maxLength) {
        valueToUse = double.tryParse(_lastValueString) ?? 0;
      } else {
        _lastValueString = value;
      }

      String masked = _applyMaskString(valueToUse.toStringAsFixed(0));
      if (rightSymbol.isNotEmpty) {
        masked += rightSymbol;
      }

      if (leftSymbol.isNotEmpty) {
        masked = leftSymbol + masked;
      }

      if (masked != text) {
        text = masked;

        final int cursorPosition = super.text.length - rightSymbol.length;
        selection = TextSelection.fromPosition(TextPosition(offset: cursorPosition));
      }
    }
  }

  void updateValue(double value) {
    double valueToUse = value;

    if (valueToUse != null) {
      if (valueToUse > maxValue) {
        valueToUse = maxValue;
      }
      if (valueToUse < minValue) {
        valueToUse = minValue;
      }
    }

    if (value.toStringAsFixed(0).length > maxLength) {
      valueToUse = _lastValue;
    } else {
      _lastValue = value;
    }

    String masked = _applyMask(valueToUse);

    if (rightSymbol.isNotEmpty) {
      masked += rightSymbol;
    }

    if (leftSymbol.isNotEmpty) {
      masked = leftSymbol + masked;
    }

    if (masked != text) {
      text = masked;

      final int cursorPosition = super.text.length - rightSymbol.length;
      selection = TextSelection.fromPosition(TextPosition(offset: cursorPosition));
    }
  }

  String get stringValue {
    if (text == '') {
      return minValue == double.negativeInfinity ? '0' : minValue.toString();
    }
    final List<String> parts = _getOnlyNumbers(text).split('').toList(growable: true);

    if (parts.isEmpty) {
      return '0';
    }

    parts.removeWhere((element) => element == '.');
    // if (parts.contains('-') && parts.length > 1) {
    //   final String subtract = parts.first;
    //   parts.removeAt(0);
    //   parts.insert(parts.length - precision, '.');
    //   parts.insert(0, subtract);
    // } else {
    //   parts.insert(parts.length - precision, '.');
    // }

    return parts.join();
  }

  double get numberValue {
    if (text == '') {
      return minValue == double.negativeInfinity ? 0 : minValue;
    }

    if (text == '-') {
      return 0;
    }

    final List<String> parts = _getOnlyNumbers(text).split('').toList(growable: true);
    if (parts.isEmpty) {
      return 1;
    }

    if (parts.contains('-') && parts.length > 1) {
      final String subtract = parts.first;
      parts.removeAt(0);
      parts.insert(parts.length - precision, '.');
      parts.insert(0, subtract);
    } else {
      parts.insert(parts.length - precision, '.');
    }

    return double.parse(parts.join());
  }

  void _validateConfig() {
    final bool rightSymbolHasNumbers = _getOnlyNumbers(rightSymbol).isNotEmpty;

    if (rightSymbolHasNumbers) {
      throw ArgumentError('rightSymbol must not have numbers.');
    }
  }

  String _getOnlyNumbers(String text) {
    String cleanedText = text.replaceAll('.', '');

    RegExp onlyNumbersRegex = RegExp(r'[^\d]');
    if (allowNagative) {
      onlyNumbersRegex = RegExp(r'^(([-]?)([0-9]+)?([.]?)([0-9]+)?)');
      final Iterable<Match> matches = onlyNumbersRegex.allMatches(text.replaceAll('.', ''));
      final List<Match> listOfMatches = matches.toList();
      cleanedText = listOfMatches.first.input.substring(listOfMatches.first.start, listOfMatches.first.end);
      return cleanedText;
    }

    cleanedText = cleanedText.replaceAll(onlyNumbersRegex, '');

    return cleanedText;
  }

  String _applyMaskString(String value) {
    String temp = value.replaceAll('.', '');
    final num number = num.tryParse(temp);
    temp = number.toStringAsFixed(0);
    temp = temp.replaceAll('.', '');

    final List<String> textRepresentation = temp.split('').reversed.toList(growable: true);

    if (textRepresentation.contains('-')) {
      textRepresentation.removeWhere((element) => element == '-');
    }

    textRepresentation.insert(0, decimalSeparator);

    for (int i = 4; true; i = i + 4) {
      if (textRepresentation.length > i) {
        textRepresentation.insert(i, thousandSeparator);
      } else {
        break;
      }
    }

    String result = textRepresentation.reversed.join('');
    if (value.contains('-')) {
      result = '-' + result;
    }

    return result;

    // if (isInteger(value)) {
    // } else {
    //   final List<String> textRepresentation = value.replaceAll('.', '').split('').reversed.toList(growable: true);
    //
    //   textRepresentation.insert(precision, decimalSeparator);
    //
    //   for (int i = precision + 4; true; i = i + 4) {
    //     if (textRepresentation.length > i) {
    //       textRepresentation.insert(i, thousandSeparator);
    //     } else {
    //       break;
    //     }
    //   }
    //
    //   return textRepresentation.reversed.join('');
    // }
  }

  String _applyMask(double value) {
    if (isInteger(value.toString())) {
      final List<String> textRepresentation = value.toStringAsFixed(0).split('').reversed.toList(growable: true);

      textRepresentation.insert(0, decimalSeparator);

      for (int i = 4; true; i = i + 4) {
        if (textRepresentation.length > i) {
          textRepresentation.insert(i, thousandSeparator);
        } else {
          break;
        }
      }

      return textRepresentation.reversed.join('');
    } else {
      final List<String> textRepresentation =
          value.toStringAsFixed(precision).replaceAll('.', '').split('').reversed.toList(growable: true);

      textRepresentation.insert(precision, decimalSeparator);

      for (int i = precision + 4; true; i = i + 4) {
        if (textRepresentation.length > i) {
          textRepresentation.insert(i, thousandSeparator);
        } else {
          break;
        }
      }

      return textRepresentation.reversed.join('');
    }
  }
}
