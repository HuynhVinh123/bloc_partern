import 'package:flutter/material.dart';

class AppbarIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final bool isEnable;
  AppbarIconButton({this.icon, this.onPressed, this.isEnable = true});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isEnable ? onPressed : null,
      icon: icon,
    );
  }
}
