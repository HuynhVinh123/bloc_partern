import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void BarCodeError(dynamic error);

class BarCode128 {
  BarCode128(
      {this.data, this.lineWidth, this.hasText, this.color, this.onError});

  final Color color;
  final String data;
  final double lineWidth;
  final BarCodeError onError;
  final bool hasText;

  void drawBarCode128(
      Canvas canvas, Size size, double top, double canvasWidth) {
    List<int> code128 = [
      0x6cc,
      0x66c,
      0x666,
      0x498,
      0x48c,
      0x44c,
      0x4c8,
      0x4c4,
      0x464,
      0x648,
      0x644,
      0x624,
      0x59c,
      0x4dc,
      0x4ce,
      0x5cc,
      0x4ec,
      0x4e6,
      0x672,
      0x65c,
      0x64e,
      0x6e4,
      0x674,
      0x76e,
      0x74c,
      0x72c,
      0x726,
      0x764,
      0x734,
      0x732,
      0x6d8,
      0x6c6,
      0x636,
      0x518,
      0x458,
      0x446,
      0x588,
      0x468,
      0x462,
      0x688,
      0x628,
      0x622,
      0x5b8,
      0x58e,
      0x46e,
      0x5d8,
      0x5c6,
      0x476,
      0x776,
      0x68e,
      0x62e,
      0x6e8,
      0x6e2,
      0x6ee,
      0x758,
      0x746,
      0x716,
      0x768,
      0x762,
      0x71a,
      0x77a,
      0x642,
      0x78a,
      0x530,
      0x50c,
      0x4b0,
      0x486,
      0x42c,
      0x426,
      0x590,
      0x584,
      0x4d0,
      0x4c2,
      0x434,
      0x432,
      0x612,
      0x650,
      0x7ba,
      0x614,
      0x47a,
      0x53c,
      0x4bc,
      0x49e,
      0x5e4,
      0x4f4,
      0x4f2,
      0x7a4,
      0x794,
      0x792,
      0x6de,
      0x6f6,
      0x7b6,
      0x578,
      0x51e,
      0x45e,
      0x5e8,
      0x5e2,
      0x7a8,
      0x7a2,
      0x5de,
      0x5ee,
      0x75e,
      0x7a2,
      0x684,
      0x690,
      0x69c
    ];

    int codeValue, checkCode, strlen = data.length;
    ByteData strValue = new ByteData(strlen);
    int sum = 0, startValue = 0x690, endFlag = 0x18eb;
    bool hasError = false;
    final painter = new Paint()..style = PaintingStyle.fill;
    double height = hasText ? size.height * 0.85 : size.height;
    double padding =
        (size.width - data.length * 13 * lineWidth) / 2 - strlen * lineWidth;

    for (int i = 0; i < 11; i++) {
      Rect rect =
          new Rect.fromLTWH(padding + (i * lineWidth), top, lineWidth, height);
      ((0x400 & (startValue << i)) == 0x400)
          ? painter.color = Colors.black
          : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < strlen; i++) {
      switch (data[i]) {
        case ' ':
          codeValue = 0;
          break;
        case '!':
          codeValue = 1;
          break;
        case '"':
          codeValue = 2;
          break;
        case '#':
          codeValue = 3;
          break;
        case '\$':
          codeValue = 4;
          break;
        case '%':
          codeValue = 5;
          break;
        case '&':
          codeValue = 6;
          break;
        case '…':
          codeValue = 7;
          break;
        case '(':
          codeValue = 8;
          break;
        case ')':
          codeValue = 9;
          break;
        case '*':
          codeValue = 10;
          break;
        case '+':
          codeValue = 11;
          break;
        case ',':
          codeValue = 12;
          break;
        case '-':
          codeValue = 13;
          break;
        case '.':
          codeValue = 14;
          break;
        case '/':
          codeValue = 15;
          break;
        case '0':
          codeValue = 16;
          break;
        case '1':
          codeValue = 17;
          break;
        case '2':
          codeValue = 18;
          break;
        case '3':
          codeValue = 19;
          break;
        case '4':
          codeValue = 20;
          break;
        case '5':
          codeValue = 21;
          break;
        case '6':
          codeValue = 22;
          break;
        case '7':
          codeValue = 23;
          break;
        case '8':
          codeValue = 24;
          break;
        case '9':
          codeValue = 25;
          break;
        case ':':
          codeValue = 26;
          break;
        case ';':
          codeValue = 27;
          break;
        case '<':
          codeValue = 28;
          break;
        case '=':
          codeValue = 29;
          break;
        case '>':
          codeValue = 30;
          break;
        case '?':
          codeValue = 31;
          break;
        case '@':
          codeValue = 32;
          break;
        case 'A':
          codeValue = 33;
          break;
        case 'B':
          codeValue = 34;
          break;
        case 'C':
          codeValue = 35;
          break;
        case 'D':
          codeValue = 36;
          break;
        case 'E':
          codeValue = 37;
          break;
        case 'F':
          codeValue = 38;
          break;
        case 'G':
          codeValue = 39;
          break;
        case 'H':
          codeValue = 40;
          break;
        case 'I':
          codeValue = 41;
          break;
        case 'J':
          codeValue = 42;
          break;
        case 'K':
          codeValue = 43;
          break;
        case 'L':
          codeValue = 44;
          break;
        case 'M':
          codeValue = 45;
          break;
        case 'N':
          codeValue = 46;
          break;
        case 'O':
          codeValue = 47;
          break;
        case 'P':
          codeValue = 48;
          break;
        case 'Q':
          codeValue = 49;
          break;
        case 'R':
          codeValue = 50;
          break;
        case 'S':
          codeValue = 51;
          break;
        case 'T':
          codeValue = 52;
          break;
        case 'U':
          codeValue = 53;
          break;
        case 'V':
          codeValue = 54;
          break;
        case 'W':
          codeValue = 55;
          break;
        case 'X':
          codeValue = 56;
          break;
        case 'Y':
          codeValue = 57;
          break;
        case 'Z':
          codeValue = 58;
          break;
        case '[':
          codeValue = 59;
          break;
        case '、':
          codeValue = 60;
          break;
        case ']':
          codeValue = 61;
          break;
        case '^':
          codeValue = 62;
          break;
        case '_':
          codeValue = 63;
          break;
        case '`':
          codeValue = 64;
          break;
        case 'a':
          codeValue = 65;
          break;
        case 'b':
          codeValue = 66;
          break;
        case 'c':
          codeValue = 67;
          break;
        case 'd':
          codeValue = 68;
          break;
        case 'e':
          codeValue = 69;
          break;
        case 'f':
          codeValue = 70;
          break;
        case 'g':
          codeValue = 71;
          break;
        case 'h':
          codeValue = 72;
          break;
        case 'i':
          codeValue = 73;
          break;
        case 'j':
          codeValue = 74;
          break;
        case 'k':
          codeValue = 75;
          break;
        case 'l':
          codeValue = 76;
          break;
        case 'm':
          codeValue = 77;
          break;
        case 'n':
          codeValue = 78;
          break;
        case 'o':
          codeValue = 79;
          break;
        case 'p':
          codeValue = 80;
          break;
        case 'q':
          codeValue = 81;
          break;
        case 'r':
          codeValue = 82;
          break;
        case 's':
          codeValue = 83;
          break;
        case 't':
          codeValue = 84;
          break;
        case 'u':
          codeValue = 85;
          break;
        case 'v':
          codeValue = 86;
          break;
        case 'w':
          codeValue = 87;
          break;
        case 'x':
          codeValue = 88;
          break;
        case 'y':
          codeValue = 89;
          break;
        case 'z':
          codeValue = 90;
          break;
        case '{':
          codeValue = 91;
          break;
        case '|':
          codeValue = 92;
          break;
        case '}':
          codeValue = 93;
          break;
        case '~':
          codeValue = 94;
          break;
        default:
          hasError = true;
          break;
      }

      if (hasError) {
        String errorMsg =
            "Invalid content for Code128. Please check https://en.wikipedia.org/wiki/Code_128 for reference.";
        if (this.onError != null) {
          this.onError(errorMsg);
        } else {
          print(errorMsg);
        }
        return;
      }

      strValue.setUint8(i, codeValue);
      sum += strValue.getUint8(i) * (i + 1);
      for (int j = 0; j < 11; j++) {
        Rect rect = new Rect.fromLTWH(
            padding + (11 * lineWidth + 11 * i * lineWidth + j * lineWidth),
            top,
            lineWidth,
            height);
        ((0x400 & (code128[codeValue] << j)) == 0x400)
            ? painter.color = Colors.black
            : painter.color = Colors.white;
        canvas.drawRect(rect, painter);
      }
    }

    checkCode = (sum + 104) % 103;
    for (int i = 0; i < 11; i++) {
      Rect rect = new Rect.fromLTWH(
          padding + (11 * lineWidth + (strlen * 11 + i) * lineWidth),
          top,
          lineWidth,
          height);
      ((0x400 & (code128[checkCode] << i)) == 0x400)
          ? painter.color = Colors.black
          : painter.color = Colors.white;
      canvas.drawRect(rect, painter);
    }

    for (int i = 0; i < 13; i++) {
      Rect rect = new Rect.fromLTWH(
          padding + (22 * lineWidth + (strlen * 11 + i) * lineWidth),
          top,
          lineWidth,
          height);
      ((0x1000 & (endFlag << i)) == 0x1000)
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
                (size.width - data.length * 8 * lineWidth) / 2 +
                    8 * i * lineWidth,
                top + height));
      }
    }
  }
}
