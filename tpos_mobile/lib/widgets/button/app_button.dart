import 'package:flutter/material.dart';

///Xây dựng giao diện nhấn nút sẵn
class AppButton extends StatelessWidget {
  const AppButton(
      {this.width,
      this.height,
      this.borderRadius,
      this.onPressed,
      this.child,
      this.background,
      this.border,
      this.decoration,
      this.padding});

  final Widget child;
  final double width;
  final double height;
  final double borderRadius;
  final Function onPressed;
  final Color background;
  final Border border;
  final Decoration decoration;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: decoration ??
          BoxDecoration(
              color: background ?? const Color(0xff0F7EFF),
              borderRadius: BorderRadius.circular(borderRadius ?? 5),
              border: border),
      child: FlatButton(
        padding: padding ?? EdgeInsets.zero,
        child: Center(child: child ?? const SizedBox()),
        onPressed: () {
          if (onPressed != null) {
            onPressed();
          }
        },
      ),
    );
  }
}
