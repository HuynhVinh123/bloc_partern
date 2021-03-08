/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tmt_flutter_untils/sources/color_utils/color_utils.dart';
import 'package:tpos_mobile/services/cache_service/cache_service.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

/// Lấy màu trạng thái khách hàng từ trạng thái text (Bình thường, bom hàng...)
Color getPartnerStatusColorFromStatusText(String statusText) {
  final cache = GetIt.I<CacheService>();

  final String hexColor = cache.partnerStatus[statusText];
  return ColorUtils.fromHex(hexColor) ?? Colors.grey;
}

@Deprecated("Không sử dụng do công thức thay đổi")
Color getColorFromPartnerStatus(String status) {
  switch (status) {
    case "Warning":
      return Colors.orange;
      break;
    case "Vip":
      return Colors.green;
      break;
    case "Bomb":
      return Colors.red;
      break;
    case "Normal":
      return Colors.greenAccent.shade200;
      break;
    default:
      return Colors.grey.shade400;
      break;
  }
}

@Deprecated("Không sử dụng do công thức thay đổi")

/// Lấy màu từ trạng thái khách hàng
List getTextColorFromParterStatus(String status) {
  switch (status) {
    case "Warning":
      return [Colors.orange, Colors.white];
      break;
    case "Vip":
      return [Colors.green, Colors.white];
      break;
    case "Bomb":
      return [Colors.red, Colors.white];
      break;
    case "Normal":
      return [Colors.greenAccent.shade100, Colors.black];
      break;
    default:
      return [Colors.white, Colors.black];
      break;
  }
}

@Deprecated("Không sử dụng do công thức thay đổi")
Color getPartnerStatusColor(String style, [String status]) {
  final Map<String, Color> bootstrapColors = {
    "primary": const Color.fromARGB(204, 229, 255, 1),
    "secondary": const Color.fromRGBO(226, 227, 229, 1),
    "success": const Color.fromRGBO(92, 184, 92, 1),
    "danger": const Color.fromRGBO(217, 83, 79, 1),
    "warning": const Color.fromRGBO(240, 173, 78, 1),
    "info": const Color.fromRGBO(189, 13, 95, 1),
    "Bomb": const Color.fromRGBO(217, 83, 79, 1),
    "Warning": const Color.fromRGBO(240, 173, 78, 1),
    "Normal": const Color.fromRGBO(226, 227, 229, 1),
  };
  return bootstrapColors[style ?? ""] ?? bootstrapColors["secondary"];
}

Color getColorStatusPartner(String colorHex) {
  int color = int.parse('0xFF9E9E9E');

  if (colorHex != null && colorHex != '' && colorHex.contains("#")) {
    color = int.parse("0xFF${colorHex.replaceAll("#", "")}");
  }
  return Color(color);
}

FastSaleOrderStateOption getFastSaleOrderStateOption({String state}) {
  final List<FastSaleOrderStateOption> options = [
    FastSaleOrderStateOption(
        state: FastSaleOrderState.draft,
        description: S.current.draft,
        backgroundColor: Colors.white,
        textColor: Colors.grey),
    FastSaleOrderStateOption(
        state: FastSaleOrderState.open,
        description: S.current.confirmed,
        backgroundColor: Colors.blue,
        textColor: Colors.blue),
    FastSaleOrderStateOption(
        state: FastSaleOrderState.cancel,
        description: S.current.cancel,
        backgroundColor: Colors.orange,
        textColor: Colors.red),
    FastSaleOrderStateOption(
        state: FastSaleOrderState.paid,
        description: S.current.paid,
        backgroundColor: Colors.orange,
        textColor: Colors.green),
    FastSaleOrderStateOption(
        state: FastSaleOrderState.na,
        description: "N/A",
        backgroundColor: Colors.orange,
        textColor: Colors.orange),
  ];

  return options.firstWhere((f) => f.state.toString().contains(state ?? ""),
      orElse: () => options.last);
}

Color getSaleOrderColor(String state) {
  switch (state) {
    case "draft":
      return Colors.grey;
      break;
    case "sale":
      return Colors.blue;
      break;
    default:
      return Colors.grey;
  }
}

Color getSaleOnlineOrderColor(String state) {
  switch (state) {
    case "Nháp":
      return Colors.grey;
      break;
    case "Đơn hàng":
      return Colors.orange;
      break;
    default:
      return Colors.grey;
  }
}

SaleOrderStateOption getSaleOrderStateOption({String state}) {
  final List<SaleOrderStateOption> options = [
    SaleOrderStateOption(
        state: SaleOrderState.no,
        description: S.current.NoNeedToCreateInvoice,
        backgroundColor: Colors.orange,
        textColor: Colors.red),
    SaleOrderStateOption(
        state: SaleOrderState.toinvoice,
        description: S.current.waitForTheInvoice,
        backgroundColor: Colors.blue,
        textColor: Colors.blue),
    SaleOrderStateOption(
        state: SaleOrderState.invoiced,
        description: S.current.invoiceCreated,
        backgroundColor: Colors.orange,
        textColor: Colors.green),
    SaleOrderStateOption(
        state: SaleOrderState.na,
        description: "N/A",
        backgroundColor: Colors.orange,
        textColor: Colors.black),
  ];

  return options.firstWhere((f) => f.state.toString().contains(state ?? ""),
      orElse: () => options.last);
}

String convertShipStatusToVietnamese(String status) {
  switch (status) {
    case "sent":
      return S.current.received;
      break;
    case "cancel":
      return S.current.canceled;
      break;
    case "none":
      return S.current.hasNotReceived;
      break;
    case "done":
      return S.current.collectedMoney;
      break;
    default:
      return status;
  }
}

// Quét mã vạch
// Future<ScanBarcodeResult> scanBarcode() async {
//   return ScanBarcodeResult(message: 'must-fix');
// }

class ScanBarcodeResult {
  ScanBarcodeResult({this.result = "", this.isError = false, this.message});
  final String result;
  final bool isError;
  final String message;
}

class FastSaleOrderStateOption {
  FastSaleOrderStateOption(
      {this.state, this.description, this.backgroundColor, this.textColor});
  FastSaleOrderState state;
  String description;
  Color backgroundColor;
  Color textColor;
}

Future confirmClosePage(BuildContext context,
    {String title = "Xác nhận đóng",
    String message = "Bạn có muốn đóng trang này không?"}) async {
  return await showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        title,
        style: const TextStyle(color: Colors.deepOrangeAccent),
      ),
      content: Text(message),
      actions: <Widget>[
        // hủy bỏ
        FlatButton(
          child: Text(S.current.cancel.toUpperCase()),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        // XÁC NHẬN"
        FlatButton(
          child: Text(S.current.confirm.toUpperCase()),
          onPressed: () {
            Navigator.pop(context, true);
          },
        )
      ],
    ),
  );
}

class SaleOrderStateOption {
  SaleOrderStateOption(
      {this.state, this.description, this.backgroundColor, this.textColor});
  SaleOrderState state;
  String description;
  Color backgroundColor;
  Color textColor;
}

String getNetworkName(String number) {
  String nameNetwork = '';
  number = number.replaceAll(' ', '');
  number = number.replaceAll('-', '');
  if (number.length > 3) {
    String numberCountry = number.substring(0, 3);
    if (numberCountry == '+84') {
      number = number.replaceAll('+84', '0');
    } else {
      numberCountry = number.substring(0, 2);
      if (numberCountry == '84') {
        numberCountry = number.substring(2, number.length);
        number = '0' + numberCountry;
      }
    }
  }
  if (number.length == 10) {
    final String headerPhoneNumber = number.substring(0, 3);
    if (headerPhoneNumber == '086' ||
        headerPhoneNumber == '096' ||
        headerPhoneNumber == '097' ||
        headerPhoneNumber == '098' ||
        headerPhoneNumber == '032' ||
        headerPhoneNumber == '033' ||
        headerPhoneNumber == '034' ||
        headerPhoneNumber == '035' ||
        headerPhoneNumber == '036' ||
        headerPhoneNumber == '037' ||
        headerPhoneNumber == '038' ||
        headerPhoneNumber == '039') {
      nameNetwork = 'Viettel';
    } else if (headerPhoneNumber == '089' ||
        headerPhoneNumber == '090' ||
        headerPhoneNumber == '093' ||
        headerPhoneNumber == '070' ||
        headerPhoneNumber == '079' ||
        headerPhoneNumber == '077' ||
        headerPhoneNumber == '076' ||
        headerPhoneNumber == '078') {
      nameNetwork = 'MobiFone';
    } else if (headerPhoneNumber == '088' ||
        headerPhoneNumber == '091' ||
        headerPhoneNumber == '094' ||
        headerPhoneNumber == '083' ||
        headerPhoneNumber == '084' ||
        headerPhoneNumber == '085' ||
        headerPhoneNumber == '081' ||
        headerPhoneNumber == '082') {
      nameNetwork = 'VinaPhone';
    } else if (headerPhoneNumber == '092' ||
        headerPhoneNumber == '056' ||
        headerPhoneNumber == '058') {
      nameNetwork = 'Vietnamobile';
    } else if (headerPhoneNumber == '099' || headerPhoneNumber == '059') {
      nameNetwork = 'Gmobile';
    } else {
      nameNetwork = 'N/A';
    }
  } else {
    nameNetwork = 'N/A';
  }
  return nameNetwork;
}
