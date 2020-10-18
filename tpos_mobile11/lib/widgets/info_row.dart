import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({
    this.title,
    this.content,
    this.padding =
        const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
    this.contentString,
    this.titleString,
    this.titleColor = Colors.black,
    this.contentColor = Colors.green,
    this.contentTextStyle,
  });
  final Widget title;
  final Widget content;
  final String titleString;
  final String contentString;
  final EdgeInsetsGeometry padding;
  final Color titleColor;
  final Color contentColor;
  final TextStyle contentTextStyle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            title ??
                (Text(
                  titleString ?? "",
                  style: TextStyle(color: titleColor),
                )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: content ??
                  Text(
                    contentString ?? "",
                    style: contentTextStyle ?? TextStyle(color: contentColor),
                    textAlign: TextAlign.right,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
