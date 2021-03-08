import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';
import 'package:tpos_mobile/services/log_services/log_service.dart';

/// Custome Client
class TPosClient extends http.BaseClient {
  TPosClient(this._inner, this._appVersion);
  final http.Client _inner;
  final _setting = locator<ISettingService>();
  final _secureConfig = GetIt.I<SecureConfigService>();
  final String _appVersion;

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    // request.headers['user-agent'] = "";
    request.headers["Authorization"] = "Bearer ${_secureConfig.shopToken}";
    request.headers["MobileAppVersion"] = "$_appVersion";
    request.headers["Content-Type"] = "application/json";

    return _inner.send(request);
  }
}

/// GET, POST, DELETE, PUT with TPOS URL AND BASE OPTION
class TposApiClient {
  TposApiClient(
      {ISettingService settingService,
      LogService logService,
      SecureConfigService secureConfigService}) {
    _setting = settingService ?? locator<ISettingService>();
    _log = logService ?? locator<LogService>();
    _secureConfig = secureConfigService ?? GetIt.I<SecureConfigService>();
    initClient();
  }
  ISettingService _setting;
  LogService _log;
  SecureConfigService _secureConfig;

  TPosClient _client;
  String get shopUrl => "${_secureConfig.shopUrl}";

  /// Khởi tạo client
  /// chạy sau khi đăng nhập hoặc khởi động chương trình
  void initClient({TPosClient client}) {
    _client?.close();
    _client = client ?? TPosClient(Client(), App.appVersion);
  }

  /// http GET
  Future<Response> httpGet(
      {String path,
      bool useBasePath = true,
      Map<String, dynamic> param,
      int timeoutInSecond = 300}) async {
    String url = path;
    if (useBasePath) {
      final String content = buildUrlEncodeString(param);
      url = "$shopUrl$path$content";
    }
    _log.info("TPOS API GET " + url);
    final response =
        await _client.get(url).timeout(Duration(seconds: timeoutInSecond));

    _log.info("RESPONSE FROM $url:");
    _log.info(response.body);

    return response;
  }

  /// HTTP POST
  Future<Response> httpPost(
      {@required String path,
      bool useBasePath = true,
      String body,
      bool throwIfStatusCodeNoOk,
      Map<String, dynamic> params,
      Duration timeOut = const Duration(minutes: 5)}) async {
    String url = path;
    final String content = buildUrlEncodeString(params);
    if (useBasePath) {
      url = "$shopUrl$path$content";
    }
    _log.info("TPOS POST: $url\n BODY: ");
    _log.info(body);
    final response = await _client.post(url, body: body).timeout(timeOut);

    _log.info("${response.statusCode}: RESPONSE FROM $url:");
    _log.info(response.body);
    return response;
  }

  /// HTTP PUT
  Future<Response> httpPut(
      {@required String path,
      bool useBasePath = true,
      String body,
      bool throwIfStatusCodeNoOk}) async {
    String url = path;

    if (useBasePath) {
      url = "$shopUrl$path";
    }

    _log.info("TPOS PUT: $url\n BODY: ");
    _log.info(body);
    final response = await _client.put(url, body: body);

    _log.info("RESPONSE FROM $url:\n");
    _log.info(response.body);
    return response;
  }

  /// HTTP Delete
  /// HTTP Delete
  Future<Response> httpDelete(
      {@required String path,
      bool useBasePath = true,
      String body,
      bool throwIfStatusCodeNoOk}) async {
    String url = path;
    if (useBasePath) {
      url = "$shopUrl$path";
    }

    _log.info("TPOS DELETE: $url\n BODY: ");
    _log.info(body);
    final response = await _client.delete(
      url,
    );

    _log.info("RESPONSE FROM $url:\n");
    _log.info(response.body);
    return response;
  }

  /// HTTP PUT
  Future<Response> httpPatch(
      {@required String path,
      bool useBasePath = true,
      String body,
      bool throwIfStatusCodeNoOk}) async {
    String url = path;

    if (useBasePath) {
      url = "$shopUrl$path";
    }

    _log.info("TPOS PATCH: $url\n BODY: ");
    _log.info(body);
    final response = await _client.patch(url, body: body);

    _log.info("RESPONSE FROM $url:\n");
    _log.info(response.body);
    return response;
  }

  ///Convert Map to UrlEncode
  String buildUrlEncodeString(Map<String, dynamic> param) {
    if (param != null && param.isNotEmpty)
      return "?" +
          param.keys.map((key) => "$key=${param[key].toString()}").join("&");
    else
      return "";
  }
}

void throwTposApiException(Response response) {
  if (response.statusCode == 401) {
    throw TException(
        "Tài khoản chưa đăng nhập. Vui lòng đăng xuất và đăng nhập lại");
  } else if (response.statusCode == 402) {
    throw TException("Tài khoản chưa thanh toán");
  } else if (response.statusCode == 403) {
    throw TException(
        "403. Forbidden. Tài khoản của bạn không có quyền truy cập tính năng này");
  } else {
    //throw  error message
    if (response.body.startsWith("{")) {
      final map = jsonDecode(response.body);
      if (map["message"] != null) throw TException("${map["message"]}");
      if (map["error"] != null) {
        throw TException("${map["error"]["message"]}");
      } else if (map["errors"] != null) {
        throw TException("${map["errors"]["error_title"]}");
      } else {
        throw TException("${response.statusCode}, ${response.reasonPhrase}");
      }
    } else
      throw TException("${response.statusCode}, ${response.reasonPhrase}");
  }
}

class TException implements Exception {
  TException([this.message]);
  final dynamic message;
  String toString() {
    final Object message = this.message;
    if (message == null) return "Exception";
    return "$message";
  }
}
