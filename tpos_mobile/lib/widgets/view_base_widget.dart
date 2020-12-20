/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';

@Deprecated('This view will be deprecated from version 1.8.0')
class ViewBaseWidget extends StatelessWidget {
  const ViewBaseWidget(
      {this.isBusyStream,
      this.stateStream,
      this.child,
      this.propertyChangedStream});
  final Stream<bool> isBusyStream;
  final Stream<ViewModelState> stateStream;
  final Stream<String> propertyChangedStream;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: isBusyStream,
        initialData: true,
        builder: (context, snapshot) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              StreamBuilder<String>(
                  stream: propertyChangedStream,
                  initialData: "",
                  builder: (context, snapshot) {
                    return child;
                  }),
              if (snapshot.data == true)
                Opacity(
                  opacity: 0.2,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.green,
                  ),
                )
              else
                const SizedBox(),
              if (snapshot.data == true)
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.transparent,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                SizedBox(),
            ],
          );
        });
  }
}
