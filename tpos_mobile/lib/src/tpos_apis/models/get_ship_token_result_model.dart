class GetShipTokenResultModel {
  GetShipTokenResultModel({this.data, this.success, this.message});
  GetShipTokenResultModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    success = json['success'];
    message = json['message'];
  }
  Data data;
  bool success;
  String message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['success'] = success;
    data['message'] = message;
    return data;
  }
}

class Data {
  Data({this.code, this.token});
  Data.fromJson(Map<String, dynamic> json) {
    code = json['code']?.toString();
    token = json['token'];
  }
  String code;
  String token;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['token'] = token;
    return data;
  }
}
