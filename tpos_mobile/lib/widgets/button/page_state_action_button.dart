import 'package:flutter/material.dart';

/// Nút nhấn mặc định sử dụng cho [PageState]
/// Bo tròn góc + có icon bên trong
class PageStateActionButton extends StatelessWidget {
  const PageStateActionButton({Key key, this.icon, this.child, this.onPressed})
      : super(key: key);
  final Widget child;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      onPressed: onPressed,
      icon: icon ?? const SizedBox(),
      label: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: child,
      ),
    );
  }
}
