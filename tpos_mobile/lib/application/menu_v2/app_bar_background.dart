import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: SvgPicture.asset('assets/svg/appbar_background.svg'),
    );
  }
}
