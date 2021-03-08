import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/change_password_api.dart';

import '../../tpos_api_client.dart';

class ChangePasswordApiImpl implements ChangePasswordApi {
  ChangePasswordApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }
  TPosApiClient _apiClient;

  @override
  Future<bool> doChangeUserPassWord(
      {String oldPassword, String newPassword, String confirmPassWord}) async {
    final Map<String, dynamic> body = {
      "OldPassword": oldPassword,
      "NewPassword": newPassword,
      "ConfirmPassword": confirmPassWord,
    };
    debugPrint(
      const JsonEncoder.withIndent('  ').convert(body),
    );

    await _apiClient.httpPost(
      "/manage/changepassword",
      data: jsonEncode(body),
    );
    return true;
  }
}
