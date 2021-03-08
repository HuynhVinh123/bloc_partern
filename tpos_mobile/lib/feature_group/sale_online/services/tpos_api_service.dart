/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/5/19 4:54 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/5/19 4:25 PM
 *
 */

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class HttpResult<T> {
  String error;
  bool success;
  String body;
  T result;
}

class TPosApiResult<T> {
  TPosApiResult({this.message, this.result, this.error = false});
  bool error;
  String message;
  T result;
}

class PartnerOdataError {
  PartnerOdataError({this.code, this.message, this.errorDescription});

  PartnerOdataError.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    message = json["message"];
    errorDescription = json["error_description"];
  }
  String code;
  String message;
  String errorDescription;
}

void throwOdataError(String errorBody) {
  final OdataError err = OdataError.fromJson(jsonDecode(errorBody));
  throw Exception(err.message);
}

Map<String, dynamic> getHttpResult(Response response) {
  if (response.statusCode.toString().startsWith("2")) {
    return jsonDecode(response.body);
  } else {
    throwHttpException(response);
    return null;
  }
}

String getHttpResultString(Response response) {
  if (response.statusCode.toString().startsWith("2")) {
    return response.body;
  } else {
    throwHttpException(response);
    return null;
  }
}

void catchOdataServerError(Response response) {}

void throwHttpException(Response rp) {
  if (rp.statusCode == 401) {
    throw Exception("Chưa đăng nhập. Vui lòng đăng nhập");
  } else if (rp.statusCode == 402) {
    throw Exception("Tài khoản chưa thanh toán");
  } else {
    throw Exception("${rp.statusCode}, ${rp.reasonPhrase}");
  }
}

void throwSocketException(SocketException ex) {
  throw Exception(
      "Không thể truy cập địa chỉ ${ex.address}. Vui lòng kiểm tra dịch vụ, mạng hoặc internet");
}

enum ProductSearchType {
  ALL,
  CODE,
  NAME,
  BARCODE,
}

class ProductSearchResult<T> extends TPosApiResult {
  ProductSearchResult(
      {this.resultCount, this.keyword, bool error, String message, T result})
      : super(error: error, message: message, result: result);
  int resultCount;
  String keyword;
}

class SearchResult<T> extends TPosApiResult {
  SearchResult(
      {this.resultCount, this.keyword, bool error, String message, T result})
      : super(error: error, message: message, result: result);
  int resultCount;
  String keyword;
}
