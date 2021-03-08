import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  @Deprecated('Using toStringFormat from tmt_flutter_utils instead.')
  String toStringFormat(String format) {
    return DateFormat(format).format(this);
  }
}
