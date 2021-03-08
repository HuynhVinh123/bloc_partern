/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/5/19 4:54 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/5/19 4:45 PM
 *
 */

import 'package:flutter/material.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class AppbarSearchWidget extends StatefulWidget {
  const AppbarSearchWidget({
    Key key,
    this.keyword = "",
    this.autoFocus = false,
    this.onTextChange,
    this.button,
  }) : super(key: key);

  final Function(String) onTextChange;
  final Widget button;
  final bool autoFocus;
  final String keyword;

  @override
  _AppbarSearchWidgetState createState() => _AppbarSearchWidgetState();
}

class _AppbarSearchWidgetState extends State<AppbarSearchWidget> {
  final TextEditingController _keywordTextController = TextEditingController();
  String keyWordTemp;

  @override
  void initState() {
    keyWordTemp = widget.keyword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (keyWordTemp != widget.keyword)
      _keywordTextController.text = widget.keyword;
    final _border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(
            color: Colors.white, width: 1, style: BorderStyle.solid));

    return TextField(
      autofocus: widget.autoFocus,
      controller: TextEditingController.fromValue(TextEditingValue(
          text: _keywordTextController.text,
          selection: TextSelection.collapsed(
              offset: _keywordTextController.text.length))),
      scrollPadding: const EdgeInsets.all(0),
      // Tìm kiếm
      decoration: InputDecoration(
        border: _border,
        fillColor: Colors.white,
        hintText: "${S.current.search}...",
        filled: true,
        isDense: true,
        contentPadding:
            const EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
        suffixIcon: _keywordTextController.text == ""
            ? const SizedBox()
            : IconButton(
                padding: const EdgeInsets.all(0),
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.grey,
                  size: 17,
                ),
                onPressed: () {
                  _keywordTextController.clear();
                  if (widget.onTextChange != null) widget.onTextChange("");
                },
              ),
      ),
      onChanged: (text) {
        _keywordTextController.clear();
        if (widget.onTextChange != null) widget.onTextChange(text);
      },
    );
  }
}
