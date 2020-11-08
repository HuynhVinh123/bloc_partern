import 'dart:async';
import 'package:flutter/material.dart';

class ModalWaitingWidget extends StatelessWidget {
  final Stream<bool> isBusyStream;
  final Stream<String> statusStream;
  final Widget statusWidget;
  final initBusy;
  final Widget child;
  ModalWaitingWidget({
    this.isBusyStream,
    this.child,
    this.initBusy = true,
    this.statusWidget,
    this.statusStream,
  });
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: isBusyStream,
        initialData: initBusy,
        builder: (context, snapshot) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              child,
              (snapshot.data == true)
                  ? Opacity(
                      opacity: 0.2,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.green,
                      ),
                    )
                  : SizedBox(),
              (snapshot.data == true)
                  ? Container(
                      height: 100,
                      width: 100,
                      color: Colors.transparent,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox(),
              Builder(
                builder: (ctx) {
                  if (snapshot.data == true && statusStream != null) {
                    return StreamBuilder(
                        stream: this.statusStream,
                        initialData: false,
                        builder: (ctx, statusSnapshot) {
                          if (statusSnapshot.hasError) {
                            return SizedBox();
                          }
                          if (statusSnapshot.hasData) {
                            return Text("${snapshot.data}");
                          } else
                            return SizedBox();
                        });
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          );
        });
  }
}
