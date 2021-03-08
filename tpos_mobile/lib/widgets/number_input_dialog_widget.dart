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
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

// ignore: must_be_immutable
class NumberInputDialogWidget extends StatelessWidget {
  NumberInputDialogWidget(
      {double currentValue, bool useSeperate, this.formats}) {
    number = currentValue;
    useSeperate = useSeperate;
    number ??= 0;

    _editingController.text = NumberFormat("###,###,###.###", "vi_VN")
        .format(number)
        .replaceAll(".", "");
    _editingController.selection = TextSelection(
        baseOffset: 0, extentOffset: _editingController.text.length);
  }
  final TextEditingController _editingController = TextEditingController();
  final bool useSeperate = false;
  double number;
  final List<TextInputFormatter> formats;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Nhập số lượng
      title: Text(
        S.current.enterTheQuantity,
        style: const TextStyle(color: Colors.green),
      ),
      content: TextField(
        onTap: () {
//          _editingController.selection = TextSelection(
//              baseOffset: 0,
//              extentOffset: _editingController.value.text.length);
        },
        autofocus: true,
        inputFormatters: formats ?? <TextInputFormatter>[],
        controller: _editingController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        maxLength: 15,
        decoration: const InputDecoration(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
          prefixIcon: Icon(
            Icons.dialpad,
            color: Colors.green,
          ),
        ),
      ),
      // Đồng ý
      actions: <Widget>[
        FlatButton(
          child: Text(
            S.current.confirm,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
