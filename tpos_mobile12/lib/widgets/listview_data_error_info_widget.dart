/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:flutter/material.dart';
import 'package:tpos_mobile/resources/string_resources.dart';

class ListViewDataErrorInfoWidget extends StatelessWidget {
  final String errorMessage;
  final List<Widget> actions;

  ListViewDataErrorInfoWidget(
      {this.errorMessage = StringResource.listviewErrorTitle, this.actions});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "$errorMessage",
                style: TextStyle(color: Colors.red),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: actions ??
                    <Widget>[
                      SizedBox(),
                    ],
              ),
            )
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
    );
  }
}
