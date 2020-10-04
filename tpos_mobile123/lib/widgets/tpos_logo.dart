import 'package:flutter/material.dart';

class TPosLogo extends StatelessWidget {
  final double width;

  const TPosLogo({Key key, this.width = 200}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/tpos_logo_512.png',
      width: width,
    );
  }
}
