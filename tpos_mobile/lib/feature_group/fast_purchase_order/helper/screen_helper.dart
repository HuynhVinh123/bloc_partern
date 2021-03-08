import 'package:flutter/material.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/tablet_detector.dart';

bool isPortrait(BuildContext context) {
  return getScreenHeight(context) > getScreenWidth(context);
}

bool isLandScape(BuildContext context) {
  return !isPortrait(context);
}

bool isTablet(BuildContext context) {
  return TabletDetector.isTablet(MediaQuery.of(context));
}

@Deprecated(
    'Sử dụng context.size.width thay thế hoặc MediaQuery.of(context).size.width trực tiếp trong ui')
double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

@Deprecated(
    'Sử dụng context.size.height thay thế hoặc MediaQuery.of(context).size.height trực tiếp trong ui')
double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getHalfPortraitWidth(BuildContext context) {
  return isPortrait(context)
      ? getScreenWidth(context) / 2
      : getScreenHeight(context) / 2;
}
