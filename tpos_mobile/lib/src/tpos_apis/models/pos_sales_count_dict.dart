class PosSalesCountDict {
  PosSalesCountDict({this.key, this.value});
  PosSalesCountDict.fromJson(Map<String, dynamic> json) {
    key = json['Key'];
    value = json['Value'];
  }
  String key;
  double value;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Key'] = key;
    data['Value'] = value;

    return data;
  }
}
