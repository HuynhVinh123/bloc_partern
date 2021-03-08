import 'package:flutter/material.dart';

/// UI hiển thị thông tin item trả lời nhanh
class FastReplyItem extends StatelessWidget {
  const FastReplyItem({this.title, this.content, this.keyBoard, this.actions});

  final String title;
  final String content;
  final String keyBoard;
  final Widget actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title ?? "",
              style: const TextStyle(color: Color(0xFF2C333A), fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              content ?? "",
              style: const TextStyle(color: Color(0xFF6B7280), fontSize: 15),
            ),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFFEBEDEF),
                            borderRadius: BorderRadius.circular(6)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        child: const Text("/"),
                      ),
                    ),
                  ),
                  actions ?? const SizedBox()
                ],
              ),
            )
          ],
        ));
  }
}
