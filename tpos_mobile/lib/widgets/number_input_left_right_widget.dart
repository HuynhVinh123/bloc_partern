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
  const NumberInputLeftRightWidget(
      {this.onChanged,
      Key key,
      this.value = 0.0,
      this.seedValue = 1.0,
      this.numberFormat,
      this.fontWeight = FontWeight.normal,
      this.textStyle = const TextStyle(color: Colors.black)})
      : super(key: key);

  final double value;
  final double seedValue;
  final Function(double) onChanged;
  final String numberFormat;
  final FontWeight fontWeight;
  final TextStyle textStyle;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 35,
            child: Material(
              color: Colors.white,
              child: OutlineButton(
                color: Colors.white,
                child: const Icon(
                  Icons.remove,
                  size: 12,
                ),
                onPressed: () {
                  if (value > seedValue) {
                    final double tempValue = value - seedValue;
                    if (onChanged != null) onChanged(tempValue);
                  }
                },
                padding: const EdgeInsets.all(0),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: SizedBox(
              //width: double.infinity,
              child: Material(
                child: OutlineButton(
                  padding: EdgeInsets.zero,
                  color: Colors.white,
                  borderSide:
                      const BorderSide(width: 0, style: BorderStyle.none),
                  child: Text(
                    "${NumberFormat("###,###,###.###", "vi_VN").format(value)}",
                    style: TextStyle(fontWeight: fontWeight),
                  ),
                  onPressed: () async {
                    final value = await showDialog(
                        context: context,
                        builder: (ctx) {
                          return NumberInputDialogWidget(
                            currentValue: this.value,
                            formats: [
                              PercentInputFormat(
                                  locate: "vi_VN", format: "###,###.###"),
                            ],
                          );
                        });

                    if (value != null) {
                      final double tempValue = value + seedValue;
                      if (onChanged != null) onChanged(tempValue);
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          SizedBox(
            width: 35,
            child: Material(
              color: Colors.white,
              child: OutlineButton(
                color: Colors.white,
                child: const Icon(
                  Icons.add,
                  size: 12,
                ),
                onPressed: () {
                  if (onChanged != null) onChanged(value + seedValue);
                },
                padding: const EdgeInsets.all(0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
