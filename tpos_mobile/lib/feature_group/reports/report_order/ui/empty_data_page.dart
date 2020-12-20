import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class EmptyDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SvgIcon(
          SvgIcon.emptyData,
          size: 80,
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          S.current.noData,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
