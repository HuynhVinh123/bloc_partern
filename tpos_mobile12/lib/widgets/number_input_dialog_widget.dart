/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile/helpers/tmt.dart';

// ignore: must_be_immutable
class NumberInputDialogWidget extends StatelessWidget {
  final TextEditingController _editingController = new TextEditingController();
  final bool useSeperate = false;
  double number;
  final List<TextInputFormatter> formats;

  NumberInputDialogWidget(
      {double currentValue, bool useSeperate, this.formats}) {
    number = currentValue;
    useSeperate = useSeperate;
    if (number == null) {
      number = 0;
    }

    _editingController.text = NumberFormat("###,###,###.###", "vi_VN")
        .format(number)
        .replaceAll(".", "");
    _editingController.selection = new TextSelection(
        baseOffset: 0, extentOffset: _editingController.text.length);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(
        "Nhập số lượng",
        style: TextStyle(color: Colors.green),
      ),
      content: new TextField(
        onTap: () {
//          _editingController.selection = TextSelection(
//              baseOffset: 0,
//              extentOffset: _editingController.value.text.length);
        },
        autofocus: true,
        inputFormatters: formats ?? new List<TextInputFormatter>(),
        controller: _editingController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        maxLength: 15,
        decoration: new InputDecoration(
          border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.teal)),
          prefixIcon: const Icon(
            Icons.dialpad,
            color: Colors.green,
          ),
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text(
            "Đồng ý",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          onPressed: () {
            number =
                App.convertToDouble(_editingController.text.trim(), "vi_VN");
            Navigator.of(context).pop(number);
          },
        ),
      ],
    );
  }
}
