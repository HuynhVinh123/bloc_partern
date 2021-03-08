class RegisterTposResult {
  RegisterTposResult(
      {this.success, this.message, this.errors, this.hash, this.data});

  RegisterTposResult.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    errors = json['errors'] != null ? Errors.fromJson(json['errors']) : null;
    hash = json['hash'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool success;
  String message;
  Errors errors;
  String hash;
  Data data;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (errors != null) {
      data['errors'] = errors.toJson();
    }
    return data;
  }
}

class Errors {
  Errors({this.email, this.prefix, this.telephone});

  Errors.fromJson(Map<String, dynamic> json) {
    email = json['Email']?.cast<String>();
    prefix = json['Prefix']?.cast<String>();
    telephone = json['Telephone']?.cast<String>();
    cityCode = json['CityCode']?.cast<String>();
  }

  List<String> email;
  List<String> prefix;
  List<String> telephone;
  List<String> cityCode;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Email'] = email;
    data['Prefix'] = prefix;
    data['Telephone'] = telephone;
    return data;
  }
}

class Data {
  Data({this.isRequired, this.orderCode, this.phoneNumber});

  Data.fromJson(Map<String, dynamic> json) {
    isRequired = json['isRequired'];
    orderCode = json['orderCode'];
    phoneNumber = json['phoneNumber'];
    timestamp = json['timestamp'];
  }
  bool isRequired;
  String orderCode;
  String phoneNumber;
  int timestamp;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isRequired'] = isRequired;
    data['orderCode'] = orderCode;
    data['phoneNumber'] = phoneNumber;
    data["timestamp"] = timestamp;
    return data;
  }
}
