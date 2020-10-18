import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';

class InputDateField extends StatelessWidget {
  const InputDateField(
      {Key key,
      this.initialValue,
      this.format,
      this.label,
      this.hint,
      this.controller,
      this.onChanged,
      this.firstDate,
      this.lastDate})
      : super(key: key);
  final DateTime initialValue;
  final String format;
  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<DateTime> onChanged;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: InkWell(
          child: Icon(Icons.calendar_today),
          onTap: () async {
            final date = await showDatePicker(
                context: context,
                initialDate: initialValue,
                firstDate: firstDate,
                lastDate: lastDate);

            onChanged(date);
          },
        ),
      ),
      enabled: true,
      readOnly: false,
      onShowPicker: (context, value) {
        return showDatePicker(
            context: context,
            initialDate: initialValue,
            firstDate: firstDate,
            lastDate: lastDate);
      },
      format: DateFormat(format),
      onChanged: onChanged,
    );
  }
}
