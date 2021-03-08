import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';
/// Lỗi này được trả về từ máy chủ
class TPosApiBadRequestException implements Exception {
  TPosApiBadRequestException({this.error});

  factory TPosApiBadRequestException.fromJson(Map<String, dynamic> json) {
    return TPosApiBadRequestException(
      error: TPosApiExceptionError.fromJson(
        json['error'],
      ),
    );
  }

  TPosApiExceptionError error;

  @override
  String toString() {
    return '';
  }
}

class TPosApiExceptionError {
  TPosApiExceptionError({this.code, this.message});
  TPosApiExceptionError.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    errorTitle = json['error_title'];
    errorDescription = json['error_description'];
    errors = json['errors'];
  }
  String code;
  String message;
  String errorTitle;
  String errorDescription;
  Map<String, dynamic> errors;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['error_title'] = errorTitle;
    data['error_description'] = errorDescription;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }

  @override
  String toString() {
    return message ?? '';
  }
}

class TPosApiExceptions implements Exception {
  TPosApiExceptions.unableToProcess() {
    _prefix = '';
    _message = S.current.network_badRequest;
  }

  TPosApiExceptions.unexpectedError() {
    _prefix = '';
    _message = S.current.network_default('');
  }

  TPosApiExceptions.noInternetConnection() {
    _prefix = '';
    _message = S.current.network_noInternetConnection;
  }

  TPosApiExceptions.socketException([SocketException errorCode]) {
    _prefix = '';

    if (errorCode?.osError?.errorCode == 104) {
      _message =
          '${S.current.network_cannotConnectServer}. Code: 104. Message: ${errorCode.osError.message}';
    } else if (errorCode?.osError?.errorCode == 110) {
      _message =
          "${S.current.network_connectTakeALongTime}. Code 110. Message: ${errorCode.osError.message}";
    } else if (errorCode?.osError?.errorCode == 113) {
      _message =
          "${S.current.network_cannotConnectServer}. Code 113. Message: ${errorCode.osError.message}";
    } else if (errorCode?.osError?.errorCode == 7) {
      _message = S.current.network_noInternetConnection;
    } else {
      _message =
          '${S.current.network_unknownError}. Code ${errorCode.osError.errorCode}. Message: ${errorCode.osError.message}';
    }
  }

  TPosApiExceptions.requestTimeout() {
    _message = S.current.network_requestTimeout;
  }

  TPosApiExceptions.gatewayTimeOut() {
    _message = S.current.network_sendTimeout;
  }
  TPosApiExceptions.sendTimeout() {
    _message = S.current.network_sendTimeout;
  }
  TPosApiExceptions.defaultE(String message) {
    _message = S.current.network_default(message);
  }
  TPosApiExceptions.badRequest({@required dynamic json}) {
    if (json is Map) {
      _message = _getErrorMessageFromJson(json);
    } else {
      _message = S.current.network_badRequest;
    }
  }
  TPosApiExceptions.unauthorisedRequest() {
    _message = S.current.network_authorisedRequest;
  }
  TPosApiExceptions.notFound() {
    _message = S.current.network_notFound;
  }
  TPosApiExceptions.internalServerError({@required dynamic json}) {
    if (json is Map) {
      _message = _getErrorMessageFromJson(json);
    } else {
      _message = S.current.network_internalServerError;
    }
  }
  TPosApiExceptions.serviceUnavailable() {
    _message = S.current.network_serviceUnavailable;
  }

  TPosApiExceptions.requestCancelled() {
    _message = S.current.network_requestCancelled;
  }

  String _prefix;
  String _message;
  dynamic innerException;

  @override
  String toString() => '${_prefix ?? ''}$_message';

  String _getErrorMessageFromJson(Map json) {
    String message = '';
    if (json['error_description'] != null) {
      message = json['error_description'];
      return message;
    }
    if (json['error'] != null) {
      if (json['error'] is Map) {
        final TPosApiBadRequestException innerException =
            TPosApiBadRequestException.fromJson(json);
        message = innerException.error.message;
      } else {
        message = json['error'];
      }
    }

    return message;
  }
}
