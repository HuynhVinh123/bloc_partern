import 'dart:async';

import 'package:flutter/material.dart';

class ModalWaitingWidget extends StatelessWidget {
  const ModalWaitingWidget({
    this.isBusyStream,
    this.child,
    this.initBusy = true,
    this.statusWidget,
    this.statusStream,
  });
  final Stream<bool> isBusyStream;
  final Stream<String> statusStream;
  final Widget statusWidget;
  final bool initBusy;
  final Widget child;

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
                const SizedBox(),
              Builder(
                builder: (ctx) {
                  if (snapshot.data == true && statusStream != null) {
                    return StreamBuilder(
                        stream: statusStream,
                        initialData: false,
                        builder: (ctx, statusSnapshot) {
                          if (statusSnapshot.hasError) {
                            return const SizedBox();
                          }
                          if (statusSnapshot.hasData) {
                            return Text("${snapshot.data}");
                          } else
                            return const SizedBox();
                        });
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          );
        });
  }
}
