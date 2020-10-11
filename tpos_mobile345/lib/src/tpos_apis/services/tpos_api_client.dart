import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';

import 'package:tpos_mobile/services/log_services/log_service.dart';

/// Custome Client
class TPosClient extends http.BaseClient {
  final http.Client _inner;
  final _setting = locator<ISettingService>();
  final String _appVersion;

  TPosClient(this._inner, this._appVersion);
  @override
  Future<StreamedResponse> send(BaseRequest request) {
    // request.headers['user-agent'] = "";
    request.headers["Authorization"] = "Bearer ${_setting.shopAccessToken}";
    request.headers["MobileAppVersion"] = "$_appVersion";
    request.headers["Content-Type"] = "application/json";

    return _inner.send(request);
  }
}

/// GET, POST, DELETE, PUT with TPOS URL AND BASE OPTION
class TposApiClient {
  ISettingService _setting;
  LogService _log;
  TposApiClient(
      {ISettingService settingService,
      LogService logService,
      Client httpClient,
      TPosClient apiClient}) {
    _setting = settingService ?? locator<ISettingService>();
    _log = logService ?? locator<LogService>();
    initClient();
  }

  TPosClient _client;
  String get shopUrl => "${_setting.shopUrl}";
  String get _accessToken => _setting.shopAccessToken;

  /// Khởi tạo client
  /// chạy sau khi đăng nhập hoặc khởi động chương trình
  void initClient({TPosClient client}) {
    _client?.close();
    _client = client ?? new TPosClient(new Client(), App.appVersion);
  }

  /// http GET
  Future<Response> httpGet(
      {String path,
      bool useBasePath = true,
      Map<String, dynamic> param,
      int timeoutInSecond = 300}) async {
    String url = path;
    if (useBasePath) {
      String content = buildUrlEncodeString(param);
      url = "$shopUrl$path$content";
    }
    _log.info("TPOS API GET " + url);
    var response = await _client
        .get(url)
        .timeout((new Duration(seconds: timeoutInSecond)));

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
    String content = buildUrlEncodeString(params);
    if (useBasePath) {
      url = "$shopUrl$path$content";
    }
    _log.info("TPOS POST: $url\n BODY: ");
    _log.info(body);
    var response = await _client.post(url, body: body).timeout(timeOut);

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
    var response = await _client.put(url, body: body);

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
    var response = await _client.delete(
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
    var response = await _client.patch(url, body: body);

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
    throw new Exception(
        "Tài khoản chưa đăng nhập. Vui lòng đăng xuất và đăng nhập lại");
  } else if (response.statusCode == 402) {
    throw new Exception("Tài khoản chưa thanh toán");
  } else if (response.statusCode == 403) {
    throw new Exception(
        "403. Forbidden. Tài khoản của bạn không có quyền truy cập tính năng này");
  } else {
    //throw  error message
    if (response.body.startsWith("{")) {
      var map = jsonDecode(response.body);
      if (map["message"] != null) throw new Exception("${map["message"]}");
      if (map["error"] != null) {
        throw new Exception("${map["error"]["message"]}");
      } else if (map["errors"] != null) {
        throw new Exception("${map["errors"]["error_title"]}");
      } else {
        throw new Exception("${response.statusCode}, ${response.reasonPhrase}");
      }
    } else
      throw new Exception("${response.statusCode}, ${response.reasonPhrase}");
  }
}
