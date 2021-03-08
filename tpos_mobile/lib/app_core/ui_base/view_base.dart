import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';

class ViewBase<T extends ViewModelBase> extends StatelessWidget {
  const ViewBase(
      {this.defaultIndicatorColor,
      this.defaultIndicatorBackgroundColor,
      this.backgroundColor,
      this.builder,
      this.model});
  final Widget Function(BuildContext context, T model, Widget child) builder;

  final ViewModelBase model;
  final Color defaultIndicatorColor;
  final Color defaultIndicatorBackgroundColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
        value: model,
        child: Consumer<T>(
          builder: (_, md, child) {
            return Stack(
              children: <Widget>[
                builder(context, model, child),
                if (md.viewModelState.isBusy)
                  _buildDefaultIndicator(
                      message: md.viewModelState.message, context: context)
                else
                  const SizedBox(),
              ],
            );
          },
        ));
  }

  Widget _buildDefaultIndicator({String message, BuildContext context}) {
    return AbsorbPointer(
      child: Material(
        color:
            backgroundColor ?? Theme.of(context).primaryColor.withOpacity(0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitCircle(
              color: defaultIndicatorBackgroundColor ??
                  Theme.of(context).primaryColor,
            ),
            Text(message ?? ""),
          ],
        ),
      ),
    );
  }
}
