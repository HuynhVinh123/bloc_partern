import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:tpos_mobile/src/tpos_apis/models/RegisterVerifyPhoneResult.dart';
import 'package:tpos_mobile/src/tpos_apis/models/register_tpos_result.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_service_base.dart';

abstract class IRegisterApi {
  /// Đăng ký ứng dụng
  Future<RegisterTposResult> registerTpos({
    @required String name,
    String message,
    @required String email,
    String company,
    @required String phone,
    String cityCode,
    String prefix,
    String facebookPhoneValidateToken,
    String facebookUserToken,
  });

  Future<RegisterVerifyPhoneResult> verifyPhoneNumber(
      {@required String phoneNumber,
      String hash,
      String orderCode,
      String code,
      int timestamp});

  Future<void> forgotPassword(String email);

  Future<bool> resendVerifyPhone(
      {String hash,
      bool isRequired,
      String orderCode,
      String phoneNumber,
      int time});
}

class RegisterApi extends ApiServiceBase implements IRegisterApi {
  final _client = Client();
  @override
  Future<RegisterTposResult> registerTpos(
      {String name,
      String message,
      String email,
      String company,
      String phone,
      String cityCode,
      String prefix,
      String facebookPhoneValidateToken,
      String facebookUserToken}) async {
    final Map<String, dynamic> bodyMap = {
      "Name": name,
      "Message": message,
      "Email": email,
      "Company": company,
      "Telephone": phone,
      "CityCode": cityCode,
      "Prefix": prefix,
      "ProductCode": "TPOS",
      "PackageCode": "BASIC",
      "recaptcha": null,
      "FacebookUserToken": facebookUserToken,
    };
//    }..removeWhere((key, value) => value == null);
    logger.debug(bodyMap);
    final response = await _client.post(
      "https://tpos.vn/api/Order/Create",
      headers: {"content-type": "application/json"},
      body: jsonEncode(bodyMap),
    );

    print(response.body);
    if (response.statusCode == 200) {
      return RegisterTposResult.fromJson(jsonDecode(response.body));
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<RegisterVerifyPhoneResult> verifyPhoneNumber(
      {String phoneNumber,
      String hash,
      String orderCode,
      String code,
      int timestamp}) async {
    final response = await _client.post(
      "https://tpos.vn/api/Order/Create",
      body: jsonEncode({
        "Code": code,
        "Hash": hash,
        "OrderCode": orderCode,
        "PhoneNumber": phoneNumber,
        "TimeStamp": timestamp,
      }),
      headers: {"content-type": "application/json"},
    );

    if (response.statusCode == 200) {
      return RegisterVerifyPhoneResult.fromJson(jsonDecode(response.body));
    }
    throwTposApiException(response);
    return null;
  }

  @override
  Future<void> forgotPassword(String email) async {
    assert(email != null && email.isNotEmpty);
  }

  @override
  Future<bool> resendVerifyPhone(
      {String hash,
      bool isRequired,
      String orderCode,
      String phoneNumber,
      int time}) async {
    final response = await _client.post(
      "https://tpos.vn/api/Order/ResendVerifyCode",
      headers: {"content-type": "application/json"},
      body: jsonEncode(
        {
          "hash": hash,
          "isRequired": isRequired,
          "orderCode": orderCode,
          "phoneNumber": phoneNumber,
          "timestamp": time,
        },
      ),
    );

    if (response.statusCode == 200) {
      final map = jsonDecode(response.body);
      if (map["success"] == true) {
        return true;
      } else {
        throw Exception(map["message"]);
      }
    }
    throwTposApiException(response);
    return false;
  }
}
