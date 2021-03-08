import 'package:intl/intl.dart';

abstract class FilterBase {
  Map<String, dynamic> toJson();
}

class OdataFilter extends FilterBase {
  OdataFilter({this.logic, this.filters});
  String logic;
  List<FilterBase> filters;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["logic"] = logic;
    data["filters"] = filters.map((f) => f.toJson()).toList();
    return data;
  }
}

class OdataFilterItem extends FilterBase {
  OdataFilterItem(
      {this.field,
      this.operator,
      this.value,
      this.convertDatetime,
      this.dataType});
  final String field;
  final String operator;
  final Object value;
  final Function(DateTime) convertDatetime;
  final Type dataType;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["field"] = field;
    data["operator"] = operator;
    data["value"] = getValueJson();

    return data;
  }

  dynamic getValueJson() {
    dynamic valueResult;
    if (value is DateTime) {
      valueResult = convertDatetime != null
          ? convertDatetime(value)
          : DateFormat("yyyy-MM-ddTHH:mm:ss").format(value as DateTime);
    } else
      valueResult = value;
    return valueResult;
  }
}
