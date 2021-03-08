import 'package:flutter/material.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/extensions.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';

/// Dialog for show dialog on bossiness logic class;
/// TODO(namnv): Đổi ten thành 'DialogService' sau khi loại bỏ DialogService cũ
class NewDialogService {
  GlobalKey<NavigatorState> get navigationKey => App.navigatorKey;
  BuildContext get overlayContext => App.overlayContext;

  Future showDialog(
      {AlertDialogType type,
      String title,
      String content,
      bool barrierDismissible = true,
      buttonTitle,
      cancelTitle}) async {
    await overlayContext.showDefaultDialog(
      type: type,
      title: title,
      content: content,
      barrierDismissible: barrierDismissible,
    );
  }

  Future showToast({
    String title,
    @required String message,
    AlertDialogType type = AlertDialogType.info,
    int durationSecond = 4,
    double marginBottom = 12,
  }) async {
    return await App.showToast(
      message: message,
      title: title,
      type: type,
      durationSecond: durationSecond,
      paddingBottom: marginBottom,
    );
  }

  // Future showSnackbar({
  //   String title,
  //   @required String message,
  //   AlertDialogType type = AlertDialogType.info,
  //   int durationSecond = 4,
  //   double marginBottom = 12,
  // }) async {
  //   return await App.showSnackbar(
  //     message: message,
  //     title: title,
  //     type: type,
  //     durationSecond: durationSecond,
  //     paddingBottom: marginBottom,
  //   );
  // }

  Future showInfo({
    String title,
    String content,
    bool barrierDismissible = true,
    String buttonTitle,
  }) async {
    return await showDialog(
        type: AlertDialogType.info,
        title: title,
        content: content,
        barrierDismissible: barrierDismissible);
  }

  Future showWarning({
    String title,
    String content,
    bool barrierDismissible = true,
    String buttonTitle,
  }) async {
    return await showDialog(
        type: AlertDialogType.warning,
        title: title,
        content: content,
        barrierDismissible: barrierDismissible);
  }

  Future showError({
    String title,
    String content,
    bool barrierDismissible = true,
    String buttonTitle,
  }) async {
    return await showDialog(
        type: AlertDialogType.error,
        title: title,
        content: content,
        barrierDismissible: barrierDismissible);
  }

  Future showSuccess({
    String title,
    String content,
    bool barrierDismissible = true,
    String buttonTitle,
  }) async {
    return await showDialog(
        type: AlertDialogType.success,
        title: title,
        content: content,
        barrierDismissible: barrierDismissible);
  }

  Future<bool> showConfirm(
      {String title, String content, bool barrierDismissible = true}) async {
    return await App.showConfirm(title: title, content: content);
  }
}
