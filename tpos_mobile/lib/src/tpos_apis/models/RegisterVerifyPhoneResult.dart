class RegisterVerifyPhoneResult {
  RegisterVerifyPhoneResult({this.success, this.data, this.message});
  RegisterVerifyPhoneResult.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? RegisterVerifyPhoneResultData.fromJson(json['data'])
        : null;
    message = json["message"];
  }
  bool success;
  RegisterVerifyPhoneResultData data;
  String message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class RegisterVerifyPhoneResultData {
  RegisterVerifyPhoneResultData({this.prefix, this.telephone, this.order});
  RegisterVerifyPhoneResultData.fromJson(Map<String, dynamic> json) {
    prefix = json['prefix'];
    telephone = json['telephone'];
    order = json['order'] != null
        ? RegisterVerifyPhoneResultDataDataOrder.fromJson(json['order'])
        : null;
  }
  String prefix;
  String telephone;
  RegisterVerifyPhoneResultDataDataOrder order;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prefix'] = prefix;
    data['telephone'] = telephone;
    if (order != null) {
      data['order'] = order.toJson();
    }
    return data;
  }
}

class RegisterVerifyPhoneResultDataDataOrder {
  RegisterVerifyPhoneResultDataDataOrder({this.code});
  RegisterVerifyPhoneResultDataDataOrder.fromJson(Map<String, dynamic> json) {
    code = json['code'];
  }

  String code;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    return data;
  }
}
