import 'package:flutter/widgets.dart';

/// Wrap your root App widget in this widget and call [AppWrapper.rebirth] to restart your app.
class AppWrapper extends StatefulWidget {
  const AppWrapper({this.child});
  final Widget child;

  @override
  _AppWrapperState createState() => _AppWrapperState();

  static reset(BuildContext context) {
    context.findAncestorStateOfType<_AppWrapperState>().restartApp();
  }
}

class _AppWrapperState extends State<AppWrapper> {
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: widget.child,
    );
  }
}
