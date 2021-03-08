class CompanyCurrentInfo {
  CompanyCurrentInfo(
      {this.currentCompany, this.dateExpired, this.expiredIn, this.companies});

  CompanyCurrentInfo.fromJson(Map<String, dynamic> json) {
    currentCompany = json["CurrentCompany"];
    expiredIn = json["ExpiredIn"];
    if (json["Companies"] != null) {
      companies = (json["Companies"] as List)
          .map((f) => OtherCompanyInfo.fromJson(f))
          .toList();
    }
  }
  String currentCompany;
  DateTime dateExpired;
  int expiredIn;
  List<OtherCompanyInfo> companies;

  String get expiredInDay {
    final int expiredInSecond = expiredIn ?? 0;
    final dur = Duration(seconds: expiredInSecond);

    final int day = dur.inDays;
    final int hour = (dur - Duration(days: day)).inHours;
    final int minute = (dur - Duration(days: day, hours: hour)).inMinutes;

    final String dayString = "$day ngày";
    final String hourString = "$hour giờ";
    final String minuteString = "$minute phút";

    return "${day != 0 ? dayString : ""} ${hour != 0 ? hourString : ""} $minuteString";
  }

  String get expiredInShort {
    final int expiredInSecond = expiredIn ?? 0;
    if (expiredInSecond < 3600) {
      final double minute = expiredInSecond / 60;
      return "${minute.toStringAsFixed(1)} phút";
    } else if (expiredInSecond < 86400) {
      final hour = expiredInSecond / 3600;
      return "${hour.toStringAsFixed(1)} giờ";
    } else if (expiredInSecond < 2592000) {
      final day = expiredInSecond / 86400;
      return "${day.toStringAsFixed(1)} ngày";
    } else if (expiredInSecond < 31536000) {
      final month = expiredInSecond / 2592000;
      return "${month.toStringAsFixed(1)} tháng";
    } else {
      final year = expiredInSecond / 31536000;
      return "${year.toStringAsFixed(1)} năm";
    }
  }
}

class OtherCompanyInfo {
  OtherCompanyInfo({this.value, this.text});
  OtherCompanyInfo.fromJson(Map<String, dynamic> json) {
    value = json["Value"];
    text = json["Text"];
  }
  String value;
  String text;
}
