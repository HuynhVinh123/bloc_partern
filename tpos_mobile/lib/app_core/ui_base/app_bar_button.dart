import 'package:flutter/material.dart';

class AppbarIconButton extends StatelessWidget {
  const AppbarIconButton({this.icon, this.onPressed, this.isEnable = true});
  final Widget icon;
  final VoidCallback onPressed;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isEnable ? onPressed : null,
      icon: icon,
    );
  }
}
