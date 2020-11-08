import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/helpers/tmt.dart';

class AppInputNumberField extends StatelessWidget {
  final double value;
  final String format;
  final InputDecoration decoration;
  final bool separatorNavigate;
  final String locate;
  final ValueChanged<double> onValueChanged;
  AppInputNumberField(
      {this.value = 0,
      this.format = "###,###,###",
      this.decoration,
      this.separatorNavigate = false,
      this.locate = "en_US",
      this.onValueChanged});

  TextEditingController _controller;

  void convertTextToDouble(String text) {
    onValueChanged(App.convertToDouble(text, locate));
  }

  @override
  Widget build(BuildContext context) {
    _controller = TextEditingController(
        text: NumberFormat(format, locate).format(value ?? 0));
    return TextField(
      controller: _controller,
      decoration: decoration,
      keyboardType:
          TextInputType.numberWithOptions(decimal: true, signed: true),
      onTap: () {
        _controller.selection = new TextSelection(
            baseOffset: 0, extentOffset: _controller.text.length);
      },
      onChanged: (text) {
        convertTextToDouble(text);
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        NumberInputFormat(format: format),
      ],
      textAlign: TextAlign.center,
    );
  }
}
