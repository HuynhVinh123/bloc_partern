import 'package:flutter/material.dart';

class SimpleInputField extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget content;
  final Widget trailing;
  final EdgeInsetsGeometry contentPadding;

  SimpleInputField(
      {this.leading,
      this.title,
      this.content,
      this.trailing,
      this.contentPadding = const EdgeInsets.all(8)});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: contentPadding,
      child: Row(
        children: <Widget>[
          leading ?? SizedBox(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: title ?? SizedBox(),
            ),
          ),
          content ?? SizedBox(),
          trailing ?? SizedBox(),
        ],
      ),
    );
  }
}
