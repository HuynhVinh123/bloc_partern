import 'package:flutter/material.dart';

/// Truyền vào một Icon và bọc nó trong một lớp được trang trí bằng shape và gradient bên ngoài
class FavoriteMenuIcon extends StatelessWidget {
  const FavoriteMenuIcon(
      {Key key, @required this.icon, @required this.gradient})
      : assert(icon != null),
        assert(gradient != null),
        super(key: key);
  final Widget icon;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: gradient,
      ),
      child: SizedBox(
        height: 47,
        width: 47,
        child: IconTheme(
          child: icon,
          data: const IconThemeData(
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}
