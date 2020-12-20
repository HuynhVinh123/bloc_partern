import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import 'favorite_menu_icon.dart';

/// Gộp một menu bao gồm icon, tiêu đề
class FavoriteMenuItem extends StatelessWidget {
  const FavoriteMenuItem(
      {Key key,
      this.title,
      this.icon,
      this.gradient,
      this.width,
      this.onPressed,
      this.badge,
      this.onDeleted})
      : super(key: key);
  final String title;
  final Widget icon;
  final LinearGradient gradient;
  final double width;
  final VoidCallback onPressed;
  final VoidCallback onDeleted;
  final String badge;

  @override
  Widget build(BuildContext context) {
    final Widget menuContent = Column(
      mainAxisSize: MainAxisSize.min, // Để không bị lỗi
      children: [
        const SizedBox(
          height: 10,
        ),
        FavoriteMenuIcon(
          icon: icon ?? const SizedBox(),
          gradient: gradient ??
              const LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white,
                ],
              ),
        ),
        const SizedBox(
          height: 10,
        ),
        Flexible(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xff484D54),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );

    final Widget menuNewWrapNew = Badge(
      child: menuContent,
      badgeColor: Colors.red,
      shape: BadgeShape.square,
      borderRadius: BorderRadius.circular(30),
      padding: const EdgeInsets.only(left: 8, right: 8),
      position: BadgePosition.topEnd(top: 5, end: 5),
      badgeContent: Text(
        badge ?? '',
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
    );

    final Widget menuWrapDelete = Stack(
      alignment: Alignment.topCenter,
      children: [
        menuContent,
        Align(
          child: InkWell(
            onTap: onDeleted,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFFE3E7E9)),
              child: const Icon(
                Icons.close,
                size: 16,
                color: Colors.grey,
              ),
            ),
          ),
          alignment: Alignment.topRight,
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: onDeleted != null
              ? menuWrapDelete
              : badge != null
                  ? menuNewWrapNew
                  : menuContent,
        ),
      ),
    );
  }
}
