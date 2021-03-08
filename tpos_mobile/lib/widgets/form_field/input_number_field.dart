import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:tpos_mobile/widgets/form_field/permission_deny_field.dart';

class InputNumberField extends StatelessWidget {
  InputNumberField({
    Key key,
    @required this.controller,
    this.onNumberChanged,
    this.onTextChanged,
    this.focusNode,
    this.nextFocusNode,
    this.hint,
    this.title,
    this.titleString,
    this.hasPermission = true,
    this.icon,
    this.valueStyle,
    this.underline = true,
    this.onEditCompleted,
    this.textInputAction,
    this.initialValue,
    this.validator,
  })  : assert((title != null && titleString != null) == false),
        super(key: key);
  final MoneyMaskedTextController controller;
  final ValueChanged<double> onNumberChanged;
  final ValueChanged<String> onTextChanged;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final String hint;
  final Widget title;
  final String titleString;
  final bool hasPermission;
  final Widget icon;
  final TextStyle valueStyle;
  final bool underline;
  final VoidCallback onEditCompleted;
  final TextInputAction textInputAction;
  final double initialValue;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    if (initialValue != null && initialValue != controller.numberValue) {
      controller.updateValue(initialValue);
    }
    return Row(
      children: <Widget>[
        icon ?? const SizedBox(),
        Expanded(
          flex: 3,
          child: title ??
              Text(
                titleString ?? '',
                style: const TextStyle(fontSize: 16.0),
              ),
        ),
        Expanded(
          flex: 3,
          child: hasPermission ? _inputField(context) : PermissionDenyField(),
        ),
      ],
    );
  }

  Widget _inputField(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        if (onTextChanged != null) {
          onTextChanged(value);
        }

        if (onNumberChanged != null) {
          onNumberChanged(controller.numberValue);
        }
      },
      controller: controller,
      onTap: () {
        controller.selection =
            TextSelection(baseOffset: 0, extentOffset: controller.text.length);
      },
      textAlign: TextAlign.end,
      focusNode: focusNode,
      onEditingComplete: onEditCompleted,
      keyboardType: const TextInputType.numberWithOptions(),
      textInputAction: TextInputAction.done,
      style: valueStyle ??
          const TextStyle(
            fontWeight: FontWeight.bold,
          ),
      decoration: InputDecoration(
        hintText: "Nhập giá bán",
        contentPadding: const EdgeInsets.all(12),
        border: underline
            ? UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade50),
              )
            : InputBorder.none,
      ),
      validator: validator,
    );
  }
}
