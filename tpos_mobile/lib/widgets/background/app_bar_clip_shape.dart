import 'package:flutter/material.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/custom_shape.dart';

/// UI dùng cho appbar có đổ màu LinearGradient theo thiết kế và CustomShape hình cong bên dưới
class AppbarClipShape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: MyClipper(),
          child: Container(
            height: 220,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-1.0, 1.0),
                end: Alignment(0.5, -1.0),
                stops: [
                  0.1,
                  0.5,
                  0.5,
                  0.9,
                ],
                colors: [
                  Color(0xff1d7d27),
                  Color(0xff3ba734),
                  Color(0xff43af35),
                  Color(0xff63c938),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
