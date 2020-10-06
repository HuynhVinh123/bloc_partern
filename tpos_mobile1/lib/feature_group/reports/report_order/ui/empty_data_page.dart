import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class EmptyDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Lottie.asset('assets/lottie/empty.json',
            fit: BoxFit.fill, width: 100, height: 100),
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
