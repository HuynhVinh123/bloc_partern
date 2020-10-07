import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';
import '../app.dart';

extension BuildContextExtensions on BuildContext {
  Future showDefaultDialog(
      {AlertDialogType type = AlertDialogType.info,
      BuildContext context,
      String title,
      String content,
      String buttonTitle,
      String cancelTitle,
      List<Widget> actions,
      bool barrierDismissible = true}) async {
    return await App.showDefaultDialog(
      type: type,
      context: context,
      title: title,
      content: content,
      buttonTitle: buttonTitle,
      barrierDismissible: barrierDismissible,
      actions: actions,
    );
  }

  Future showToast(
      {String title,
      String message,
      AlertDialogType type,
      int durationSecond = 4}) async {
    return await App.showToast(
      title: title,
      message: message,
      type: type = type,
      context: this,
      durationSecond: durationSecond,
    );
  }

  Future navigateTo(Widget page) {
    return Navigator.push(
      this,
      MaterialPageRoute(
        builder: (context) {
          return page;
        },
      ),
    );
  }
}
