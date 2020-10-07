class RegisterVerifyPhoneResult {
  bool success;
  RegisterVerifyPhoneResultData data;
  String message;
  RegisterVerifyPhoneResult({this.success, this.data, this.message});

  RegisterVerifyPhoneResult.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? new RegisterVerifyPhoneResultData.fromJson(json['data'])
        : null;
    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class RegisterVerifyPhoneResultData {
  String prefix;
  String telephone;
  RegisterVerifyPhoneResultDataDataOrder order;

  RegisterVerifyPhoneResultData({this.prefix, this.telephone, this.order});

  RegisterVerifyPhoneResultData.fromJson(Map<String, dynamic> json) {
    prefix = json['prefix'];
    telephone = json['telephone'];
    order = json['order'] != null
        ? new RegisterVerifyPhoneResultDataDataOrder.fromJson(json['order'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prefix'] = this.prefix;
    data['telephone'] = this.telephone;
    if (this.order != null) {
      data['order'] = this.order.toJson();
    }
    return data;
  }
}

class RegisterVerifyPhoneResultDataDataOrder {
  String code;

  RegisterVerifyPhoneResultDataDataOrder({this.code});

  RegisterVerifyPhoneResultDataDataOrder.fromJson(Map<String, dynamic> json) {
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    return data;
  }
}
