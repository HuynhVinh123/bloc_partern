import 'package:flutter/material.dart';

class CustomMoneyMaskedTextController extends TextEditingController {
  CustomMoneyMaskedTextController(
      {this.decimalSeparator = ',',
      this.thousandSeparator = '.',
      this.rightSymbol = '',
      this.leftSymbol = '',
      this.precision = 2,
      this.maxLength = 16,
      this.minValue,
      this.maxValue = double.infinity,
      this.defaultValue}) {
    _validateConfig();
    if (defaultValue != null) {
      text = defaultValue.toStringAsFixed(precision);
    } else {
      minValue = double.negativeInfinity;
    }

    addListener(() {
      if (text != null && text != '') {
        updateValue(numberValue);
        afterChange(text, numberValue);
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
  double maxValue;
  double minValue;

  Function afterChange = (String maskedValue, double rawValue) {};

  double _lastValue = 0.0;

  bool isInteger(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
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

  double get numberValue {
    if (text == '') {
      return minValue == double.negativeInfinity ? 0 : minValue;
    }
    final List<String> parts = _getOnlyNumbers(text).split('').toList(growable: true);
    if (parts.isEmpty) {
      return 1;
    }
    parts.insert(parts.length - precision, '.');

    return double.parse(parts.join());
  }

  void _validateConfig() {
    final bool rightSymbolHasNumbers = _getOnlyNumbers(rightSymbol).isNotEmpty;

    if (rightSymbolHasNumbers) {
      throw ArgumentError('rightSymbol must not have numbers.');
    }
  }

  String _getOnlyNumbers(String text) {
    String cleanedText = text;

    final RegExp onlyNumbersRegex = RegExp(r'[^\d]');

    cleanedText = cleanedText.replaceAll(onlyNumbersRegex, '');

    return cleanedText;
  }

  String _applyMask(double value) {
    if (isInteger(value.toString())) {
      final List<String> textRepresentation =
          value.toStringAsFixed(0).split('').reversed.toList(growable: true);

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
