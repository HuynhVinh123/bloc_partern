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
  const ListViewDataErrorInfoWidget(
      {this.errorMessage = StringResource.listviewErrorTitle, this.actions});

  final String errorMessage;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "$errorMessage",
                style: const TextStyle(color: Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: actions ??
                    <Widget>[
                      const SizedBox(),
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
