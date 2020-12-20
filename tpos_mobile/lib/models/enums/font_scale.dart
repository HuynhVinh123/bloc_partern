import 'package:flutter/foundation.dart';

enum FontScale {
  scale80,
  scale90,
  scale100,
  scale110,
  scale120,
  scale130,
  scale140,
  scale150,
  scale160,
  scale170,
  scale180,
  scale190,
  scale200,
}

extension FontScaleExtension on FontScale {
  String describe() {
    return describeEnum(this);
  }

  String getDescription() {
    switch (this) {
      case FontScale.scale80:
        return "80 %";
      case FontScale.scale90:
        return "90 %";
      case FontScale.scale100:
        return "100 %";
      case FontScale.scale110:
        return "110 %";

      case FontScale.scale120:
        return "120 %";
        break;
      case FontScale.scale130:
        return "130 %";
        break;
      case FontScale.scale140:
        return "140 %";
        break;
      case FontScale.scale150:
        return "150 %";
        break;
      case FontScale.scale160:
        return "160 %";
        break;
      case FontScale.scale170:
        return "170 %";
        break;
      case FontScale.scale180:
        return "180 %";
        break;
      case FontScale.scale190:
        return "190 %";
        break;
      case FontScale.scale200:
        return "200 %";
        break;
      default:
        return "100 %";
    }
  }

  double getScale() {
    switch (this) {
      case FontScale.scale80:
        return 0.8;
      case FontScale.scale90:
        return 0.9;
      case FontScale.scale100:
        return 1.0;
      case FontScale.scale110:
        return 1.1;

      case FontScale.scale120:
        return 1.2;

      case FontScale.scale130:
        return 1.3;
        break;
      case FontScale.scale140:
        return 1.4;
        break;
      case FontScale.scale150:
        return 1.5;
        break;
      case FontScale.scale160:
        return 1.6;
        break;
      case FontScale.scale170:
        return 1.7;
        break;
      case FontScale.scale180:
        return 1.8;
        break;
      case FontScale.scale190:
        return 1.9;
        break;
      case FontScale.scale200:
        return 2.0;
        break;
      default:
        return 1.0;
    }
  }
}
