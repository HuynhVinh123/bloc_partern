/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NumberFieldWidget extends StatelessWidget {
  NumberFieldWidget({
    int initNumber = 0,
    Function(int) onChanged,
  }) {
    _initNumber = initNumber;
    _onChanged = onChanged;
    _textEditingController.text = initNumber.toString();
  }
  int _initNumber;
  Function(int) _onChanged;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(width: 1, color: Colors.green)),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              setDown();
            },
          ),
          Expanded(
            child: TextField(
              controller: _textEditingController,
              onChanged: (text) {
                _onChanged(int.parse(text));
              },
              decoration: const InputDecoration(
                  hintText: "10", border: InputBorder.none),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(decorationStyle: TextDecorationStyle.dotted),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              setUp();
            },
          ),
        ],
      ),
    );
  }

  void setUp() {
    _initNumber += 1;
    _textEditingController.text = _initNumber.toString();
    _onChanged(_initNumber);
  }

  void setDown() {
    if (_initNumber > 1) _initNumber -= 1;
    _textEditingController.text = _initNumber.toString();
    _onChanged(_initNumber);
  }
}
