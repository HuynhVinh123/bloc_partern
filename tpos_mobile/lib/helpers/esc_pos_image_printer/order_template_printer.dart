import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:tmt_flutter_untils/tmt_flutter_utils.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/data_helper.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_desktop/print_fast_sale_order_data.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_desktop/print_ship_data.dart';
import 'package:tpos_mobile/feature_group/sale_online/services/service.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/models/enums/font_scale.dart';
import 'package:tpos_mobile/services/config_service/shop_config_service.dart';

import 'my_canvas_printer.dart';

class OrderTemplatePrinter {
  Future<void> templateShip(CanvasPrinter printer, PrintShipData data) async {
    final setting = locator<ISettingService>();
    final printerConfig = GetIt.I<ShopConfigService>().printerConfig;
    if (data.imageLogo.isNotNullOrEmpty()) {
      final Uint8List bytes = await networkImageToByte('${data.imageLogo}');

      printer.printImage(bytes, 300, 170);
    }

    final double fontSize = 25 * printerConfig.shipFontScale.getScale();
    final double fontSize1 = 30 * printerConfig.shipFontScale.getScale();
    final double headerFontSize = 40 * printerConfig.shipFontScale.getScale();
    final CanvasStyles style = CanvasStyles(fontSize: fontSize);
    if (data.companyName != null) {
      printer.printTextLn("${data.companyName}",
          style: style.copyWith(bold: true, fontSize: headerFontSize));
    }

    if (data.companyAddress != null) {
      printer.emptyLines(10);
      printer.printTextLn("Địa chỉ: ${data.companyAddress}",
          style: style.copyWith(bold: true));
    }

    if (data.companyPhone != null) {
      printer.emptyLines(10);
      printer.printTextLn("SĐT: ${data.companyPhone}", style: style);
    }

    if (data.companyEmail != null) {
      printer.emptyLines(10);
      printer.printTextLn("Email: ${data.companyEmail}", style: style);
    }

    if (data.sender.isNotNullOrEmpty()) {
      printer.emptyLines(10);
      printer.printTextLn(data.sender, style: style);
    }

    if (data.staff != null) {
      printer.emptyLines(10);
      printer.printTextLn("Nhân viên: ${data.staff}", style: style);
    }

    if (data.carrierName != null) {
      printer.emptyLines(1);
      printer.printTextLn(
        "${data.carrierName}",
        style: style.copyWith(
          align: TextAlign.center,
          bold: false,
        ),
      );
    }

    if (data.trackingArea != null) {
      printer.emptyLines(1);
      printer.printTextLn(
        "${data.trackingArea}",
        style:
            style.copyWith(align: TextAlign.center, bold: true, fontSize: 32),
      );
    }

    if (data.trackingRefSort != null) {
      printer.emptyLines(1);
      printer.printTextLn(
        "${data.trackingRefSort}",
        style: style.copyWith(
          align: TextAlign.center,
          bold: true,
        ),
      );
    }
    if (data.shipCode.isNotNullOrEmpty() &&
        data.shipCodeQRCode.isNullOrEmpty()) {
      printer.printBarCode(
        "${data.shipCode}",
        height: 100,
        hasText: false,
      );
      printer.printTextLn(
        "${data.trackingRefToShow}",
        style: style.copyWith(
          bold: true,
          align: TextAlign.center,
        ),
      );
    }

    if (data.shipCodeQRCode.isNotNullOrEmpty()) {
      printer.emptyLines(10);
      printer.printQrcode(data.shipCodeQRCode, 180);
      printer.printTextLn(
        data.trackingRefToShow ?? '',
        style: style.copyWith(
          bold: true,
          align: TextAlign.center,
        ),
      );
    }

    // Số tiền thu hộ. In Ô vuông để nhập nếu Thu hộ =null
    if (data.cashOnDeliveryPrice != null) {
      printer.emptyLines(25);
      printer.printTextLn(
        "Thu hộ ${vietnameseCurrencyFormat(data.cashOnDeliveryPrice)} VND",
        style: style.copyWith(
          align: TextAlign.center,
          bold: true,
          fontSize: 50,
        ),
      );
    } else {
      // In chỗ nhập tiền thu hộ
      printer.emptyLines(25);
      printer.printTextLn("Thu hộ (COD)",
          style: style.copyWith(
              align: TextAlign.center, bold: true, fontSize: headerFontSize));
      printer.printTextLn("                 ",
          style: style.copyWith(
            align: TextAlign.center,
            bold: true,
            fontSize: 50,
          ),
          hasBorder: true);
    }

    // Số lượng sản phẩm
    if (data.productQuantity != null) {
      printer.printTextLn(
        "Số lượng SP: ${data.productQuantity.toStringFormat('###,###,###')}",
        style: style.copyWith(
          bold: true,
          align: TextAlign.center,
        ),
      );
    }

    if (data.depositAmount != null) {
      printer.printTextLn(
        "Tiền cọc: ${data.depositAmount.toStringFormat('###,###,###')}",
        style: style.copyWith(
          bold: true,
          align: TextAlign.center,
        ),
      );
    }

    if (data.invoiceAmount != null || data.deliveryPrice != null) {
      printer.emptyLines(5);
      printer.printTextLn(
        "${data.invoiceAmount == null || data.deliveryPrice == null ? "" : "("}"
        "${data.invoiceAmount != null ? "Tiền hàng: ${vietnameseCurrencyFormat(data.invoiceAmount)}" : ""}"
        "${data.invoiceAmount == null || data.deliveryPrice == null ? "" : ""}"
        "${data.deliveryPrice != null ? "+ Tiền ship: ${vietnameseCurrencyFormat(data.deliveryPrice)}" : "+ Tiền ship"}"
        "${data.invoiceAmount == null || data.deliveryPrice == null ? "" : ")"}",
        style:
            style.copyWith(bold: true, align: TextAlign.center, fontSize: 30),
      );
    }

    if (data.invoiceNumber != null) {
      printer.emptyLines(5);
      printer.printTextLn("${data.invoiceNumber}",
          style: style.copyWith(
              bold: true, align: TextAlign.center, fontSize: 30));
    }

    if (data.invoiceDate != null) {
      printer.emptyLines(5);
      printer.printTextLn(
          "Ngày: ${DateFormat("dd/MM/yyyy").format(data.invoiceDate)}",
          style: style.copyWith(
              bold: true, align: TextAlign.center, fontSize: 30));
    }

    if (data.receiverName != null) {
      printer.emptyLines(25);
      printer.printTextSpans(textSpans: [
        CanvasTextSpan(
          "Người nhận: ",
          style: style.copyWith(
            bold: true,
          ),
        ),
        CanvasTextSpan(
          "${data.receiverName}",
          style: style.copyWith(
            bold: true,
            fontSize: fontSize1,
          ),
        ),
      ]);
    }

    if (data.receiverAddress != null) {
      printer.emptyLines(25);
      printer.printTextSpans(textSpans: [
        CanvasTextSpan(
          "Địa chỉ: ",
          style: style.copyWith(bold: true),
        ),
        CanvasTextSpan(
          "${data.receiverAddress}",
          style: style.copyWith(),
        ),
      ]);
    }

    if (data.receiverPhone != null) {
      printer.emptyLines(25);
      printer.printTextSpans(textSpans: [
        CanvasTextSpan(
          "SĐT: ",
          style: style.copyWith(bold: true),
        ),
        CanvasTextSpan(
          "${data.receiverPhone}",
          style: style.copyWith(),
        ),
      ]);
    }

    // Khối lương ship
    if (data.shipWeight != null) {
      printer.printTextSpans(center: false, textSpans: [
        CanvasTextSpan(
          "KL ship (g): ",
          style: style.copyWith(bold: true, align: TextAlign.start),
        ),
        CanvasTextSpan(
          "${data.shipWeight.toInt()}",
          style: style.copyWith(),
        ),
      ]);
    }

    // Thông tin sản phẩm
    if (data.orderLines != null) {
      String productInfo = "";
      String getProductInfo(item) {
        final nameTemplate = item.nameTemplate ?? "";
        final productUOMQty =
            " SL:${vietnameseCurrencyFormat(item.productUOMQty ?? 0)}";
        final priceUnit =
            " x ${vietnameseCurrencyFormat(item.priceUnit ?? 0)}đ ";
        final note = item.note != null ? "(${item.note}); " : "; ";
        final productInfo = nameTemplate + productUOMQty + priceUnit + note;
        return productInfo;
      }

      data.orderLines.forEach((item) {
        productInfo = productInfo + getProductInfo(item);
      });

      printer.printTextSpans(
        textSpans: [
          CanvasTextSpan(
            "Thông tin SP: ",
            style: style.copyWith(bold: true, align: TextAlign.start),
          ),
          CanvasTextSpan(
            productInfo,
            style: style.copyWith(bold: false),
          ),
        ],
      );
    }
    printer.emptyLines(5);

    if (data.shipNote != null) {
      printer.printTextSpans(
        textSpans: [
          CanvasTextSpan(
            "Ghi chú giao hàng: ",
            style: style.copyWith(bold: true, align: TextAlign.start),
          ),
          CanvasTextSpan(
            data.shipNote,
            style: style.copyWith(bold: false),
          ),
        ],
      );
    }

    if (data.note != null) {
      printer.emptyLines(10);
      printer.printTextSpans(textSpans: [
        CanvasTextSpan(
          "Lưu ý: ",
          style: style.copyWith(bold: true),
        ),
        CanvasTextSpan(
          "${data.note}",
          style: style.copyWith(),
        ),
      ]);
    }

    // Mã theo dõi sắp xếp, mã chia
    if (data.trackingRefSort.isNotNullOrEmpty()) {
      if (data.qrTrackingRefSort.isNotNullOrEmpty()) {
        printer.printQrcode(data.trackingRefSort, 180);
        printer.printTextLn(
          "${data.trackingRefSort}",
          style: style.copyWith(
            bold: true,
            align: TextAlign.center,
          ),
        );
      } else {
        printer.printBarCode(
          data.trackingRefSort,
          hasText: true,
          height: 70,
        );
      }
    }

    /// Mã tỉnh
    if (data.trackingArea.isNotNullOrEmpty()) {
      printer.emptyLines(25);

      printer.printTextLn(
        data.trackingArea,
        style: style.copyWith(
          bold: true,
          align: TextAlign.center,
          fontSize: headerFontSize,
        ),
        hasBorder: true,
      );
    }
    printer.emptyLines(60);
  }

  void templateShipGhtk(CanvasPrinter printer, PrintShipData data) {
    //printer.kCanvasSizeWidth = (printer.paperWidth * 50 / 80);
    //printer.kCanvasSizeHeight = (printer.paperWidth * 50 / 80);
    //printer.hasBorder = true;
    printer.setUp(
      isHasBorder: true,
      width: printer.paperWidth * 50 / 80,
      height: printer.paperWidth * 50 / 80,
    );
    printer.setUpCanvasHeader(
      canvasHeader: CanvasHeader(
          headerImage: CanvasImage(
            url: "giaohangtietkiem.vn/wp-content/uploads/2015/10/logo.png",
          ),
          title: HeaderTitle(title: "Giaohangtietkiem.vn")),
    );
    if (data.shipCode != null) {
      printer.emptyLines(10);
      printer.printBarCode("${data.shipCode}", lineWidth: 2, height: 60);
    }
    if (data.trackingRefToShow != null) {
      printer.emptyLines(5);
      printer.printTextLn(
        "${data.trackingRefToShow}",
        style: CanvasStyles(
          bold: true,
          align: TextAlign.center,
        ),
      );
    }
    if (data.trackingRefGHTK != null) {
      printer.emptyLines(10);
      printer.printTextLn(
        "${data.trackingRefGHTK}",
        hasBorder: true,
        style: CanvasStyles(
          bold: true,
          align: TextAlign.center,
        ),
      );
    }
    printer.emptyLines(6);
    printer.printTextLn(
      "${data.receiverName != null ? "${data.receiverName}" : ""}"
      "${data.receiverPhone != null ? ", ${data.receiverPhone}" : ""}"
      "${data.receiverAddress != null ? ", ${data.receiverAddress}" : ""}"
      "${data.receiverWardName != null ? ", ${data.receiverWardName}" : ""}"
      "${data.receiverDictrictName != null ? ", ${data.receiverDictrictName}" : ""}"
      "${data.receiverCityName != null ? ", ${data.receiverCityName}" : ""}"
      "${data.invoiceNumber != null ? ", ${data.invoiceNumber}" : ""}",
      style: CanvasStyles(fontSize: 18),
    );
  }

  Future<void> templateFastSaleOrder(
      CanvasPrinter printer, PrintFastSaleOrderData data) async {
    printer.fontFamily = "";

    final printerConfig = GetIt.I<ShopConfigService>().printerConfig;

    final double fontSize = 25 * printerConfig.invoiceFontScale.getScale();
    final double headerFontSize =
        40 * printerConfig.invoiceFontScale.getScale();
    final CanvasStyles style = CanvasStyles(fontSize: fontSize);

    if (data.imageLogo.isNotNullOrEmpty()) {
      final Uint8List bytes = await networkImageToByte('${data.imageLogo}');
      printer.printImage(bytes, 300, 170);
    }

    // Tên công ty
    if (data.companyName != null) {
      printer.printTextLn(
        "${data.companyName}",
        style: style.copyWith(
          align: TextAlign.center,
          bold: true,
          fontSize: headerFontSize,
        ),
      );
    }
    if (data.companyMoreInfo != null) {
      printer.printTextLn(
        "${data.companyMoreInfo}",
        style: style.copyWith(
          align: TextAlign.center,
        ),
      );
    }
    if (data.companyAddress != null) {
      printer.printTextLn(
        "${data.companyAddress}",
        style: style.copyWith(
          align: TextAlign.center,
        ),
      );
    }
    if (data.companyPhone != null) {
      printer.printTextLn(
        "${data.companyPhone}",
        style: style.copyWith(
          align: TextAlign.center,
        ),
      );
    }

    if (data.companyEmail != null) {
      printer.printTextLn(
        "${data.companyEmail}",
        style: style.copyWith(
          align: TextAlign.center,
        ),
      );
    }

    if (data.carrierName != null) {
      printer.printTextLn(
        "${data.carrierName}",
        style: style.copyWith(
          align: TextAlign.center,
        ),
      );
    }

    if (!data.changeTrackingRefAndTrackingRefSort) {
      if (data.shipCode != null) {
        printer.printBarCode("${data.shipCode}", height: 60, lineWidth: 2.8);
      }
    } else {
      if (data.trackingRefSort.isNotNullOrEmpty()) {
        if (data.qrCodeTrackingRefSort == null)
          printer.printBarCode(
            "${data.trackingRefSort}",
            height: 60,
            lineWidth: 2,
            hasText: false,
          );
        else {
          printer.printQrcode(data.trackingRefSort, 180);
        }
        printer.printTextLn(
          "${data.trackingRefSort}",
          style: style.copyWith(
            bold: true,
            align: TextAlign.center,
          ),
        );
      }
    }

    if (data.trackingRefToShow != null) {
      printer.printTextLn(
        "${data.trackingRefToShow}",
        style: style.copyWith(
          align: TextAlign.center,
          bold: true,
        ),
      );
    }

    if (data.shipWeight != null) {
      printer.printTextSpans(center: true, textSpans: [
        CanvasTextSpan(
          "KL ship (g): ",
          style: style.copyWith(bold: true),
        ),
        CanvasTextSpan(
          "${data.shipWeight.toInt()}",
          style: style.copyWith(),
        ),
      ]);
    }

    if (data.cashOnDeliveryAmount != null) {
      printer.printTextSpans(
        center: true,
        textSpans: [
          CanvasTextSpan(
            "Thu hộ: ",
            style: style.copyWith(),
          ),
          CanvasTextSpan(
            "${vietnameseCurrencyFormat(data.cashOnDeliveryAmount)}",
            style: style.copyWith(),
          ),
        ],
      );
    }

    printer.emptyLines(18);

    printer.printDividerDash();

    printer.emptyLines(25);
    printer.printTextLn(
      "PHIẾU BÁN HÀNG",
      style: style.copyWith(align: TextAlign.center, fontSize: headerFontSize),
    );
    printer.emptyLines(25);
    if (data.invoiceNumber != null) {
      printer.printTextSpans(
        center: true,
        textSpans: [
          CanvasTextSpan(
            "Số phiếu: ",
            style: style.copyWith(bold: true),
          ),
          CanvasTextSpan(
            "${data.invoiceNumber}",
            style: style.copyWith(),
          ),
        ],
      );
    }

    if (data.invoiceDate != null) {
      printer.printTextSpans(
        center: true,
        textSpans: [
          CanvasTextSpan(
            "Ngày: ",
            style: style.copyWith(bold: true),
          ),
          CanvasTextSpan(
            "${getDate(data.invoiceDate)} ${getTime(data.invoiceDate)}",
            style: style.copyWith(),
          ),
        ],
      );
    }
    printer.emptyLines(18);
    if (data.invoiceNumber != null || data.invoiceDate != null) {
      printer.printDividerDash();
    }
    printer.emptyLines(10);
    if (data.customerName != null) {
      printer.printTextSpans(
        textSpans: [
          CanvasTextSpan(
            "Khách hàng: ",
            style: style.copyWith(bold: true),
          ),
          CanvasTextSpan(
            "${data.customerName}",
            style: style.copyWith(),
          ),
        ],
      );
    }

    if (data.customerAddress != null) {
      printer.printTextSpans(
        textSpans: [
          CanvasTextSpan(
            "Địa chỉ: ",
            style: style.copyWith(bold: true),
          ),
          CanvasTextSpan(
            "${data.customerAddress}",
            style: style.copyWith(),
          ),
        ],
      );
    }

    if (data.customerPhone != null) {
      printer.printTextSpans(
        textSpans: [
          CanvasTextSpan(
            "Điện thoại: ",
            style: style.copyWith(bold: true),
          ),
          CanvasTextSpan(
            "${data.customerPhone}",
            style: style.copyWith(),
          ),
        ],
      );
    }

    if (data.user != null) {
      printer.printTextSpans(
        textSpans: [
          CanvasTextSpan(
            "Người bán: ",
            style: style.copyWith(bold: true),
          ),
          CanvasTextSpan(
            "${data.user}",
            style: style.copyWith(),
          ),
        ],
      );
    }

    if (data.userDelivery != null) {
      printer.printTextSpans(
        textSpans: [
          CanvasTextSpan(
            "NV giao hàng: ",
            style: style.copyWith(bold: true),
          ),
          CanvasTextSpan(
            "${data.userDelivery}",
            style: style.copyWith(),
          ),
        ],
      );
    }
    printer.emptyLines(10);
    printer.printDividerDash(lineDash: LineDash(dashSpace: 0));
    printer.printRow(
      [
        CanvasColumn(
          text: "Sản phẩm",
          width: 3,
          styles: style.copyWith(bold: true),
        ),
        CanvasColumn(
          text: "Giá bán",
          width: 3,
          styles: style.copyWith(bold: true),
        ),
        CanvasColumn(
          text: "CK",
          width: 3,
          styles: style.copyWith(bold: true),
        ),
        CanvasColumn(
          text: "Thành tiền",
          width: 3,
          styles: style.copyWith(bold: true),
        ),
      ],
    );
    printer.printDividerDash(lineDash: LineDash(dashSpace: 0));

    var qty = 0.0;
    if (data.orderLines != null) {
      data.orderLines.forEach((item) {
        qty = qty + item.productUOMQty;
        printer.printTextLn(
          "${item.nameTemplate ?? " "}",
          style: style.copyWith(bold: true),
        );
        if (item.note != null && item.note != "")
          printer.printTextLn(
            "${item.note ?? " "}",
            style: style.copyWith(bold: false),
          );
        printer.emptyLines(10);
        printer.printRow(
          [
            CanvasColumn(
              text:
                  "${item.productUOMQty?.toInt() ?? " "} ${item.productUomName ?? " "}",
              width: 3,
              styles: style.copyWith(
                bold: false,
                align: TextAlign.start,
              ),
            ),
            CanvasColumn(
              text: "${vietnameseCurrencyFormat(item.priceUnit ?? 0)}",
              width: 3,
              styles: style.copyWith(
                bold: false,
                align: TextAlign.center,
              ),
            ),
            CanvasColumn(
              text: item.discount != null && item.discount > 0
                  ? "${item.discount?.toInt() ?? 0}%"
                  : item.discountFixed != null && item.discountFixed > 0
                      ? "${vietnameseCurrencyFormat(item.discountFixed)} đ  "
                      : "0%",
              width: 3,
              styles: style.copyWith(
                bold: false,
                align: TextAlign.center,
              ),
            ),
            CanvasColumn(
              text: "${vietnameseCurrencyFormat(item.priceTotal ?? 0)}",
              width: 3,
              styles: style.copyWith(
                bold: false,
                align: TextAlign.end,
              ),
            ),
          ],
        );
        printer.printDividerDash(lineDash: LineDash(dashSpace: 0));
      });
    }

    printer.emptyLines(5);
    printer.printRow(
      [
        CanvasColumn(
          text: "Tổng:",
          width: 3,
          styles: style.copyWith(bold: true),
        ),
        CanvasColumn(
          text: "SL: ${qty.toInt()}",
          width: 3,
          styles: style.copyWith(bold: true),
        ),
        CanvasColumn(
          text: "${vietnameseCurrencyFormat(data.subTotal ?? 0)}",
          width: 6,
          styles: style.copyWith(
            bold: true,
            align: TextAlign.end,
          ),
        ),
      ],
    );
    //Chiết khấu %
    if (data.discount != null && data.discount != 0) {
      printer.emptyLines(10);
      printer.printRow(
        [
          CanvasColumn(
            text: " ",
            width: 3,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
          CanvasColumn(
            text: "CK (${data.discount} %):",
            width: 6,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
          CanvasColumn(
            text: "${vietnameseCurrencyFormat(data.discountAmount ?? 0)}",
            width: 3,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
        ],
      );
    }
    //Giảm tiền
    if (data.decreaseAmount != null && data.decreaseAmount != 0) {
      printer.emptyLines(10);
      printer.printRow(
        [
          CanvasColumn(
            text: " ",
            width: 3,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
          CanvasColumn(
            text: "Giảm tiền:",
            width: 6,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
          CanvasColumn(
            text: "${vietnameseCurrencyFormat(data.decreaseAmount ?? 0)}",
            width: 3,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
        ],
      );
    }
    //Tiền ship
    if (data.shipAmount != null) {
      printer.emptyLines(10);
      printer.printRow(
        [
          CanvasColumn(
            text: " ",
            width: 3,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
          CanvasColumn(
            text: "Tiền ship:",
            width: 6,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
          CanvasColumn(
            text: "${vietnameseCurrencyFormat(data.shipAmount ?? 0)}",
            width: 3,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
        ],
      );
    }

    //Tiền cọc

    if (data.depositAmount != null && data.depositAmount != 0) {
      printer.emptyLines(10);
      printer.printRow(
        [
          CanvasColumn(
            text: " ",
            width: 3,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
          CanvasColumn(
            text: "Tiền cọc:",
            width: 6,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
          CanvasColumn(
            text: "${vietnameseCurrencyFormat(data.depositAmount ?? 0)}",
            width: 3,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
        ],
      );
    }

    printer.emptyLines(10);
    if (data.totalAmount != null)
      printer.printRow(
        [
          CanvasColumn(
            text: " ",
            width: 3,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
          CanvasColumn(
            text: "Tổng tiền:",
            width: 6,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
          CanvasColumn(
            text: "${vietnameseCurrencyFormat(data.totalAmount ?? 0)}",
            width: 3,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
        ],
      );
    printer.emptyLines(10);

    if (data.totalInWords != null)
      printer.printTextLn(
        "Bằng chữ:",
        style: style.copyWith(
          bold: false,
        ),
      );
    if (data.totalInWords != null)
      printer.printTextLn(
        data.totalInWords,
        style: style.copyWith(
          bold: true,
        ),
      );
    printer.emptyLines(10);
    if (data.previousBalance != null)
      printer.printRow(
        [
          CanvasColumn(
            text: " ",
            width: 3,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
          CanvasColumn(
            text: "Nợ cũ:",
            width: 6,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
          CanvasColumn(
            text: "${vietnameseCurrencyFormat(data.previousBalance ?? 0)}",
            width: 3,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
        ],
      );
    printer.emptyLines(10);
    if (data.payment != null)
      printer.printRow(
        [
          CanvasColumn(
            text: " ",
            width: 3,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
          CanvasColumn(
            text: "Thanh toán:",
            width: 6,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
          CanvasColumn(
            text: "${vietnameseCurrencyFormat(data.payment)}",
            width: 3,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
        ],
      );

    printer.emptyLines(10);
    if (data.totalDeb != null)
      printer.printRow(
        [
          CanvasColumn(
            text: " ",
            width: 3,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
          CanvasColumn(
            text: "TỔNG NỢ:",
            width: 6,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
          CanvasColumn(
            text: "${vietnameseCurrencyFormat(data.totalDeb ?? 0)}",
            width: 3,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
        ],
      );
    if (data.shipNote != null) {
      printer.printTextSpans(
        textSpans: [
          CanvasTextSpan(
            "Ghi chú GH: ",
            style: style.copyWith(bold: true),
          ),
          CanvasTextSpan(
            "${data.shipNote}",
            style: style.copyWith(),
          ),
        ],
      );
    }

    printer.emptyLines(10);
    if (data.invoiceNote != null) {
      printer.printTextSpans(
        textSpans: [
          CanvasTextSpan(
            "Ghi chú: ",
            style: style.copyWith(bold: true),
          ),
          CanvasTextSpan(
            "${data.invoiceNote}",
            style: style.copyWith(),
          ),
        ],
      );
    }

    if (data.revenue != null) {
      printer.printTextSpans(
        textSpans: [
          CanvasTextSpan(
            "Doanh số: ",
            style: style.copyWith(bold: true, fontSize: 40),
          ),
          CanvasTextSpan(
            "${vietnameseCurrencyFormat(data.revenue ?? 0)}",
            style: style.copyWith(fontSize: 40),
          ),
        ],
      );
    }

    if (!data.hideDelivery) {
//      printer.printTextLn(
//        "YÊU CẦU",
//        style: CanvasStyles(
//          fontSize: 50,
//          bold: true,
//          align: TextAlign.center,
//        ),
//      );
//      printer.emptyLines(20);
      printer.printDividerDash();
      printer.emptyLines(10);
      printer.printTextLn(
        "GIAO HÀNG",
        style: style.copyWith(
          fontSize: 50,
          bold: true,
          align: TextAlign.center,
        ),
      );
      printer.emptyLines(20);
      if (data.receiverName != null) {
        printer.printTextSpans(
          textSpans: [
            CanvasTextSpan(
              "Người nhận: ",
              style: style.copyWith(bold: true, fontSize: headerFontSize),
            ),
            CanvasTextSpan(
              "${data.receiverName}",
              style: style.copyWith(fontSize: headerFontSize),
            ),
          ],
        );
      }
      if (data.receiverPhone != null) {
        printer.printTextSpans(
          textSpans: [
            CanvasTextSpan(
              "Điện thoại: ",
              style: style.copyWith(bold: true, fontSize: headerFontSize),
            ),
            CanvasTextSpan(
              "${data.receiverPhone}",
              style: style.copyWith(fontSize: headerFontSize),
            ),
          ],
        );
      }
      if (data.receiverAddress != null) {
        printer.printTextSpans(
          textSpans: [
            CanvasTextSpan(
              "Địa chỉ GH: ",
              style: style.copyWith(bold: true, fontSize: headerFontSize),
            ),
            CanvasTextSpan(
              "${data.receiverAddress}",
              style: style.copyWith(fontSize: headerFontSize),
            ),
          ],
        );
      }
    }

    if (data.defaultNote != null) {
      printer.emptyLines(10);
      printer.printTextSpans(
        textSpans: [
          CanvasTextSpan(
            "Lưu ý: ",
            style: style.copyWith(bold: true),
          ),
          CanvasTextSpan(
            "${data.defaultNote}",
            style: style.copyWith(),
          ),
        ],
      );
    }

    if (data.changeTrackingRefAndTrackingRefSort) {
      if (data.shipCode != null) {
        printer.printBarCode("${data.shipCode}",
            height: 60, lineWidth: 2.8, hasText: false);
        printer.printTextLn(
          "${data.shipCode}",
          style: style.copyWith(
            bold: true,
            align: TextAlign.center,
          ),
        );
      }
    } else {
      if (data.trackingRefSort.isNotNullOrEmpty()) {
        if (data.qrCodeTrackingRefSort == null)
          printer.printBarCode(
            "${data.trackingRefSort}",
            height: 60,
            lineWidth: 2,
            hasText: false,
          );
        else {
          printer.printQrcode(data.trackingRefSort, 180);
        }
        printer.printTextLn(
          "${data.trackingRefSort}",
          style: style.copyWith(
            bold: true,
            align: TextAlign.center,
          ),
        );
      }
    }
    printer.emptyLines(10);
    printer.printDividerDash();
    if (data.hideSign != null)
      printer.printRow(
        [
          CanvasColumn(
            text: "NGƯỜI GIAO",
            width: 6,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.start,
            ),
          ),
          CanvasColumn(
            text: "NGƯỜI NHẬN",
            width: 6,
            styles: style.copyWith(
              bold: true,
              align: TextAlign.end,
            ),
          ),
        ],
      );
    printer.emptyLines(70);
  }
}
