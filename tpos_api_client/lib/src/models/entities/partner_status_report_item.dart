class PartnerStatusReportItem {
  PartnerStatusReportItem(
      {this.statusText, this.count, this.statusStyle, this.isSelect});
  PartnerStatusReportItem.fromJson(Map<String, dynamic> json) {
    statusText = json['StatusText'];
    count = json['Count'];
    statusStyle = json['StatusStyle'];
  }
  String statusText;
  int count;
  String statusStyle;
  bool isSelect = false;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusText'] = statusText;
    data['Count'] = count;
    data['StatusStyle'] = statusStyle;
    return data;
  }
}
