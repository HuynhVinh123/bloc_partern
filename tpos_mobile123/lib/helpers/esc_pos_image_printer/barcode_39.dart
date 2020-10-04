import 'package:flutter/material.dart';

typedef void BarCodeError(dynamic error);

class BarCode39 {
  BarCode39(
      {this.data, this.lineWidth, this.hasText, this.color, this.onError});

  final Color color;
  final String data;
  final double lineWidth;
  final BarCodeError onError;
  final bool hasText;

  void drawBarCode39(Canvas canvas, Size size, double top, double canvasWidth) {
    final List<int> binSet = [
      0xa6d,
      0xd2b,
      0xb2b,
      0xd95,
      0xa6b,
      0xd35,
      0xb35,
      0xa5b,
      0xd2d,
      0xb2d,
      0xd4b,
      0xb4b,
      0xda5,
      0xacb,
      0xd65,
      0xb65,
      0xa9b,
      0xd4d,
      0xb4d,
      0xacd,
      0xd53,
      0xb53,
      0xda9,
      0xad3,
      0xd69,
      0xb69,
      0xab3,
      0xd59,
      0xb59,
      0xad9,
      0xcab,
      0x9ab,
      0xcd5,
      0x96b,
      0xcb5,
      0x9b5,
      0x95b,
      0xcad,
      0x9ad,
      0x925,
      0x929,
      0x949,
      0xa49,
      0x96d
    ];

    int codeValue = 0;
    bool hasError = false;
    final painter = new Paint()..style = PaintingStyle.fill;
    double height = hasText ? size.height * 0.85 : size.height;
    double padding =
        (size.width - data.length * 13 * lineWidth) / 2 - 13 * lineWidth;

    for (int i = 0; i < data.length; i++) {
      switch (data[i]) {
        case '0':
          codeValue = 0;
          break;
        case '1':
          codeValue = 1;
          break;
        case '2':
          codeValue = 2;
          break;
        case '3':
          codeValue = 3;
          break;
        case '4':
          codeValue = 4;
          break;
        case '5':
          codeValue = 5;
          break;
        case '6':
          codeValue = 6;
          break;
        case '7':
          codeValue = 7;
          break;
        case '8':
          codeValue = 8;
          break;
        case '9':
          codeValue = 9;
          break;
        case 'A':
          codeValue = 10;
          break;
        case 'B':
          codeValue = 11;
          break;
        case 'C':
          codeValue = 12;
          break;
        case 'D':
          codeValue = 13;
          break;
        case 'E':
          codeValue = 14;
          break;
        case 'F':
          codeValue = 15;
          break;
        case 'G':
          codeValue = 16;
          break;
        case 'H':
          codeValue = 17;
          break;
        case 'I':
          codeValue = 18;
          break;
        case 'J':
          codeValue = 19;
          break;
        case 'K':
          codeValue = 20;
          break;
        case 'L':
          codeValue = 21;
          break;
        case 'M':
          codeValue = 22;
          break;
        case 'N':
          codeValue = 23;
          break;
        case 'O':
          codeValue = 24;
          break;
        case 'P':
          codeValue = 25;
          break;
        case 'Q':
          codeValue = 26;
          break;
        case 'R':
          codeValue = 27;
          break;
        case 'S':
          codeValue = 28;
          break;
        case 'T':
          codeValue = 29;
          break;
        case 'U':
          codeValue = 30;
          break;
        case 'V':
          codeValue = 31;
          break;
        case 'W':
          codeValue = 32;
          break;
        case 'X':
          codeValue = 33;
          break;
        case 'Y':
          codeValue = 34;
          break;
        case 'Z':
          codeValue = 35;
          break;
        case '-':
          codeValue = 36;
          break;
        case '.':
          codeValue = 37;
          break;
        case ' ':
          codeValue = 38;
          break;
        case '\$':
          codeValue = 39;
          break;
        case '/':
          codeValue = 40;
          break;
        case '+':
          codeValue = 41;
          break;
        case '%':
          codeValue = 42;
          break;
        default:
          codeValue = 0;
          hasError = true;
          break;
      }

      if (hasError) {
        String errorMsg =
            "Invalid content for Code39. Please check https://en.wikipedia.org/wiki/Code_39 for reference.";
        if (this.onError != null) {
          this.onError(errorMsg);
        } else {
          print(errorMsg);
        }
        return;
      }

      for (int j = 0; j < 12; j++) {
        Rect rect = new Rect.fromLTWH(
            padding + (13 * lineWidth + 13 * i * lineWidth + j * lineWidth),
            top,
            lineWidth,
            height);
        ((0x800 & (binSet[codeValue] << j)) == 0x800)
            ? painter.color = Colors.black
            : painter.color = Colors.white;
        canvas.drawRect(rect, painter);
      }
    }

    for (int i = 0; i < 12; i++) {
      Rect rect =
          new Rect.fromLTWH(padding + i * lineWidth, top, lineWidth, height);
      ((0x800 & (binSet[43] << i)) == 0x800)
          ? painter.color = Colors.black
          : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 12; i++) {
      Rect rect = new Rect.fromLTWH(
          padding + (13 + i) * lineWidth + 13 * (data.length) * lineWidth,
          top,
          lineWidth,
          height);
      ((0x800 & (binSet[43] << i)) == 0x800)
          ? painter.color = Colors.black
          : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    if (hasText) {
      for (int i = 0; i < data.length; i++) {
        TextSpan span = new TextSpan(
            style: new TextStyle(color: Colors.black, fontSize: 15.0),
            text: data[i]);
        TextPainter textPainter = new TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr);
        textPainter.layout();
        textPainter.paint(
            canvas,
            new Offset(
                (size.width - data.length * 13 * lineWidth) / 2 +
                    13 * i * lineWidth,
                top + height));
      }
    }
  }

  double getPadding() {
    bool hasError = false;
    double padding = 0;
    for (int i = 0; i < data.length; i++) {
      if (hasError) {
        return 0;
      }
      for (int j = 0; j < 12; j++) {
        padding =
            padding + (13 * lineWidth + 13 * i * lineWidth + j * lineWidth);
      }
      print(padding);
    }

    for (int i = 0; i < 12; i++) {
      padding = padding + i * lineWidth;
    }

    for (int i = 0; i < 12; i++) {
      padding =
          padding + ((13 + i) * lineWidth + 13 * (data.length) * lineWidth);
    }

    print(padding);
    return padding / 100;
  }
}
