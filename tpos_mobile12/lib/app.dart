import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:package_info/package_info.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile/widgets/app_wrapper.dart';
import 'package:tpos_mobile/widgets/button/action_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/dialog/app_alert_dialog.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

const bool isEnableDataMock = false;

class App {
  App._();
  static Logger _logger = Logger();
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

  static Future showToast(
      {String title,
      @required String message,
      AlertDialogType type = AlertDialogType.info,
      BuildContext context,
      int durationSecond = 4}) async {
    assert(message != null);
    assert(type != null);
    return await Flushbar(
      title: title,
      message: message,
      backgroundColor: type.textColor.withOpacity(0.9),
      borderColor: type.textColor,
      routeColor: Colors.red,
      borderRadius: 8,
      icon: type.getIcon(40, Colors.white),
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.only(left: 30, right: 8, top: 8, bottom: 8),
      duration: Duration(seconds: durationSecond),
    )
      ..show(context ?? overlayContext);
  }
}
