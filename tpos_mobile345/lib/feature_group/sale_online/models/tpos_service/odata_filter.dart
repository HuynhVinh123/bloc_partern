import 'package:intl/intl.dart';
import 'package:tpos_mobile/helpers/tpos_api_helper.dart';

abstract class FilterBase {
  Map<String, dynamic> toJson();
  String toUrlEncode();
}

class OdataSortItem {
  OdataSortItem({this.dir, this.field});
  String dir;

  String field;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["dir"] = dir;
    data["field"] = field;
    return data;
  }

  String tourlEncode() {
    return "$field $dir";
  }
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

  String toUrlEncode() {
    String filter = "";

    filter = filters
        .map((f) {
          return f.toUrlEncode();
        })
        .toList()
        .join(logic == "and" ? " and " : " or ");

    return "($filter)";
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
    var valueResult;
    if (value is DateTime) {
      valueResult = convertDatetime != null
          ? convertDatetime(value)
          : DateFormat("yyyy-MM-ddTHH:mm:ss").format(value as DateTime);
    } else
      valueResult = value;
    return valueResult;
  }

  String toUrlEncode() {
    String result = "";
    String valueResult = "";
    if (dataType == int) {
      valueResult = value;
    } else if (value is String) {
      valueResult = "'$value'";
    } else if (value is DateTime) {
      final DateTime valueDate = value as DateTime;

      valueResult = convertDatetime != null
          ? convertDatetime(value)
          : valueDate.toIso8601String() +
              printDuration(valueDate.timeZoneOffset);
    } else {
      valueResult = value.toString();
    }
    result = "$field $operator $valueResult";
    if (operator == "contains") {
      result = "contains($field, '$value')";
    }
    return result;
  }
}
