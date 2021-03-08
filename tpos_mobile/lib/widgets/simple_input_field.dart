import 'package:flutter/material.dart';

class SimpleInputField extends StatelessWidget {
  const SimpleInputField(
      {this.leading,
      this.title,
      this.content,
      this.trailing,
      this.contentPadding = const EdgeInsets.all(8)});
  final Widget leading;
  final Widget title;
  final Widget content;
  final Widget trailing;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: contentPadding,
      child: Row(
        children: <Widget>[
          leading ?? const SizedBox(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: title ?? const SizedBox(),
            ),
          ),
          content ?? const SizedBox(),
          trailing ?? const SizedBox(),
        ],
      ),
    );
  }
}
