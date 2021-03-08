import 'package:flutter/material.dart';

class TPosLogo extends StatelessWidget {
  const TPosLogo({Key key, this.width = 200}) : super(key: key);
  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/tpos_logo_512.png',
      width: width,
    );
  }
}
