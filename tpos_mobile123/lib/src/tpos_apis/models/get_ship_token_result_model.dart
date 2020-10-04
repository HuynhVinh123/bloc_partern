class GetShipTokenResultModel {
  Data data;
  bool success;
  String message;

  GetShipTokenResultModel({this.data, this.success, this.message});

  GetShipTokenResultModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String code;
  String token;

  Data({this.code, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['token'] = this.token;
    return data;
  }
}
