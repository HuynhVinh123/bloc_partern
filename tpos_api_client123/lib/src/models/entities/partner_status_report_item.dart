class PartnerStatusReportItem {
  PartnerStatusReportItem({this.statusText, this.count, this.statusStyle});
  PartnerStatusReportItem.fromJson(Map<String, dynamic> json) {
    statusText = json['StatusText'];
    count = json['Count'];
    statusStyle = json['StatusStyle'];
  }
  String statusText;
  int count;
  String statusStyle;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StatusText'] = statusText;
    data['Count'] = count;
    data['StatusStyle'] = statusStyle;
    return data;
  }
}
