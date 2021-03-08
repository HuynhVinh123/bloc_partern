import 'package:flutter/material.dart';

class InputCheckbox extends StatelessWidget {
  const InputCheckbox({Key key, this.value, this.onChanged, this.title})
      : super(key: key);
  final bool value;
  final ValueChanged<bool> onChanged;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Text(title ?? ''),
      ],
    );
  }
}
