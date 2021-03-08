import 'partner_status_report_item.dart';

class PartnerStatusReport {
  PartnerStatusReport({this.birthdayCount, this.item});
  PartnerStatusReport.fromJson(Map<String, dynamic> json) {
    birthdayCount = json["count_birthDay"]?.toInt();
    if (json["item"] != null) {
      item = (json["item"] as List)
          .map((f) => PartnerStatusReportItem.fromJson(f))
          .toList();
    }
  }
  int birthdayCount;
  List<PartnerStatusReportItem> item;
}
