import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Lottie.asset('assets/lottie/empty.json',
            fit: BoxFit.fill,width: 100,height: 100),
        const Text(
          "không có dữ liệu!",
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 12,
        ),

      ],
    );
  }
}
