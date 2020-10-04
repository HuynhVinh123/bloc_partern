import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcons {
  AppIcons._();
  static Widget menuHome({Color color}) => SvgPicture.asset(
        'assets/icon/bottom_navigation_icon_home.svg',
        color: color,
      );
}
