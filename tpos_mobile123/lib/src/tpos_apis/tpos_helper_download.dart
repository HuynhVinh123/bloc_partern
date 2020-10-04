import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tpos_mobile/feature_group/sale_online/services/service.dart';
import 'package:tpos_mobile/locator.dart';

Future<String> downloadExcel(
    {String path,
    String method = "post",
    String nameFile,
    String body = ""}) async {
  Permission _permissionHandler = Permission.storage;
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
    ISettingService _setting = locator<ISettingService>();

    BaseOptions options = BaseOptions(
        connectTimeout: 30000,
        receiveTimeout: 30000,
        headers: {
          "Authorization": 'Bearer ${_setting.shopAccessToken}',
        },
        contentType: "application/json");

    Dio dio = Dio(options);
    String dirloc = "";

    if (Platform.isAndroid) {
      dirloc = "/sdcard/download/com-";
    } else {
      dirloc = (await getApplicationDocumentsDirectory()).path;
    }

    String dateCreated =
        DateFormat("dd-MM-yyyy(hh-mm-ss)").format(DateTime.now());
    String fileName = dirloc + nameFile + "-$dateCreated" + ".xlsx";
    String shopUrl = "${_setting.shopUrl}";
    String url = "$shopUrl$path";
    var response = await dio.download(url, fileName,
        options: Options(method: method), data: body);
    if (response.statusCode == 200) {
      return fileName;
    }
    throw new Exception("${response.statusCode}, ${response.statusMessage}");
  }
  return null;
}
