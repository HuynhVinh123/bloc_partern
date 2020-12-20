/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/5/19 4:54 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/5/19 4:12 PM
 *
 */

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:nam_esc_pos_printer/nam_esc_pos_printer.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart' show Printing;
import 'package:tmt_flutter_untils/tmt_flutter_utils.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/print_pos_data.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_desktop/print_fast_sale_order_config.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_desktop/print_fast_sale_order_data.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_desktop/print_sale_online_data.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_desktop/print_ship_config.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_desktop/print_ship_data.dart';
import 'package:tpos_mobile/helpers/app_helper.dart';
import 'package:tpos_mobile/helpers/esc_pos_image_printer/my_canvas_printer.dart';
import 'package:tpos_mobile/helpers/esc_pos_image_printer/order_template_printer.dart';
import 'package:tpos_mobile/helpers/ui_help.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/print_service/printer_device.dart';
import 'package:tpos_mobile/services/tpos_desktop_api_service.dart';
import 'package:tpos_mobile/src/number_to_text/number_to_text.dart';

import 'package:tpos_mobile/src/tpos_apis/models/printer_configs.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/company_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/fast_sale_order_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/sale_setting_api.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';

import 'app_setting_service.dart';

abstract class PrintService {
  Future<void> printSaleOnlineTag(
      {@required SaleOnlineOrder order,
      String comment,
      String partnerNote,
      String productName,
      String partnerStatus,
      String note,
      bool isPrintNode = false});

  /// In hóa đơn
  Future<void> printOrder({int fastSaleOrderId, FastSaleOrder fastSaleOrder});
  Future<ByteData> printShipImage80mm(PrintShipData data);
  Future<ByteData> printShipGhtkImage80mm(PrintShipData data);
  Future<ByteData> printFastSaleOrderImage80mm(PrintFastSaleOrderData data);

  ///In sale online test qua Lan
  Future<void> printSaleOnlineLanTest();

  ///In sale online test qua TPOS PRINTER
  Future printSaleOnlineViaComputerTest();
  Future<void> printGame(
      {String name, String uid, String phone, String partnerCode});

/*  CÁC HÀM IN MỚI*/

  /// In phiếu ship
  Future<void> printShip(
      {int fastSaleOrderId,
      FastSaleOrder fastSaleOrder,
      bool download = false});

  void clearCache();
  Future<void> printPos80mm(PrintPostData data);
  Future<void> printPosImage80mm(
      PrintPostData data, PrinterDevice settingPrinter);
}

class PosPrintService implements PrintService {
  PosPrintService(
      {ITposApiService tposApiService,
      ITPosDesktopService tposDesktop,
      ISettingService setting,
      FastSaleOrderApi fastSaleOrderApi,
      ISaleSettingApi saleSettingApi,
      ICompanyApi companyApi,
      PartnerApi partnerApi}) {
    _setting = setting ?? locator<ISettingService>();
    _tposApiService = tposApiService ?? locator<ITposApiService>();
    _tposDesktop = tposDesktop ?? locator<ITPosDesktopService>();
    _fastSaleOrderApi = fastSaleOrderApi ?? locator<FastSaleOrderApi>();
    _partnerApi = partnerApi ?? GetIt.I<PartnerApi>();
    _saleSettingApi = saleSettingApi ?? locator<ISaleSettingApi>();
    _companyApi = companyApi ?? locator<ICompanyApi>();
  }
  ITposApiService _tposApiService;
  ITPosDesktopService _tposDesktop;
  FastSaleOrderApi _fastSaleOrderApi;
  PartnerApi _partnerApi;
  ISaleSettingApi _saleSettingApi;
  ICompanyApi _companyApi;
  ISettingService _setting;
  final Logger _log = Logger("PosPrintService");

  /// Cache _companyConfig
  CompanyConfig _companyConfig;

  /// Cache PrinterConfig;
  PrinterConfig _printShipConfigCache;

  /// Cache Print Invoice Config
  PrinterConfig _printInvoiceConfigCache;

  /// Sale setting Cache
  SaleSetting _saleSettingCache;

  /// companyCache
  Company _companyCache;

  @override
  void clearCache() {
    _companyConfig = null;
    _printShipConfigCache = null;
    _printInvoiceConfigCache = null;
    _saleSettingCache = null;
    _companyCache = null;
  }

  /// Get and cache ShipOtherConfig
  PrintShipConfig _getPrintShipOtherConfig(PrinterConfig printShipConfig) {
    final PrintShipConfig shipConfig = PrintShipConfig();
    final others = printShipConfig?.others;
    if (others != null) {
      shipConfig.isHideShipAmount = others
              .firstWhere((f) => f.key == "config.hide_ship_amount",
                  orElse: () => null)
              ?.value ??
          false;

      shipConfig.isHideShip = others
              .firstWhere((f) => f.key == "config.hide_ship",
                  orElse: () => null)
              ?.value ??
          false;
      shipConfig.isHideNoteShip = others
              .firstWhere((f) => f.key == "config.hide_noteship",
                  orElse: () => null)
              ?.value ??
          false;
      shipConfig.isHideInfoShip = others
              .firstWhere((f) => f.key == "config.hide_infoship",
                  orElse: () => null)
              ?.value ??
          false;
      shipConfig.isHideAddress = others
              .firstWhere((f) => f.key == "config.hide_address",
                  orElse: () => null)
              ?.value ??
          false;
      shipConfig.isShowLogo = others
              .firstWhere((f) => f.key == "config.show_logo",
                  orElse: () => null)
              ?.value ??
          false;

      shipConfig.isHideCod = others
              .firstWhere((f) => f.key == "config.hide_COD", orElse: () => null)
              ?.value ??
          false;
      shipConfig.isHideInvoiceCode = others
              .firstWhere((f) => f.key == "config.hide_invoice_code",
                  orElse: () => null)
              ?.value ??
          false;
      shipConfig.isShowStaff = others
              .firstWhere((f) => f.key == "config.show_staff",
                  orElse: () => null)
              ?.value ??
          false;

      shipConfig.isHideTrackingRefSort = others
              .firstWhere((f) => f.key == "config.hide_trackingrefsort",
                  orElse: () => null)
              ?.value ??
          false;

      shipConfig.isHideTrackingArea = others
              .firstWhere((f) => f.key == "config.hide_tracking_area",
                  orElse: () => null)
              ?.value ??
          false;

      shipConfig.isHideWeightShip = others
              .firstWhere((f) => f.key == "config.hide_weight_ship",
                  orElse: () => null)
              ?.value ??
          false;

      shipConfig.isCoverPhone = others
              .firstWhere((f) => f.key == "config.cover_phone",
                  orElse: () => null)
              ?.value ??
          false;

      shipConfig.isShowQrCode = others
              .firstWhere((f) => f.key == "config.show_QrCode",
                  orElse: () => null)
              ?.value ??
          false;
      return shipConfig;
    }
    return null;
  }

  /// Get InvoiceOtherConfig
  PrintFastSaleOrderConfig _getPrintInvoiceOtherConfig(
      PrinterConfig printConfig) {
    final PrintFastSaleOrderConfig webPrintConfig = PrintFastSaleOrderConfig();
    // ignore: avoid_function_literals_in_foreach_calls
    printConfig.others.forEach((f) {
      switch (f.keyConfig) {
        case Config.hide_address:
          webPrintConfig.hideAddress = f.value;
          break;
        case Config.hide_product_code:
          webPrintConfig.hideProductCode = f.value;
          break;
        case Config.hide_delivery:
          webPrintConfig.hideDelivery = f.value;
          break;
        case Config.hide_debt:
          webPrintConfig.hideDebt = f.value;
          break;
        case Config.hide_logo:
          webPrintConfig.hideLogo = f.value;
          break;
        case Config.hide_receiver:
          webPrintConfig.hideReceiver = f.value;
          break;

        case Config.hide_phone:
          webPrintConfig.hidePhone = f.value;
          break;
        case Config.hide_staff:
          webPrintConfig.hideStaff = f.value;
          break;
        case Config.hide_amount_text:
          webPrintConfig.hideAmountText = f.value;
          break;
        case Config.hide_sign:
          webPrintConfig.hideSign = f.value;
          break;
        case Config.hide_TrackingRef:
          webPrintConfig.hideTrackingRef = f.value;
          break;
        case Config.hide_CustomerName:
          webPrintConfig.hideCustomerName = f.value;
          break;
        case Config.showbarcode:
          webPrintConfig.showBarcode = f.value;
          break;
        case Config.showweightship:
          webPrintConfig.showWeightShip = f.value;
          break;
        case Config.hide_product_note:
          webPrintConfig.hideProductNote = f.value;
          break;
        case Config.show_COD:
          webPrintConfig.showCod = f.value;
          break;
        case Config.show_revenue:
          webPrintConfig.showRevenue = f.value;
          break;
        case Config.show_combo:
          webPrintConfig.showCombo = f.value;
          break;
        case Config.show_tracking_ref_sort:
          webPrintConfig.showTrackingRefSoft = f.value;
          break;
        case Config.hide_company_address:
          webPrintConfig.hideCompanyAddress = f.value;
          break;
        case Config.hide_company_phone_number:
          webPrintConfig.hideCompanyPhoneNumber = f.value;
      }
    });

    return webPrintConfig;
  }

  /// Get and cache Print ship config
  Future<PrinterConfig> _getPrintShipConfig() async {
    _printShipConfigCache ??= await _tposApiService.getPrintShipConfig();
    return _printShipConfigCache;
  }

  /// Get and cache Print ship config
  Future<PrinterConfig> _getPrintInvoiceConfig() async {
    if (_printInvoiceConfigCache == null ||
        _printInvoiceConfigCache.code != "01") {
      _printInvoiceConfigCache = await _tposApiService.getPrintInvoiceConfig();
    }
    return _printInvoiceConfigCache;
  }

  /// Get and cache SaleSetting
  Future<SaleSetting> _getSaleSetting() async {
    _saleSettingCache ??= await _saleSettingApi.getDefault();
    return _saleSettingCache;
  }

  /// Get and cache Company
  Future<Company> _getCompany(int id) async {
    if (_companyCache == null || _companyCache.id != id) {
      _companyCache = await _companyApi.getById(id);
    }
    return _companyCache;
  }

  /// Cấu hình in saleonlin
  PrinterConfig get _saleOnlinePrinterConfig => _companyConfig?.printerConfigs
      ?.firstWhere((f) => f.code == "03", orElse: () => null);

  Future _fetchCompanyConfig() async {
    try {
      _companyConfig = await _companyApi.getCompanyConfig();
    } catch (e, s) {
      _log.severe(e.toString());
    }
  }

  String _getDeliverCarrierBarcode(String carrierType, String trackingRef) {
    if (trackingRef == null || trackingRef == "") return "";
    final type = carrierType.toLowerCase();
    switch (type) {
      case "ghtk":
        return trackingRef.split(".").last;
        break;
      case "ghn":
        return trackingRef;
        break;
      default:
        return trackingRef;
    }
  }

  String _getDeliveryCarrierCodeToShow(String carrierType, String trackingRef) {
    if (trackingRef == null || trackingRef == "") return "";
    switch (carrierType.toLowerCase()) {
      case "ghtk":
        return trackingRef.replaceAll("${trackingRef.split(".")[0]}.", "");

        break;
      case "ghn":
        return trackingRef;
        break;
      default:
        return trackingRef;
    }
  }

  /// In hóa đơn bán hàng nhanh
  @override
  Future<void> printOrder(
      {int fastSaleOrderId, FastSaleOrder fastSaleOrder}) async {
    // Lấy máy in
    final printerDevice = _setting.printers.firstWhere(
        (f) => f.name == _setting.fastSaleOrderInvoicePrinterName,
        orElse: () => null);

    if (printerDevice == null) {
      throw Exception(
          "Không tìm thấy máy in được cấu hình: ${_setting.fastSaleOrderInvoicePrinterName}. Vui lòng chọn lại trong Cài đặt-> Máy in -> Hóa đơn");
    }

    // Cấu hình in hóa đơn
    final printerConfig = await _getPrintInvoiceConfig();
    // Cấu hình bán hàng
    final saleSetting = await _getSaleSetting();

    if (printerDevice.type == "preview") {
      PdfPageFormat pdfFormat = PdfPageFormat.a4;
      if (printerConfig != null) {
        switch (printerConfig.template) {
          case "BILL80":
            pdfFormat = const PdfPageFormat(7.6, 20);
            break;
          case "A5":
            pdfFormat = PdfPageFormat.a5;
            break;
          case "A4":
            pdfFormat = PdfPageFormat.a4;
            break;
        }
      }

      var invoice = await _tposApiService.getFastSaleOrderPrintDataAsHtml(
          fastSaleOrderId: fastSaleOrderId ?? fastSaleOrder?.id,
          type: "invoice");

      if (invoice != null) {
        invoice = invoice
            .replaceAll('href="/Content', 'href="${_setting.shopUrl}/Content')
            .replaceAll('/Web', '${_setting.shopUrl}/Web');
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async {
            return await Printing.convertHtml(format: pdfFormat, html: invoice);
          },
        );
      }
    } else if (printerDevice.type == "tpos_printer") {
      await _printOrderTPosPrinter(printerDevice,
          printerConfig: printerConfig,
          orderId: fastSaleOrderId,
          order: fastSaleOrder,
          saleSetting: saleSetting);
    } else if (printerDevice.type == "esc_pos") {
      await _printOrderLan(printerDevice,
          orderId: fastSaleOrderId,
          order: fastSaleOrder,
          printerConfig: printerConfig,
          saleSetting: saleSetting);
    }
  }

  @override
  Future<void> printShip(
      {int fastSaleOrderId,
      FastSaleOrder fastSaleOrder,
      bool download = false}) async {
    assert(fastSaleOrderId != null || fastSaleOrder != null);
    // Lấy thông tin hóa đơn
    FastSaleOrder order;
    if (fastSaleOrder != null) {
      order = fastSaleOrder;
    } else {
      order = await _fastSaleOrderApi.getById(fastSaleOrderId);
    }

    // Nếu là Okiela thì tài pdf
    if (order.carrierDeliveryType == "OkieLa") {
      final link = await _fastSaleOrderApi.printOkielaShip(order.id);

      if (Platform.isIOS) {
        urlLauch(link);
      } else {
        if (!download) {
          final Directory tempDir = await getTemporaryDirectory();
          final String fileName = "${tempDir.path}/${link.split("/").last}";
          final File file = File.fromUri(Uri(path: fileName));

          Printing.layoutPdf(
            onLayout: (PdfPageFormat format) async => file.readAsBytesSync(),
            format: const PdfPageFormat(252, 252),
          );
        } else {
          urlLauch(link);
        }
      }
      return;
    }

    // Đọc cấu hình
    final PrinterDevice printerDevice =
        _setting.printers.firstWhere((f) => f.name == _setting.shipPrinterName);
    final printShipConfig = await _getPrintShipConfig();

    // In preview nếu máy in là preview và in qua lan
    if (_setting.shipPrinterName == "Xem và in") {
      _printShipViaPreivew(fastSaleOrderId, order.carrierId, printShipConfig);
      return;
    }

    final saleSetting = await _getSaleSetting();
    final company = await _getCompany(order.companyId);

    // Tạo dữ liệu in theo mẫu
    String temDeliveryNote = order.deliveryNote;
    if (order.orderLines != null && order.orderLines.isNotEmpty) {
      if (temDeliveryNote != null) {
        temDeliveryNote += '\n ${order.orderLines.first.note ?? ""}';
      }
    }
    final dataPrint = PrintShipData(
        companyName: company.name,
        companyPhone: company.phone,
        companyAddress: company.street,
        carrierName: order.carrierName,
        carrierService: order.shipServiceId,
        shipWeight: order.shipWeight?.toInt(),
        cashOnDeliveryPrice: order.cashOnDelivery,
        imageLogo: _companyCache.imageUrl,
        // Tính lại giá hàng hóa in ra
        // Giá hàng hóa = Tiền thu hộ - Tiền ship
//        invoiceAmount: order.amountTotal,

        invoiceAmount: (order.cashOnDelivery ?? 0) -
            (order.deliveryPrice ?? 0) +
            (order.amountDeposit ?? 0),
        deliveryPrice: order.deliveryPrice,
        invoiceNumber: order.number,
        invoiceDate: order.dateInvoice,
        receiverName: order.receiverName ?? order?.partner?.name,
        receiverPhone: order.receiverPhone ?? order?.partner?.phone,
        receiverAddress: order.receiverAddress ?? order?.partner?.street,
        receiverCityName:
            order.shipReceiver?.city?.name ?? order?.partner?.city?.name,
        receiverDictrictName: order.shipReceiver?.district?.name ??
            order?.partner?.district?.name,
        receiverWardName:
            order.shipReceiver?.ward?.name ?? order?.partner?.ward?.name,
        note: printShipConfig?.note, // Ghi chú cấu hình trong phiếu ship
        shipNote:
            temDeliveryNote, // Ghi chú giao hàng cần bổ sung thêm Ghi chú sản phẩm
        content: order.orderLines
            ?.map((f) => "${f.productUOMQty?.toInt()}  ${f.nameTemplate}")
            ?.join(", "),
        trackingRef: order.trackingRef,
        trackingRefSort: order.trackingRefSort,
        staff: order.userName,
        depositAmount: order.amountDeposit,
        productQuantity: order.productQuantity,
        sender: company.sender,
        trackingArea: order.trackingArea);
    // Thêm dữ liệu in
    // nếu cấu hinh in địa chỉ đẩy đủ
    if (saleSetting.groupFastSaleAddressFull) {
      dataPrint.receiverAddress = order.address ?? order.partner?.addressFull;
    }
    if (order.carrierDeliveryType != null && order.trackingRef != null) {
      final String carrierType = order.carrierDeliveryType.toLowerCase();
      switch (carrierType) {
        case "ghtk":
          dataPrint.shipCode = order.trackingRef.split(".").last;
          dataPrint.trackingRefToShow = order.trackingRef
              .replaceAll("${order.trackingRef.split(".")[0]}.", "");

          if (order.trackingRef.split(".").length > 2)
            dataPrint.trackingRefGHTK =
                "${order.trackingRef.split(".")[1]}.${order.trackingRef.split(".")[2]}";
          else
            dataPrint.trackingRefGHTK = order.trackingRef;
          break;
        case "ghn":
          dataPrint.shipCode = order.trackingRef;
          dataPrint.trackingRefToShow = order.trackingRef;
          break;
        default:
          dataPrint.shipCode = order.trackingRef;
          dataPrint.trackingRefToShow = order.trackingRef;
      }
    }

    dataPrint.shipCodeQRCode = dataPrint.shipCode;

    // IN nào
    if (printerDevice.type == "tpos_printer") {
      if (!_setting.settingPrintShipShowDepositAmount) {
        dataPrint.depositAmount = null;
      }

      if (!_setting.settingPrintShipShowProductQuantity) {
        dataPrint.productQuantity = null;
      }
      await _tposDesktop.printShip(
        hostName: printerDevice.ip,
        port: printerDevice.port,
        data: dataPrint,
        size: _setting.shipSize,
        config: _getPrintShipOtherConfig(printShipConfig),
      );
    } else if (printerDevice.type == "esc_pos") {
      await _printShipViaLan(
        data: dataPrint,
        settingPrinter: printerDevice,
        config: _getPrintShipOtherConfig(printShipConfig),
      );
    }
  }

  /// In phiếu ship qua Lan, Mẫu 80 Image font đẹp
  Future<void> _printShipViaLanImage({
    PrintShipConfig config,
    PrintShipData data,
    PrinterDevice settingPrinter,
  }) async {
    // In hình đẹp
    try {
      if (config.isHideAddress) data.companyAddress = null;
      if (config.isHideCod) data.cashOnDeliveryPrice = null;
      if (config.isHideShipAmount) {
        data.deliveryPrice = null;
        data.invoiceAmount = null;
      }

      if (config.isHideShip) {
        data.deliveryPrice = null;
      }
      if (config.isHideInvoiceCode) {
        data.invoiceNumber = null;
      }
      if (config.isHideNoteShip) {
        data.shipNote = null;
      }
      if (config.isHideTrackingRefSort) {
        data.trackingRefSort = null;
      }
      if (config.isHideTrackingArea) {
        data.trackingArea = null;
      }
      if (!config.isShowStaff) {
        data.staff = null;
      }
      if (!config.isShowLogo) {
        data.imageLogo = null;
      }
      if (config.isHideWeightShip) {
        data.shipWeight = null;
      }

      if (config.isShowQrCode == false) {
        data.shipCodeQRCode = null;
      }

      if (config.isCoverPhone) {
        if (data.receiverPhone.isNotNullOrEmpty()) {
          data.receiverPhone = data.receiverPhone
              .hideNumber(start: 3, end: 7, replacement: '****');
        }
      }

      final image = await printShipImage80mm(data);
      final profile =
          await ProfileManager().getProfile(settingPrinter.profileName);
      final escPrinter = EscPrinter(
        profile: profile,
        host: settingPrinter.ip,
        port: settingPrinter.port,
        timeout: const Duration(seconds: 10),
      );

      await escPrinter.printFormSplit(
        PosForm(size: PaperSize.bill80, profile: profile)
          ..imageForm(image, ignore: settingPrinter.isImageRasterPrint)
          ..imageRaster(image, ignore: !settingPrinter.isImageRasterPrint)
          ..emptyLines(5)
          ..cut(),
        bufferSize:
            settingPrinter.overideSetting ? settingPrinter.packetSize : null,
        sleepTime:
            settingPrinter.overideSetting ? settingPrinter.delayTimeMs : null,
        delayBeforeDisconnect: settingPrinter.overideSetting
            ? settingPrinter.delayBeforeDisconnectMs
            : null,
      );
    } catch (e, s) {
      _log.severe("print", e, s);
      rethrow;
    }
    return;
  }

  /// In phiếu ship qua Lan, Mẫu 80 Raw, mặc định
  Future<void> _printShipViaLanEsc(
      {PrintShipConfig config,
      PrintShipData data,
      PrinterDevice settingPrinter}) async {
    if (config.isShowLogo && data.imageLogo.isNotNullOrEmpty()) {
      try {
        final Uint8List bytes = await networkImageToByte('${data.imageLogo}');
        final shipProfile =
            await ProfileManager().getProfile(settingPrinter.profileName);
        final shipForm = PosForm(size: PaperSize.bill80, profile: shipProfile);
        shipForm.logo(
            imageData: ByteData.view(bytes.buffer), width: 300, height: 170);
        shipForm.feed(1);

        final printer = EscPrinter(
            profile: shipProfile,
            host: settingPrinter.ip,
            port: settingPrinter.port,
            timeout: const Duration(seconds: 5));
        await printer.printForm(shipForm);
      } catch (e, s) {
        _log.severe("print", e, s);
      }
    }

    final PosStyles normalStyle =
        PosStyles(codeTable: PosCodeTable.wpc1258.value);

    final PrinterProfile printerProfile =
        await ProfileManager().getProfile(settingPrinter.profileName);
    final PosForm form =
        PosForm(size: PaperSize.bill80, profile: printerProfile);

    form.reset();
    form.setLineSpacing(110);
    form.textLine(
      "${data.companyName}",
      styles: normalStyle.copyWith(
          bold: true, height: PosTextSize.size2, width: PosTextSize.size2),
    );
    form.setLineSpacing(80);
    form.textLine(
      "SĐT: ${data.companyPhone}",
      styles: normalStyle.copyWith(bold: true),
    );

    // Địa chỉ công ty
    if (!config.isHideAddress) {
      form.textLine(
        "Địa chỉ: ${data.companyAddress}",
        styles: normalStyle.copyWith(bold: true),
      );
    }

    // moreInfo (sender)
    if (data.sender.isNotNullOrEmpty()) {
      form.textLine(
        "${data.sender}",
        styles: normalStyle,
      );
    }
    if (config.isShowStaff) {
      form.textLine(
        "Nhân viên: ${data.staff ?? ""}",
        styles: normalStyle.copyWith(bold: false),
      );
    }

    if (data.carrierName != null) {
      form.textLine("${data.carrierName}",
          styles:
              normalStyle.copyWith(bold: false, align: PosTextAlign.center));
    }

    if (data.trackingArea.isNotNullOrEmpty() && !config.isHideTrackingArea) {
      form.textLine(
        "${data.trackingArea}",
        styles: normalStyle.copyWith(
          align: PosTextAlign.center,
          bold: true,
        ),
      );
    }

    if (config.isShowQrCode == false && data.shipCode.isNotNullOrEmpty()) {
      form.barcode(
        "${data.shipCode}",
        width: 3,
        height: 70,
        type: Barcodetype.barcode_code39,
        textPosition: BarcodeTextPosition.barcode_text_position_none,
        align: PosTextAlign.center,
      );
    }

    if (config.isShowQrCode == true && data.shipCode.isNotNullOrEmpty()) {
      form.qrCode(data.shipCode,
          qrSize: QRSize.Size8, align: PosTextAlign.center);
    }
    form.feed(1);
    if (data.trackingRefToShow != null) {
      form.textLine("${data.trackingRefToShow}",
          styles:
              normalStyle.copyWith(bold: false, align: PosTextAlign.center));
    }

    // Barcode
    form.feed(1);
    if (!config.isHideCod) {
      form.textLine(
        "Thu hộ: ${vietnameseCurrencyFormat(data.cashOnDeliveryPrice ?? 0)} VNĐ",
        styles: normalStyle.copyWith(
            align: PosTextAlign.center,
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            bold: true),
      );
    } else {
      // Hiện ô nhập COD
      form.textLine("THU HỘ (COD)",
          styles: normalStyle.copyWith(
              align: PosTextAlign.center, width: PosTextSize.size2));
      form.textLine("___________________",
          styles: normalStyle.copyWith(
              align: PosTextAlign.center, width: PosTextSize.size2));
      form.textLine("|                  |",
          styles: normalStyle.copyWith(
              align: PosTextAlign.center, width: PosTextSize.size2));
      form.textLine("___________________",
          styles: normalStyle.copyWith(
              align: PosTextAlign.center, width: PosTextSize.size2));
    }

    form.emptyLines(1);
    // Tiền hàng +  tiền ship
    if (!config.isHideShipAmount) {
      final String shipAmountString =
          " + Ship: ${vietnameseCurrencyFormat(data.deliveryPrice ?? 0)})";
      form.textLine(
        "(Tiền hàng : ${vietnameseCurrencyFormat(data.invoiceAmount ?? 0)}${config.isHideShip ? "" : shipAmountString}",
        styles: normalStyle.copyWith(
          align: PosTextAlign.center,
          width: PosTextSize.size1,
          height: PosTextSize.size1,
          bold: true,
        ),
      );
    }

    // Mã hóa đơn
    if (!config.isHideInvoiceCode) {
      form.textLine(
        "${data.invoiceNumber}",
        styles: normalStyle.copyWith(
          align: PosTextAlign.center,
          width: PosTextSize.size1,
          height: PosTextSize.size1,
          bold: true,
        ),
      );
    }

    form.textLine(
      "Ngày: ${DateFormat("dd/MM/yyyy").format(data.invoiceDate)}",
      styles: normalStyle.copyWith(
        align: PosTextAlign.center,
        width: PosTextSize.size1,
        height: PosTextSize.size1,
        bold: true,
      ),
    );

    form.textLine("Người nhận: ${data.receiverName}",
        styles: normalStyle.copyWith(bold: true));
    final String newPhone =
        data.receiverPhone?.hideNumber(start: 3, end: 7, replacement: '****');
    form.textLine("Điện thoại: $newPhone",
        styles: normalStyle.copyWith(bold: true));
    form.textLine("Địa chỉ: ${data.receiverAddress}",
        styles: normalStyle.copyWith(bold: false));

    // Khối lượng ship
    if (data.shipWeight != null && config.isHideWeightShip == false) {
      form.textLine(
        'KL ship (g): ${data.shipWeight.toInt()}',
        styles: normalStyle.copyWith(bold: true),
      );
    }

    // Ghi chú giao hàng
    if (!config.isHideNoteShip && data.shipNote != null) {
      form.feed(1);
      form.textLine(
        "Ghi chú GH: ${data.shipNote ?? ""}",
        styles: normalStyle.copyWith(
            bold: false, height: PosTextSize.size1, width: PosTextSize.size1),
      );
    }

    form.textLine("Ghi chú khác: ${data.note ?? ""}",
        styles: normalStyle.copyWith(bold: false));

    // Mã chia
    if (data.trackingRefSort != null && config.isHideTrackingRefSort == false) {
      form.barcode(
        data.trackingRefSort,
        align: PosTextAlign.center,
        width: 3,
        height: 70,
        textPosition: BarcodeTextPosition.barcode_text_Position_below,
        type: Barcodetype.barcode_code39,
      );
    }

    /// Mã tỉnh,
    if (data.trackingArea.isNotNullOrEmpty() &&
        config.isHideTrackingArea == false) {
      form.textLine("_________",
          styles: normalStyle.copyWith(
              align: PosTextAlign.center, width: PosTextSize.size2));
      form.textLine(
        data.trackingArea,
        styles: normalStyle.copyWith(
          bold: true,
          width: PosTextSize.size2,
          height: PosTextSize.size2,
          align: PosTextAlign.center,
        ),
      );
      form.textLine("_________",
          styles: normalStyle.copyWith(
              align: PosTextAlign.center, width: PosTextSize.size2));
    }
    form.resetLineSpacing();
    form.emptyLines(4);
    form.cut();

    // print
    final EscPrinter printer = EscPrinter(
      profile: printerProfile,
      timeout: const Duration(seconds: 5),
      host: settingPrinter.ip,
      port: settingPrinter.port,
    );

    await printer.printFormSplit(
      form,
      bufferSize:
          settingPrinter.overideSetting ? settingPrinter.packetSize : null,
      sleepTime:
          settingPrinter.overideSetting ? settingPrinter.delayTimeMs : null,
      delayBeforeDisconnect: settingPrinter.overideSetting
          ? settingPrinter.delayBeforeDisconnectMs
          : null,
    );
  }

  /// In phiếu ship qua máy in Lan, Bao gồm cả mẫu in đẹp và mẫu in nhanh bình thường
  /// + data: Dữ liệu in
  /// + settingPrinter: Thiết bị dùng để in
  /// + config: Cấu hình in phiếu ship
  Future<void> _printShipViaLan(
      {PrintShipData data,
      PrinterDevice settingPrinter,
      PrintShipConfig config}) async {
    //Check printer

    if (_setting.shipSize == "BILL80-IMAGE") {
      await _printShipViaLanImage(
          config: config, settingPrinter: settingPrinter, data: data);
    } else {
      await _printShipViaLanEsc(
          config: config, data: data, settingPrinter: settingPrinter);
    }
  }

  /// In phiếu ship qua máy
  Future<void> _printShipViaPreivew(
    int fastSaleOrderId,
    int carrierId,
    PrinterConfig printConfig,
  ) async {
    var html = await _tposApiService.getFastSaleOrderPrintDataAsHtml(
        fastSaleOrderId: fastSaleOrderId, carrierId: carrierId, type: "ship");

    if (html != null) {
      html = html
          .replaceAll('href="/Content', 'href="${_setting.shopUrl}/Content')
          .replaceAll('/Web', '${_setting.shopUrl}/Web');

      PdfPageFormat pdfFormat = PdfPageFormat.a4;
      if (printConfig != null) {
        switch (printConfig.template) {
          case "BILL80":
            pdfFormat = const PdfPageFormat(
                7.6 * PdfPageFormat.cm, 20 * PdfPageFormat.cm);
            break;
          case "A5":
            pdfFormat = PdfPageFormat.a5;
            break;
          case "A4":
            pdfFormat = PdfPageFormat.a4;
            break;
        }
      }

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async {
          return await Printing.convertHtml(format: pdfFormat, html: html);
        },
      );
    }
  }

  /// In sale online
  @override
  Future<void> printSaleOnlineTag(
      {@required SaleOnlineOrder order,
      String comment,
      String partnerNote,
      String productName,
      String partnerStatus,
      String note,
      bool isPrintNode = false}) async {
    if (_companyConfig == null) {
      await _fetchCompanyConfig();
    }

    final String product = productName ??
        (order.details != null
            ? order.details.map((f) => f.productName).join(", ")
            : "");

    Future<String> _tryGetPartnerCode(int partnerId) async {
      _log.info("GET PARTNER CODE FOR PRINT TAG");
      try {
        final parnter = await _partnerApi.getById(partnerId);
        return parnter?.ref;
      } catch (e, s) {
        _log.severe("print", e, s);
        return null;
      }
    }

    // Get setting
    final PrintSaleOnlineData printData = PrintSaleOnlineData(
      index: order.sessionIndex != null && order.sessionIndex != 0
          ? order.sessionIndex
          : null,
      code: order.code,
      uid: order.facebookUserId,
      partnerCode:
          order.partnerCode ?? await _tryGetPartnerCode(order.partnerId),
      partnerStatus: partnerStatus,
      name: order.facebookUserName,
      product: product,
      phone: order.telephone,
    );

    // read header setting
    if (_setting.isSaleOnlinePrintCustomHeader) {
      printData.header =
          _setting.saleOnlinePrintCustomHeaderContent; // Header tùy chỉnh
    } else {
      printData.header = _saleOnlinePrinterConfig?.noteHeader; // Header web
    }

    printData.footer = _saleOnlinePrinterConfig?.note;

    if (note == null || note == "") {
      note = "";
      if (_setting.isSaleOnlinePrintAllOrderNote || isPrintNode) {
        note = order.note;
      }
// In địa chỉ
      if (_setting.isSaleOnlinePrintAddress == true) {
        if (note != null && note.isNotEmpty) {
          if (order.address != null && order.address != "") {
            note += "\nDc: ${order.address}";
          }
        } else {
          note = order.address ?? "";
        }
      }
// In Comment
      if (_setting.isSaleOnlinePrintComment == true &&
          _setting.isSaleOnlinePrintAllOrderNote == false) {
        if (note?.isNotEmpty == true) {
          if (comment != null && comment != "") {
            note += "\n------------\n$comment";
          }
        } else {
          note = comment ?? "";
        }
      }

      if (_setting.isSaleOnlinePrintPartnerNote) {
        if (note?.isNotEmpty == true) {
          if (partnerNote != null && partnerNote != "") {
            note += "\n-----------\n" + (partnerNote ?? "");
          }
        } else {
          note = partnerNote ?? "";
        }
      }
    }

    if (_setting.printMethod == PrintSaleOnlineMethod.ComputerPrinter) {
      await _tposDesktop.printSaleOnline(null, null, note, printData);
    } else if (_setting.printMethod == PrintSaleOnlineMethod.LanPrinter) {
      // print by ESC POS DEVICE
      final shipPrinter = _setting.printers
          .firstWhere((f) => f.type == "esc_pos", orElse: () => null);

      if (_setting.saleOnlineSize == "BILL80-IMAGE") {
        await printSaleOnlineTagImage80mm(
            printData: printData,
            note: order.note,
            comment: comment,
            dateCreated: order.dateCreated,
            isPrintOrderNote: isPrintNode,
            address: order.address);
        return;
      } else {
        //var printer = Printer(printerProfileName: shipPrinter.profileName);

//        await printer.connect(
//          host: _setting.lanPrinterIp,
//          port: int.parse(_setting.lanPrinterPort),
//          timeout: Duration(seconds: 30),
//        );

        //Content here
        final style = PosStyles(
            bold: true,
            fontType: PosFontType.fontA,
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            align: PosTextAlign.center,
            isRemoveMark: _setting.settingPrintSaleOnlineNoSign);

        try {
          // IN nội dung theo cài đặt
          final settingContents = _setting.settingSaleOnlinePrintContents;
          final PrinterProfile profile =
              await ProfileManager().getProfile(shipPrinter.profileName);
          final PosForm form =
              PosForm(size: PaperSize.bill80, profile: profile);
          form.reset();
          form.setLineSpacing(110);

          // ignore: avoid_function_literals_in_foreach_calls
          settingContents.forEach((content) async {
            // Chuyển int sang PosFontSize
            PosTextSize getPosSize(int value) {
              switch (value) {
                case 1:
                  return PosTextSize.size1;
                  break;
                case 2:
                  return PosTextSize.size2;
                  break;
                case 3:
                  return PosTextSize.size3;
                default:
                  return PosTextSize.size1;
              }
            }

            QRSize getSizeQRCode(int value) {
              switch (value) {
                case 1:
                  return QRSize.Size4;
                  break;
                case 2:
                  return QRSize.Size5;
                  break;
                case 3:
                  return QRSize.Size6;
                default:
                  return QRSize.Size5;
              }
            }

            // Tạo style cho chữ
            final textStyle = style.copyWith(
              bold: content.bold,
              width: getPosSize(
                content.fontSize,
              ),
              height: getPosSize(content.fontSize),
            );
            switch (content.name) {
              case "header":
                if (_setting.saleOnlinePrintCustomHeaderContent
                    .isNotNullOrEmpty()) {
                  form.textLine(
                    _setting.saleOnlinePrintCustomHeaderContent,
                    styles: textStyle,
                  );
                }
                break;
              case "uid":
                if (printData.uid.isNotNullOrEmpty())
                  form.textLine(
                    printData.uid,
                    styles: textStyle,
                  );
                break;
              case "name":
                if (printData.name.isNotNullOrEmpty()) {
                  form.textLine(printData.name, styles: textStyle);
                }

                break;
              case "phone":
                if (printData.phone.isNotNullOrEmpty())
                  form.textLine("SĐT: ${printData.phone}", styles: textStyle);
                break;
              case "phoneNameNetwork":
                if (printData.phone.isNotNullOrEmpty()) {
                  if (getNetworkName(printData.phone) != "N/A") {
                    form.textLine(
                        "${printData.phone}(${getNetworkName(printData.phone)})",
                        styles: textStyle);
                  } else {
                    form.textLine("SĐT: ${printData.phone}", styles: textStyle);
                  }
                }
                break;
              case "qrCodePhone":
                if (printData.phone.isNotNullOrEmpty() && Platform.isAndroid) {
                  form.feed(1);
                  form.qrCode(printData.phone,
                      qrSize: getSizeQRCode(content.fontSize));
                }

                break;
              case "qrCodeOrderCode":
                if (printData.code.isNotNullOrEmpty() && Platform.isAndroid) {
                  form.feed(1);
                  form.qrCode(printData.code,
                      qrSize: getSizeQRCode(content.fontSize));
                }
                break;
              case "barCodePhone":
                if (printData.phone.isNotNullOrEmpty() && Platform.isAndroid) {
                  form.feed(1);
                  form.barcode(printData.phone,
                      type: Barcodetype.barcode_code39);
                }
                break;
              case "address":
                if (order.address.isNotNullOrEmpty()) {
                  form.textLine(
                    "ĐC: ${order.address}",
                    styles: textStyle,
                  );
                }
                break;
              case "partnerCode":
                if (printData.partnerCode.isNotNullOrEmpty()) {
                  form.textLine(
                    printData.partnerCode,
                    styles: textStyle,
                  );
                }

                break;
              case "productName":
                if (printData.product.isNotNullOrEmpty()) {
                  form.textLine(
                    printData.product,
                    styles: textStyle,
                  );
                }
                break;
              case "orderIndex":
                if (order.sessionIndex != null && order.sessionIndex != 0) {
                  form.textLine(
                    "STT đơn: ${order.sessionIndex}",
                    styles: textStyle,
                  );
                }
                break;
              case "orderCode":
                if (order.code.isNotNullOrEmpty()) {
                  form.textLine(
                    "Mã đơn: ${order.code}",
                    styles: textStyle,
                  );
                }
                break;
              case "orderIndexAndCode":
                String indexCodeBuilder = "";
                if (printData.index != null && printData.index != 0) {
                  indexCodeBuilder = "#${printData.index.toString()}. ";
                }
                // Code
                form.textLine("$indexCodeBuilder${printData.code}",
                    styles: textStyle);
                break;
              case "orderTime":
                if (order.dateCreated != null) {
                  form.textLine(
                    "Ngày ĐH: ${DateFormat("dd/MM/yyyy HH:mm").format(order.dateCreated.toLocal())}",
                    styles: textStyle,
                  );
                }
                break;
              case "comment":
                if (comment.isNotNullOrEmpty()) {
                  form.textLine(
                    "$comment",
                    styles: textStyle,
                  );
                }
                break;
              case "note":
                if (order.note.isNotNullOrEmpty() &&
                    _setting.isSaleOnlinePrintAllOrderNote) {
                  form.textLine(
                    "${order.note}",
                    styles: textStyle,
                  );
                }
                break;
              case "printTime":
                // time// Time
                form.textLine(
                  DateFormat("dd/MM/yyyy HH:mm").format(DateTime.now()),
                  styles: textStyle,
                );
                break;
              case "partnerStatus":
                // time// Time
                if (printData.partnerCode.isNotNullOrEmpty()) {
                  form.textLine(
                    "${printData.partnerCode}",
                    styles: textStyle,
                  );
                }

                break;
              case "partnerCodeAndStatus":
                // time// Time
                if (printData.partnerCode.isNotNullOrEmpty()) {
                  form.textLine(
                    "${printData.partnerCode} (${printData.partnerStatus})",
                    styles: textStyle,
                  );
                }
                break;

              case "footer":
                if (printData.footer.isNotNullOrEmpty()) {
                  form.textLine("${printData.footer}", styles: textStyle);
                }
            }
          });

          if (!settingContents.any((f) => f.name == "note")) {
            if (isPrintNode) {
              // In order note nếu nội dung in không chứa order note và là in lại
              form.textLine(
                "${order.note}",
                styles: const PosStyles(align: PosTextAlign.center),
              );
            }
          }

          form.resetLineSpacing();
          form.emptyLines(1);
          form.textLine(
            "TPOS.VN",
            styles: const PosStyles(
              align: PosTextAlign.center,
            ),
          );

          form.emptyLines(4);
          form.cut();

          final EscPrinter printer = EscPrinter(
            host: _setting.lanPrinterIp,
            port: int.parse(_setting.lanPrinterPort),
            profile: profile,
            timeout: const Duration(seconds: 7),
          );

          await printer.printForm(form);
        } catch (e, s) {
          _log.severe("", e, s);
          rethrow;
        }
      }
    }
  }

  Future<void> printSaleOnlineTagImage80mm({
    @required PrintSaleOnlineData printData,
    String comment,
    String note,
    DateTime dateCreated,
    String address,
    bool isPrintOrderNote = false,
  }) async {
    // print by ESC POS DEVICE
    final shipPrinter = _setting.printers
        .firstWhere((f) => f.type == "esc_pos", orElse: () => null);

    try {
      final CanvasPrinter canvasPrinter = CanvasPrinter();
      final CanvasStyles canvasStyles = CanvasStyles();
      // IN nội dung theo cài đặt
      final settingContents = _setting.settingSaleOnlinePrintContents;
      // ignore: avoid_function_literals_in_foreach_calls
      settingContents.forEach(
        (content) {
          // Chuyển int sang PosFontSize
          double getPosSize(int value) {
            switch (value) {
              case 1:
                return 30;
                break;
              case 2:
                return 50;
                break;
              case 3:
                return 70;
              default:
                return 30;
            }
          }

          double getSizeQRCode(int value) {
            switch (value) {
              case 1:
                return 120;
                break;
              case 2:
                return 140;
                break;
              case 3:
                return 160;
              default:
                return 120;
            }
          }

          // Tạo style cho chữ
          final textStyle = canvasStyles.copyWith(
            bold: content.bold,
            fontSize: getPosSize(
              content.fontSize,
            ),
            align: TextAlign.center,
          );
          switch (content.name) {
            case "header":
              if (_setting.saleOnlinePrintCustomHeaderContent
                  .isNotNullOrEmpty()) {
                canvasPrinter.printTextLn(
                  _setting.saleOnlinePrintCustomHeaderContent,
                  style: textStyle,
                );
              }
              break;
            case "uid":
              if (printData.uid.isNotNullOrEmpty())
                canvasPrinter.printTextLn(
                  printData.uid,
                  style: textStyle,
                );
              break;
            case "name":
              if (printData.name.isNotNullOrEmpty()) {
                canvasPrinter.printTextLn(printData.name, style: textStyle);
              }

              break;
            case "phone":
              if (printData.phone.isNotNullOrEmpty())
                canvasPrinter.printTextLn("SĐT: ${printData.phone}",
                    style: textStyle);
              break;
            case "qrCodePhone":
              if (printData.phone.isNotNullOrEmpty()) {
                canvasPrinter.emptyLines(5);
                canvasPrinter.printQrcode(
                    printData.phone, getSizeQRCode(content.fontSize));
              }
              break;
            case "qrCodeOrderCode":
              if (printData.code.isNotNullOrEmpty()) {
                canvasPrinter.emptyLines(5);
                canvasPrinter.printQrcode(
                    printData.code, getSizeQRCode(content.fontSize));
              }
              break;
            case "barcodePhone":
              if (printData.phone.isNotNullOrEmpty()) {
                canvasPrinter.emptyLines(5);
                canvasPrinter.printBarCode(printData.phone,
                    lineWidth: 3, height: 70);
              }
              break;
            case "phoneNameNetwork":
              if (printData.phone.isNotNullOrEmpty()) {
                if (getNetworkName(printData.phone) != "N/A") {
                  canvasPrinter.printTextLn(
                      "${printData.phone}(${getNetworkName(printData.phone)})",
                      style: textStyle);
                } else {
                  canvasPrinter.printTextLn("SĐT: ${printData.phone}",
                      style: textStyle);
                }
              }
              break;

            case "address":
              if (address.isNotNullOrEmpty()) {
                canvasPrinter.printTextLn(
                  "ĐC: $address",
                  style: textStyle,
                );
              }
              break;
            case "partnerCode":
              if (printData.partnerCode.isNotNullOrEmpty()) {
                canvasPrinter.printTextLn(
                  printData.partnerCode,
                  style: textStyle,
                );
              }

              break;
            case "productName":
              if (printData.product.isNotNullOrEmpty()) {
                canvasPrinter.printTextLn(
                  printData.product,
                  style: textStyle,
                );
              }
              break;
            case "orderIndex":
              if (printData.index != null && printData.index != 0) {
                canvasPrinter.printTextLn(
                  "STT đơn: ${printData.index}",
                  style: textStyle,
                );
              }
              break;
            case "orderCode":
              if (printData.code.isNotNullOrEmpty()) {
                canvasPrinter.printTextLn(
                  "Mã đơn: ${printData.code}",
                  style: textStyle,
                );
              }
              break;
            case "orderIndexAndCode":
              String indexCodeBuilder = "";
              if (printData.index != null && printData.index != 0) {
                indexCodeBuilder = "#${printData.index.toString()}. ";
              }
              // Code
              canvasPrinter.printTextLn(
                "$indexCodeBuilder${printData.code}",
                style: textStyle,
              );
              break;
            case "orderTime":
              if (dateCreated != null) {
                canvasPrinter.printTextLn(
                  "Ngày ĐH: ${DateFormat("dd/MM/yyyy HH:mm").format(dateCreated.toLocal())}",
                  style: textStyle,
                );
              }
              break;
            case "comment":
              if (comment.isNotNullOrEmpty()) {
                canvasPrinter.printTextLn(
                  comment,
                  style: textStyle,
                );
              }
              break;
            case "note":
              if (note.isNotNullOrEmpty() &&
                  _setting.isSaleOnlinePrintAllOrderNote) {
                canvasPrinter.printTextLn(
                  note,
                  style: textStyle,
                );
              }
              break;
            case "printTime":
              // time// Time
              canvasPrinter.printTextLn(
                DateFormat("dd/MM/yyyy HH:mm").format(DateTime.now()),
                style: textStyle,
              );
              break;
            case "partnerStatus":
              // time// Time
              if (printData.partnerCode.isNotNullOrEmpty()) {
                canvasPrinter.printTextLn(
                  printData.partnerCode,
                  style: textStyle,
                );
              }

              break;
            case "partnerCodeAndStatus":
              // time// Time
              if (printData.partnerCode.isNotNullOrEmpty()) {
                canvasPrinter.printTextLn(
                  "${printData.partnerCode} (${printData.partnerStatus})",
                  style: textStyle,
                );
              }
              break;
            case "footer":
              // time// Time
              if (printData.footer.isNotNullOrEmpty())
                canvasPrinter.printTextLn(
                  "${printData.footer}",
                  style: textStyle,
                );
              break;
          }
        },
      );

      if (isPrintOrderNote == true &&
          !settingContents.any((f) => f.name == "note")) {
        canvasPrinter.printTextLn(
          "${note ?? ""}",
          style: CanvasStyles(
            align: TextAlign.center,
          ),
        );
      }
      canvasPrinter.emptyLines(1);
      canvasPrinter.printTextLn(
        "TPOS.VN",
        style: CanvasStyles(
          align: TextAlign.center,
        ),
      );

      _log.info("GEN IMAGE PRINT");
      final image = await canvasPrinter.generateImage();
      _log.info("END GEN IMAGE PRINT");

      final printerProfile = await ProfileManager()
          .getProfile(shipPrinter.profileName ?? "default");
      final PosForm imageForm =
          PosForm(size: PaperSize.bill80, profile: printerProfile)
            ..imageForm(image, ignore: shipPrinter.isImageRasterPrint)
            ..imageRaster(image, ignore: !shipPrinter.isImageRasterPrint)
            ..emptyLines(5)
            ..cut();

      final EscPrinter printer = EscPrinter(
        host: _setting.lanPrinterIp,
        port: int.parse(_setting.lanPrinterPort),
        timeout: const Duration(seconds: 20),
        profile: printerProfile,
      );

      await printer.printFormSplit(
        imageForm,
        bufferSize: shipPrinter.overideSetting ? shipPrinter.packetSize : null,
        sleepTime: shipPrinter.overideSetting ? shipPrinter.delayTimeMs : null,
        delayBeforeDisconnect: shipPrinter.overideSetting
            ? shipPrinter.delayBeforeDisconnectMs
            : null,
      );
    } catch (e, s) {
      _log.severe("", e, s);
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<void> _printOrderViaLanImage({
    FastSaleOrder order,
    PrinterConfig printerConfig,
    Company company,
    Partner partner,
    SaleSetting saleSetting,
    PrintFastSaleOrderConfig webPrintConfig,
    PrinterDevice printerDevice,
  }) async {
    try {
      double revenue;
      if (webPrintConfig.showRevenue) {
        final getRevenueResult =
            await _partnerApi.getRevenueById(order.partnerId);
        revenue = getRevenueResult.revenueTotal;
      }

      final printData = PrintFastSaleOrderData();

      printData.companyName = company.name;
      printData.companyMoreInfo = company.moreInfo;
      printData.companyPhone = company.phone;
      printData.companyAddress = company.street;
      printData.imageLogo = _companyCache.imageUrl;
      printData.carrierName = order.carrierName;
      if (order.trackingRef != null && order.trackingRef != "") {
        printData.shipCode = _getDeliverCarrierBarcode(
            order.carrierDeliveryType, order.trackingRef);
        printData.trackingRef = order.trackingRef;
      }
      printData.trackingRefSort = order.trackingRefSort;

      printData.shipNote = order.deliveryNote;

      printData.cashOnDeliveryAmount = order.cashOnDelivery;
      printData.invoiceNumber = order.number;
      printData.invoiceDate = order.dateInvoice;
      printData.customerName = partner.name;
      printData.customerPhone = partner.phone;
      printData.customerAddress = saleSetting.groupFastSaleAddressFull
          ? partner.addressFull
          : partner.street;

      printData.subTotal = order.subTotal;
      printData.shipAmount = order.carrierId != null && order.carrierId != 0
          ? order.deliveryPrice
          : null;
      printData.discount = order.discount;
      printData.discountAmount = order.discountAmount;
      printData.decreaseAmount = order.decreaseAmount;
      printData.totalAmount = order.total;
      printData.oldCredit = order.previousBalance;
      printData.payment = order.paymentAmount;
      printData.totalDeb = (order.previousBalance ?? 0) -
          (order.paymentAmount ?? 0) +
          (order.amountTotal ?? 0);
      printData.previousBalance = order.previousBalance;
      printData.invoiceNote = order.comment;
      printData.defaultNote = printerConfig?.note;
      printData.receiverPhone =
          order.shipReceiver.phone ?? order.partner?.phone;
      printData.receiverAddress =
          order.shipReceiver.street ?? order.partner?.addressFull;
      printData.receiverName = order.shipReceiver.name ?? order.partner?.name;
      printData.depositAmount = order.amountDeposit;

      printData.hideProductCode = webPrintConfig.hideProductCode;
      printData.hideDelivery = webPrintConfig.hideDelivery;
      printData.hideDebt = webPrintConfig.hideDebt;
      printData.hideLogo = webPrintConfig.hideLogo;
      printData.hideReceiver = webPrintConfig.hideReceiver;
      printData.hideAddress = webPrintConfig.hideAddress;
      printData.hidePhone = webPrintConfig.hidePhone;
      printData.hideStaff = webPrintConfig.hideStaff;

      printData.hideAmountText = webPrintConfig.hideAmountText;
      printData.hideSign = webPrintConfig.hideSign;
      printData.hideTrackingRef = webPrintConfig.hideTrackingRef;
      printData.hideCustomerName = webPrintConfig.hideCustomerName;
      printData.hideProductNote = webPrintConfig.hideProductNote;
      printData.showBarcode = webPrintConfig.showBarcode;

      printData.showWeightShip = webPrintConfig.showWeightShip;
      printData.showCod = webPrintConfig.showCod;
      printData.showRevenue = webPrintConfig.showRevenue;
      printData.showCombo = webPrintConfig.showCombo;
      printData.showTrackingRefSort = webPrintConfig.showTrackingRefSoft;
      printData.trackingRefToShow = _getDeliveryCarrierCodeToShow(
          order.carrierDeliveryType, order.trackingRef);

      printData.revenue = revenue;
      printData.user = order.userName;
      printData.orderLines = order.orderLines;
      printData.totalInWords =
          "${convertNumberToWord(order.total.toInt().toString())} ./.";

      // Hide
      if (webPrintConfig.hideAddress) printData.customerAddress = null;
      if (webPrintConfig.hidePhone) printData.customerPhone = null;
      if (webPrintConfig.hideAmountText) printData.totalInWords = null;
      if (webPrintConfig.hideCustomerName) printData.customerName = null;
      if (webPrintConfig.hideDebt) printData.previousBalance = null;
      if (webPrintConfig.hideDebt) printData.totalDeb = null;
      if (webPrintConfig.hideDebt) printData.payment = null;
      if (webPrintConfig.hideTrackingRef) printData.trackingRef = null;
      if (webPrintConfig.hideTrackingRef) printData.trackingRefToShow = null;
      if (webPrintConfig.hideTrackingRef) printData.shipCode = null;
      if (webPrintConfig.hideTrackingRef) printData.carrierName = null;
      if (webPrintConfig.hideStaff) printData.userDelivery = null;
      if (webPrintConfig.hideStaff) printData.user = null;
      if (webPrintConfig.hidePhone) if (webPrintConfig.hideReceiver) {
        printData.receiverAddress = null;
        printData.receiverName = null;
        printData.receiverPhone = null;
      }

      if (webPrintConfig.hideProductNote) {
        // ignore: avoid_function_literals_in_foreach_calls
        printData.orderLines?.forEach((f) {
          f.note = null;
        });
      }

      // show
      if (!webPrintConfig.showWeightShip) printData.shipWeight = null;
      if (!webPrintConfig.showTrackingRefSoft) printData.trackingRefSort = null;
      if (!webPrintConfig.showCod) printData.cashOnDeliveryAmount = null;
      if (!webPrintConfig.showRevenue) printData.revenue = null;
      if (webPrintConfig.hideCompanyAddress) printData.companyAddress = null;
      if (webPrintConfig.hideCompanyPhoneNumber) printData.companyPhone = null;

      printData.deliveryDate = order.deliveryDate;
      final orderImage = await printFastSaleOrderImage80mm(printData);

      final profile =
          await ProfileManager().getProfile(printerDevice.profileName);
      final escPrinter = EscPrinter(
        profile: profile,
        host: printerDevice.ip,
        port: printerDevice.port,
        timeout: const Duration(seconds: 10),
      );

      await escPrinter.printFormSplit(
        PosForm(size: PaperSize.bill80, profile: profile)
          ..imageForm(orderImage, ignore: printerDevice.isImageRasterPrint)
          ..imageRaster(orderImage, ignore: !printerDevice.isImageRasterPrint)
          ..emptyLines(5)
          ..cut(),
        bufferSize:
            printerDevice.overideSetting ? printerDevice.packetSize : null,
        sleepTime:
            printerDevice.overideSetting ? printerDevice.delayTimeMs : null,
        delayBeforeDisconnect: printerDevice.overideSetting
            ? printerDevice.delayBeforeDisconnectMs
            : null,
      );
    } catch (e, s) {
      _log.severe("", e, s);
      rethrow;
    }
  }

  Future<void> _printOrderViaLanEsc({
    FastSaleOrder order,
    PrinterConfig printerConfig,
    Company company,
    Partner partner,
    SaleSetting saleSetting,
    PrintFastSaleOrderConfig webPrintConfig,
    PrinterDevice printerDevice,
  }) async {
    final double productCount =
        order.orderLines?.map((f) => f.productUOMQty)?.reduce((a, b) => a + b);

    double revenue;
    if (webPrintConfig.showRevenue) {
      final getRevenueResult =
          await _partnerApi.getRevenueById(order.partnerId);
      revenue = getRevenueResult.revenueTotal;
    }

    final printerProfile =
        await ProfileManager().getProfile(printerDevice.profileName);
    if (_companyCache.imageUrl.isNotNullOrEmpty()) {
      try {
        final Uint8List bytes =
            await networkImageToByte('${_companyCache.imageUrl}');

        final shipForm =
            PosForm(size: PaperSize.bill80, profile: printerProfile);
        shipForm.logo(
            imageData: ByteData.view(bytes.buffer), width: 300, height: 170);
        shipForm.feed(1);

        final printer = EscPrinter(
            profile: printerProfile,
            host: printerDevice.ip,
            port: printerDevice.port,
            timeout: const Duration(seconds: 5));
        await printer.printForm(shipForm);
      } catch (e) {
        _log.severe(e.toString());
      }
    }

    final PosForm form =
        PosForm(size: PaperSize.bill80, profile: printerProfile);

    var style = const PosStyles(align: PosTextAlign.center);
    form.setLineSpacing(70);

    form.textLine(order.company?.name,
        styles: style.copyWith(width: PosTextSize.size2));
    form.emptyLines(1);
    form.textLine(company?.moreInfo,
        styles: style.copyWith(width: PosTextSize.size2));
    if (!webPrintConfig.hideCompanyAddress) {
      form.textLine(company?.street, styles: style);
    }

    if (!webPrintConfig.hideCompanyPhoneNumber) {
      form.textLine(company?.phone, styles: style);
    }

//Tên đối tác giao hàng
    form.textLine(order.carrierName, styles: style);

    if (!webPrintConfig.hideTrackingRef) {
      if (order.trackingRefSort != null)
        form.textLine(order.trackingRefSort, styles: style);
// bar code
      if (order.trackingRef != null && order.trackingRef != "") {
        form.barcode(
          _getDeliverCarrierBarcode(
              order.carrierDeliveryType, order.trackingRef),
          width: 3,
          height: 70,
          textPosition: BarcodeTextPosition.barcode_text_Position_below,
          type: Barcodetype.barcode_code39,
          align: PosTextAlign.center,
        );

        form.textLine(
            _getDeliveryCarrierCodeToShow(
                order.carrierDeliveryType, order.trackingRef),
            styles: style);
        if (webPrintConfig.showWeightShip) {
          form.textLine("KL ship (g) ${order.shipWeight}", styles: style);
        }
      }
    }

// Thu hộ
    if (webPrintConfig.showCod)
      form.textLine(
          "Thu hộ ${vietnameseCurrencyFormat(order.cashOnDelivery ?? 0)}",
          styles: style);
// Gạch
    form.textLine("------------------------------------------------",
        styles: style);
    form.textLine("Phiếu Bán Hàng",
        styles: style.copyWith(
            width: PosTextSize.size3, height: PosTextSize.size2));
    form.emptyLines(1);
    form.textLine("Số phiếu: ${order.number}", styles: style);
    form.textLine(
        "Ngày: ${DateFormat("dd/MM/yyyy HH:mm").format(order.dateInvoice)}",
        styles: style);
// gạch
    form.textLine("------------------------------------------------",
        styles: style);

    style = style.copyWith(align: PosTextAlign.left);
//  Tên khách hàng
    if (!webPrintConfig.hideCustomerName)
      form.textLine("Khách hàng: ${order.partner?.name}", styles: style);
// Địa chỉ khách hàng
    if (!webPrintConfig.hideAddress)
      form.textLine("Địa chỉ: ${order.partner?.addressFull ?? ""}",
          styles: style);

// Phone khách hàng
    if (!webPrintConfig.hidePhone)
      form.textLine("Điện thoại: ${order.partner?.phone ?? ""}", styles: style);

// Tên nhân viên bán
    if (!webPrintConfig.hideStaff)
      form.textLine("Người bán: ${order.userName ?? ""}", styles: style);
// Tên người giao hàng
//      if (!webPrintConfig.hideDelivery)
//        printer.textLine("NV giao hàng: ${order.userName}", styles: style);

// Tiêu đề bảng
    form.textLine("------------------------------------------------",
        styles: style);
    const columnStyle = PosStyles(align: PosTextAlign.left, bold: true);
    form.row([
      PosColumn(text: "Sản phẩm", width: 4, styles: columnStyle),
      PosColumn(text: "Giá bán", width: 3, styles: columnStyle),
      PosColumn(text: "CK", width: 2, styles: columnStyle),
      PosColumn(text: "Thành tiền", width: 3, styles: columnStyle),
    ]);
    form.textLine("------------------------------------------------",
        styles: style);

    if (order.orderLines != null && order.orderLines.isNotEmpty) {
      for (final product in order.orderLines) {
//Tên sản phẩm
        form.textLine("${product.productNameGet}",
            styles: style.copyWith(bold: true));
// Ghi chú sản phẩm
        if (webPrintConfig.hideProductNote == false &&
            product.note != null &&
            product.note != "")
          form.textLine("${product.note}", styles: style.copyWith(bold: false));
// SL, đơn vị, đơn giá, chiết khấu, thành tiền

        form.row([
          PosColumn(
              width: 4,
              text: "${product.productUOMQty} ${product.productUomName}",
              styles:
                  columnStyle.copyWith(bold: false, align: PosTextAlign.left)),
          PosColumn(
              width: 3,
              text: "${vietnameseCurrencyFormat(product.priceUnit ?? 0)}",
              styles:
                  columnStyle.copyWith(bold: false, align: PosTextAlign.left)),
          PosColumn(
              width: 2,
              text: product.discount != null && product.discount > 0
                  ? "${product.discount?.toInt() ?? 0}%"
                  : product.discountFixed != null && product.discountFixed > 0
                      ? "${vietnameseCurrencyFormat(product.discountFixed)} đ  "
                      : "0%",
              styles:
                  columnStyle.copyWith(bold: false, align: PosTextAlign.left)),
          PosColumn(
              width: 3,
              text: "${vietnameseCurrencyFormat(product.priceTotal ?? 0)}",
              styles:
                  columnStyle.copyWith(bold: false, align: PosTextAlign.right)),
        ]);

        form.textLine(
          "------------------------------------------------",
        );
      }
    }

// Tổng cộng
    form.row([
      PosColumn(
          width: 3,
          text: "Tổng:",
          styles: style.copyWith(bold: true, align: PosTextAlign.left)),
      PosColumn(
          width: 6, text: "$productCount", styles: style.copyWith(bold: true)),
      PosColumn(
          width: 3,
          text: "${vietnameseCurrencyFormat(order.amountTotal)}",
          styles: style.copyWith(align: PosTextAlign.right, bold: true)),
    ]);

//  Chiết khấu %
    if (order.discount != null && order.discount > 0) {
      form.row([
        PosColumn(
            text: "",
            width: 6,
            styles: style.copyWith(align: PosTextAlign.right, bold: true)),
        PosColumn(
            text: "CK (${order.discount} %):",
            width: 3,
            styles: style.copyWith(align: PosTextAlign.right, bold: true)),
        PosColumn(
            text: "${vietnameseCurrencyFormat(order.discountAmount ?? 0)}",
            width: 3,
            styles: style.copyWith(align: PosTextAlign.right, bold: false)),
      ]);
    }
//  Chiết khấu tiền
    if (order.decreaseAmount != null && order.decreaseAmount > 0) {
      form.row([
        PosColumn(
            text: "",
            width: 6,
            styles: style.copyWith(align: PosTextAlign.right, bold: true)),
        PosColumn(
            text: "Giảm tiền:",
            width: 3,
            styles: style.copyWith(align: PosTextAlign.right, bold: true)),
        PosColumn(
            text: "${vietnameseCurrencyFormat(order.decreaseAmount ?? 0)}",
            width: 3,
            styles: style.copyWith(align: PosTextAlign.right, bold: false)),
      ]);
    }

// Tiền ship
    if (order.carrierId != null && order.deliveryPrice != null)
      form.row([
        PosColumn(
            text: "",
            width: 6,
            styles: style.copyWith(align: PosTextAlign.right, bold: true)),
        PosColumn(
            text: "Tiền ship:",
            width: 3,
            styles: style.copyWith(align: PosTextAlign.right, bold: true)),
        PosColumn(
            text: "${vietnameseCurrencyFormat(order.deliveryPrice ?? 0)}",
            width: 3,
            styles: style.copyWith(align: PosTextAlign.right, bold: true)),
      ]);

    // Tiền đặt cọc
    if (order.amountDeposit != null && order.amountDeposit != 0)
      form.row([
        PosColumn(
            text: "",
            width: 6,
            styles: style.copyWith(align: PosTextAlign.right, bold: true)),
        PosColumn(
            text: "Tiền cọc:",
            width: 3,
            styles: style.copyWith(align: PosTextAlign.right, bold: true)),
        PosColumn(
            text: "${vietnameseCurrencyFormat(order.amountDeposit ?? 0)}",
            width: 3,
            styles: style.copyWith(align: PosTextAlign.right, bold: true)),
      ]);
// Tổng tiền

    form.row([
      PosColumn(
          text: "",
          width: 6,
          styles: style.copyWith(align: PosTextAlign.right, bold: true)),
      PosColumn(
          text: "Tổng  tiền:",
          width: 3,
          styles: style.copyWith(align: PosTextAlign.right, bold: true)),
      PosColumn(
          text: "${vietnameseCurrencyFormat(order.total)}",
          width: 3,
          styles: style.copyWith(align: PosTextAlign.right, bold: true)),
    ]);

// Bằng chữ

    if (!webPrintConfig.hideAmountText) {
      final words = convertNumberToWord((order.total).toInt().toString());
      form.textLine("Bằng chữ: $words ./.", styles: style);
    }

// Nợ cũ
    if (!webPrintConfig.hideDebt) {
      form.row([
        PosColumn(
            text: "",
            width: 6,
            styles: style.copyWith(align: PosTextAlign.right, bold: true)),
        PosColumn(
            text: "Nợ cũ:",
            width: 3,
            styles: style.copyWith(align: PosTextAlign.right, bold: true)),
        PosColumn(
            text: "${vietnameseCurrencyFormat(order.previousBalance ?? 0)}",
            width: 3,
            styles: style.copyWith(align: PosTextAlign.right, bold: true)),
      ]);

// thanh toán
      form.row([
        PosColumn(
            text: "",
            width: 6,
            styles: style.copyWith(align: PosTextAlign.right, bold: true)),
        PosColumn(
            text: "Thanh toán:",
            width: 3,
            styles: style.copyWith(align: PosTextAlign.right, bold: true)),
        PosColumn(
            text: "${vietnameseCurrencyFormat(order.paymentAmount ?? 0)}",
            width: 3,
            styles: style.copyWith(align: PosTextAlign.right, bold: true)),
      ]);
// thanh toán
      form.row([
        PosColumn(
            text: "",
            width: 6,
            styles: style.copyWith(align: PosTextAlign.right, bold: true)),
        PosColumn(
            text: "TỔNG NỢ:",
            width: 3,
            styles: style.copyWith(align: PosTextAlign.right, bold: true)),
        PosColumn(
            text: "${vietnameseCurrencyFormat(partner.credit ?? 0)}",
            width: 3,
            styles: style.copyWith(align: PosTextAlign.right, bold: true)),
      ]);
    }

//Ghi chú giao hàng
    if (order.deliveryNote != null)
      form.textLine("Ghi chú GH: ${order.deliveryNote}", styles: style);

//Ghi chú hóa đơn
    if (order.comment != null)
      form.textLine("Ghi chú: ${order.comment ?? ""}", styles: style);
// Ghi chú khác
    if (printerConfig?.note != null)
      form.textLine("Lưu ý: ${printerConfig?.note ?? ""}", styles: style);

    if (webPrintConfig.showRevenue) {
      form.textLine("Doanh số: ${vietnameseCurrencyFormat(revenue ?? 0)}");
    }
// Người nhận

    if (!webPrintConfig.hideReceiver) {
      form.textLine(
        "Yêu Cầu",
        styles: style.copyWith(
            bold: true,
            align: PosTextAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size3),
      );

      form.textLine("------------------------------------------------",
          styles: style);
      form.textLine(
        "Giao Hàng",
        styles: style.copyWith(
            align: PosTextAlign.center,
            bold: true,
            height: PosTextSize.size2,
            width: PosTextSize.size3),
      );

      if (order.deliveryDate != null) {
        form.textLine(
          "Ngày giao: ${DateFormat("dd/MM/yyyy HH:mm").format(order.deliveryDate)}",
          styles: style.copyWith(
              bold: false, height: PosTextSize.size1, width: PosTextSize.size1),
        );
      }

      form.textLine(
        "Người nhận: ${order.shipReceiver?.name ?? order.partner?.name}",
        styles: style.copyWith(
            bold: false, height: PosTextSize.size1, width: PosTextSize.size1),
      );
      form.textLine(
        "Điện thoại: ${order.shipReceiver?.phone ?? order.partner?.phone}",
        styles: style.copyWith(
            bold: false, height: PosTextSize.size1, width: PosTextSize.size1),
      );
      form.textLine(
        "Địa chỉ GH: ${order.shipReceiver?.street ?? order.partner?.street} ",
        styles: style.copyWith(
            bold: false, height: PosTextSize.size1, width: PosTextSize.size1),
      );
    }

    form.textLine("------------------------------------------------",
        styles: style);
//Kí tên
    if (!webPrintConfig.hideSign) {
      form.row([
        PosColumn(
            text: "Người giao",
            width: 6,
            styles: style.copyWith(align: PosTextAlign.center, bold: true)),
        PosColumn(
            text: "Người nhận:",
            width: 6,
            styles: style.copyWith(align: PosTextAlign.center, bold: true)),
      ]);

      form.feed(1);
    }

    if (webPrintConfig.showTrackingRefSoft &&
        order.trackingRefSort.isNotNullOrEmpty()) {
      form.barcode(
        order.trackingRefSort,
        width: 3,
        height: 70,
        textPosition: BarcodeTextPosition.barcode_text_Position_below,
        type: Barcodetype.barcode_code39,
        align: PosTextAlign.center,
      );
    }
    form?.resetLineSpacing();
    form?.emptyLines(4);
    form?.cut();

    final EscPrinter printer = EscPrinter(
      host: printerDevice.ip,
      port: printerDevice.port,
      profile: printerProfile,
      timeout: const Duration(seconds: 5),
    );

    await printer.printFormSplit(
      form,
      bufferSize:
          printerDevice.overideSetting ? printerDevice.packetSize : null,
      sleepTime:
          printerDevice.overideSetting ? printerDevice.delayTimeMs : null,
      delayBeforeDisconnect: printerDevice.overideSetting
          ? printerDevice.delayBeforeDisconnectMs
          : null,
    );
  }

  /// In phiếu bán hàng qua Lan
  Future<void> _printOrderLan(PrinterDevice printerDevice,
      {FastSaleOrder order,
      int orderId,
      @required PrinterConfig printerConfig,
      SaleSetting saleSetting}) async {
    assert(order != null || orderId != null);
    assert(printerConfig != null);

    order ??= await _fastSaleOrderApi.getById(orderId);

    if (order == null) {
      throw Exception("Không tải được dữ liệu");
    }

    // Print setting

    final company = await _getCompany(order.companyId);
    final partner = await _partnerApi.getById(order.partnerId);
    final webPrintConfig = _getPrintInvoiceOtherConfig(printerConfig);

    double revenue;
    if (webPrintConfig.showRevenue) {
      final getRevenueResult =
          await _partnerApi.getRevenueById(order.partnerId);
      revenue = getRevenueResult.revenueTotal;
    }

    if (_setting.fastSaleOrderInvoicePrintSize == "BILL80-IMAGE") {
      await _printOrderViaLanImage(
          partner: partner,
          company: company,
          order: order,
          printerConfig: printerConfig,
          printerDevice: printerDevice,
          saleSetting: saleSetting,
          webPrintConfig: webPrintConfig);
    } else {
      await _printOrderViaLanEsc(
          partner: partner,
          company: company,
          order: order,
          printerConfig: printerConfig,
          printerDevice: printerDevice,
          saleSetting: saleSetting,
          webPrintConfig: webPrintConfig);
    }
  }

  Future<void> _printOrderTPosPrinter(PrinterDevice printerDevice,
      {FastSaleOrder order,
      int orderId,
      @required PrinterConfig printerConfig,
      SaleSetting saleSetting}) async {
    assert(order != null || orderId != null);
    assert(printerConfig != null);

    order ??= await _fastSaleOrderApi.getById(orderId);

    if (order == null) {
      throw Exception("Không tải được dữ liệu");
    }

    // Print setting

    final company = await _companyApi.getById(order.companyId);
    final partner = await _partnerApi.getById(order.partnerId);

    double revenue;

    final PrintFastSaleOrderConfig webPrintConfig = PrintFastSaleOrderConfig();
    // ignore: avoid_function_literals_in_foreach_calls
    printerConfig.others.forEach((f) {
      switch (f.keyConfig) {
        case Config.hide_address:
          webPrintConfig.hideAddress = f.value;
          break;
        case Config.hide_product_code:
          webPrintConfig.hideProductCode = f.value;
          break;
        case Config.hide_delivery:
          webPrintConfig.hideDelivery = f.value;
          break;
        case Config.hide_debt:
          webPrintConfig.hideDebt = f.value;
          break;
        case Config.hide_logo:
          webPrintConfig.hideLogo = f.value;
          break;
        case Config.hide_receiver:
          webPrintConfig.hideReceiver = f.value;
          break;
        case Config.hide_phone:
          webPrintConfig.hidePhone = f.value;
          break;
        case Config.hide_staff:
          webPrintConfig.hideStaff = f.value;
          break;
        case Config.hide_amount_text:
          webPrintConfig.hideAmountText = f.value;
          break;
        case Config.hide_sign:
          webPrintConfig.hideSign = f.value;
          break;
        case Config.hide_TrackingRef:
          webPrintConfig.hideTrackingRef = f.value;
          break;
        case Config.hide_CustomerName:
          webPrintConfig.hideCustomerName = f.value;
          break;
        case Config.showbarcode:
          webPrintConfig.showBarcode = f.value;
          break;
        case Config.showweightship:
          webPrintConfig.showWeightShip = f.value;
          break;
        case Config.hide_product_note:
          webPrintConfig.hideProductNote = f.value;
          break;
        case Config.show_COD:
          webPrintConfig.showCod = f.value;
          break;
        case Config.show_revenue:
          webPrintConfig.showRevenue = f.value;
          break;
        case Config.show_combo:
          webPrintConfig.showCombo = f.value;
          break;
        case Config.show_tracking_ref_sort:
          webPrintConfig.showTrackingRefSoft = f.value;
          break;
        case Config.hide_company_address:
          webPrintConfig.hideCompanyAddress = f.value;
          break;
        case Config.hide_company_phone_number:
          webPrintConfig.hideCompanyPhoneNumber = f.value;
      }
    });

    if (webPrintConfig.showRevenue) {
      final getRevenueResult =
          await _partnerApi.getRevenueById(order.partnerId);
      revenue = getRevenueResult.revenueTotal;
    }

    final Printer printer =
        Printer(printerProfileName: printerDevice.profileName);
    await printer.connect(
        port: printerDevice.port,
        host: printerDevice.ip,
        timeout: const Duration(seconds: 5));

    final printData = PrintFastSaleOrderData();
    printData.companyName = company.name;
    printData.companyMoreInfo = company.moreInfo;
    printData.companyPhone = company.phone;
    printData.companyAddress = company.street;

    printData.carrierName = order.carrierName;
    if (order.trackingRef != null && order.trackingRef != "") {
      printData.shipCode = _getDeliverCarrierBarcode(
          order.carrierDeliveryType, order.trackingRef);
      printData.trackingRef = order.trackingRef;
      printData.trackingRefSort = order.trackingRefSort;
    }

    printData.shipNote = order.deliveryNote;

    printData.cashOnDeliveryAmount = order.cashOnDelivery;
    printData.invoiceNumber = order.number;
    printData.invoiceDate = order.dateInvoice;
    printData.customerName = partner.name;
    printData.customerPhone = partner.phone;
    printData.customerAddress = saleSetting.groupFastSaleAddressFull
        ? partner.addressFull
        : partner.street;

    printData.subTotal = order.subTotal;
    printData.shipAmount = order.deliveryPrice;
    printData.totalAmount = order.amountTotal;
    printData.discount = order.discount;
    printData.discountAmount = order.discountAmount;
    printData.decreaseAmount = order.decreaseAmount;
    printData.oldCredit = order.previousBalance;
    printData.payment = order.paymentAmount;
    printData.totalDeb = (order.previousBalance ?? 0) -
        (order.paymentAmount ?? 0) +
        (order.amountTotal ?? 0);
    printData.invoiceNote = order.comment;
    printData.defaultNote = printerConfig?.note;
    printData.receiverPhone = order.receiverPhone;
    printData.receiverAddress = order.receiverAddress;
    printData.receiverName = order.receiverName;
    printData.receiverDate = order.receiverDate;
    printData.revenue = revenue?.toDouble();
    printData.shipNote = order.deliveryNote;
    printData.userDelivery = order.deliver;
    printData.shipWeight = order.shipWeight;

    printData.hideProductCode = webPrintConfig.hideProductCode;
    printData.hideDelivery = webPrintConfig.hideDelivery;
    printData.hideDebt = webPrintConfig.hideDebt;
    printData.hideLogo = webPrintConfig.hideLogo;
    printData.hideReceiver = webPrintConfig.hideReceiver;
    printData.hideAddress = webPrintConfig.hideAddress;
    printData.hidePhone = webPrintConfig.hidePhone;
    printData.hideStaff = webPrintConfig.hideStaff;

    printData.hideAmountText = webPrintConfig.hideAmountText;
    printData.hideSign = webPrintConfig.hideSign;
    printData.hideTrackingRef = webPrintConfig.hideTrackingRef;
    printData.hideCustomerName = webPrintConfig.hideCustomerName;
    printData.hideProductNote = webPrintConfig.hideProductNote;
    printData.showBarcode = webPrintConfig.showBarcode;

    printData.showWeightShip = webPrintConfig.showWeightShip;
    printData.showCod = webPrintConfig.showCod;
    printData.showRevenue = webPrintConfig.showRevenue;
    printData.showCombo = webPrintConfig.showCombo;
    printData.showTrackingRefSort = webPrintConfig.showTrackingRefSoft;
    printData.trackingRefToShow = _getDeliveryCarrierCodeToShow(
        order.carrierDeliveryType, order.trackingRef);

    printData.user = order.userName;
    printData.orderLines = order.orderLines;
    printData.totalInWords =
        "${convertNumberToWord((order.amountTotal ?? 0).toInt().toString())} ./.";

    printData.deliveryDate = order.deliveryDate;

    if (webPrintConfig.hideAddress) printData.customerAddress = null;
    if (webPrintConfig.hidePhone) printData.customerPhone = null;
    if (webPrintConfig.hideAmountText) printData.totalInWords = null;
    if (webPrintConfig.hideCustomerName) printData.customerName = null;
    if (webPrintConfig.hideDebt) printData.previousBalance = null;
    if (webPrintConfig.hideTrackingRef) printData.trackingRef = null;
    if (webPrintConfig.hideTrackingRef) printData.trackingRefToShow = null;
    if (webPrintConfig.hideTrackingRef) printData.trackingRefSort = null;
    if (webPrintConfig.hideTrackingRef) printData.shipCode = null;
    if (webPrintConfig.hideTrackingRef) printData.carrierName = null;
    if (webPrintConfig.hideDelivery) printData.userDelivery = null;
    if (webPrintConfig.hideStaff) printData.user = null;

    if (webPrintConfig.hideReceiver) {
      printData.receiverAddress = null;
      printData.receiverName = null;
      printData.receiverPhone = null;
    }

    // show
    if (!webPrintConfig.showWeightShip) printData.shipWeight = null;
    if (!webPrintConfig.showTrackingRefSoft) printData.trackingRefSort = null;
    if (!webPrintConfig.showCod) printData.cashOnDeliveryAmount = null;
    if (!webPrintConfig.showRevenue) printData.revenue = null;

    if (webPrintConfig.hideCompanyAddress) printData.companyAddress = null;
    if (webPrintConfig.hideCompanyPhoneNumber) printData.companyPhone = null;

    await _tposDesktop.printFastSaleOrder(
      ip: printerDevice.ip,
      port: printerDevice.port,
      size: "BILL80",
      data: printData,
    );
  }

  @override
  Future<ByteData> printShipImage80mm(PrintShipData data) async {
    final CanvasPrinter printer = CanvasPrinter();
    await OrderTemplatePrinter().templateShip(printer, data);
    final result = await printer.generateImage();
    return result;
  }

  @override
  Future<ByteData> printShipGhtkImage80mm(PrintShipData data) async {
    final CanvasPrinter printer = CanvasPrinter();
    OrderTemplatePrinter().templateShipGhtk(printer, data);
    final result = await printer.generateImage();
    return result;
  }

  @override
  Future<ByteData> printFastSaleOrderImage80mm(
      PrintFastSaleOrderData data) async {
    final CanvasPrinter printer = CanvasPrinter();
    await OrderTemplatePrinter().templateFastSaleOrder(printer, data);
    final result = await printer.generateImage();
    return result;
  }

  Future<ui.Image> printFastSaleOrderImage80mm2(
      PrintFastSaleOrderData data) async {
    final CanvasPrinter printer = CanvasPrinter();
    OrderTemplatePrinter().templateFastSaleOrder(printer, data);
    final result = await printer.generateImageImg();
    return result;
  }

  /// In sale online lan test
  @override
  Future<void> printSaleOnlineLanTest() async {
    final testOrder = SaleOnlineOrder();
    testOrder.index = 111;
    testOrder.code = "10000023";
    testOrder.facebookUserId = "1000028347384";
    testOrder.partnerCode = "KH00023";
    testOrder.facebookUserName = "Tên Facebook";
    testOrder.telephone = "0985555555";

    await printSaleOnlineTag(order: testOrder);
  }

  /// In sale online Tpos printer test
  Future printSaleOnlineViaComputerTest() async {
    final data = PrintSaleOnlineData(
        uid: "10000023049934",
        name: "Nguyễn văn nam",
        code: "KH000001",
        header: "Công ty Trường Minh Thịnh",
        index: 100001,
        time: DateTime.now().toString(),
        partnerCode: "KH000001",
        note: "",
        phone: "0908075555",
        product: "Keo dán ABC");

    await _tposDesktop.printSaleOnline(
        "BILL80", "", "Ghi chú [Comment, địa chỉ....]", data);
  }

  @override
  Future<void> printGame(
      {String name, String uid, String phone, String partnerCode}) async {
    final printData = PrintSaleOnlineData(
        name: "$name (Trúng thưởng game)",
        uid: uid,
        phone: phone,
        partnerCode: partnerCode,
        note: "Đã trúng thưởng");

    if (_setting.printMethod == PrintSaleOnlineMethod.LanPrinter) {
      final saleOnlinePrinter = _setting.printers
          .firstWhere((f) => f.type == "esc_pos", orElse: () => null);

      final PrinterProfile escPrinterProfile =
          await ProfileManager().getProfile(saleOnlinePrinter.profileName);
      final EscPrinter escPrinter = EscPrinter(
        profile: escPrinterProfile,
        host: _setting.lanPrinterIp,
        port: int.parse(_setting.lanPrinterPort),
        timeout: const Duration(seconds: 10),
      );

      if (_setting.saleOnlineSize == "BILL80-IMAGE") {
        print("print Image");
        final CanvasPrinter imagePrinter = CanvasPrinter();
        final CanvasStyles canvasStyles = CanvasStyles(
          align: TextAlign.center,
          bold: true,
          fontSize: 45,
        );
        imagePrinter.printTextLn("TRÚNG THƯỞNG GAME", style: canvasStyles);
        imagePrinter.printTextLn("Tên: $name", style: canvasStyles);
        imagePrinter.printTextLn("SĐT: ${phone ?? ""}", style: canvasStyles);
        imagePrinter.printTextLn("UID: ${uid ?? ""}", style: canvasStyles);
        if (partnerCode != null)
          imagePrinter.printTextLn("Mã khách hàng: $partnerCode",
              style: canvasStyles);

        final imageByte = await imagePrinter.generateImage();

        escPrinter.printForm(
          PosForm(
            profile: escPrinterProfile,
            size: PaperSize.bill80,
          )
            ..image(imageByte)
            ..emptyLines(5)
            ..cut(),
        );
      } else {
        final PosForm form =
            PosForm(size: PaperSize.bill80, profile: escPrinterProfile);

        const textStyle = PosStyles(
            align: PosTextAlign.center,
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            isRemoveMark: true);
        form.setLineSpacing(100);
        form.textLine("TRUNG THUONG GAME", styles: textStyle);
        form.textLine("Ten: $name", styles: textStyle);
        form.textLine("SDT: $phone", styles: textStyle);
        form.textLine("UID: $uid", styles: textStyle);
        if (partnerCode != null)
          form.textLine("Mã khách hàng: $partnerCode", styles: textStyle);
        form.resetLineSpacing();
        form.emptyLines(4);
        form.cut();

        escPrinter.printFormSplit(form,
            bufferSize: saleOnlinePrinter.overideSetting
                ? saleOnlinePrinter.packetSize
                : null,
            sleepTime: saleOnlinePrinter.overideSetting
                ? saleOnlinePrinter.delayTimeMs
                : null,
            delayBeforeDisconnect: saleOnlinePrinter.overideSetting
                ? saleOnlinePrinter.delayBeforeDisconnectMs
                : null);
      }
    } else if (_setting.printMethod == PrintSaleOnlineMethod.ComputerPrinter) {
      await _tposDesktop.printSaleOnline("BILL80", "", "", printData);
    }
  }

  @override
  Future<void> printPos80mm(PrintPostData data) async {
//    var settingPrinter = _setting.printers
//        .firstWhere((f) => f.type == "esc_pos", orElse: () => null);
    final PrinterDevice settingPrinter = _setting.printers
        .firstWhere((f) => f.name == _setting.posOrderPrinterName);
    if (settingPrinter.type == "tpos_printer") {
      print("tpos_printer");
    } else if (settingPrinter.type == "esc_pos") {
      /// In hình đẹp
      if (_setting.posOrderPrintSize == "BILL80-IMAGE") {
        await printPosImage80mm(data, settingPrinter);
      } else if (_setting.posOrderPrintSize == "BILL80") {
        final Printer printer =
            Printer(printerProfileName: settingPrinter.profileName);
        await printer.connect(
            host: settingPrinter.ip,
            port: settingPrinter.port,
            timeout: const Duration(seconds: 5));

        try {
          final PosStyles normalStyle =
              PosStyles(codeTable: PosCodeTable.wpc1258.value);

          if (data.isHeaderOrFooter) {
            if (data.header != "" && data.header != null) {
              printer.printTextLn(
                "${data.header}",
                style: normalStyle.copyWith(
                    bold: false, align: PosTextAlign.center),
              );
            }
          }

          if (data.isLogo && data.imageLogo.isNotNullOrEmpty()) {
            try {
              final Uint8List bytes =
                  await networkImageToByte('${data.imageLogo}');

              printer.printImageLogo(
                  imageData: ByteData.view(bytes.buffer),
                  width: 300,
                  height: 170);
            } catch (e) {
              _log.severe(e.toString());
            }
          }

          printer.printTextLn(
            "${data.companyName ?? ""}",
            style: normalStyle.copyWith(bold: true, align: PosTextAlign.center),
          );

          // Địa chỉ công ty
          if (_setting.isShowCompanyAddressPosOrder) {
            printer.printTextLn(
              "${data.companyAddress ?? ""}",
              style:
                  normalStyle.copyWith(bold: false, align: PosTextAlign.center),
            );
          }

          if (_setting.isShowCompanyPhoneNumberPosOrder) {
            // SDT
            printer.printTextLn("${data.companyPhone}",
                style: normalStyle.copyWith(
                    bold: false, align: PosTextAlign.center));
          }

          printer.printTextLn(
              "------------------------------------------------",
              style: normalStyle.copyWith(
                  bold: false, align: PosTextAlign.center));

          printer.printTextLn("PHIẾU BÁN HÀNG",
              style: normalStyle.copyWith(
                  bold: false,
                  height: PosTextSize.size2,
                  width: PosTextSize.size2,
                  align: PosTextAlign.center),
              lineAfter: 1);

          printer.printTextLn("${data.namePayment ?? ""}",
              style:
                  normalStyle.copyWith(bold: false, align: PosTextAlign.center),
              colInd: 1);

          if (data.partnerName != null) {
            printer.printTextLn(
              "Khách hàng: ${data.partnerName ?? ""}",
              style: normalStyle.copyWith(
                bold: false,
              ),
            );
          }

          if (data.partnerPhone != null) {
            printer.printTextLn(
              "Điện thoại: ${data.partnerPhone ?? ""}",
              style: normalStyle.copyWith(
                bold: false,
              ),
            );
          }

          if (data.partnerAddress != null) {
            printer.printTextLn(
              "Địa chỉ: ${data.partnerAddress ?? ""}",
              style: normalStyle.copyWith(
                bold: false,
              ),
            );
          }

          printer.printTextLn(
            "Ngày bán: ${DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.parse(data.dateSale).toLocal()) ?? ""}",
            style: normalStyle.copyWith(
              bold: false,
            ),
          );

          printer.printTextLn("Thu ngân: ${data.employee ?? ""}",
              style: normalStyle.copyWith(
                bold: false,
              ),
              lineAfter: 1);

          const columnStyle = PosStyles(align: PosTextAlign.left);

          printer.printRow([
            PosColumn(
                text: 'Hàng hóa',
                width: 5,
                styles: columnStyle.copyWith(bold: true)),
            PosColumn(
              text: 'Đơn giá',
              width: 4,
              styles:
                  columnStyle.copyWith(bold: true, align: PosTextAlign.center),
            ),
            PosColumn(
              text: 'Thành tiền',
              width: 3,
              styles:
                  columnStyle.copyWith(bold: true, align: PosTextAlign.left),
            )
          ]);

          printer.printTextLn(
            "------------------------------------------------",
            lineAfter: 0,
          );

          int countLine = 0;
          double total = 0;

          // In các sản phẩm
          for (var i = 0; i < data.lines.length; i++) {
            countLine += data.lines[i].qty;
            total += data.lines[i].qty * data.lines[i].priceUnit;
            printer.printTextLn(
              "${data.lines[i].productName}",
              style: columnStyle,
            );
            if (data.lines[i].note != null && data.lines[i].note != "") {
              printer.printTextLn(
                "${data.lines[i].note}",
                style: columnStyle,
              );
            }
            printer.printRow([
              PosColumn(
                text: '${data.lines[i].qty}',
                width: 5,
                styles: columnStyle.copyWith(align: PosTextAlign.left),
              ),
              PosColumn(
                text: '${vietnameseCurrencyFormat(data.lines[i].priceUnit)}',
                width: 4,
                styles: columnStyle.copyWith(align: PosTextAlign.left),
              ),
              PosColumn(
                  text:
                      '${vietnameseCurrencyFormat(data.lines[i].qty * data.lines[i].priceUnit)}',
                  width: 3,
                  styles: columnStyle.copyWith(align: PosTextAlign.left)),
            ]);

            if (data.lines[i].discount != null && data.lines[i].discount != 0) {
              printer.printTextLn(
                "CK: ${data.lines[i].discount.floor()}%",
                style: columnStyle,
              );
            }

            // Gạch
            printer.printTextLn(
                "------------------------------------------------");
          }

          printer.printRow([
            PosColumn(
              text: 'Tổng',
              width: 5,
              styles: columnStyle,
            ),
            PosColumn(
              text: 'SL: $countLine',
              width: 4,
              styles: columnStyle.copyWith(align: PosTextAlign.left),
            ),
            PosColumn(
                text: '${vietnameseCurrencyFormat(total)}',
                width: 3,
                styles: columnStyle.copyWith(align: PosTextAlign.left))
          ]);
          printer.printTextLn(
            " ",
            style: normalStyle.copyWith(bold: false, height: PosTextSize.size1),
          );

          if (data.discount != 0 && data.discount != null) {
            printer.printRow([
              PosColumn(
                  text: 'Chiết khấu tổng ${data.discount.floor()}%:',
                  width: 6,
                  styles: columnStyle.copyWith(align: PosTextAlign.right)),
              PosColumn(
                  text:
                      '${limitNumber(vietnameseCurrencyFormat(data.amountDiscount), 9)}',
                  width: 6,
                  styles: columnStyle.copyWith(align: PosTextAlign.right))
            ]);
          }

          if (data.discountCash != 0 && data.discountCash != null) {
            printer.printRow([
              PosColumn(
                  text: 'Tiền giảm:',
                  width: 6,
                  styles: columnStyle.copyWith(align: PosTextAlign.right)),
              PosColumn(
                  text:
                      '${limitNumber(vietnameseCurrencyFormat(data.discountCash), 9)}',
                  width: 6,
                  styles: columnStyle.copyWith(align: PosTextAlign.right))
            ]);
          }

          if (data.amountBeforeTax != 0 &&
              data.amountBeforeTax != null &&
              data.tax != 0 &&
              data.tax != null) {
            printer.printRow([
              PosColumn(
                  text: 'Tiền trước thuế:',
                  width: 6,
                  styles: columnStyle.copyWith(align: PosTextAlign.right)),
              PosColumn(
                  text:
                      '${limitNumber(vietnameseCurrencyFormat(data.amountBeforeTax), 9)}',
                  width: 6,
                  styles: columnStyle.copyWith(align: PosTextAlign.right))
            ]);
          }

          if (data.tax != 0 && data.tax != null) {
            printer.printRow([
              PosColumn(
                  text: 'Thuế GTGT ${data.tax.floor()}%:',
                  width: 6,
                  styles: columnStyle.copyWith(align: PosTextAlign.right)),
              PosColumn(
                  text:
                      '${limitNumber(vietnameseCurrencyFormat(data.amountTax), 9)}',
                  width: 6,
                  styles: columnStyle.copyWith(align: PosTextAlign.right))
            ]);
          }

          printer.printRow([
            PosColumn(
                text: 'Tổng thanh toán:',
                width: 6,
                styles: columnStyle.copyWith(align: PosTextAlign.right)),
            PosColumn(
                text:
                    '${limitNumber(vietnameseCurrencyFormat(data.amountBeforeTax + data.amountTax), 9)}',
                width: 6,
                styles: columnStyle.copyWith(align: PosTextAlign.right))
          ]);
          printer.printTextLn(
            " ",
            style: normalStyle.copyWith(bold: false, height: PosTextSize.size1),
          );
          printer.printRow([
            PosColumn(
              text: 'Tiền mặt:',
              width: 6,
              styles: columnStyle.copyWith(align: PosTextAlign.right),
            ),
            PosColumn(
              text:
                  '${limitNumber(vietnameseCurrencyFormat(data.amountBeforeTax + data.amountTax), 9)}',
              width: 6,
              styles: columnStyle.copyWith(align: PosTextAlign.right),
            )
          ]);
          printer.printTextLn(
            " ",
            style: normalStyle.copyWith(bold: false, height: PosTextSize.size1),
          );
          printer.printRow([
            PosColumn(
              text: 'Dư:',
              width: 6,
              styles: columnStyle.copyWith(align: PosTextAlign.right),
            ),
            PosColumn(
              text:
                  '${limitNumber(vietnameseCurrencyFormat(data.amountReturn ?? 0), 9)}',
              width: 6,
              styles: columnStyle.copyWith(align: PosTextAlign.right),
            )
          ]);

          printer.emptyLines(2);

          if (data.isHeaderOrFooter) {
            if (data.footer != "" && data.footer != null) {
              printer.printTextLn(
                data.footer,
                style: normalStyle.copyWith(
                    bold: false, align: PosTextAlign.center),
              );
            }
          }

          printer.feed(4);
          printer.cut();
        } catch (e, s) {
          _log.severe("print", e, s);
          throw Exception(e.toString());
        } finally {
          printer.disconnect();
        }
      }
    }
  }

  String limitNumber(String number, int limit) {
    String res = number;
    if (number.length < limit) {
      final int count = limit - number.length;
      for (var i = 0; i < count; i++) {
        res = " " + res;
      }
    }
    return res;
  }

  @override
  Future<void> printPosImage80mm(
      PrintPostData data, PrinterDevice settingPrinter) async {
//    var settingPrinter = _setting.printers
//        .firstWhere((f) => f.type == "esc_pos", orElse: () => null);

    final CanvasPrinter canvasPrinter = CanvasPrinter();
    try {
      final CanvasStyles normalStyle = CanvasStyles();

      if (data.isHeaderOrFooter) {
        if (data.header != "" && data.header != null) {
          print(data.header);
          canvasPrinter.printTextLn(
            "${data.header}",
            style: normalStyle.copyWith(bold: false, align: TextAlign.center),
          );
        }
      }

      if (data.isLogo && data.imageLogo.isNotNullOrEmpty()) {
        final Uint8List bytes = await networkImageToByte('${data.imageLogo}');

        canvasPrinter.printImage(bytes, 300, 170);
      }

      canvasPrinter.printTextLn(
        "${data.companyName ?? ""}",
        style: normalStyle.copyWith(bold: true, align: TextAlign.center),
      );

      // Địa chỉ công ty
      if (_setting.isShowCompanyAddressPosOrder) {
        canvasPrinter.printTextLn(
          "${data.companyAddress ?? ""}",
          style: normalStyle.copyWith(bold: false, align: TextAlign.center),
        );
      }

      if (_setting.isShowCompanyPhoneNumberPosOrder) {
        // SDT
        canvasPrinter.printTextLn("${data.companyPhone}",
            style: normalStyle.copyWith(bold: false, align: TextAlign.center));
      }

      canvasPrinter.printTextLn(
          "------------------------------------------------",
          style: normalStyle.copyWith(bold: false, align: TextAlign.center));

      canvasPrinter.printTextLn(
        "PHIẾU BÁN HÀNG",
        style: normalStyle.copyWith(
            bold: false, fontSize: 40, align: TextAlign.center),
      );
      canvasPrinter.emptyLines(15);

      canvasPrinter.printTextLn("${data.namePayment ?? ""}",
          style: normalStyle.copyWith(bold: false, align: TextAlign.center));

      if (data.partnerName != null) {
        canvasPrinter.printTextLn(
          "Khách hàng: ${data.partnerName ?? ""}",
          style: normalStyle.copyWith(
            bold: false,
          ),
        );
      }

      if (data.partnerPhone != null) {
        canvasPrinter.printTextLn(
          "Điện thoại: ${data.partnerPhone ?? ""}",
          style: normalStyle.copyWith(
            bold: false,
          ),
        );
      }

      if (data.partnerAddress != null) {
        canvasPrinter.printTextLn(
          "Địa chỉ: ${data.partnerAddress ?? ""}",
          style: normalStyle.copyWith(
            bold: false,
          ),
        );
      }

      canvasPrinter.printTextLn(
        "Ngày bán: ${DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.parse(data.dateSale).toLocal()) ?? ""}",
        style: normalStyle.copyWith(
          bold: false,
        ),
      );

      canvasPrinter.printTextLn(
        "Thu ngân: ${data.employee ?? ""}",
        style: normalStyle.copyWith(
          bold: false,
        ),
      );
      canvasPrinter.emptyLines(15);

      final columnStyle = CanvasStyles(align: TextAlign.left);

      canvasPrinter.printRow([
        CanvasColumn(
            text: 'Hàng hóa',
            width: 4,
            styles: columnStyle.copyWith(bold: true)),
        CanvasColumn(
          text: 'Đơn giá',
          width: 4,
          styles: columnStyle.copyWith(bold: true, align: TextAlign.center),
        ),
        CanvasColumn(
          text: 'Thành tiền',
          width: 4,
          styles: columnStyle.copyWith(bold: true, align: TextAlign.right),
        )
      ]);

      canvasPrinter.printDivider(height: 1);

      int countLine = 0;
      double total = 0;

      // In các sản phẩm
      for (var i = 0; i < data.lines.length; i++) {
        countLine += data.lines[i].qty;
        total += data.lines[i].qty * data.lines[i].priceUnit;
        canvasPrinter.printTextLn(
          "${data.lines[i].productName}",
          style: columnStyle,
        );
        if (data.lines[i].note != null && data.lines[i].note != "") {
          canvasPrinter.printTextLn(
            "${data.lines[i].note}",
            style: columnStyle,
          );
        }
        canvasPrinter.printRow([
          CanvasColumn(
            text: '${data.lines[i].qty}',
            width: 4,
            styles: columnStyle.copyWith(align: TextAlign.left),
          ),
          CanvasColumn(
            text: '${vietnameseCurrencyFormat(data.lines[i].priceUnit)}',
            width: 4,
            styles: columnStyle.copyWith(align: TextAlign.center),
          ),
          CanvasColumn(
              text:
                  '${vietnameseCurrencyFormat(data.lines[i].qty * data.lines[i].priceUnit)}',
              width: 4,
              styles: columnStyle.copyWith(align: TextAlign.right)),
        ]);

        if (data.lines[i].discount != null && data.lines[i].discount != 0) {
          canvasPrinter.printTextLn(
            "CK: ${data.lines[i].discount.floor()}%",
            style: columnStyle,
          );
        }

        canvasPrinter.printDivider(height: 1);
      }

      canvasPrinter.printRow([
        CanvasColumn(
          text: 'Tổng',
          width: 4,
          styles: columnStyle,
        ),
        CanvasColumn(
          text: 'SL: $countLine',
          width: 4,
          styles: columnStyle.copyWith(align: TextAlign.center),
        ),
        CanvasColumn(
            text: '${vietnameseCurrencyFormat(total)}',
            width: 4,
            styles: columnStyle.copyWith(align: TextAlign.right))
      ]);

      canvasPrinter.emptyLines(20);

      if (data.discount != 0 && data.discount != null) {
        canvasPrinter.printRow([
          CanvasColumn(
              text: 'Chiết khấu tổng ${data.discount.floor()}%',
              width: 6,
              styles: columnStyle.copyWith(align: TextAlign.left)),
          CanvasColumn(
              text: '${vietnameseCurrencyFormat(data.amountDiscount)}',
              width: 6,
              styles: columnStyle.copyWith(align: TextAlign.right))
        ]);
      }

      if (data.discountCash != 0 && data.discountCash != null) {
        canvasPrinter.printRow([
          CanvasColumn(
              text: 'Tiền giảm',
              width: 6,
              styles: columnStyle.copyWith(align: TextAlign.left)),
          CanvasColumn(
              text: '${vietnameseCurrencyFormat(data.discountCash)}',
              width: 6,
              styles: columnStyle.copyWith(align: TextAlign.right))
        ]);
      }

      if (data.amountBeforeTax != 0 &&
          data.amountBeforeTax != null &&
          data.tax != 0 &&
          data.tax != null) {
        canvasPrinter.printRow([
          CanvasColumn(
              text: 'Tiền trước thuế',
              width: 6,
              styles: columnStyle.copyWith(align: TextAlign.left)),
          CanvasColumn(
              text: '${vietnameseCurrencyFormat(data.amountBeforeTax)}',
              width: 6,
              styles: columnStyle.copyWith(align: TextAlign.right))
        ]);
      }

      if (data.tax != 0 && data.tax != null) {
        canvasPrinter.printRow([
          CanvasColumn(
              text: 'Thuế GTGT ${data.tax.floor()}%',
              width: 6,
              styles: columnStyle.copyWith(align: TextAlign.left)),
          CanvasColumn(
              text: '${vietnameseCurrencyFormat(data.amountTax)}',
              width: 6,
              styles: columnStyle.copyWith(align: TextAlign.right))
        ]);
      }
      canvasPrinter.printRow([
        CanvasColumn(
            text: 'Tổng thanh toán:',
            width: 6,
            styles: columnStyle.copyWith(align: TextAlign.left)),
        CanvasColumn(
            text:
                '${vietnameseCurrencyFormat(data.amountBeforeTax + data.amountTax)}',
            width: 6,
            styles: columnStyle.copyWith(align: TextAlign.right))
      ]);
      canvasPrinter.emptyLines(20);
      canvasPrinter.printRow([
        CanvasColumn(
          text: 'Tiền mặt:',
          width: 6,
          styles: columnStyle.copyWith(align: TextAlign.left),
        ),
        CanvasColumn(
          text:
              '${vietnameseCurrencyFormat(data.amountBeforeTax + data.amountTax)}',
          width: 6,
          styles: columnStyle.copyWith(align: TextAlign.right),
        )
      ]);

      canvasPrinter.emptyLines(25);

      canvasPrinter.printRow([
        CanvasColumn(
          text: 'Dư',
          width: 6,
          styles: columnStyle.copyWith(align: TextAlign.left),
        ),
        CanvasColumn(
          text: '${vietnameseCurrencyFormat(data.amountReturn ?? 0)}',
          width: 6,
          styles: columnStyle.copyWith(align: TextAlign.right),
        )
      ]);

      canvasPrinter.emptyLines(25);
      if (data.isHeaderOrFooter) {
        if (data.footer != "" && data.footer != null) {
          canvasPrinter.printTextLn(
            "${data.footer}",
            style: normalStyle.copyWith(bold: false, align: TextAlign.center),
          );
        }
      }

      final image = await canvasPrinter.generateImage();
      final profile =
          await ProfileManager().getProfile(settingPrinter.profileName);

      final printer = EscPrinter(
          profile: profile,
          host: settingPrinter.ip,
          port: settingPrinter.port,
          timeout: const Duration(seconds: 5));
      final form = PosForm(size: PaperSize.bill80, profile: profile);

      if (settingPrinter.isImageRasterPrint) {
        form.imageRaster(image);
      } else {
        form.imageForm(image);
      }
      form.resetLineSpacing();
      form.emptyLines(4);
      form.cut();
      await printer.printFormSplit(
        form,
        bufferSize:
            settingPrinter.overideSetting ? settingPrinter.packetSize : null,
        sleepTime:
            settingPrinter.overideSetting ? settingPrinter.delayTimeMs : null,
        delayBeforeDisconnect: settingPrinter.overideSetting
            ? settingPrinter.delayBeforeDisconnectMs
            : null,
      );
    } catch (e, s) {
      _log.severe("print", e, s);
      rethrow;
    } finally {}
  }
}
