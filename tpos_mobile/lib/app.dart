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
  static final Logger _logger = Logger();
  static double width = 720;
  static double height = 0;
  static String appVersion;
  static bool isAppLogOut = false;

  /// NavigatorKey for Overlay Screen. Using for show dialog, show toast, show snackbar, Navigation on root stack
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// NavigatorKey for App Navigator. That using default by Navigator.of(context)
  static GlobalKey<NavigatorState> appNavigatorKey =
      GlobalKey<NavigatorState>();

  static bool get isTablet => width > 900;

  static BuildContext get overlayContext =>
      navigatorKey.currentState.overlay.context;

  static BuildContext get routeContext => navigatorKey.currentState.context;

  App._();

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

  static void pop([dynamic param]) {
    appNavigatorKey.currentState.pop(param);
  }

  /// Using pushName without BuildContext
  static Future<dynamic> pushNamed(String routeName,
      {BuildContext context}) async {
    return await appNavigatorKey.currentState.pushNamed(routeName);
  }

  static void restart(BuildContext context) {
    AppWrapper.reset(context);
  }

  /// Show thông báo xác nhận, Trả về true nếu đồng ý và trả về false nếu không đồng ý hoặc nhấn ra vùng bên ngoài thông báo
  static Future<bool> showConfirm(
      {String title,
      String content,
      BuildContext context,
      bool useRootNavigator = true}) async {
    final bool result = await showDialog(
        AlertDialog(
          title: Text(title ?? S.current.confirm),
          content: Text(content ?? ''),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context ?? overlayContext).pop(false);
              },
              child: Text(S.current.cancel.toUpperCase()),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context ?? overlayContext).pop(true);
              },
              child: Text(S.current.confirm.toUpperCase()),
              textColor: AppColors.primary1,
            ),
          ],
        ),
        useRootNavigator: useRootNavigator);

    return result ?? false;
  }

  /// show app default dialog on [overlay]
  static Future<dynamic> showDefaultDialog({
    AlertDialogType type = AlertDialogType.info,
    BuildContext context,
    String title,
    String content,
    String buttonTitle,
    String cancelTitle,
    List<Widget> actions,
    List<WidgetBuilder> actionBuilders,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
  }) async {
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
          content: Text(content ?? ''),
          actions: actionBuilders != null
              ? actionBuilders
                  .map((action) => action(context ?? overlayContext))
                  .toList()
              : actions ?? defaultActions(context),
        );

    return await showGeneralDialog<dynamic>(
        useRootNavigator: useRootNavigator,
        context: context ?? overlayContext,
        pageBuilder: (context, animation, secondAnimation) {
          return _buildDialog(context);
        },
        barrierDismissible: barrierDismissible,
        barrierLabel: 'Close the dialog');
  }

  static Future showDialog<T>(Widget widget,
      {BuildContext context,
      bool barrierDismissible = true,
      bool useRootNavigator = true}) async {
    return await showGeneralDialog<T>(
        useRootNavigator: useRootNavigator,
        context: context ?? overlayContext,
        pageBuilder: (context, animation, secondAnimation) {
          return widget;
        },
        barrierDismissible: barrierDismissible,
        barrierLabel: 'Close the dialog');
  }

  /// Show default toast/notify/snackbar using Flushbar.
  static Future showToast(
      {String title,
      String message,
      AlertDialogType type = AlertDialogType.info,
      BuildContext context,
      int durationSecond = 4,
      double paddingBottom = 12}) async {
    assert(message != null || title != null);
    assert(type != null);
    assert(context != null || overlayContext != null);
    final BuildContext appContext = context ?? overlayContext;
    return WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Flushbar(
        title: title,
        message: message ?? title,
        backgroundColor: type.textColor,
        borderColor: type.textColor,
        routeColor: Colors.red,
        borderRadius: 8,
        icon: type.getIcon(40, Colors.white),
        margin: EdgeInsets.only(
            left: 12, top: 12, right: 12, bottom: paddingBottom),
        padding: const EdgeInsets.only(left: 30, right: 8, top: 8, bottom: 8),
        duration: Duration(seconds: durationSecond),
        mainButton: FlatButton(
          onPressed: () {
            Navigator.of(appContext).pop();
          },
          child: Text(S.current.close),
          textColor: Colors.white,
        ),
      ).show(appContext);
    });
  }
}
