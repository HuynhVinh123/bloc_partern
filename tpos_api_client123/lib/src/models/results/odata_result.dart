import 'package:tpos_api_client/src/json_convert.dart';

class OdataResult<T> {
  T value;
  OdataResult({this.value});

  factory OdataResult.fromJson(Map<String, dynamic> json) {
    OdataResult<T> data = OdataResult<T>();
    if (T is List) {
      if (json['value'] != null && json['value'] is List) {
        data.value = (json['value'] as List)
            .map((e) => tPosJsonConvert.deserialize<T>(e))
            .toList() as T;
      }
    } else {
      data.value = tPosJsonConvert.deserialize<T>(json['value']);
    }
    return data;
  }
}
