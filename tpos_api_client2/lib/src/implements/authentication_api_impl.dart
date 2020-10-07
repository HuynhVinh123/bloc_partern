import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstraction.dart';
import 'package:tpos_api_client/src/abstractions/authentication_api.dart';
import 'package:tpos_api_client/src/models/results/login_result.dart';
import 'package:dio/dio.dart';

class AuthenticationApiImpl implements AuthenticationApi {
  AuthenticationApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }
  static const loginPath = '/token';
  static const refreshTokenPath = '/token';

  TPosApi _apiClient;
  @override
  Future<LoginResult> login(
      {@required String url, String username, String password}) async {
    assert(url != null && url.isNotEmpty);

    final json = await _apiClient.httpPost(
      "$url/token",
      options: Options(
          contentType: 'application/x-www-form-urlencoded; charset=UTF-8'),
      data: {
        "username": username,
        "password": password,
        "grant_type": "password",
        "client_id": "tmtWebApp ",
      },
      catchDefaultException: true,
    );

    return LoginResult.fromJson(json);
  }

  @override
  Future<LoginResult> refreshToken({String refreshToken}) async {
    final json = await _apiClient.httpPost(
      refreshTokenPath,
      data: {
        "refresh_token": refreshToken,
        "grant_type": "refresh_token",
        "client_id": "tmtWebApp ",
      },
      options: Options(
          contentType: 'application/x-www-form-urlencoded; charset=UTF-8'),
    );

    return LoginResult.fromJson(json);
  }

  @override
  Future<bool> checkToken(String token) async {
    bool isTokenValid = true;
    try {
      await _apiClient.httpGetRaw('/rest/v1.0/user/info');
    } catch (e) {
      if (e is DioError) {
        if (e.type == DioErrorType.RESPONSE && e.response.statusCode == 401) {
          isTokenValid = false;
        }
      }
    }

    return isTokenValid;
  }
}
