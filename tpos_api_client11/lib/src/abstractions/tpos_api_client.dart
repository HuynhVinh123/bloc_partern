import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/src/exceptions/tpos_api_exception.dart';

abstract class TPosApi {
  Interceptors get interceptors;
  Dio get dio;
  Future<T> httpGet<T>(
    String path, {
    Map<String, dynamic> parameters,
    bool Function(int code) successCondition,
    CancelToken cancelToken,
  });

  Future<T> httpGetRaw<T>(
    String path, {
    Map<String, dynamic> parameters,
    bool Function(int code) successCondition,
    CancelToken cancelToken,
  });

  Future<T> httpPost<T>(
    String path, {
    dynamic data,
    Map<String, dynamic> parameters,
    bool Function(int code) successCondition,
    Options options,
    CancelToken cancelToken,
    bool catchDefaultException = true,
  });

  Future<T> httpPatch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic> parameters,
    bool Function(int code) successCondition,
    Options options,
    CancelToken cancelToken,
    bool catchDefaultException = true,
  });

  httpPut<T>(String path, {Map<String, dynamic> parameters, dynamic data});

  Future<T> httpDelete<T>(String path,
      {dynamic data,
      Options options,
      Map<String, dynamic> parameters,
      bool Function(int code) successCondition,
      CancelToken cancelToken,
      bool catchDefaultException = true});

  Future<void> config({ApiConfig config});
}

class TPosApiClient extends TPosApi {
  TPosApiClient({Dio dio, @required ApiConfig apiConfig}) {
    _dio = dio ?? Dio();
    _config = apiConfig;
  }
  final Logger _logger = Logger();
  Dio _dio;
  ApiConfig _config;

  Dio get dio => _dio;
  Interceptors get interceptors => _dio.interceptors;

  Future<void> config({@required ApiConfig config}) async {
    assert(config != null);
    assert(config.url != null);
    assert(config.token != null);
    assert(config.version != null);
    _config = config;
    await setup();
  }

  Future<void> setup() async {
    _dio.options.baseUrl = _config.url;
    _dio.options.contentType = ContentType.json.toString();
    _dio.options.headers = {
      'Authorization': 'Bearer ${_config.token}',
      'MobileAppVersion': _config.version
    };
  }

  @override
  Future<T> httpGet<T>(String path,
      {Map<String, dynamic> parameters,
      CancelToken cancelToken,
      bool Function(int code) successCondition}) async {
    try {
      final Response<T> result = await _dio.get<T>(
        path,
        queryParameters: parameters,
        cancelToken: cancelToken,
      );
      return result.data;
    } catch (e) {
      throw _getException(e);
    }
  }

  @override
  Future<T> httpGetRaw<T>(String path,
      {Map<String, dynamic> parameters,
      CancelToken cancelToken,
      bool Function(int code) successCondition}) async {
    final Response<T> result = await _dio.get<T>(
      path,
      queryParameters: parameters,
      cancelToken: cancelToken,
    );
    return result.data;
  }

  @override
  Future<T> httpPost<T>(
    String path, {
    dynamic data,
    Options options,
    Map<String, dynamic> parameters,
    bool Function(int code) successCondition,
    CancelToken cancelToken,
    bool catchDefaultException = true,
  }) async {
    try {
      final Response<T> result = await _dio.post<T>(path,
          data: data,
          queryParameters: parameters,
          cancelToken: cancelToken,
          options: options);
      return result.data;
    } catch (e) {
      if (catchDefaultException) {
        throw _getException(e);
      }
      rethrow;
    }
  }

  @override
  Future<T> httpPatch<T>(
    String path, {
    dynamic data,
    Options options,
    Map<String, dynamic> parameters,
    bool Function(int code) successCondition,
    CancelToken cancelToken,
    bool catchDefaultException = true,
  }) async {
    try {
      final Response<T> result = await _dio.patch<T>(path,
          data: data,
          queryParameters: parameters,
          cancelToken: cancelToken,
          options: options);
      return result.data;
    } catch (e) {
      if (catchDefaultException) {
        throw _getException(e);
      }
      rethrow;
    }
  }

  @override
  Future<T> httpPut<T>(String path,
      {Map<String, dynamic> parameters, dynamic data}) async {
    try {
      final Response<dynamic> response =
          await _dio.put<T>(path, queryParameters: parameters, data: data);
      return response.data;
    } catch (e) {
      throw _getException(e);
    }
  }

  Future<T> httpDelete<T>(String path,
      {dynamic data,
      Options options,
      Map<String, dynamic> parameters,
      bool Function(int code) successCondition,
      CancelToken cancelToken,
      bool catchDefaultException = true}) async {
    try {
      final Response<T> response = await _dio.delete(
        path,
        data: data,
        queryParameters: parameters,
        cancelToken: cancelToken,
        options: options,
      );

      return response.data;
    } catch (e, s) {
      if (catchDefaultException) {
        throw _getException(e);
      }
      rethrow;
    }
  }

  Exception _getException(error) {
    if (error is Exception) {
      if (error is DioError) {
        try {
          switch (error.type) {
            case DioErrorType.CONNECT_TIMEOUT:
              return TPosApiExceptions.requestTimeout();
            case DioErrorType.SEND_TIMEOUT:
              return TPosApiExceptions.sendTimeout();
            case DioErrorType.RECEIVE_TIMEOUT:
              return TPosApiExceptions.sendTimeout();
            case DioErrorType.RESPONSE:
              switch (error.response.statusCode) {
                case 400:
                  return TPosApiExceptions.badRequest(
                    json: error.response.data,
                  );
                case 401:
                  return TPosApiExceptions.unauthorisedRequest();
                case 403:
                  return TPosApiExceptions.unauthorisedRequest();
                case 404:
                  return TPosApiExceptions.notFound();
                case 500:
                  return TPosApiExceptions.internalServerError(
                      json: error.response.data);
                case 503:
                  return TPosApiExceptions.serviceUnavailable();
                default:
                  return TPosApiExceptions.defaultE(
                      '${error.response.statusCode}');
              }

              break;
            case DioErrorType.CANCEL:
              return TPosApiExceptions.requestCancelled();
              break;
            case DioErrorType.DEFAULT:
              return TPosApiExceptions.noInternetConnection();

            default:
              return TPosApiExceptions.defaultE('');
          }
        } catch (e) {
          return TPosApiExceptions.defaultE('');
        }
      } else if (error is SocketException) {
        return TPosApiExceptions.noInternetConnection();
      } else {
        return TPosApiExceptions.unexpectedError();
      }
    } else {
      if (error.toString().contains('is not subtype of')) {
        return TPosApiExceptions.unableToProcess();
      } else {
        return TPosApiExceptions.unexpectedError();
      }
    }
  }
}

class ApiConfig {
  ApiConfig({this.url, this.token, this.version});
  String url;
  String token;
  String version;
}

bool isJson(String str) {
  try {
    json.decode(str);
  } catch (e) {
    return false;
  }
  return true;
}
