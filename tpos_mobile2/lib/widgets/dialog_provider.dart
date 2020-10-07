import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

class DialogProvider extends StatefulWidget {
  const DialogProvider({this.child, Key key}) : super(key: key);
  final Widget child;

  @override
  _DialogProviderState createState() => _DialogProviderState();
}

class _DialogProviderState extends State<DialogProvider> {
  final _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
