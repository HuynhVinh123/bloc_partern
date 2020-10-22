import 'package:flutter/material.dart';

class ItemTag extends StatelessWidget {
  const ItemTag(
      {@required this.stateColor,
      @required this.title,
      @required this.backGroundColor,
      @required this.stateText,
      this.onTap,
      this.actions
      })
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            onTap: onTap ?? () {},
            leading: Container(
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
                      const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                )
              ],
            ),
            trailing: actions ?? const SizedBox()
          ),
          const Padding(
            padding: EdgeInsets.only(left: 68, right: 16, top: 2, bottom: 4),
            child: Divider(
              height: 1,
            ),
          )
        ],
      ),
    );
  }
}
