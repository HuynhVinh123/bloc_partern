import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final Widget child;

  const ActionButton(
      {Key key, this.onPressed, this.color, this.child, this.textColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 42,
      child: RaisedButton(
        onPressed: onPressed,
        color: color,
        textColor: textColor,
        child: child,
        shape: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
