class TPosCity {
  TPosCity({this.value, this.label});
  TPosCity.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label = json['label'];
  }

  String value;
  String label;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['label'] = label;
    return data;
  }
}
