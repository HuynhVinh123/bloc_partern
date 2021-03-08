import 'package:flutter/cupertino.dart';
import 'package:tmt_flutter_viewmodel/tmt_flutter_viewmodel.dart';

class ProviderVmState<T extends ProviderVM> extends StatelessWidget {
  const ProviderVmState({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
      ],
    );
  }
}
