/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/5/19 4:54 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/5/19 2:54 PM
 *
 */

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_desktop/print_fast_sale_order_data.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_desktop/print_sale_online_data.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_desktop/print_ship_config.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_desktop/print_ship_data.dart';

import 'app_setting_service.dart';

abstract class ITPosDesktopService {
  void setConfig({String computerIp, String computerPort}) {}

  Future printSaleOnline(
    String size,
    String html,
    String note,
    PrintSaleOnlineData data,
  );

  Future<dynamic> printHtml(
      {String target,
      String url,
      String html,
      List<String> cssLink,
      String cssContent});

  Future<void> printShip({
    String hostName,
    int port,
    PrintShipData data,
    PrintShipConfig config,
    String size,
  });

  Future<void> printFastSaleOrder(
      {String ip, int port, String size, PrintFastSaleOrderData data});
}

class TPosDesktopService implements ITPosDesktopService {
  String _ipAddress;
  String _port;
  final setting = locator<ISettingService>();
  String get url =>
      "http://" +
      (setting.computerIp ?? "") +
      ":" +
      (setting.computerPort ?? "");

  Logger _log = new Logger("TPosDesktopService");

  TPosDesktopService({String computerIp, String computerPort}) {
    _ipAddress = computerIp;
    _port = computerPort;
  }
  @override
  Future printSaleOnline(
    String size,
    String html,
    String note,
    PrintSaleOnlineData data,
  ) async {
    var jsonMap = {
      "size": "BILL80",
      "note": note,
      "json": data.toJsonMap(),
    };
    var json = jsonEncode(jsonMap);

    var response = await http
        .post(
          "$url/print/html",
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: json,
        )
        .timeout(new Duration(seconds: 30));
    if (response.statusCode == 200) {
    } else {
      throw new Exception(
          "Lỗi request. Code: ${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  @override
  void setConfig({String computerIp, String computerPort}) {
    _ipAddress = computerIp;
    _port = computerPort;
  }

  @override
  Future printHtml(
      {String target,
      String url,
      String html,
      List<String> cssLink,
      String cssContent}) async {
    var jsonMap = {
      "target": target,
      "url": url,
      "html": html,
      "css": cssLink?.join(","),
      "cssContent": cssContent
    };

    var response = await http.post(
      "${this.url}/api/printhtml",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(jsonMap),
    );
  }

  @override
  Future<void> printShip(
      {String hostName,
      int port,
      PrintShipData data,
      PrintShipConfig config,
      String size}) async {
    String url = "http://$hostName:$port/print/ship";
    Map<String, dynamic> bodyMap = {
      "size": size ?? "A5Portrait",
      "data": data.toJson(true),
      "config": config,
    }..removeWhere((key, value) => value == null);

    _log.fine("printShip: $url");
    _log.fine(jsonEncode(bodyMap));
    var response = await http
        .post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode(bodyMap),
        )
        .timeout(
          new Duration(seconds: 30),
        );
    _log.fine("printShip: ${response.body}");

    if (response.statusCode != 200) {
      throw new Exception("Máy chủ in báo ko thể in. Không rõ lý do");
    }
  }

  @override
  Future<void> printFastSaleOrder(
      {String size, PrintFastSaleOrderData data, String ip, int port}) async {
    Map<String, dynamic> bodyMap = {
      "size": size ?? "BILL80",
      "data": data.toJson(true),
    }..removeWhere((key, value) => value == null);

    String url = "http://$ip:$port/print/fastsaleorder";
    _log.fine("printFastSaleOrder: $url");
    _log.fine(jsonEncode(bodyMap));
    var response = await http
        .post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode(bodyMap),
        )
        .timeout(
          new Duration(seconds: 30),
        );
    _log.fine("print fast sale order: ${response.body}");

    if (response.statusCode != 200) {
      throw new Exception("Máy chủ in báo ko thể in. Không rõ lý do");
    }
  }
}
