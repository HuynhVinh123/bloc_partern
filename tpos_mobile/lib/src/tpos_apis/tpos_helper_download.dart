import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tpos_mobile/feature_group/sale_online/services/service.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';

Future<String> downloadExcel(
    {String path,
    String method = "post",
    String nameFile,
    String body = ""}) async {
  final Permission _permissionHandler = Permission.storage;
  var status = await _permissionHandler.status;

  if (status == PermissionStatus.undetermined) {
    await Permission.storage.request();
    status = await _permissionHandler.status;
  }
  if (status == PermissionStatus.denied) {
    await Permission.storage.request();
    status = await _permissionHandler.status;
  }
  if (status == PermissionStatus.granted) {
    final ISettingService _setting = locator<ISettingService>();
    final SecureConfigService _secureConfig = GetIt.I<SecureConfigService>();

    final BaseOptions options = BaseOptions(
        connectTimeout: 30000,
        receiveTimeout: 30000,
        headers: {
          "Authorization": 'Bearer ${_secureConfig.shopToken}',
        },
        contentType: "application/json");

    final Dio dio = Dio(options);
    String dirloc = "";

    if (Platform.isAndroid) {
      dirloc = "/sdcard/download/com-";
    } else {
      dirloc = (await getApplicationDocumentsDirectory()).path;
    }

    final String dateCreated =
        DateFormat("dd-MM-yyyy(hh-mm-ss)").format(DateTime.now());
    final String fileName = dirloc + nameFile + "-$dateCreated" + ".xlsx";
    final String shopUrl = "${_secureConfig.shopUrl}";
    final String url = "$shopUrl$path";
    final response = await dio.download(url, fileName,
        options: Options(method: method), data: body);
    if (response.statusCode == 200) {
      return fileName;
    }
    throw Exception("${response.statusCode}, ${response.statusMessage}");
  }
  return null;
}
