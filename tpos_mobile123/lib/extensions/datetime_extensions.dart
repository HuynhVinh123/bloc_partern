import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String toStringFormat(String format) {
    return DateFormat(format).format(this);
  }
}
