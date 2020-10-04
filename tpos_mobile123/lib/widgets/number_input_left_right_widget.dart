/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/16/19 5:56 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/16/19 1:41 PM
 *
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'number_input_dialog_widget.dart';
// ignore: must_be_immutable

class NumberInputLeftRightWidget extends StatelessWidget {
  final Key key;
  final double value;
  final double seedValue;
  final Function(double) onChanged;
  final String numberFormat;
  final FontWeight fontWeight;
  final TextStyle textStyle;
  NumberInputLeftRightWidget(
      {this.onChanged,
      this.key,
      this.value = 0.0,
      this.seedValue = 1.0,
      this.numberFormat,
      this.fontWeight = FontWeight.normal,
      this.textStyle = const TextStyle(color: Colors.black)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: new Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new SizedBox(
            width: 35,
            child: Material(
              color: Colors.white,
              child: OutlineButton(
                color: Colors.white,
                child: Icon(
                  Icons.remove,
                  size: 12,
                ),
                onPressed: () {
                  if (value > this.seedValue) {
                    double newValue = value - this.seedValue;
                    if (onChanged != null) onChanged(newValue);
                  }
                },
                padding: EdgeInsets.all(0),
              ),
            ),
          ),
          new SizedBox(
            width: 5,
          ),
          Expanded(
            child: new SizedBox(
              //width: double.infinity,
              child: Material(
                child: OutlineButton(
                  padding: EdgeInsets.zero,
                  color: Colors.white,
                  borderSide: BorderSide(width: 0, style: BorderStyle.none),
                  child: Text(
                    "${NumberFormat("###,###,###.###", "vi_VN").format(value)}",
                    style: TextStyle(fontWeight: this.fontWeight),
                  ),
                  onPressed: () async {
                    var value = await showDialog(
                        context: context,
                        builder: (ctx) {
                          return new NumberInputDialogWidget(
                            currentValue: this.value,
                            formats: [
                              PercentInputFormat(
                                  locate: "vi_VN", format: "###,###.###"),
                            ],
                          );
                        });

                    if (value != null) {
                      var newValue = value;
                      if (onChanged != null) onChanged(newValue);
                    }
                  },
                ),
              ),
            ),
          ),
          new SizedBox(
            width: 5,
          ),
          new SizedBox(
            width: 35,
            child: Material(
              color: Colors.white,
              child: OutlineButton(
                color: Colors.white,
                child: Icon(
                  Icons.add,
                  size: 12,
                ),
                onPressed: () {
                  if (onChanged != null) onChanged(value + seedValue);
                },
                padding: EdgeInsets.all(0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
