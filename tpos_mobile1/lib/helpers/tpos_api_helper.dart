const String TIME_TRACTIONAL_SECOND_PARTERN = "(?<=\\.)\\d+";
const String TIME_ZONE_PARTERN = "(?<=\\.)\\d+";

/// Xóa hàm convert thời gian sang chuỗi

String printDuration(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    if (n < 0) return "-0${-n}";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  if (duration < Duration()) {
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  } else {
    return "+${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }
}

/// Xóa hàm convert thời gian sang chuỗi
