import 'package:flutter/material.dart';
import 'package:tpos_mobile/resources/app_colors.dart';

class BottomSingleButton extends StatelessWidget {
  const BottomSingleButton(
      {Key key,
      this.title,
      this.color,
      this.textColor,
      this.onPressed,
      this.hideOnKeyboard = false})
      : super(key: key);
  final String title;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;
  final bool hideOnKeyboard;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          color: color ?? AppColors.access,
          textColor: textColor ?? Colors.white,
          onPressed: onPressed,
          child: Text(title ?? ''),
        ),
      ),
    );
  }
}
