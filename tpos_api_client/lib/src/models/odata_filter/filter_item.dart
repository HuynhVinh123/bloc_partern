class FilterItem {
  FilterItem({this.field, this.operator, this.value});
  FilterItem.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    operator = json['operator'];
    value = json['value'];
  }
  String field;
  String operator;
  String value;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['field'] = field;
    data['operator'] = operator;
    data['value'] = value;
    return data;
  }

  // TODO
  String toUrlEncode() {
    throw UnimplementedError();
  }
}
