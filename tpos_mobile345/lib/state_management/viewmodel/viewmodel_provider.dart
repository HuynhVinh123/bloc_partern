import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tpos_mobile/state_management/viewmodel/base_viewmodel.dart';

class ViewModelProvider<PViewModel extends ChangeNotifier>
    extends StatelessWidget {
  const ViewModelProvider(
      {Key key,
      @required this.viewModel,
      this.busyStateType,
      this.child,
      this.onStateChanged,
      this.disableIndicator = false})
      : assert(viewModel != null),
        super(key: key);
  final PViewModel viewModel;
  final Type busyStateType;
  final Widget child;
  final Function(dynamic, PViewModel vm) onStateChanged;
  final bool disableIndicator;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PViewModel>.value(
      value: viewModel,
      child: Stack(
        children: [
          child,
          if (!disableIndicator || onStateChanged != null)
            StreamBuilder<dynamic>(builder: (context, snapshot) {
              if (onStateChanged != null) {
                onStateChanged(snapshot.data, viewModel);
              }
              if (snapshot.data.runtimeType ==
                  (busyStateType ?? PViewModelLoading)) {
                return _buildDefaultIndicator();
              }
              return const SizedBox();
            }),
        ],
      ),
    );
  }

  Widget _buildDefaultIndicator({String message, BuildContext context}) {
    return Material(
      color: Theme.of(context).primaryColor.withOpacity(0.2),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  spreadRadius: 0,
                  blurRadius: 0,
                  color: Colors.grey,
                )
              ],
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 50,
                  height: 50,
                  child: SpinKitCircle(
                    color: Theme.of(context).primaryColor,
                    size: 50,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(child: Text(message ?? "")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
