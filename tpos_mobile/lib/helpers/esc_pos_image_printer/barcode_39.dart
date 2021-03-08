import 'package:flutter/material.dart';

typedef BarCodeError = void Function(dynamic error);

class BarCode39 {
  BarCode39({this.data, this.liidth, this.hasText, this.color, this.onError});

  final Color color;
  final String data;
  final double liidth;
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
    final painter = Paint()..style = PaintingStyle.fill;
    final double height = hasText ? size.height * 0.85 : size.height;
    final double padding =
        (size.width - data.length * 13 * liidth) / 2 - 13 * liidth;

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
        const String errorMsg =
            "Invalid content for Code39. Please check https://en.wikipedia.org/wiki/Code_39 for reference.";
        if (onError != null) {
          onError(errorMsg);
        } else {
          print(errorMsg);
        }
        return;
      }

      for (int j = 0; j < 12; j++) {
        final Rect rect = Rect.fromLTWH(
            padding + (13 * liidth + 13 * i * liidth + j * liidth),
            top,
            liidth,
            height);
        ((0x800 & (binSet[codeValue] << j)) == 0x800)
            ? painter.color = Colors.black
            : painter.color = Colors.white;
        canvas.drawRect(rect, painter);
      }
    }

    for (int i = 0; i < 12; i++) {
      final Rect rect =
          Rect.fromLTWH(padding + i * liidth, top, liidth, height);
      ((0x800 & (binSet[43] << i)) == 0x800)
          ? painter.color = Colors.black
          : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 12; i++) {
      final Rect rect = Rect.fromLTWH(
          padding + (13 + i) * liidth + 13 * (data.length) * liidth,
          top,
          liidth,
          height);
      ((0x800 & (binSet[43] << i)) == 0x800)
          ? painter.color = Colors.black
          : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    if (hasText) {
      for (int i = 0; i < data.length; i++) {
        final TextSpan span = TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 15.0),
            text: data[i]);
        final TextPainter textPainter = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr);
        textPainter.layout();
        textPainter.paint(
            canvas,
            Offset(
                (size.width - data.length * 13 * liidth) / 2 + 13 * i * liidth,
                top + height));
      }
    }
  }

  double getPadding() {
    const bool hasError = false;
    double padding = 0;
    for (int i = 0; i < data.length; i++) {
      if (hasError) {
        return 0;
      }
      for (int j = 0; j < 12; j++) {
        padding = padding + (13 * liidth + 13 * i * liidth + j * liidth);
      }
      print(padding);
    }

    for (int i = 0; i < 12; i++) {
      padding = padding + i * liidth;
    }

    for (int i = 0; i < 12; i++) {
      padding = padding + ((13 + i) * liidth + 13 * (data.length) * liidth);
    }

    print(padding);
    return padding / 100;
  }
}
