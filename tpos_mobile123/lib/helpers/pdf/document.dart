//import 'dart:async';
//import 'dart:typed_data';
//import 'package:flutter/services.dart';
//import 'package:intl/intl.dart';
//import 'package:pdf/pdf.dart';
//import 'package:pdf/widgets.dart';
//import 'package:flutter/widgets.dart' as fw;
//import 'package:printing/printing.dart';
//import 'package:tpos_mobile/helpers/helpers.dart';
//import 'package:tpos_mobile/sale_online/viewmodels/fast_sale_order_pdf_viewmodel.dart';
//
//class MyPage extends Page {
//  MyPage(
//      {PdfPageFormat pageFormat = PdfPageFormat.a4,
//      BuildCallback build,
//      EdgeInsets margin})
//      : super(pageFormat: pageFormat, margin: margin, build: build);
//}
//
//Future<Document> generateDocumentA4(PdfPageFormat format) async {
//  String trackingRefUrl, trackingRefSortUrl;
//  FastSaleOrderPDFViewModel viewModel = new FastSaleOrderPDFViewModel();
//  var data = await viewModel.refreshFastSaleOrderInfo(40419);
//  if (data.trackingRef != null)
//    trackingRefUrl = await viewModel.getBarcodeTrackingRef();
//  if (data.trackingRefSort != null)
//    trackingRefSortUrl = await viewModel.getBarcodeTrackingRefSort();
//
//  final PdfDoc pdf = PdfDoc();
//  final PdfImage barcodeImageTrackingRef = await pdfImageFromImageProvider(
//      pdf: pdf.document,
//      image: fw.NetworkImage(trackingRefUrl ?? ""),
//      onError: (dynamic exception, StackTrace stackTrace) {
//        print('Unable to download image');
//      });
//
//  final ByteData fontNormal = await rootBundle.load('fonts/arial.ttf');
//  final ByteData fontBold = await rootBundle.load("fonts/arialbd.ttf");
//  final ByteData fontItalic = await rootBundle.load("fonts/ariali.ttf");
//  final ByteData fontBoldItalic = await rootBundle.load("fonts/arialbi.ttf");
//
//  final Font ttfNormal = Font.ttf(fontNormal);
//  final Font ttfBold = Font.ttf(fontBold);
//  final Font ttfItalic = Font.ttf(fontItalic);
//  final Font ttfBoldItalic = Font.ttf(fontBoldItalic);
//
//  TextStyle _normalStyle = TextStyle(
//      font: ttfNormal,
//      fontBold: ttfBold,
//      fontItalic: ttfItalic,
//      fontBoldItalic: ttfBoldItalic,
//      fontSize: 11);
//
//  pdf.addPage(MultiPage(
//      pageFormat: PdfPageFormat.a4.copyWith(
//          marginBottom: PdfPageFormat.cm,
//          marginTop: PdfPageFormat.cm,
//          marginRight: PdfPageFormat.cm,
//          marginLeft: PdfPageFormat.cm),
//      orientation: PageOrientation.natural,
//      crossAxisAlignment: CrossAxisAlignment.start,
//      build: (Context context) => <Widget>[
//            Column(
//              children: [
//                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                  Expanded(
//                    child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          Text('TMT25',
//                              style: _normalStyle.copyWith(
//                                  fontWeight: FontWeight.bold)),
//                          Padding(padding: const EdgeInsets.only(top: 5)),
//                          Row(children: <Widget>[
//                            Text(
//                              'Địa chỉ: ',
//                              style: _normalStyle.copyWith(
//                                  fontWeight: FontWeight.bold),
//                            ),
//                            Text(
//                                '54/35 Diệp Minh Châu, Tân Sơn Nhì, Tân Phú, HCM',
//                                style: _normalStyle),
//                          ]),
//                          Padding(padding: const EdgeInsets.only(top: 5)),
//                          Row(children: <Widget>[
//                            Text(
//                              'Điện thoại: ',
//                              style: _normalStyle.copyWith(
//                                  fontWeight: FontWeight.bold),
//                            ),
//                            Text('0972584133', style: _normalStyle),
//                          ]),
//                          Padding(padding: const EdgeInsets.only(top: 5)),
//                          Row(children: <Widget>[
//                            Text(
//                              'Email: ',
//                              style: _normalStyle.copyWith(
//                                  fontWeight: FontWeight.bold),
//                            ),
//                            Text('testdfmail.com', style: _normalStyle),
//                          ]),
//                        ]),
//                  ),
//                  if (barcodeImageTrackingRef != null)
//                    Column(children: [
//                      Text("${data.carrierName}"),
//                      Padding(padding: const EdgeInsets.only(bottom: 2)),
//                      Container(
//                        height: 30,
//                        width: 120,
//                        child:
//                            Image(barcodeImageTrackingRef, fit: BoxFit.cover),
//                      ),
//                      Padding(padding: const EdgeInsets.only(bottom: 5)),
//                      Text(
//                        "${data.carrierId == 1 ? data.trackingRef.substring(8) : data.trackingRef}",
//                        style:
//                            _normalStyle.copyWith(fontWeight: FontWeight.bold),
//                      ),
//                    ]),
//                ]),
//                Column(children: <Widget>[
//                  Text(
//                    "PHIẾU BÁN HÀNG",
//                    style: _normalStyle.copyWith(
//                        fontWeight: FontWeight.bold, fontSize: 20),
//                  ),
//                  Padding(padding: const EdgeInsets.only(top: 5)),
//                  Row(mainAxisAlignment: MainAxisAlignment.center, children: <
//                      Widget>[
//                    Text(
//                      "Số phiếu: ",
//                      style: _normalStyle.copyWith(fontWeight: FontWeight.bold),
//                    ),
//                    Text("${data.number}", style: _normalStyle),
//                    Text(
//                      " - Ngày: ",
//                      style: _normalStyle.copyWith(fontWeight: FontWeight.bold),
//                    ),
//                    Text(
//                        "${DateFormat("dd/MM/yyyy HH:mm", "en_US").format(data.dateInvoice ?? DateTime.now())}",
//                        style: _normalStyle),
//                  ]),
//                ]),
//                Padding(padding: const EdgeInsets.only(top: 10)),
//                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
//                    Widget>[
//                  Row(children: <Widget>[
//                    Text(
//                      'Khách hàng: ',
//                      style: _normalStyle.copyWith(fontWeight: FontWeight.bold),
//                    ),
//                    Text('${data.partnerDisplayName}', style: _normalStyle),
//                  ]),
//                  Padding(padding: const EdgeInsets.only(top: 5)),
//                  Row(children: <Widget>[
//                    Text(
//                      'Địa chỉ: ',
//                      style: _normalStyle.copyWith(fontWeight: FontWeight.bold),
//                    ),
//                    Text('${data.receiverAddress}', style: _normalStyle),
//                  ]),
//                  Padding(padding: const EdgeInsets.only(top: 5)),
//                  Row(children: <Widget>[
//                    Expanded(
//                      child: Row(children: <Widget>[
//                        Text(
//                          'Điện thoại: ',
//                          style: _normalStyle.copyWith(
//                              fontWeight: FontWeight.bold),
//                        ),
//                        Text('${data.partnerPhone}', style: _normalStyle),
//                      ]),
//                    ),
//                    Expanded(
//                        child: Row(children: <Widget>[
//                      Text(
//                        'Nhân viên: ',
//                        style:
//                            _normalStyle.copyWith(fontWeight: FontWeight.bold),
//                      ),
//                      Text('${data.userName}', style: _normalStyle),
//                    ])),
//                  ]),
//                ]),
//                Padding(padding: const EdgeInsets.only(top: 10)),
//              ],
//            ),
//            Table(
//                border: TableBorder(width: 0.5),
//                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                tableWidth: TableWidth.max,
//                children: [
//                  TableRow(children: [
//                    Container(
//                      padding:
//                          EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
//                      width: 28,
//                      child: Text("STT",
//                          style: _normalStyle.copyWith(
//                              fontWeight: FontWeight.bold),
//                          textAlign: TextAlign.center),
//                    ),
//                    Container(
//                      padding:
//                          EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
//                      width: 90,
//                      child: Text("Mã vạch",
//                          style: _normalStyle.copyWith(
//                              fontWeight: FontWeight.bold),
//                          textAlign: TextAlign.center),
//                    ),
//                    Container(
//                      padding: const EdgeInsets.only(
//                          left: 2, right: 2, top: 5, bottom: 5),
//                      child: Text("Sản phẩm",
//                          style: _normalStyle.copyWith(
//                              fontWeight: FontWeight.bold),
//                          textAlign: TextAlign.center),
//                    ),
//                    Container(
//                      padding:
//                          EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
//                      width: 45,
//                      child: Text("ĐVT",
//                          style: _normalStyle.copyWith(
//                              fontWeight: FontWeight.bold),
//                          textAlign: TextAlign.center),
//                    ),
//                    Container(
//                      padding:
//                          EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
//                      width: 45,
//                      child: Text("SL",
//                          style: _normalStyle.copyWith(
//                              fontWeight: FontWeight.bold),
//                          textAlign: TextAlign.center),
//                    ),
//                    Container(
//                      padding:
//                          EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
//                      width: 80,
//                      child: Text("Giá",
//                          style: _normalStyle.copyWith(
//                              fontWeight: FontWeight.bold),
//                          textAlign: TextAlign.center),
//                    ),
//                    Container(
//                      padding:
//                          EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
//                      width: 70,
//                      child: Text("CK",
//                          style: _normalStyle.copyWith(
//                              fontWeight: FontWeight.bold),
//                          textAlign: TextAlign.center),
//                    ),
//                    Container(
//                      padding:
//                          EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
//                      width: 80,
//                      child: Text("Thành tiền",
//                          style: _normalStyle.copyWith(
//                              fontWeight: FontWeight.bold),
//                          textAlign: TextAlign.center),
//                    ),
//                  ]),
//                  for (int i = 0; i < data.orderLines.length; i++)
//                    TableRow(children: [
//                      Container(
//                        padding: EdgeInsets.only(
//                            top: 5, bottom: 5, left: 5, right: 5),
//                        width: 28,
//                        child: Text("${i + 1}",
//                            style: _normalStyle.copyWith(),
//                            textAlign: TextAlign.center),
//                      ),
//                      Container(
//                        padding: EdgeInsets.only(
//                            top: 5, bottom: 5, left: 2, right: 2),
//                        width: 90,
//                        child: Text("${data.orderLines[i].productBarcode}",
//                            style: _normalStyle.copyWith(),
//                            textAlign: TextAlign.left),
//                      ),
//                      Container(
//                        padding: const EdgeInsets.only(
//                            left: 2, right: 2, top: 5, bottom: 5),
//                        child: Text("${data.orderLines[i].productNameGet}",
//                            style: _normalStyle.copyWith(),
//                            textAlign: TextAlign.left),
//                      ),
//                      Container(
//                        padding: EdgeInsets.only(
//                            top: 5, bottom: 5, left: 2, right: 2),
//                        width: 45,
//                        child: Text("${data.orderLines[i].productUomName}",
//                            style: _normalStyle.copyWith(),
//                            textAlign: TextAlign.center),
//                      ),
//                      Container(
//                        padding: EdgeInsets.only(
//                            top: 5, bottom: 5, left: 2, right: 2),
//                        width: 45,
//                        child: Text(
//                            "${vietnameseCurrencyFormat(data.orderLines[i].productUOMQty)}",
//                            style: _normalStyle.copyWith(),
//                            textAlign: TextAlign.right),
//                      ),
//                      Container(
//                        padding: EdgeInsets.only(
//                            top: 5, bottom: 5, left: 2, right: 2),
//                        width: 80,
//                        child: Text(
//                            "${vietnameseCurrencyFormat(data.orderLines[i].priceUnit)}",
//                            style: _normalStyle.copyWith(),
//                            textAlign: TextAlign.right),
//                      ),
//                      Container(
//                        padding: EdgeInsets.only(
//                            top: 5, bottom: 5, left: 2, right: 2),
//                        width: 70,
//                        child: Text("${data.orderLines[i].discount}",
//                            style: _normalStyle.copyWith(),
//                            textAlign: TextAlign.right),
//                      ),
//                      Container(
//                        padding: EdgeInsets.only(
//                            top: 5, bottom: 5, left: 2, right: 2),
//                        width: 80,
//                        child: Text(
//                            "${vietnameseCurrencyFormat(data.orderLines[i].priceUnit * data.orderLines[i].productUOMQty)}",
//                            style: _normalStyle.copyWith(),
//                            textAlign: TextAlign.right),
//                      ),
//                    ]),
//                ]),
//            Table(
//                border: TableBorder(
//                  top: false,
//                  width: 0.5,
//                  horizontalInside: false,
//                  verticalInside: false,
//                ),
//                children: [
//                  TableRow(children: [
//                    Container(
//                      padding:
//                          EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
//                      width: 28,
//                    ),
//                    Container(
//                      padding:
//                          EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
//                      width: 90,
//                    ),
//                    Container(
//                      padding: const EdgeInsets.only(
//                          left: 2, right: 2, top: 5, bottom: 5),
//                      child: Text("",
//                          style: _normalStyle.copyWith(
//                              fontWeight: FontWeight.bold),
//                          textAlign: TextAlign.center),
//                    ),
//                    Container(
//                      padding:
//                          EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
//                      width: 45,
//                      child: Text("Tổng:",
//                          style: _normalStyle.copyWith(
//                              fontWeight: FontWeight.bold),
//                          textAlign: TextAlign.center),
//                    ),
//                    Container(
//                      padding:
//                          EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
//                      width: 45,
//                      child: Text("${viewModel.totalQuantity}",
//                          style: _normalStyle.copyWith(
//                              fontWeight: FontWeight.bold),
//                          textAlign: TextAlign.right),
//                    ),
//                    Container(
//                      padding:
//                          EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
//                      width: 80,
//                    ),
//                    Container(
//                      padding:
//                          EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
//                      width: 70,
//                    ),
//                    Container(
//                      padding:
//                          EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
//                      width: 80,
//                      child: Text(
//                          "${vietnameseCurrencyFormat(data.amountUntaxed)}",
//                          style: _normalStyle.copyWith(
//                              fontWeight: FontWeight.bold),
//                          textAlign: TextAlign.right),
//                    ),
//                  ]),
//                ]),
//            Padding(
//              padding: const EdgeInsets.only(bottom: 50, top: 5),
//              child: Column(
//                children: [
//                  Row(children: <Widget>[
//                    Text(
//                      'Số tiền bằng chữ: ',
//                      style: _normalStyle.copyWith(fontWeight: FontWeight.bold),
//                    ),
//                    Text('Một triệu hai trăm sáu mươi lăm nghìn đồng',
//                        style: _normalStyle),
//                  ]),
//                  Row(children: <Widget>[
//                    Text(
//                      'Ghi chú GH: ',
//                      style: _normalStyle.copyWith(fontWeight: FontWeight.bold),
//                    ),
//                    Text('${data.deliveryNote ?? ''}', style: _normalStyle),
//                  ]),
//                  Padding(padding: const EdgeInsets.only(top: 5)),
//                  Row(children: <Widget>[
//                    Text(
//                      "THÔNG TIN NGƯỜI NHẬN",
//                      style: _normalStyle.copyWith(fontSize: 16),
//                    ),
//                  ]),
//                  Padding(padding: const EdgeInsets.only(top: 10)),
//                  Table(
//                      border: TableBorder(
//                        right: false,
//                        left: false,
//                        bottom: false,
//                        width: 0.5,
//                        verticalInside: false,
//                        horizontalInside: false,
//                      ),
//                      defaultVerticalAlignment:
//                          TableCellVerticalAlignment.middle,
//                      tableWidth: TableWidth.max,
//                      children: [
//                        TableRow(children: [
//                          Container(
//                              padding:
//                                  EdgeInsets.only(top: 5, bottom: 5, right: 5),
//                              width: 330,
//                              child: Row(children: [
//                                Text('Người nhận: ',
//                                    style: _normalStyle.copyWith(
//                                        fontWeight: FontWeight.bold),
//                                    textAlign: TextAlign.left),
//                                Expanded(
//                                  child: Text('${data.receiverName ?? ''}',
//                                      style: _normalStyle,
//                                      textAlign: TextAlign.left),
//                                ),
//                              ])),
//                          Container(
//                              width: 262,
//                              padding: const EdgeInsets.only(
//                                  left: 2, right: 2, top: 5, bottom: 5),
//                              child: Row(children: [
//                                Text('Điện thoại: ',
//                                    style: _normalStyle.copyWith(
//                                        fontWeight: FontWeight.bold),
//                                    textAlign: TextAlign.left),
//                                Expanded(
//                                  child: Text('${data.receiverPhone ?? ''}',
//                                      style: _normalStyle,
//                                      textAlign: TextAlign.left),
//                                ),
//                              ])),
//                        ]),
//                        TableRow(children: [
//                          Container(
//                              padding:
//                                  EdgeInsets.only(top: 5, bottom: 5, right: 5),
//                              width: 330,
//                              child: Row(children: [
//                                Text('Địa chỉ: ',
//                                    style: _normalStyle.copyWith(
//                                        fontWeight: FontWeight.bold),
//                                    textAlign: TextAlign.left),
//                                Expanded(
//                                  child: Text('${data.receiverAddress ?? ''}',
//                                      style: _normalStyle,
//                                      textAlign: TextAlign.left),
//                                ),
//                              ])),
//                          Container(
//                            width: 262,
//                            padding: const EdgeInsets.only(
//                                left: 2, right: 2, top: 5, bottom: 5),
//                            child: Row(children: [
//                              Text("Thông tin khác: ",
//                                  style: _normalStyle.copyWith(
//                                      fontWeight: FontWeight.bold),
//                                  textAlign: TextAlign.left),
//                              Expanded(
//                                child: Text('${data.receiverNote ?? ''}',
//                                    style: _normalStyle,
//                                    textAlign: TextAlign.left),
//                              ),
//                            ]),
//                          ),
//                        ]),
//                      ]),
//                  Table(
//                      border: TableBorder(
//                        right: false,
//                        left: false,
//                        bottom: false,
//                        top: false,
//                        width: 0.5,
//                        verticalInside: false,
//                        horizontalInside: false,
//                      ),
//                      defaultVerticalAlignment:
//                          TableCellVerticalAlignment.middle,
//                      tableWidth: TableWidth.max,
//                      children: [
//                        TableRow(children: [
//                          Container(
//                            padding: EdgeInsets.only(
//                                top: 5, bottom: 5, left: 5, right: 5),
//                            width: 148,
//                            child: Text('NGƯỜI MUA',
//                                style: _normalStyle.copyWith(
//                                    fontWeight: FontWeight.bold),
//                                textAlign: TextAlign.center),
//                          ),
//                          Container(
//                            padding: EdgeInsets.only(
//                                top: 5, bottom: 5, left: 2, right: 2),
//                            width: 148,
//                            child: Text('NGƯỜI BÁN',
//                                style: _normalStyle.copyWith(
//                                    fontWeight: FontWeight.bold),
//                                textAlign: TextAlign.center),
//                          ),
//                          Container(
//                            width: 148,
//                            padding: const EdgeInsets.only(
//                                left: 2, right: 2, top: 5, bottom: 5),
//                            child: Text('TRỢ LÝ',
//                                style: _normalStyle.copyWith(
//                                    fontWeight: FontWeight.bold),
//                                textAlign: TextAlign.center),
//                          ),
//                          Container(
//                            padding: EdgeInsets.only(
//                                top: 5, bottom: 5, left: 2, right: 2),
//                            width: 148,
//                            child: Text('GIÁM ĐỐC',
//                                style: _normalStyle.copyWith(
//                                    fontWeight: FontWeight.bold),
//                                textAlign: TextAlign.center),
//                          ),
//                        ]),
//                        TableRow(children: [
//                          Container(
//                            padding: EdgeInsets.only(
//                                top: 5, bottom: 5, left: 5, right: 5),
//                            width: 148,
//                            child: Text('(Ký, Họ tên)',
//                                style: _normalStyle.copyWith(
//                                    fontStyle: FontStyle.italic),
//                                textAlign: TextAlign.center),
//                          ),
//                          Container(
//                            padding: EdgeInsets.only(
//                                top: 5, bottom: 5, left: 2, right: 2),
//                            width: 148,
//                            child: Text('(Ký, Họ tên)',
//                                style: _normalStyle.copyWith(
//                                    fontStyle: FontStyle.italic),
//                                textAlign: TextAlign.center),
//                          ),
//                          Container(
//                            width: 148,
//                            padding: const EdgeInsets.only(
//                                left: 2, right: 2, top: 5, bottom: 5),
//                            child: Text('(Ký, Họ tên)',
//                                style: _normalStyle.copyWith(
//                                    fontStyle: FontStyle.italic),
//                                textAlign: TextAlign.center),
//                          ),
//                          Container(
//                            padding: EdgeInsets.only(
//                                top: 5, bottom: 5, left: 2, right: 2),
//                            width: 148,
//                            child: Text('(Ký, Họ tên)',
//                                style: _normalStyle.copyWith(
//                                    fontStyle: FontStyle.italic),
//                                textAlign: TextAlign.center),
//                          ),
//                        ]),
//                      ]),
//                ],
//              ),
//            ),
//          ]));
//  return pdf;
//}
//
//Future<Document> generateDocumentA5(PdfPageFormat format) async {
//  FastSaleOrderPDFViewModel viewModel = new FastSaleOrderPDFViewModel();
//  String trackingRefUrl, trackingRefSortUrl;
//  var data = await viewModel.refreshFastSaleOrderInfo(40418);
//  if (data.trackingRef != null)
//    trackingRefUrl = await viewModel.getBarcodeTrackingRef();
//  if (data.trackingRefSort != null)
//    trackingRefSortUrl = await viewModel.getBarcodeTrackingRefSort();
//
//  final PdfDoc pdf = PdfDoc();
//  final PdfImage barcodeImageTrackingRef = await pdfImageFromImageProvider(
//      pdf: pdf.document,
//      image: fw.NetworkImage(trackingRefUrl ?? ""),
//      onError: (dynamic exception, StackTrace stackTrace) {
//        print('Unable to download image');
//      });
//
//  final PdfImage barcodeImageTrackingRefSort = await pdfImageFromImageProvider(
//      pdf: pdf.document,
//      image: fw.NetworkImage(trackingRefSortUrl ?? ""),
//      onError: (dynamic exception, StackTrace stackTrace) {
//        print('Unable to download image');
//      });
//
//  final ByteData fontNormal = await rootBundle.load('fonts/arial.ttf');
//  final ByteData fontBold = await rootBundle.load("fonts/arialbd.ttf");
//  final ByteData fontItalic = await rootBundle.load("fonts/ariali.ttf");
//  final ByteData fontBoldItalic = await rootBundle.load("fonts/arialbi.ttf");
//
//  final Font ttfNormal = Font.ttf(fontNormal);
//  final Font ttfBold = Font.ttf(fontBold);
//  final Font ttfItalic = Font.ttf(fontItalic);
//  final Font ttfBoldItalic = Font.ttf(fontBoldItalic);
//
//  TextStyle _normalStyle = TextStyle(
//      font: ttfNormal,
//      fontBold: ttfBold,
//      fontItalic: ttfItalic,
//      fontBoldItalic: ttfBoldItalic,
//      fontSize: 11);
//
//  pdf.addPage(MultiPage(
//      pageFormat: PdfPageFormat.a5.copyWith(
//          marginTop: 20, marginLeft: 20, marginRight: 20, marginBottom: 20),
//      orientation: PageOrientation.natural,
//      crossAxisAlignment: CrossAxisAlignment.start,
//      build: (Context context) => <Widget>[
//            Column(
//              children: [
//                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                  Expanded(
//                    child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          Text('TMT25',
//                              style: _normalStyle.copyWith(
//                                  fontWeight: FontWeight.bold, fontSize: 16)),
//                          Padding(padding: const EdgeInsets.only(top: 5)),
//                          Text(
//                            'Thông tin in thêm trên phiếu ship',
//                            style: _normalStyle.copyWith(
//                                fontWeight: FontWeight.bold),
//                          ),
//                          Padding(padding: const EdgeInsets.only(top: 5)),
//                          Text(
//                            'SĐT: 0972584133',
//                            style: _normalStyle.copyWith(
//                                fontWeight: FontWeight.bold),
//                          ),
//                          Padding(padding: const EdgeInsets.only(top: 5)),
//                          Text(
//                            'Đc: 54/35 dmc tan son nhi tan phu hcm',
//                            style: _normalStyle.copyWith(
//                                fontWeight: FontWeight.bold),
//                          ),
//                          Padding(padding: const EdgeInsets.only(top: 5)),
//                          Text(
//                            'COSMETICS',
//                            style: _normalStyle.copyWith(
//                                fontWeight: FontWeight.bold),
//                          ),
//                          Padding(padding: const EdgeInsets.only(top: 5)),
//                          Text(
//                            'In bởi TMT',
//                            style: _normalStyle.copyWith(
//                                fontWeight: FontWeight.bold),
//                          ),
//                        ]),
//                  ),
//                  if (barcodeImageTrackingRef != null)
//                    Column(children: [
//                      Text("${data.carrierName}"),
//                      Padding(padding: const EdgeInsets.only(bottom: 2)),
//                      Container(
//                        height: 30,
//                        width: 120,
//                        child:
//                            Image(barcodeImageTrackingRef, fit: BoxFit.cover),
//                      ),
//                      Padding(padding: const EdgeInsets.only(bottom: 5)),
//                      Text(
//                          "${data.carrierId == 1 ? data.trackingRef.substring(8) : data.trackingRef}",
//                          style: _normalStyle.copyWith(
//                              fontWeight: FontWeight.bold)),
//                    ]),
//                ]),
//                Padding(padding: const EdgeInsets.only(top: 50)),
//                Row(children: <Widget>[
//                  if (barcodeImageTrackingRefSort != null)
//                    Column(children: [
//                      Container(
//                        height: 30,
//                        width: 120,
//                        child: Image(barcodeImageTrackingRefSort),
//                      ),
//                      Padding(padding: const EdgeInsets.only(bottom: 5)),
//                      Text(
//                        "${data.trackingRefSort}",
//                        style:
//                            _normalStyle.copyWith(fontWeight: FontWeight.bold),
//                      ),
//                    ]),
//                  Expanded(
//                    child: Column(children: [
//                      Text(
//                          "Thu hộ (COD): ${vietnameseCurrencyFormat(data.cashOnDelivery)} VND",
//                          style: _normalStyle.copyWith(
//                              fontWeight: FontWeight.bold, fontSize: 16),
//                          textAlign: TextAlign.center),
//                      Padding(padding: const EdgeInsets.only(top: 2)),
//                      Text(
//                          "(Tiền hàng: ${vietnameseCurrencyFormat(data.amountUntaxed)} + Tiền ship: ${vietnameseCurrencyFormat(data.deliveryPrice)})",
//                          style: _normalStyle.copyWith(
//                              fontWeight: FontWeight.bold),
//                          textAlign: TextAlign.center),
//                      Padding(padding: const EdgeInsets.only(top: 2)),
//                      Text(
//                          "HĐ: ${data.number} Ngày: ${DateFormat("dd/MM/yyyy", "en_US").format(data.dateInvoice ?? DateTime.now())}",
//                          style: _normalStyle.copyWith(
//                              fontWeight: FontWeight.bold),
//                          textAlign: TextAlign.center),
//                    ]),
//                  ),
//                ]),
//                Padding(padding: const EdgeInsets.only(top: 10)),
//                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
//                    Widget>[
//                  Row(children: [
//                    Container(
//                      width: 80,
//                      child: Text(
//                        'Người nhận: ',
//                        style:
//                            _normalStyle.copyWith(fontWeight: FontWeight.bold),
//                      ),
//                    ),
//                    Expanded(
//                      child: Text(
//                        '${data.receiverName}',
//                        style:
//                            _normalStyle.copyWith(fontWeight: FontWeight.bold),
//                      ),
//                    ),
//                  ]),
//                  Padding(padding: const EdgeInsets.only(bottom: 5)),
//                  Row(children: [
//                    Container(
//                      width: 80,
//                      child: Text(
//                        'SĐT: ',
//                        style:
//                            _normalStyle.copyWith(fontWeight: FontWeight.bold),
//                      ),
//                    ),
//                    Expanded(
//                      child: Text(
//                        '${data.receiverPhone}',
//                        style:
//                            _normalStyle.copyWith(fontWeight: FontWeight.bold),
//                      ),
//                    ),
//                  ]),
//                  Padding(padding: const EdgeInsets.only(bottom: 5)),
//                  Row(children: [
//                    Container(
//                      width: 80,
//                      child: Text(
//                        'Địa chỉ: ',
//                        style:
//                            _normalStyle.copyWith(fontWeight: FontWeight.bold),
//                      ),
//                    ),
//                    Expanded(
//                      child: Text(
//                        '${data.receiverAddress}',
//                        style:
//                            _normalStyle.copyWith(fontWeight: FontWeight.bold),
//                      ),
//                    ),
//                  ]),
//                  Padding(padding: const EdgeInsets.only(bottom: 5)),
//                  Row(children: [
//                    Container(
//                      width: 80,
//                      child: Text(
//                        'Ghi chú GH: ',
//                        style:
//                            _normalStyle.copyWith(fontWeight: FontWeight.bold),
//                      ),
//                    ),
//                    Expanded(
//                      child: Text('${data.deliveryNote}', style: _normalStyle),
//                    ),
//                  ]),
//                  Padding(padding: const EdgeInsets.only(bottom: 5)),
//                  Row(children: [
//                    Container(
//                      width: 80,
//                      child: Text(
//                        'Lưu ý: ',
//                        style:
//                            _normalStyle.copyWith(fontWeight: FontWeight.bold),
//                      ),
//                    ),
//                    Expanded(
//                      child: Text(
//                          '${data.receiverNote ?? 'shop cảm ơn quý khách'}',
//                          style: _normalStyle),
//                    ),
//                  ]),
//                ]),
//              ],
//            ),
//          ]));
//  return pdf;
//}
