/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/5/19 4:54 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/5/19 4:45 PM
 *
 */

import 'package:flutter/material.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SearchAppBarCustomWidget extends StatelessWidget {
  const SearchAppBarCustomWidget(
      {Key key, this.controller, this.onChanged, this.color = Colors.white})
      : super(key: key);
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(50)),
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 12,
          ),
          Icon(
            Icons.search,
            color: color,
          ),
          Expanded(
            child: Center(
              child: Container(
                  height: 35,
                  margin: const EdgeInsets.only(left: 4),
                  child: Center(
                    child: TextField(
                      controller: controller,
                      onChanged: (text) {
                        onChanged?.call(text);
                      },
                      autofocus: true,
                      decoration: InputDecoration.collapsed(
                        hintText: S.current.search,
                        border: InputBorder.none,
                      ),
                    ),
                  )),
            ),
          ),
          Visibility(
            visible: true,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.grey,
                size: 18,
              ),
              onPressed: () {
                onChanged?.call("");
                controller?.clear();
              },
            ),
          )
        ],
      ),
    );
  }
}
