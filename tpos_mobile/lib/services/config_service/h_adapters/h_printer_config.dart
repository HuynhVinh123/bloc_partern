import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:tpos_mobile/models/enums/font_scale.dart';
import 'package:tpos_mobile/resources/constant.dart';
import 'package:tpos_mobile/services/config_service/h_adapters/h_config_base.dart';
import 'package:tpos_mobile/services/print_service/printer_device.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';

import 'h_config_schema.dart';

const _invoiceFontScaleKey = HConfigSchema(
  'printerConfig_invoiceFontScale',
  FontScale.scale100,
);
const _invoicePaperSizeKey =
    HConfigSchema('printerConfig_InvoicePaperSize', 'BILL80-IMAGE');

const _invoicePrinterNameKey =
    HConfigSchema('printerConfig_invoicePrinterName', 'Xem và in');
const _printShipShowDepositAmountKey =
    HConfigSchema('printerConfig_printShopShowDepositAmount', false);

const _printShipShowInvoiceNoteKey =
    HConfigSchema('printerConfig_printShipShowInvoiceNote', false);

const _printShipShowProductQuantityKey =
    HConfigSchema('printerConfig_printShipShowProductQuantity', false);

const _saleOnlinePrinterNameKey = HConfigSchema(
    'printerConfig_saleOnlinePrinterName', 'Máy ESC/POS (In qua Wifi)');
const _shipFontScaleKey = HConfigSchema(
  'printerConfig_shipFontScale',
  FontScale.scale100,
);

const _shipPaperSizeKey =
    HConfigSchema('printerConfig_ShipPaperSize', 'BILL80-IMAGE');
const _shipPrinterNameKey =
    HConfigSchema('printerConfig_shipPrinterName', 'Xem và in');

class HPrinterConfig extends HconfigBase {
  HPrinterConfig(Box hive) : super(hive);
  bool _printShipShowInvoiceNote;

  /// The printers of the shop.
  List<PrinterDevice> _printerDevices;

  /// tên máy in phiếu
  String _saleOnlinePrinterName;

  /// Tỉ lệ scale font chữ phiếu bán hàng. T
  /// Cài đặt này sẽ không được cache trong ram.
  FontScale get invoiceFontScale {
    final String value = hive.get(_invoiceFontScaleKey.key);
    if (value != null && value.isNotEmpty) {
      return value.toEnum<FontScale>(FontScale.values);
    }
    return _invoiceFontScaleKey.defaultValue;
  }

  set invoiceFontScale(FontScale value) {
    hive.put(_shipFontScaleKey.key, value.describe());
  }

  String get invoicePaperSize {
    final value = hive.get(_invoicePaperSizeKey.key);
    return value ?? _invoicePaperSizeKey.defaultValue;
  }

  set invoicePaperSize(String value) =>
      hive.put(_invoicePaperSizeKey.key, value);

  PrinterDevice get invoicePrinterDevice {
    return printerDevices.firstWhere(
        (element) => element.name == invoicePrinterName,
        orElse: () => null);
  }

  /// Get the name of the invoice printer.
  String get invoicePrinterName => hive.get(_invoicePrinterNameKey.key,
      defaultValue: _invoicePrinterNameKey.defaultValue);

  /// Set the name of the invoice printer.
  set invoicePrinterName(String value) {
    hive.put(_invoicePrinterNameKey.key, value);
  }

  /// Get printers of the shop.
  List<PrinterDevice> get printerDevices {
    if (_printerDevices == null) {
      final String json = hive.get('printerConfig_printerDevices');
      if (json != null) {
        final Map<String, dynamic> map = jsonDecode(json);
        if (map['printers'] != null) {
          _printerDevices = (map['printers'] as List)
              .map((e) => PrinterDevice.fromJson(e))
              .toList();
        }
      }
    }
    _printerDevices ??= Const.defaultPrinterDevices;
    return _printerDevices;
  }

  /// Set printers of the shop.
  set printerDevices(List<PrinterDevice> devices) {
    _printerDevices = devices;
    final json = <String, dynamic>{
      'printers': devices.map((e) => e.toJson()).toList(),
    };

    hive.put('printerConfig_printerDevices', jsonEncode(json));
  }

  /// Get the value that Whether to show the deposit amount in the delivery print template.
  bool get printShipShowDepositAmount =>
      hive.get(_printShipShowDepositAmountKey.key,
          defaultValue: _printShipShowDepositAmountKey.defaultValue);

  /// Set the value for [printShipShowDepositAmount].
  set printShipShowDepositAmount(bool value) {
    hive.put(_printShipShowDepositAmountKey.key, value);
  }

  /// Get the value that whether to show note of invoice when print delivery template.
  bool get printShipShowInvoiceNote =>
      _printShipShowInvoiceNote ??= hive.get(_printShipShowInvoiceNoteKey.key,
          defaultValue: _printShipShowInvoiceNoteKey.defaultValue);

  set printShipShowInvoiceNote(bool value) {
    _printShipShowInvoiceNote = value;
    hive.put(_printShipShowInvoiceNoteKey.key, value);
  }

  /// Get the value that Whether to show product quantity when print delivery template.
  bool get printShipShowProductQuantity =>
      hive.get(_printShipShowProductQuantityKey.key) ??
      _printShipShowProductQuantityKey.defaultValue;

  set printShipShowProductQuantity(bool value) {
    hive.put(_printShipShowProductQuantityKey.key, value);
  }

  PrinterDevice get saleOnlinePrinterDevice {
    return printerDevices.firstWhere(
        (element) => element.name == saleOnlinePrinterName,
        orElse: () => null);
  }

  String get saleOnlinePrinterName =>
      _saleOnlinePrinterName ??= hive.get(_saleOnlinePrinterNameKey.key,
          defaultValue: _saleOnlinePrinterNameKey.defaultValue);

  set saleOnlinePrinterName(String value) {
    _saleOnlinePrinterName = value;
    hive.put(_saleOnlinePrinterNameKey.key, value);
  }

  FontScale get shipFontScale {
    final String value = hive.get(_shipFontScaleKey.key);
    if (value != null && value.isNotEmpty) {
      return value.toEnum<FontScale>(FontScale.values);
    }
    return _shipFontScaleKey.defaultValue;
  }

  set shipFontScale(FontScale value) {
    hive.put(_shipFontScaleKey.key, value.describe());
  }

  String get shipPaperSize => hive.get(_shipPaperSizeKey.key,
      defaultValue: _shipPaperSizeKey.defaultValue);

  set shipPaperSize(String value) => hive.put(_shipPaperSizeKey.key, value);

  PrinterDevice get shipPrinterDevice {
    return printerDevices.firstWhere(
        (element) => element.name == shipPrinterName,
        orElse: () => null);
  }

  /// Get the name of the (delivery printer)
  String get shipPrinterName => hive.get(_shipPrinterNameKey.key,
      defaultValue: _shipPrinterNameKey.defaultValue);

  /// Set the name of the delivery printer.
  set shipPrinterName(String value) {
    hive.put(_shipPrinterNameKey.key, value);
  }

  @override
  void fromJson(Map<String, dynamic> json) {
    saleOnlinePrinterName =
        json[_saleOnlinePrinterNameKey.key] ?? saleOnlinePrinterName;
    invoicePrinterName = json[_invoicePrinterNameKey.key] ?? invoicePrinterName;
    invoiceFontScale = json[_invoiceFontScaleKey.key] ?? invoicePrinterName;
    invoicePaperSize = json[_invoicePaperSizeKey.key] ?? invoicePaperSize;

    shipPrinterName = json[_shipPrinterNameKey.key] ?? shipPrinterName;
    shipPaperSize = json[_shipPaperSizeKey.key] ?? shipPaperSize;
    shipFontScale = json[_shipFontScaleKey.key] ?? shipFontScale;
    printShipShowInvoiceNote =
        json[_printShipShowInvoiceNoteKey.key] ?? printShipShowInvoiceNote;
    printShipShowProductQuantity = json[_printShipShowProductQuantityKey.key] ??
        printShipShowProductQuantity;
    printShipShowDepositAmount =
        json[_printShipShowDepositAmountKey.key] ?? printShipShowDepositAmount;
  }

  @override
  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[_saleOnlinePrinterNameKey.key] = saleOnlinePrinterName;

    data[_invoicePaperSizeKey.key] = invoicePaperSize;
    data[_invoiceFontScaleKey.key] = invoiceFontScale;
    data[_invoicePrinterNameKey.key] = invoicePrinterDevice;

    data[_shipFontScaleKey.key] = shipFontScale;
    data[_shipPrinterNameKey.key] = shipPrinterName;
    data[_printShipShowInvoiceNoteKey.key] = printShipShowInvoiceNote;
    data[_printShipShowDepositAmountKey.key] = printShipShowDepositAmount;
    data[_printShipShowProductQuantityKey.key] = printShipShowProductQuantity;

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }

  void updatePrinterDevice(PrinterDevice device) {
    final existsDevice = printerDevices.firstWhere(
        (element) => element.name == device.name,
        orElse: () => null);

    PrinterDevice updateDevice;
    updateDevice = existsDevice ?? PrinterDevice();
    updateDevice.name = device.name;
    updateDevice.ip = device.ip;
    updateDevice.port = device.port;
    updateDevice.type = device.type;
    updateDevice.delayBeforeDisconnectMs = device.delayBeforeDisconnectMs;
    updateDevice.delayTimeMs = device.delayTimeMs;
    updateDevice.isDefault = device.isDefault;
    updateDevice.overideSetting = device.overideSetting;
    updateDevice.note = device.note;
    updateDevice.packetSize = device.packetSize;
    updateDevice.profileName = device.profileName;

    if (existsDevice == null) {
      printerDevices.add(updateDevice);
    }

    printerDevices = printerDevices;
  }
}
