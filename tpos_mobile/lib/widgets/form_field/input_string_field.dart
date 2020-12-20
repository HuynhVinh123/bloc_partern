import 'package:flutter/material.dart';

class InputStringField extends StatelessWidget {
  const InputStringField(
      {Key key,
      this.controller,
      this.hint,
      this.label,
      this.textStyle,
      this.maxLines = 1,
      this.textInputType,
      this.textInputAction,
      this.minLines,
      this.validator,
      this.onChanged,
      this.initialValue})
      : super(key: key);
  final TextEditingController controller;
  final String hint;
  final String label;
  final TextStyle textStyle;
  final int maxLines;
  final int minLines;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onChanged;
  final String initialValue;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
      ),
      style: textStyle,
      maxLines: maxLines,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      minLines: minLines,
      validator: validator,
      onChanged: onChanged,
      initialValue: initialValue,
    );
  }
}
