import 'package:flutter/material.dart';

/// UI hiển thị nhãn
class TagItem extends StatelessWidget {
  const TagItem(
      {@required this.stateColor,
      @required this.title,
      @required this.backGroundColor,
      @required this.stateText,
      this.isUnderLine,
      this.onTap,
      this.actions})
      : assert(stateColor != null &&
            title != null &&
            backGroundColor != null &&
            stateText != null);

  final Color stateColor;
  final Color backGroundColor;
  final String title;
  final String stateText;
  final VoidCallback onTap;
  final Widget actions;

  /// Nếu true thì ở dưới sẽ có gạch chân, false thì ẩn gạch chần đi. Dùng cho item cuối cùng sẽ ko hiển thị underline
  final bool isUnderLine;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
              onTap: onTap ?? () {},
              leading: Container(
                margin: const EdgeInsets.only(top: 4),
                height: 25,
                width: 40,
                decoration: BoxDecoration(
                    color: stateColor,
                    borderRadius: const BorderRadius.all(Radius.circular(13))),
              ),
              title: Text(title),
              subtitle: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 6),
                    height: 6,
                    width: 6,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: backGroundColor),
                  ),
                  Text(
                    stateText,
                    style:
                        const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                  )
                ],
              ),
              trailing: actions ?? const SizedBox()),
          if (isUnderLine)
            const Padding(
              padding: EdgeInsets.only(left: 68, right: 16, bottom: 4),
              child: Divider(
                height: 1,
              ),
            )
          else
            const SizedBox()
        ],
      ),
    );
  }
}
