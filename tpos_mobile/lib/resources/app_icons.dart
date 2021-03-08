import 'package:flutter/material.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';

class AppIcons {
  AppIcons._();
  static Widget menuHome({Color color}) => SvgIcon(
        SvgIcon.homeNavigation,
        color: color,
      );
}
