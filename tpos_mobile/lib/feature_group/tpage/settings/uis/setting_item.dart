import 'package:flutter/material.dart';

/// UI hiển thị Item cho trang setting
class SettingItem extends StatelessWidget {
  const SettingItem(
      {@required this.title,
      @required this.icon,
      this.onTap,
      this.isLine = true})
      : assert(icon != null && title != null);
  final String title;
  final Widget icon;
  final VoidCallback onTap;
  final bool isLine;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 12),
                decoration: const BoxDecoration(
                    color: Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                width: 40,
                height: 40,
                child: Center(
                  child: icon,
                ),
              ),
              Text(
                title ?? "",
                style: const TextStyle(color: Color(0xFF2C333A)),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            size: 19,
            color: Color(0xFFCDD3DB),
          ),
          onTap: onTap ?? () {},
        ),
        if (isLine)
          const Padding(
            padding: EdgeInsets.only(left: 68, right: 16, top: 4, bottom: 4),
            child: Divider(
              height: 1,
            ),
          )
        else
          const SizedBox(),
      ],
    );
  }
}
