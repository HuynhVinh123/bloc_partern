import 'dart:io';

import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/navigation_service.dart';

const String TIME_TRACTIONAL_SECOND_PARTERN = "(?<=\\.)\\d+";
const String TIME_ZONE_PARTERN = "(?<=\\.)\\d+";

class App {
  App._();
  static String locate = "vi_VN";

  /// Format số theo [numberLocate]
  static String numberLocate = 'vi_VN';

  ///Convert String number to double type with locate input. Defaut is en_US locate
  ///Null[null] and empty [""] will convert to 0
  static double convertToDouble(String value, String locate) {
    String temp = value;
    if (value == null) return 0;
    if (value == null || value == "") temp = "0";
    switch (locate) {
      case "vi_VN":
        temp = temp.replaceAll(".", "").replaceAll(",", ".");
        break;
      case "en_US":
        temp = temp.replaceAll(",", "");
        break;
      default:
        temp = temp;
        break;
    }

    return double.parse(temp);
  }

  static String getErrorString(Object exception) {
    if (exception is SocketException) {
      return "Không có kết nối mạng hoặc máy chủ không khả dụng";
    } else {
      return exception.toString();
    }
  }

  static Future<T> pushNamed<T>(String routeName) async {
    return await locator<NavigationService>().navigateTo(routeName);
  }

  static Future<T> pushToRoute<T>(String routeName) async {}
}
