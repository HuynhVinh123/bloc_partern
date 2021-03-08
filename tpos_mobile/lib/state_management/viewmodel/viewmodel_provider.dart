import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tpos_mobile/state_management/viewmodel/base_viewmodel.dart';

/// Một widget triển khai ChangeNotifierProvider sử dụng cho [BaseViewModel]
/// Đồng thời cung câp sẵn overlay Loading... khi trạng thái của ViewModel là Loading hoặc Busy
class ViewModelProvider<T extends PViewModel> extends StatelessWidget {
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
    return ChangeNotifierProvider<T>.value(
      value: viewModel,
      child: Stack(
        children: [
          child,
          if (!disableIndicator)
            StreamBuilder<PViewModelState>(
              stream: viewModel.stateStream,
              initialData: viewModel.state,
              builder: (context, AsyncSnapshot<PViewModelState> snapshot) {
                final data = snapshot.data;
                if (data is PViewModelBusy) {
                  return _buildDefaultIndicator(
                      context: context, message: data.message);
                }
                return const SizedBox();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildDefaultIndicator({String message, BuildContext context}) {
    return Material(
      color: Colors.grey.withOpacity(0.5),
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
