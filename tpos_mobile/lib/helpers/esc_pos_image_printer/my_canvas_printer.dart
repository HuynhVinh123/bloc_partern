import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:image/image.dart' as IMG;
import 'package:qr_flutter/qr_flutter.dart';

import 'barcode_128.dart';

class CanvasPrinter {
  List<CanvasItem> _listCanvasItem;
  double _kCanvasSizeWidth = 570.0;
  double _paperWidth = 570.0;
  get paperWidth => _paperWidth;
  double _kCanvasSizeHeight;
  Canvas _canvas;
  bool _hasBorder = false;
  CanvasHeader _canvasHeader;
  String fontFamily;

  void setFontFamily(String font) {
    this.fontFamily = font;
  }

  void setUpCanvasHeader({CanvasHeader canvasHeader}) {
    _canvasHeader = canvasHeader;
  }

  CanvasPrinter() {
    _listCanvasItem = new List<CanvasItem>();
  }

  Future<ByteData> generateImage() async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    _canvas = Canvas(
      recorder,
      Rect.fromPoints(Offset(0.0, 0.0), Offset(_paperWidth, getHeight())),
    );
    double heightCanvas = 0;
    double widthCanvas = 0;
    double rowHeight = 0;

    if (_canvasHeader != null) {
      int height = _canvasHeader.headerImage.height;
      int width = _canvasHeader.headerImage.width;
      ui.Paragraph paragraph = createParagraph("${_canvasHeader.title.title}",
              style: CanvasStyles(
                fontSize: _canvasHeader.title.fontSize,
                //align: TextAlign.center,
              ),
              hasBorder: false)
          .paragraph;
      _canvas.drawParagraph(paragraph, Offset(50 + width.toDouble(), 5));
      String url =
          "https://images.weserv.nl/?url=${_canvasHeader.headerImage.url}&w=$width&h=$height&t=fit";
      var codec = await ui.instantiateImageCodec(await networkImageToByte(url));
      var frame = await codec.getNextFrame();
      ui.Image image = frame.image;
      _canvas.drawImage(image, Offset(40, 7), Paint());

      heightCanvas = heightCanvas + height;
    }

    if (_hasBorder) {
      Paint paint = new Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      Rect rect = new Rect.fromLTWH(0.5, 0.5, _kCanvasSizeWidth,
          _kCanvasSizeHeight != null ? _kCanvasSizeHeight - 1.5 : heightCanvas);
      _canvas.drawRect(rect, paint);

      widthCanvas = widthCanvas + 10;
    }
    for (CanvasItem canvasItem in _listCanvasItem) {
      if (canvasItem.hasBorder) {
        Paint paint = new Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        Rect rect = new Rect.fromLTWH(
          0,
          heightCanvas,
          _kCanvasSizeWidth,
          canvasItem.height,
        );
        _canvas.drawRect(rect, paint);
      }
      if (canvasItem.type == "paragraph") {
        //print("đang test $widthCanvas == $_kCanvasSizeWidth");
        if (canvasItem.paragraph.width != _kCanvasSizeWidth) {
          //print(canvasItem.paragraph.width);
          rowHeight = rowHeight > canvasItem.paragraph.height
              ? rowHeight
              : canvasItem.paragraph.height;
          _canvas.drawParagraph(
              canvasItem.paragraph, Offset(widthCanvas, heightCanvas));
          widthCanvas = widthCanvas + canvasItem.paragraph.width;

          if (widthCanvas > _kCanvasSizeWidth - 10) {
            widthCanvas = 0;
            heightCanvas = heightCanvas + rowHeight;
            rowHeight = 0;
          }
        } else {
          _canvas.drawParagraph(
              canvasItem.paragraph, Offset(widthCanvas, heightCanvas));
          heightCanvas = heightCanvas + canvasItem.paragraph.height;
        }
      } else if (canvasItem.type == "divider") {
        final paint = Paint()
          ..color = Colors.black
          ..strokeWidth = canvasItem.height;
        _canvas.drawLine(
            Offset(0, heightCanvas + (canvasItem.height / 2) + rowHeight),
            Offset(_kCanvasSizeWidth,
                heightCanvas + (canvasItem.height / 2) + rowHeight),
            paint);
        heightCanvas = heightCanvas + canvasItem.height;
      } else if (canvasItem.type == "dividerDash") {
        final paint = Paint()
          ..color = Colors.black
          ..strokeWidth = canvasItem.height;

        var max = _kCanvasSizeWidth;
        var dashWidth = canvasItem.dashStyle.dashWidth;
        var dashSpace = canvasItem.dashStyle.dashSpace;
        double y = heightCanvas + (canvasItem.height / 2) + rowHeight;
        double x = 0;
        while (max >= 0) {
          _canvas.drawLine(Offset(x, y), Offset(x + dashWidth, y), paint);
          final space = (dashSpace + dashWidth);
          x += space;
          max -= space;
        }

        heightCanvas = heightCanvas + canvasItem.height;
      } else if (canvasItem.type == "image") {
        var codec = await ui.instantiateImageCodec(canvasItem.imageLogo);
        var frame = await codec.getNextFrame();
        ui.Image image = frame.image;
        if (image.height != image.width) {
          if (image.height > canvasItem.height &&
              image.width > canvasItem.width) {
            image = await printImageCanvas(canvasItem, canvasItem.width.floor(),
                canvasItem.height.floor());
          } else if (image.height > canvasItem.height &&
              image.width < canvasItem.width) {
            double reduceSize =
                (image.height.toDouble() - canvasItem.height) / 100;
            image = await printImageCanvas(
                canvasItem,
                (image.width * (1 - reduceSize)).floor(),
                (image.height * (1 - reduceSize)).floor());
          } else if (image.height < canvasItem.height &&
              image.width > canvasItem.width) {
            double reduceSize =
                (image.width.toDouble() - canvasItem.width) / 100;
            image = await printImageCanvas(
                canvasItem,
                (image.width * (1 - reduceSize)).floor(),
                (image.height * (1 - reduceSize)).floor());
          }
        } else {
          if (canvasItem.height < canvasItem.width) {
            if (image.height > canvasItem.height) {
              image = await printImageCanvas(canvasItem,
                  canvasItem.height.floor(), canvasItem.height.floor());
            }
          } else {
            if (image.width > canvasItem.width) {
              image = await printImageCanvas(canvasItem,
                  canvasItem.width.floor(), canvasItem.width.floor());
            }
          }
        }
//        image.width = int.parse(120.toString());

//        ui.Image image = await completer.future;

        double offSetWidth = (_paperWidth / 2) - (image.width / 2);
        _canvas.drawImage(image, Offset(offSetWidth, heightCanvas), Paint());

        heightCanvas = heightCanvas + image.height;
      } else if (canvasItem.type == "barcode") {
        canvasItem.barCodePainter.drawBarCode128(
          _canvas,
          Size(_kCanvasSizeWidth, canvasItem.height),
          heightCanvas,
          _kCanvasSizeWidth,
        );
        heightCanvas = heightCanvas + canvasItem.height;
      } else if (canvasItem.type == "imageNetWork") {
        try {
          int width = canvasItem.imageNetWork.width;
          int height = canvasItem.imageNetWork.height;

          String url =
              "https://images.weserv.nl/?url=${canvasItem.imageNetWork.url}&w=$width&h=$height&t=fit";
          var codec =
              await ui.instantiateImageCodec(await networkImageToByte(url));
          var frame = await codec.getNextFrame();
          ui.Image image = frame.image;
          _canvas.drawImage(image, Offset(widthCanvas, heightCanvas), Paint());
          heightCanvas = heightCanvas + height;
        } catch (e, s) {}
      } else if (canvasItem.type == "qrcode") {
        final image = await QrPainter(
                data: canvasItem.qrcode,
                color: Colors.black,
                version: QrVersions.auto,
                emptyColor: Colors.white)
            .toImageData(canvasItem.height);
        var codec = await ui.instantiateImageCodec(image.buffer.asUint8List());
        var frame = await codec.getNextFrame();
        ui.Image _image = frame.image;
        double offSetWidth = (_paperWidth / 2) - (_image.width / 2);
        _canvas.drawImage(_image, Offset(offSetWidth, heightCanvas), Paint());
        heightCanvas = heightCanvas + _image.height + 8;
      }
    }

    _canvas.drawColor(Colors.white, BlendMode.color);

    final picture = recorder.endRecording();

    ///nếu vượt quá 16384 sẽ bị lỗi (chưa rõ nguyên nhân, đoán là do quá cao)
    heightCanvas = heightCanvas.toInt() <= 16384 ? heightCanvas : 16384;
    print("heightCanvas" + heightCanvas.toString());
    final img = await picture.toImage(
        _paperWidth.toInt(),
        _kCanvasSizeHeight != null
            ? _kCanvasSizeHeight.toInt()
            : heightCanvas.toInt());
    final result = await img.toByteData(format: ui.ImageByteFormat.png);
    _listCanvasItem.clear();
    return result;
  }

//  Future<List<ByteData>> getImageSplit(int height) async {
//    List<ByteData> _images = <ByteData>[];
//    final ui.PictureRecorder recorder = ui.PictureRecorder();
//    _canvas = Canvas(
//      recorder,
//      Rect.fromPoints(Offset(0.0, 0.0), Offset(_paperWidth, getHeight())),
//    );
//    double heightCanvas = 0;
//    double widthCanvas = 0;
//    double rowHeight = 0;
//
//    if (_canvasHeader != null) {
//      int height = _canvasHeader.headerImage.height;
//      int width = _canvasHeader.headerImage.width;
//      ui.Paragraph paragraph = createParagraph("${_canvasHeader.title.title}",
//              style: CanvasStyles(
//                fontSize: _canvasHeader.title.fontSize,
//                //align: TextAlign.center,
//              ),
//              hasBorder: false)
//          .paragraph;
//      _canvas.drawParagraph(paragraph, Offset(50 + width.toDouble(), 5));
//      String url =
//          "https://images.weserv.nl/?url=${_canvasHeader.headerImage.url}&w=$width&h=$height&t=fit";
//      var codec = await ui.instantiateImageCodec(await networkImageToByte(url));
//      var frame = await codec.getNextFrame();
//      ui.Image image = frame.image;
//      _canvas.drawImage(image, Offset(40, 7), Paint());
//
//      heightCanvas = heightCanvas + height;
//    }
//
//    if (_hasBorder) {
//      Paint paint = new Paint()
//        ..color = Colors.black
//        ..style = PaintingStyle.stroke
//        ..strokeWidth = 1;
//      Rect rect = new Rect.fromLTWH(0.5, 0.5, _kCanvasSizeWidth,
//          _kCanvasSizeHeight != null ? _kCanvasSizeHeight - 1.5 : heightCanvas);
//      _canvas.drawRect(rect, paint);
//
//      widthCanvas = widthCanvas + 10;
//    }
//    for (CanvasItem canvasItem in _listCanvasItem) {
//      if (canvasItem.hasBorder) {
//        Paint paint = new Paint()
//          ..color = Colors.black
//          ..style = PaintingStyle.stroke
//          ..strokeWidth = 1;
//        Rect rect = new Rect.fromLTWH(
//          0,
//          heightCanvas,
//          _kCanvasSizeWidth,
//          canvasItem.height,
//        );
//        _canvas.drawRect(rect, paint);
//      }
//      if (canvasItem.type == "paragraph") {
//        //print("đang test $widthCanvas == $_kCanvasSizeWidth");
//        if (canvasItem.paragraph.width != _kCanvasSizeWidth) {
//          //print(canvasItem.paragraph.width);
//          rowHeight = rowHeight > canvasItem.paragraph.height
//              ? rowHeight
//              : canvasItem.paragraph.height;
//          _canvas.drawParagraph(
//              canvasItem.paragraph, Offset(widthCanvas, heightCanvas));
//          widthCanvas = widthCanvas + canvasItem.paragraph.width;
//
//          if (widthCanvas > _kCanvasSizeWidth - 10) {
//            widthCanvas = 0;
//            heightCanvas = heightCanvas + rowHeight;
//            rowHeight = 0;
//          }
//        } else {
//          _canvas.drawParagraph(
//              canvasItem.paragraph, Offset(widthCanvas, heightCanvas));
//          heightCanvas = heightCanvas + canvasItem.paragraph.height;
//        }
//        if (heightCanvas > height) {}
//      } else if (canvasItem.type == "divider") {
//        final paint = Paint()
//          ..color = Colors.black
//          ..strokeWidth = canvasItem.height;
//        _canvas.drawLine(
//            Offset(0, heightCanvas + (canvasItem.height / 2) + rowHeight),
//            Offset(_kCanvasSizeWidth,
//                heightCanvas + (canvasItem.height / 2) + rowHeight),
//            paint);
//        heightCanvas = heightCanvas + canvasItem.height;
//      } else if (canvasItem.type == "dividerDash") {
//        final paint = Paint()
//          ..color = Colors.black
//          ..strokeWidth = canvasItem.height;
//
//        var max = _kCanvasSizeWidth;
//        var dashWidth = canvasItem.dashStyle.dashWidth;
//        var dashSpace = canvasItem.dashStyle.dashSpace;
//        double y = heightCanvas + (canvasItem.height / 2) + rowHeight;
//        double x = 0;
//        while (max >= 0) {
//          _canvas.drawLine(Offset(x, y), Offset(x + dashWidth, y), paint);
//          final space = (dashSpace + dashWidth);
//          x += space;
//          max -= space;
//        }
//
//        heightCanvas = heightCanvas + canvasItem.height;
//      } else if (canvasItem.type == "image") {
//        var codec = await ui.instantiateImageCodec(canvasItem.imageLogo);
//        var frame = await codec.getNextFrame();
//        ui.Image image = frame.image;
//        if (image.height != image.width) {
//          if (image.height > canvasItem.height &&
//              image.width > canvasItem.width) {
//            image = await printImageCanvas(canvasItem, canvasItem.width.floor(),
//                canvasItem.height.floor());
//          } else if (image.height > canvasItem.height &&
//              image.width < canvasItem.width) {
//            double reduceSize =
//                (image.height.toDouble() - canvasItem.height) / 100;
//            image = await printImageCanvas(
//                canvasItem,
//                (image.width * (1 - reduceSize)).floor(),
//                (image.height * (1 - reduceSize)).floor());
//          } else if (image.height < canvasItem.height &&
//              image.width > canvasItem.width) {
//            double reduceSize =
//                (image.width.toDouble() - canvasItem.width) / 100;
//            image = await printImageCanvas(
//                canvasItem,
//                (image.width * (1 - reduceSize)).floor(),
//                (image.height * (1 - reduceSize)).floor());
//          }
//        } else {
//          if (canvasItem.height < canvasItem.width) {
//            if (image.height > canvasItem.height) {
//              image = await printImageCanvas(canvasItem,
//                  canvasItem.height.floor(), canvasItem.height.floor());
//            }
//          } else {
//            if (image.width > canvasItem.width) {
//              image = await printImageCanvas(canvasItem,
//                  canvasItem.width.floor(), canvasItem.width.floor());
//            }
//          }
//        }
////        image.width = int.parse(120.toString());
//
////        ui.Image image = await completer.future;
//
//        double offSetWidth = (_paperWidth / 2) - (image.width / 2);
//        _canvas.drawImage(image, Offset(offSetWidth, heightCanvas), Paint());
//
//        heightCanvas = heightCanvas + image.height;
//      } else if (canvasItem.type == "barcode") {
//        canvasItem.barCodePainter.drawBarCode128(
//          _canvas,
//          Size(_kCanvasSizeWidth, canvasItem.height),
//          heightCanvas,
//          _kCanvasSizeWidth,
//        );
//        heightCanvas = heightCanvas + canvasItem.height;
//      } else if (canvasItem.type == "imageNetWork") {
//        try {
//          int width = canvasItem.imageNetWork.width;
//          int height = canvasItem.imageNetWork.height;
//
//          String url =
//              "https://images.weserv.nl/?url=${canvasItem.imageNetWork.url}&w=$width&h=$height&t=fit";
//          var codec =
//              await ui.instantiateImageCodec(await networkImageToByte(url));
//          var frame = await codec.getNextFrame();
//          ui.Image image = frame.image;
//          _canvas.drawImage(image, Offset(widthCanvas, heightCanvas), Paint());
//          heightCanvas = heightCanvas + height;
//        } catch (e, s) {}
//      } else if (canvasItem.type == "qrcode") {
//        final image = await QrPainter(
//                data: canvasItem.qrcode,
//                color: Colors.black,
//                version: QrVersions.auto,
//                emptyColor: Colors.white)
//            .toImageData(canvasItem.height);
//        var codec = await ui.instantiateImageCodec(image.buffer.asUint8List());
//        var frame = await codec.getNextFrame();
//        ui.Image _image = frame.image;
//        double offSetWidth = (_paperWidth / 2) - (_image.width / 2);
//        _canvas.drawImage(_image, Offset(offSetWidth, heightCanvas), Paint());
//        heightCanvas = heightCanvas + _image.height + 8;
//      }
//    }
//
//    _canvas.drawColor(Colors.white, BlendMode.color);
//
//    final picture = recorder.endRecording();
//
//    ///nếu vượt quá 16384 sẽ bị lỗi (chưa rõ nguyên nhân, đoán là do quá cao)
//    heightCanvas = heightCanvas.toInt() <= 16384 ? heightCanvas : 16384;
//    print("heightCanvas" + heightCanvas.toString());
//    final img = await picture.toImage(
//        _paperWidth.toInt(),
//        _kCanvasSizeHeight != null
//            ? _kCanvasSizeHeight.toInt()
//            : heightCanvas.toInt());
//    final result = await img.toByteData(format: ui.ImageByteFormat.png);
//    _listCanvasItem.clear();
//    return result;
//  }

  Future<ui.Image> printImageCanvas(
      CanvasItem canvasItem, int width, int height) async {
    ui.Image image;
    IMG.Image images = IMG.decodeImage(canvasItem.imageLogo);
    final IMG.Image resized =
        IMG.copyResize(images, width: width, height: height);
    final List<int> resizedBytes = IMG.encodePng(resized);
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(
        resizedBytes, (ui.Image imge) => completer.complete(imge));
    image = await completer.future;

    return image;
  }

  Future<ui.Image> generateImageImg() async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    _canvas = Canvas(
      recorder,
      Rect.fromPoints(Offset(0.0, 0.0), Offset(_paperWidth, getHeight())),
    );
    double heightCanvas = 0;
    double widthCanvas = 0;
    double rowHeight = 0;

    if (_canvasHeader != null) {
      int height = _canvasHeader.headerImage.height;
      int width = _canvasHeader.headerImage.width;
      ui.Paragraph paragraph = createParagraph("${_canvasHeader.title.title}",
              style: CanvasStyles(
                fontSize: _canvasHeader.title.fontSize,
                //align: TextAlign.center,
              ),
              hasBorder: false)
          .paragraph;
      _canvas.drawParagraph(paragraph, Offset(50 + width.toDouble(), 5));
      String url =
          "https://images.weserv.nl/?url=${_canvasHeader.headerImage.url}&w=$width&h=$height&t=fit";
      var codec = await ui.instantiateImageCodec(await networkImageToByte(url));
      var frame = await codec.getNextFrame();
      ui.Image image = frame.image;
      _canvas.drawImage(image, Offset(40, 7), Paint());

      heightCanvas = heightCanvas + height;
    }

    if (_hasBorder) {
      Paint paint = new Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      Rect rect = new Rect.fromLTWH(0.5, 0.5, _kCanvasSizeWidth,
          _kCanvasSizeHeight != null ? _kCanvasSizeHeight - 1.5 : heightCanvas);
      _canvas.drawRect(rect, paint);

      widthCanvas = widthCanvas + 10;
    }
    for (CanvasItem canvasItem in _listCanvasItem) {
      if (canvasItem.hasBorder) {
        Paint paint = new Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        Rect rect = new Rect.fromLTWH(
          0,
          heightCanvas,
          _kCanvasSizeWidth,
          canvasItem.height,
        );
        _canvas.drawRect(rect, paint);
      }
      if (canvasItem.type == "paragraph") {
        //print("đang test $widthCanvas == $_kCanvasSizeWidth");
        if (canvasItem.paragraph.width != _kCanvasSizeWidth) {
          //print(canvasItem.paragraph.width);
          rowHeight = rowHeight > canvasItem.paragraph.height
              ? rowHeight
              : canvasItem.paragraph.height;
          _canvas.drawParagraph(
              canvasItem.paragraph, Offset(widthCanvas, heightCanvas));
          widthCanvas = widthCanvas + canvasItem.paragraph.width;

          if (widthCanvas > _kCanvasSizeWidth - 10) {
            widthCanvas = 0;
            heightCanvas = heightCanvas + rowHeight;
            rowHeight = 0;
          }
        } else {
          _canvas.drawParagraph(
              canvasItem.paragraph, Offset(widthCanvas, heightCanvas));
          heightCanvas = heightCanvas + canvasItem.paragraph.height;
        }
      } else if (canvasItem.type == "divider") {
        final paint = Paint()
          ..color = Colors.black
          ..strokeWidth = canvasItem.height;
        _canvas.drawLine(
            Offset(0, heightCanvas + (canvasItem.height / 2) + rowHeight),
            Offset(_kCanvasSizeWidth,
                heightCanvas + (canvasItem.height / 2) + rowHeight),
            paint);
        heightCanvas = heightCanvas + canvasItem.height;
      } else if (canvasItem.type == "dividerDash") {
        final paint = Paint()
          ..color = Colors.black
          ..strokeWidth = canvasItem.height;

        var max = _kCanvasSizeWidth;
        var dashWidth = canvasItem.dashStyle.dashWidth;
        var dashSpace = canvasItem.dashStyle.dashSpace;
        double y = heightCanvas + (canvasItem.height / 2) + rowHeight;
        double x = 0;
        while (max >= 0) {
          _canvas.drawLine(Offset(x, y), Offset(x + dashWidth, y), paint);
          final space = (dashSpace + dashWidth);
          x += space;
          max -= space;
        }

        heightCanvas = heightCanvas + canvasItem.height;
      } else if (canvasItem.type == "image") {
        var codec = await ui
            .instantiateImageCodec(canvasItem.byteData.buffer.asUint8List());
        var frame = await codec.getNextFrame();
        ui.Image image = frame.image;
        _canvas.drawImage(image, Offset(0, heightCanvas), Paint());

        heightCanvas = heightCanvas + image.height;
      } else if (canvasItem.type == "barcode") {
        canvasItem.barCodePainter.drawBarCode128(
          _canvas,
          Size(_kCanvasSizeWidth, canvasItem.height),
          heightCanvas,
          _kCanvasSizeWidth,
        );
        heightCanvas = heightCanvas + canvasItem.height;
      } else if (canvasItem.type == "imageNetWork") {
        try {
          int width = canvasItem.imageNetWork.width;
          int height = canvasItem.imageNetWork.height;

          String url =
              "https://images.weserv.nl/?url=${canvasItem.imageNetWork.url}&w=$width&h=$height&t=fit";
          var codec =
              await ui.instantiateImageCodec(await networkImageToByte(url));
          var frame = await codec.getNextFrame();
          ui.Image image = frame.image;
          _canvas.drawImage(image, Offset(widthCanvas, heightCanvas), Paint());
          heightCanvas = heightCanvas + height;
        } catch (e) {
          print(e);
        }
      }
    }

    _canvas.drawColor(Colors.white, BlendMode.color);
    final picture = recorder.endRecording();

    ///nếu vượt quá 16384 sẽ bị lỗi (chưa rõ nguyên nhân, đoán là do quá cao)
    heightCanvas = heightCanvas.toInt() <= 16384 ? heightCanvas : 16384;
    ui.Image image = await picture.toImage(
        _paperWidth.toInt(),
        _kCanvasSizeHeight != null
            ? _kCanvasSizeHeight.toInt()
            : heightCanvas.toInt());

    return image;
  }

  CanvasItem createParagraph(String text,
      {CanvasStyles style, bool hasBorder = false}) {
    ui.ParagraphBuilder paragraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: style.align,
        fontSize: style.fontSize,
        fontStyle: style.fontStyle,
        fontWeight: style.fontWeight,
        fontFamily: fontFamily != null ? fontFamily : style.fontFamily,
        maxLines: isRowChild(text) ? 1 : null,
      ),
    )
      ..pushStyle(ui.TextStyle(
        color: Colors.black,
        fontSize: style.fontSize,
        fontStyle: style.fontStyle,
        fontWeight: style.fontWeight,
        fontFamily: fontFamily != null ? fontFamily : style.fontFamily,
        decoration: style.underline ? TextDecoration.underline : null,
      ))
      ..addText("${isRowChild(text) ? getRowValue(text) : text}");
    double width = isRowChild(text) ? getRowWidth(text) : _kCanvasSizeWidth;
    final ui.Paragraph paragraph = paragraphBuilder.build()
      ..layout(
        ui.ParagraphConstraints(
          width: width,
        ),
      );

    return CanvasItem(
      type: "paragraph",
      paragraph: paragraph,
      hasBorder: hasBorder,
    );
  }

  void printTextLn(
    String text, {
    CanvasStyles style,
    bool hasBorder = false,
  }) {
    _listCanvasItem.add(
      createParagraph(text ?? "",
          style: style ?? new CanvasStyles(), hasBorder: hasBorder),
    );
  }

  void printBorder({double width, double height}) {
    _listCanvasItem.add(
      CanvasItem(
        height: height ?? 100,
        type: "border",
      ),
    );
  }

  void emptyLines(double length) {
    for (int i = 1; i <= length; i++) {
      printTextLn("", style: CanvasStyles(fontSize: 1));
    }
  }

  void printRow(List<CanvasColumn> list) {
    if (checkPrintRowValid(list)) {
      for (CanvasColumn canvasColumn in list) {
        _listCanvasItem.add(
          createParagraph(
            "${canvasColumn.text ?? ""}${canvasColumn.text != "" ? "[width=/${canvasColumn.width}/]" : ""}",
            style: canvasColumn.styles ?? new CanvasStyles(),
          ),
        );
      }
    } else {
      print("width không đủ 12 !!!");
    }
  }

  void printDivider({double height}) {
    _listCanvasItem.add(
      CanvasItem(
        type: "divider",
        height: height,
      ),
    );
  }

  void printDividerDash({
    double height = 1,
    LineDash lineDash,
  }) {
    _listCanvasItem.add(
      CanvasItem(
        type: "dividerDash",
        height: height,
        dashStyle: lineDash,
      ),
    );
  }

  void printImage(Uint8List imageLogo, double width, double height) {
    _listCanvasItem.add(
      CanvasItem(
          type: "image", imageLogo: imageLogo, height: height, width: width),
    );
  }

  void printQrcode(String value, double size) {
    _listCanvasItem.add(
      CanvasItem(type: "qrcode", qrcode: value, height: size),
    );
  }

  void printImageNetWork({CanvasImage imageNetWork}) {
    _listCanvasItem.add(CanvasItem(
      type: "imageNetWork",
      imageNetWork: imageNetWork,
    ));
  }

  bool checkPrintRowValid(List<CanvasColumn> list) {
    double totalWidth = 0;
    for (CanvasColumn item in list) {
      totalWidth = totalWidth + item.width;
    }
    return totalWidth == 12;
  }

  bool isRowChild(String text) {
    return text.contains("[width=/");
  }

  double getRowWidth(String text) {
    return _kCanvasSizeWidth / 12 * double.parse(text.split("/")[1]);
  }

  String getRowValue(String text) {
    return "${text.split("[width=/")[0]}";
  }

  double getHeight() {
    double high = 0;
    for (CanvasItem item in _listCanvasItem) {
      high = high + item.height;
    }

    return high;
  }

  void printBarCode(
    String barcode, {
    double lineWidth = 2.0,
    bool hasText = false,
    Color color = const Color(0xFF000000),
    double height = 100,
  }) {
    _listCanvasItem.add(
      CanvasItem(
          type: "barcode",
          barCodePainter: BarCode128(
            data: "$barcode",
            lineWidth: lineWidth,
            hasText: hasText,
            color: color,
          ),
          height: height),
    );
  }

  CanvasItem createTextSpan(List<CanvasTextSpan> textSpans, bool center) {
    ui.ParagraphBuilder paragraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: center ? TextAlign.center : TextAlign.start,
        fontSize: 30,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
      ),
    );
    textSpans.forEach((textSpan) {
      paragraphBuilder
        ..pushStyle(
          ui.TextStyle(
            color: Colors.black,
            fontSize: textSpan.style.fontSize,
            fontStyle: textSpan.style.fontStyle,
            fontWeight: textSpan.style.fontWeight,
            fontFamily:
                fontFamily != null ? fontFamily : textSpan.style.fontFamily,
            decoration:
                textSpan.style.underline ? TextDecoration.underline : null,
          ),
        )
        ..addText("${textSpan.text}");
    });
    final ui.Paragraph paragraph = paragraphBuilder.build()
      ..layout(
        ui.ParagraphConstraints(
          width: _kCanvasSizeWidth,
        ),
      );

    return CanvasItem(type: "paragraph", paragraph: paragraph);
  }

  void printTextSpans({List<CanvasTextSpan> textSpans, bool center = false}) {
    textSpans.forEach((textSpan) {});

    _listCanvasItem.add(
      createTextSpan(textSpans, center),
    );
  }

  void setUp({bool isHasBorder, double width, double height}) {
    _hasBorder = isHasBorder ?? _hasBorder;
    _kCanvasSizeWidth = width ?? _kCanvasSizeWidth;
    _kCanvasSizeHeight = height ?? _kCanvasSizeHeight;
    //_kCanvasSizeWidth = _hasBorder ? _kCanvasSizeWidth - 50 : _kCanvasSizeWidth;
  }
}

class CanvasHeader {
  CanvasImage headerImage;
  HeaderTitle title;

  CanvasHeader({this.headerImage, this.title});
}

class HeaderTitle {
  String title;
  double fontSize;

  HeaderTitle({this.title = "", this.fontSize = 22});
}

class CanvasImage {
  String url;
  int width;
  int height;

  CanvasImage({
    this.url = "img.icons8.com/metro/26/000000/empty-box.png",
    this.width = 25,
    this.height = 25,
  }) {
    this.url = this.url.replaceAll("https://", "").replaceAll("http://", "");
  }
}

class CanvasTextSpan {
  String text;
  CanvasStyles style = new CanvasStyles();

  CanvasTextSpan(this.text, {this.style});
}

class CanvasItem {
  ///paragraph, divider,dividerDash,image,barcode,imageNetWork
  String type;
  double height;
  double width;
  ui.Paragraph paragraph;
  LineDash dashStyle;
  ByteData byteData;
  BarCode128 barCodePainter;
  bool hasBorder;
  CanvasImage imageNetWork;
  Uint8List imageLogo;
  String qrcode;

  CanvasItem(
      {this.type,
      this.height = 0,
      this.width,
      this.paragraph,
      this.dashStyle,
      this.byteData,
      this.barCodePainter,
      this.hasBorder = false,
      this.imageNetWork,
      this.imageLogo,
      this.qrcode}) {
    if (type == "paragraph") {
      height = paragraph.height;
    } else if (type == "dividerDash") {
      dashStyle = dashStyle == null ? new LineDash() : dashStyle;
    }
  }
}

/// Linedash là đường thẳng nét đứt ---------
class LineDash {
  double dashSpace;
  double dashWidth;

  LineDash({
    this.dashSpace = 5,
    this.dashWidth = 5,
  });
}

class CanvasColumn {
  String text;
  double width;
  CanvasStyles styles;

  CanvasColumn({this.text = "", this.width, this.styles});
}

class CanvasStyles {
  double fontSize;
  FontStyle fontStyle;
  FontWeight fontWeight;
  TextAlign align;
  String fontFamily;
  bool underline;
  bool bold;

  CanvasStyles({
    this.fontSize = 25,
    this.fontStyle = FontStyle.normal,
    this.fontWeight = FontWeight.w400,
    this.align = TextAlign.left,
    this.fontFamily = 'times.ttf',
    this.underline = false,
    this.bold = false,
  }) {
    this.fontWeight = bold ? FontWeight.w700 : FontWeight.w400;
  }

  CanvasStyles copyWith({
    double fontSize,
    FontStyle fontStyle,
    FontWeight fontWeight,
    TextAlign align,
    String fontFamily,
    bool underline,
    bool bold,
  }) {
    return CanvasStyles(
      fontSize: fontSize ?? this.fontSize,
      fontStyle: this.fontStyle ?? this.fontStyle,
      fontWeight: this.fontWeight ?? this.fontWeight,
      align: align ?? this.align,
      fontFamily: fontFamily ?? this.fontFamily,
      underline: underline ?? this.underline,
      bold: bold ?? this.bold,
    );
  }
}
