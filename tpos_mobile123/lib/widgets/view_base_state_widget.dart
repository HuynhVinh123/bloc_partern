import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';

class ViewBaseStateWidget extends StatelessWidget {
  final Stream<bool> isBusyStream;
  final Stream<ViewModelState> stateStream;
  final Widget child;
  ViewBaseStateWidget({this.stateStream, this.isBusyStream, this.child});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ViewModelState>(
        stream: stateStream,
        initialData: new ViewModelState(message: "", isBusy: true),
        builder: (context, snapshot) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              child,
              (snapshot.data.isBusy == true)
                  ? Opacity(
                      opacity: 0.2,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.green,
                      ),
                    )
                  : SizedBox(),
              (snapshot.data.isBusy == true)
                  ? Container(
                      height: 100,
                      width: 100,
                      color: Colors.transparent,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox(),
            ],
          );
        });
  }
}
