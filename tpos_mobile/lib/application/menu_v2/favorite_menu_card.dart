import 'package:flutter/material.dart';

/// Một UI Card bọc bên ngoài một widget khác
///
/// + Default border radius is 16
/// + Default color is white with opacity 0.85
/// + Default box shadow y = 5, radius = 30
class FavoriteMenuCard extends StatelessWidget {
  ///  Tạo một cái UI kiểu Card với các thông số mặc định
  ///
  /// + Default border radius is 16
  /// + Default color is white with opacity 0.85
  /// + Default box shadow y = 5, radius = 30
  const FavoriteMenuCard({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          16,
        ),
        color: Colors.white.withOpacity(0.85),
        boxShadow: const [
          BoxShadow(
            color: Color(0xffE6E6E6),
            offset: Offset(0, 5),
            blurRadius: 30,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}
