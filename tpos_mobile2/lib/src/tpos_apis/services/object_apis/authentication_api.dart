import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tpos_mobile/src/tpos_apis/models/LoginInfo.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_service_base.dart';
import 'package:http/http.dart' as http;

/// Api dùng để xác thực ứng dụng và tài khoản
abstract class IAuthenticationApi {
  /// Đăng nhập
  Future<LoginInfo> login(
      {@required String username, @required String password});

  /// Làm mới  token
  Future<LoginInfo> refreshToken({@required String refreshToken});
}

class AuthenticationApi extends ApiServiceBase implements IAuthenticationApi {
  @override
  Future<LoginInfo> login({String username, String password}) async {
    var response = await http.post(
      "${apiClient.shopUrl}/token",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
      },
      body: {
        "username": username,
        "password": password,
        "grant_type": "password",
        "client_id": "tmtWebApp ",
      },
    ).timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      return LoginInfo.getFromJson(jsonDecode(response.body));
    } else {
      if (response.body.startsWith("{")) {
        var map = jsonDecode(response.body);
        throw Exception("${map["error_description"]}");
      }

      if (response.statusCode == 404) {
        throw Exception("Không tồn tại");
      } else if (response.statusCode == 503) {
        throw Exception(
            "Máy chủ hiện đang không hoạt động. Vui lòng thử lại vào lúc khác");
      } else {
        throw Exception(
            "${response.statusCode}: ${response.reasonPhrase} | ${response.body}");
      }
    }
  }

  @override
  Future<LoginInfo> refreshToken({String refreshToken}) async {
    var body = {
      "refresh_token": refreshToken,
      "grant_type": "refresh_token",
      "client_id": "tmtWebApp ",
    };
    var response = await http.post(
      apiClient.shopUrl + "/token",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return LoginInfo.getFromJson(json.decode(response.body));
    } else {
      throwTposApiException(response);
      return null;
    }
  }
}
