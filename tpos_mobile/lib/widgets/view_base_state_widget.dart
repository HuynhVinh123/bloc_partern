import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';

class ViewBaseStateWidget extends StatelessWidget {
  const ViewBaseStateWidget({this.stateStream, this.isBusyStream, this.child});
  final Stream<bool> isBusyStream;
  final Stream<ViewModelState> stateStream;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ViewModelState>(
        stream: stateStream,
        initialData: ViewModelState(message: "", isBusy: true),
        builder: (context, snapshot) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              child,
              if (snapshot.data.isBusy == true)
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
              if (snapshot.data.isBusy == true)
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.transparent,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                const SizedBox(),
            ],
          );
        });
  }
}
