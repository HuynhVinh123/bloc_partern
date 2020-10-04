import 'package:flutter/material.dart';

class AppFilterBool extends StatelessWidget {
  final Key key;
  final Widget title;
  final bool value;
  final ValueChanged<bool> onSelectedChange;
  AppFilterBool(
      {this.key, this.title, this.value = false, this.onSelectedChange})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: <Widget>[
          Checkbox(
            value: value,
            onChanged: onSelectedChange,
          ),
          Expanded(child: title)
        ],
      ),
      onTap: onSelectedChange != null
          ? () {
              onSelectedChange(!value);
            }
          : null,
    );
  }
}
