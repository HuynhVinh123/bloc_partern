import 'package:flutter/material.dart';
import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/lucky_wheel_tutorial_page.dart';

void showTutorial(BuildContext context) {
  showDialog(
      context: context,
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.only(top: 60),
        child: LuckyWheelTutorialPage(),
      ));
}
