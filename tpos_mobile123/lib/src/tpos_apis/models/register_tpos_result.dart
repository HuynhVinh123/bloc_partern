class RegisterTposResult {
  bool success;
  String message;
  Errors errors;
  String hash;
  Data data;

  RegisterTposResult(
      {this.success, this.message, this.errors, this.hash, this.data});

  RegisterTposResult.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    errors =
        json['errors'] != null ? new Errors.fromJson(json['errors']) : null;
    hash = json['hash'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.errors != null) {
      data['errors'] = this.errors.toJson();
    }
    return data;
  }
}

class Errors {
  List<String> email;
  List<String> prefix;
  List<String> telephone;
  List<String> cityCode;

  Errors({this.email, this.prefix, this.telephone});

  Errors.fromJson(Map<String, dynamic> json) {
    email = json['Email']?.cast<String>();
    prefix = json['Prefix']?.cast<String>();
    telephone = json['Telephone']?.cast<String>();
    cityCode = json['CityCode']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Email'] = this.email;
    data['Prefix'] = this.prefix;
    data['Telephone'] = this.telephone;
    return data;
  }
}

class Data {
  bool isRequired;
  String orderCode;
  String phoneNumber;
  int timestamp;

  Data({this.isRequired, this.orderCode, this.phoneNumber});

  Data.fromJson(Map<String, dynamic> json) {
    isRequired = json['isRequired'];
    orderCode = json['orderCode'];
    phoneNumber = json['phoneNumber'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isRequired'] = this.isRequired;
    data['orderCode'] = this.orderCode;
    data['phoneNumber'] = this.phoneNumber;
    data["timestamp"] = this.timestamp;
    return data;
  }
}
