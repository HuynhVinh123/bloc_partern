import 'package:package_info/package_info.dart';

const bool isEnableDataMock = false;

/// Các dịch vụ và cấu hình tĩnh
class App {
  App._();
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
    } catch (e) {}
  }
}
