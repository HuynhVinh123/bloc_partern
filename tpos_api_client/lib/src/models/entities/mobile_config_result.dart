import 'package:tpos_api_client/src/model.dart';

class MobileConfigResult {
  MobileConfigResult({this.success, this.message, this.model});

  MobileConfigResult.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json["model"] != null) {
      model = MobileConfig.fromJson(json['model']);
    }
  }
  bool success;
  String message;
  MobileConfig model;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['model'] = model?.toJson();

    return data;
  }
}
