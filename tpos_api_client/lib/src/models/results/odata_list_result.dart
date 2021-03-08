import 'package:tpos_api_client/src/json_convert.dart';

class OdataListResult<T> {
  OdataListResult({this.count, this.value});

  factory OdataListResult.fromJson(Map<String, dynamic> json) {
    final OdataListResult<T> data = OdataListResult<T>();
    data.count = json['@odata.count'] ?? json['Total'];
    if (json['value'] != null && json['value'] is List) {
      data.value = (json['value'] as List).map((e) => tPosJsonConvert.deserialize<T>(e)).toList();
    }

    if (json['Data'] != null) {
      data.value = (json['Data'] as List)
          .map((e) => tPosJsonConvert.deserialize<T>(e))
          .toList();
    }
    return data;
  }

  int count;
  List<T> value;
}
