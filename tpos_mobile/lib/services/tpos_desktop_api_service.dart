/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/5/19 4:54 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/5/19 2:54 PM
 *
 */

import 'dart:async';
import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_desktop/print_fast_sale_order_data.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_desktop/print_sale_online_data.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_desktop/print_ship_config.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_desktop/print_ship_data.dart';
import 'package:tpos_mobile/locator.dart';

import 'app_setting_service.dart';
import 'config_service/shop_config_service.dart';

abstract class ITPosDesktopService {
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
  final Logger _log = Logger("TPosDesktopService");

  String getUrl() {
    final _setting = locator<ISettingService>();
    final _shopConfig = GetIt.I<ShopConfigService>();
    final _printer = _shopConfig.printerConfig.printerDevices.firstWhere(
        (element) =>
            element.name == _shopConfig.printerConfig.saleOnlinePrinterName,
        orElse: () => null);
    if (_printer == null) {
      throw Exception('Không tìm thấy máy in');
    }

    final url = 'http://${_printer.ip}:${_printer.port}';

    return url;
  }

  @override
  Future printSaleOnline(
    String size,
    String html,
    String note,
    PrintSaleOnlineData data,
  ) async {
    final jsonMap = {
      "size": "BILL80",
      "note": note,
      "json": data.toJsonMap(),
    };
    final json = jsonEncode(jsonMap);

    final response = await http
        .post(
          "${getUrl()}/print/html",
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: json,
        )
        .timeout(const Duration(seconds: 30));
    if (response.statusCode == 200) {
    } else {
      throw Exception(
          "Lỗi request. Code: ${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  @override
  Future printHtml(
      {String target,
      String url,
      String html,
      List<String> cssLink,
      String cssContent}) async {
    final jsonMap = {
      "target": target,
      "url": url,
      "html": html,
      "css": cssLink?.join(","),
      "cssContent": cssContent
    };

    await http.post(
      "${getUrl()}/api/printhtml",
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
    final String url = "http://$hostName:$port/print/ship";
    final Map<String, dynamic> bodyMap = {
      "size": size ?? "A5Portrait",
      "data": data.toJson(true),
      "config": config,
    }..removeWhere((key, value) => value == null);

    _log.fine("printShip: $url");
    _log.fine(jsonEncode(bodyMap));
    final response = await http
        .post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode(bodyMap),
        )
        .timeout(
          const Duration(seconds: 30),
        );
    _log.fine("printShip: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Máy chủ in báo ko thể in. Không rõ lý do");
    }
  }

  @override
  Future<void> printFastSaleOrder(
      {String size, PrintFastSaleOrderData data, String ip, int port}) async {
    final Map<String, dynamic> bodyMap = {
      "size": size ?? "BILL80",
      "data": data.toJson(true),
    }..removeWhere((key, value) => value == null);

    final String url = "http://$ip:$port/print/fastsaleorder";
    _log.fine("printFastSaleOrder: $url");
    _log.fine(jsonEncode(bodyMap));
    final response = await http
        .post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode(bodyMap),
        )
        .timeout(
          const Duration(seconds: 30),
        );
    _log.fine("print fast sale order: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Máy chủ in báo ko thể in. Không rõ lý do");
    }
  }
}
