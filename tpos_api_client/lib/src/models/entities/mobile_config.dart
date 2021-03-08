import 'package:tpos_api_client/tpos_api_client.dart';

class MobileConfig {
  MobileConfig({
    this.values,
    this.deviceId,
    this.host,
    this.userId,
    this.id,
    this.jsonValues,
    this.version,
  });

  MobileConfig.fromJson(Map<String, dynamic> jsonMap) {
    deviceId = jsonMap['Device_Id'];
    host = jsonMap['Host'];
    id = jsonMap['Id'];
    userId = jsonMap['UserId'];
    values = jsonMap['Values'] != null
        ? ConfigurationValue.fromJson(jsonMap['Values'])
        : null;

    jsonValues = jsonMap['Values'];
    version = jsonMap['Version']?.toInt();
  }

  Map<String, dynamic> toJson([removeIfNull = false]) {
    final Map<String, dynamic> map = <String, dynamic>{
      'Device_Id': deviceId,
      'Id': id,
      'Host': host,
      'UserId': userId,
      'Values': values != null ? values?.toJson(removeIfNull) : jsonValues,
      'Version': version,
    };

    if (removeIfNull) {
      map.removeWhere((key, value) => value == null || value == '');
    }

    return map;
  }

  String deviceId;
  String id;
  String host;
  String userId;
  ConfigurationValue values;
  Map<String, dynamic> jsonValues;
  int version;
}
