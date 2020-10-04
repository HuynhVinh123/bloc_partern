import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:tpos_mobile/widgets/form_field/permission_deny_field.dart';

class InputNumberField extends StatelessWidget {
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

  InputNumberField({
    Key key,
    this.controller,
    this.onNumberChanged,
    this.onTextChanged,
    this.focusNode,
    this.nextFocusNode,
    this.hint,
    this.title,
    this.titleString,
    this.hasPermission = true,
    this.icon,
  }) : super(key: key) {
    assert((title != null && titleString != null) == false);
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        icon ?? SizedBox(),
        new Expanded(
          flex: 3,
          child: title != null
              ? title
              : Text(
                  titleString ?? '',
                  style: TextStyle(fontSize: 16.0),
                ),
        ),
        new Expanded(
          flex: 3,
          child: hasPermission ? _inputField(context) : PermissionDenyField(),
        ),
      ],
    );
  }

  Widget _inputField(BuildContext context) {
    return TextField(
      onChanged: (value) {
        if (onTextChanged != null) {
          onTextChanged(value);
        }
      },
      controller: controller,
      onTap: () {
        controller.selection =
            TextSelection(baseOffset: 0, extentOffset: controller.text.length);
      },
      textAlign: TextAlign.end,
      focusNode: focusNode,
      onEditingComplete: () {
        focusNode.unfocus();
        FocusScope.of(context).requestFocus(nextFocusNode);
      },
      keyboardType: TextInputType.numberWithOptions(),
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        hintText: "Nhập giá bán",
        contentPadding: EdgeInsets.all(12),
        border: InputBorder.none,
      ),
    );
  }
}
