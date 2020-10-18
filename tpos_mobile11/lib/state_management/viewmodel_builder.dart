import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tpos_mobile/state_management/viewmodel/base_viewmodel.dart';

/// UI builder base on PViewModelState
class PViewModelBuilder<T extends PViewModel> extends StatelessWidget {
  const PViewModelBuilder({Key key, this.builder, this.viewModel})
      : super(key: key);
  final Function(BuildContext context, T vm, PViewModelState state) builder;
  final T viewModel;

  @override
  Widget build(BuildContext context) {
    final PViewModel vm = viewModel ?? Provider.of<T>(context);
    return StreamBuilder<PViewModelState>(
      stream: vm.stateStream,
      builder: (context, snapshot) {
        return builder(context, vm, snapshot.data);
      },
    );
  }
}
