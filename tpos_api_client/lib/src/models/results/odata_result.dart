// import 'package:tpos_api_client/src/json_convert.dart';
//
// class OdataResult<T> {
//   T value;
//   OdataResult({this.value});
//
//   factory OdataResult.fromJson(Map<String, dynamic> json) {
//     OdataResult<T> data = OdataResult<T>();
//     if (T is List) {
//       if (json['value'] != null && json['value'] is List) {
//         data.value = (json['value'] as List)
//             .map((e) => tPosJsonConvert.deserialize<T>(e))
//             .toList() as T;
//       }
//     } else {
//       data.value = tPosJsonConvert.deserialize<T>(json['value']);
//     }
//     return data;
//   }
// }

@Deprecated('OdataResult<T> is obsolete. Using OdataObjectResult<T> instate')
class OdataResult<T> {
  OdataResult({this.error, this.value});
  OdataResult.fromJson(Map<String, dynamic> json,
      {T inValue, Function parseValue}) {
    if (json["error"] != null) {
      error = OdataError.fromJson(json["error"]);
    }

    if (parseValue != null) {
      value = parseValue();
    } else {
      value = inValue;
    }
  }
  OdataError error;
  T value;
}

class OdataError {
  OdataError({this.code, this.message});

  OdataError.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    message = json["message"];
  }
  String code;
  String message;
  String errorDescription;
}
