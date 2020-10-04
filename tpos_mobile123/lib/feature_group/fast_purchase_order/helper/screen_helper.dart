import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/tablet_detector.dart';

void updateScreenResolution(BuildContext context) {
  double screenWidth, screenHeight;
  Size size = MediaQuery.of(context).size;
  screenWidth = size.width;
  screenHeight = size.height;
  if (TabletDetector.isTablet(MediaQuery.of(context))) {
    if (screenWidth < screenHeight) {
      ScreenUtil.instance = ScreenUtil(width: 1536, height: 2048)
        ..init(context);
    } else {
      ScreenUtil.instance = ScreenUtil(width: 2048, height: 1536)
        ..init(context);
    }
  } else {
    if (screenWidth < screenHeight) {
      ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    } else {
      ScreenUtil.instance = ScreenUtil(width: 1334, height: 750)..init(context);
    }
  }
}

bool isPortrait(BuildContext context) {
  return getScreenHeight(context) > getScreenWidth(context);
}

bool isLandScape(BuildContext context) {
  return !isPortrait(context);
}

bool isTablet(BuildContext context) {
  return TabletDetector.isTablet(MediaQuery.of(context));
}

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getHalfPortraitWidth(BuildContext context) {
  return isPortrait(context)
      ? getScreenWidth(context) / 2
      : getScreenHeight(context) / 2;
}
