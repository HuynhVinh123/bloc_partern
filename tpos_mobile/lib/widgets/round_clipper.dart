import 'package:flutter/cupertino.dart';

class RoundClipper extends CustomClipper<Path> {
  RoundClipper({this.factor = 20.0});

  final double factor;

  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height - factor);
    path.quadraticBezierTo(0, size.height, factor, size.height);
    path.lineTo(size.width - factor, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(factor, 0);
    path.quadraticBezierTo(0, 0, 0, factor);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
