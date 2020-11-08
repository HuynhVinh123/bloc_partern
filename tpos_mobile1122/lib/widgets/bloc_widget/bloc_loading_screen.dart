import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../loading_indicator.dart';

class BlocLoadingScreen<T extends Bloc<dynamic, dynamic>>
    extends StatelessWidget {
  const BlocLoadingScreen(
      {Key key,
      this.bloc,
      this.child,
      this.busyStates = const [],
      this.isModal = true})
      : super(key: key);
  final T bloc;
  final Widget child;
  final List<dynamic> busyStates;
  final bool isModal;

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, alignment: Alignment.topLeft, children: [
      child,
      BlocBuilder<T, dynamic>(
        builder: (context, state) {
          if (busyStates.any((element) => element == state.runtimeType)) {
            if (isModal) {
              return LoadingIndicator();
            } else {
              return const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(),
              );
            }
          }
          return SizedBox();
        },
      ),
    ]);
  }
}
