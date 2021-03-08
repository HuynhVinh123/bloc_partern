import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../loading_indicator.dart';

class BlocUiProvider<T extends Bloc<dynamic, dynamic>> extends StatelessWidget {
  const BlocUiProvider({
    Key key,
    @required this.bloc,
    this.child,
    this.busyStates = const [],
    this.listen,
    this.errorState,
    this.errorBuilder,
  }) : super(key: key);
  final T bloc;
  final Widget child;
  final List<dynamic> busyStates;
  final dynamic errorState;
  final ValueChanged<dynamic> listen;
  final Widget Function(BuildContext context, dynamic state) errorBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>(
      create: (context) => bloc,
      child: Stack(children: [
        child,
        if (errorState != null)
          BlocBuilder<T, dynamic>(
            builder: (context, state) {
              if (state.runtimeType == errorState) {
                return errorBuilder(context, state) ??
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          Text("Đã gặp sự cố khi tải dữ liệu"),
                          Text("Vui lòng thử lại hoặc liên hệ trợ giúp"),
                        ],
                      ),
                    );
              }
              return const SizedBox();
            },
          ),
        if (busyStates.isNotEmpty || listen != null)
          BlocConsumer<T, dynamic>(
            listener: (context, state) {
              if (listen != null) {
                listen(state);
              }
            },
            builder: (context, state) {
              if (busyStates.any((element) => element == state.runtimeType)) {
                return const LoadingIndicator();
              }
              return const SizedBox();
            },
          ),
      ]),
    );
  }
}
