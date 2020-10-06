import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/dialog/app_alert_dialog.dart';

extension BuildContextExtensions on BuildContext {
  Future showAppDialog(
      {String title,
      String messsage,
      AlertDialogType type = AlertDialogType.info,
      List<Widget> actions}) async {
    assert(type != null);
    List<Widget> defaultAction = <Widget>[];

    await showDialog(
      context: this,
      builder: (context) {
        return AppAlertDialog(
          title: Text(title ?? type.defaultTitle),
          content: Text(messsage ?? ''),
          actions: actions ?? type.getDefaultActions(),
        );
      },
    );
  }

  void showSnackBar({String message, String title, AlertDialogType type}) {
    final scaffold = Scaffold.of(this);
    if (scaffold != null) {
      scaffold.removeCurrentSnackBar();
      scaffold.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: type.backgroundColor,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  void showNotify({String message, String title, AlertDialogType type}) {
    Flushbar(
      margin: EdgeInsets.all(12),
      borderRadius: 12,
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: 5),
      backgroundColor: type.textColor,
      message: message ?? '',
      barBlur: 5,
      title: title ?? type.defaultTitle,
      icon: type.icon,
    ).show(this);
  }

  Future showAlertDialogWrapper(Widget child,
      {Widget title, List<Widget> actions}) async {
    return await showDialog(
      context: this,
      builder: (context) {
        return AlertDialog(
          content: child,
          actions: actions,
        );
      },
    );
  }
}
