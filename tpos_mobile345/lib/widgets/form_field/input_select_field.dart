import 'package:flutter/material.dart';

class InputSelectField extends StatelessWidget {
  const InputSelectField(
      {Key key,
      this.icon,
      this.title,
      this.content,
      this.trailing,
      this.onPressed})
      : super(key: key);
  final Widget icon;
  final Text title;
  final Text content;
  final Widget trailing;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding:
              const EdgeInsets.only(left: 0, right: 8, top: 12, bottom: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon ?? const SizedBox(),
              DefaultTextStyle(
                child: title ?? const SizedBox(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Expanded(
                  child: DefaultTextStyle(
                textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.black87),
                child: content ?? const SizedBox(),
              )),
              trailing ?? const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
