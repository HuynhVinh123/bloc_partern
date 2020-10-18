import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:logger/logger.dart';
import 'package:package_info/package_info.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile/widgets/app_wrapper.dart';
import 'package:tpos_mobile/widgets/button/action_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/dialog/app_alert_dialog.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';
import 'package:get/get.dart';

const bool isEnableDataMock = false;

class App {
  App._();
  static final Logger _logger = Logger();
  static bool get isTablet => width > 900;
  static double width = 720;
  static double height = 0;

  static String appVersion;
  static bool isAppLogOut = false;

  static Future<void> getAppVersion() async {
    try {
      if (appVersion != null) {
        return appVersion;
      }

      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appVersion = packageInfo.version;
      return appVersion;
    } catch (e, s) {
      _logger.e('', e, s);
    }
  }

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext get overlayContext =>
      navigatorKey.currentState.overlay.context;
  static BuildContext get routeContext => navigatorKey.currentState.context;

  static void restart(BuildContext context) {
    AppWrapper.reset(context);
  }

  /// show app default dialog on [overlay]
  static Future showDefaultDialog(
      {AlertDialogType type = AlertDialogType.info,
      BuildContext context,
      String title,
      String content,
      String buttonTitle,
      String cancelTitle,
      List<Widget> actions,
      bool barrierDismissible = true}) async {
    List<Widget> defaultActions(BuildContext context) => [
          ActionButton(
            child: Text(S.current.dialogActionOk.toUpperCase()),
            color: Colors.grey.shade200,
            textColor: AppColors.brand3,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ];
    Widget _buildDialog(BuildContext context) => AppAlertDialog(
          type: type,
          title: Text(title ?? type.defaultTitle),
          content: Text(content),
          actions: actions ?? defaultActions(context),
        );

    await showGeneralDialog(
        context: context ?? overlayContext,
        pageBuilder: (context, animation, secondAnimation) {
          return _buildDialog(context);
        },
        barrierDismissible: barrierDismissible,
        barrierLabel: 'Close the dialog');
  }

  static Future showDialog(Widget widget,
      {BuildContext context, bool barrierDismissible = true}) async {
    await showGeneralDialog(
        context: context ?? overlayContext,
        pageBuilder: (context, animation, secondAnimation) {
          return widget;
        },
        barrierDismissible: barrierDismissible,
        barrierLabel: 'Close the dialog');
  }

  static Future<bool> showConfirm(
      {String title, String content, BuildContext context}) async {
    return await showDialog(
      AlertDialog(
        title: Text(title ?? S.current.confirm),
        content: Text(content ?? ''),
        actions: [
          RaisedButton(
            onPressed: () {
              Navigator.of(context ?? overlayContext).pop(false);
            },
            color: AppColors.backgroundColor,
            child: Text(S.current.cancel),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context ?? overlayContext).pop(true);
            },
            child: Text(S.current.confirm),
            color: AppColors.brand3,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  static Future showToast(
      {String title,
      String message,
      AlertDialogType type = AlertDialogType.info,
      BuildContext context,
      int durationSecond = 4,
      double paddingBottom = 12}) async {
    assert(message != null || title != null);
    assert(type != null);
    return await Flushbar(
      title: title,
      message: message ?? title,
      backgroundColor: type.textColor,
      borderColor: type.textColor,
      routeColor: Colors.red,
      borderRadius: 8,
      icon: type.getIcon(40, Colors.white),
      margin:
          EdgeInsets.only(left: 12, top: 12, right: 12, bottom: paddingBottom),
      padding: const EdgeInsets.only(left: 30, right: 8, top: 8, bottom: 8),
      duration: Duration(seconds: durationSecond),
    ).show(context ?? routeContext);
  }

  static Future showSnackbar(
      {String title,
      String message,
      AlertDialogType type = AlertDialogType.info,
      BuildContext context,
      int durationSecond = 4,
      double paddingBottom = 12}) async {
    Get.snackbar(title, message);
  }
}
