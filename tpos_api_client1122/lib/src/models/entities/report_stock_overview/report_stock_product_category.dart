class ReportStockProductCategory {
  ReportStockProductCategory({this.text, this.value, this.nameNoSign});

  ReportStockProductCategory.fromJson(Map<String, dynamic> json) {
    text = json['Text'];
    value = json['Value'];
    nameNoSign = json['NameNoSign'];
  }

  String text;
  String value;
  String nameNoSign;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Text'] = text;
    data['Value'] = value;
    data['NameNoSign'] = nameNoSign;
    return data;
  }
}
