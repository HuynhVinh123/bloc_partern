/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile/resources/string_resources.dart';
import 'package:version/version.dart';

/// Định dạng sô theo tiền viêt nam
String vietnameseCurrencyFormat(double input, {String sysmbol = ""}) {
  return input != null
      ? NumberFormat("###,###,###", "vi-VN").format(input)
      : null;
}

/// So sánh 2 phiên bản phần mềm dạng 1.3.5 hoặc 1.10
/// Nếu source > des thì trả về true
/// ngược lại trả về false
bool compareVersion(String source, String des) {
  final vera = Version.parse(source);
  final verb = Version.parse(des);
  if (vera > verb)
    return true;
  else
    return false;
}

class RegexLibrary {
  static const String phoneNumberPattern =
      r"(?:\b|[^0-9])((0|84|\+84)(\s?)([2-9]|1[0-9])(\d(\s|\.)?){8})(?:\b|[^0-9])";

  static const String phoneNumberPattern2 =
      r"((0|84|\+84)(\s?)([2-9]|1[0-9])(\d(\s|\.)?){8})";

  /// 250-255 | 200-249 | (0|1)? [0-9] [0-9]?
  static const String ipV4Pattern =
      r"^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$";
}

class CurrencyInputFormatter extends TextInputFormatter {
  CurrencyInputFormatter({this.locate});
  final String locate;
  double value;

  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    value = double.parse(newValue.text);

    final formatter = NumberFormat(
        "###,###,###,###", locate ?? StringResource.defaultSeparateLocate);

    final String newText = formatter.format(value);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}

class NumberInputFormat extends TextInputFormatter {
  NumberInputFormat(
      {this.locate = StringResource.defaultSeparateLocate,
      this.value = 0,
      this.format = "###,###,###,###",
      this.sufix = ""});
  NumberInputFormat.vietnameDong(
      {this.format = "###,###,###,###,###",
      this.locate = "vi-VN",
      this.value,
      this.sufix = ""});
  final String locate;
  double value;
  final String format;
  final String sufix;

  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    value = double.parse(newValue.text);

    final formatter = NumberFormat(format, locate);

    final String newText = "${formatter.format(value)}$sufix";

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}

class PercentInputFormat extends TextInputFormatter {
  PercentInputFormat({this.locate, this.format});
  final String locate;
  final String format;
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String newText = newValue.text;
    switch (locate) {
      case "vi_VN":
        newText =
            newValue.text.trim().replaceAll(".", ",").replaceAll(",", ",");
        break;
      case "vi-VN":
        newText =
            newValue.text.trim().replaceAll(".", ",").replaceAll(",", ",");
        break;

      case "en_US":
        newText = newValue.text.trim().replaceAll(",", ".");
        if (newText == null || newText == "") newText = "0";
        break;

      case "en-US":
        newText = newValue.text.trim().replaceAll(",", ".");
        if (newText == null || newText == "") newText = "0";
        break;
    }

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}
