import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemFastReply extends StatelessWidget {
  const ItemFastReply({this.title, this.content, this.replies, this.actions});

  final String title;
  final String content;

  final List<String> replies;
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
            "[Mặc định] Mẫu gửi tin nhắn đơn hàng áo",
            style: TextStyle(color: Color(0xFF2C333A), fontSize: 16),
          ),
          const SizedBox(height: 10,),
          Text(
            "Xin chào {partner.name}, {order} Cảm ơn ...",
            style: TextStyle(color: Color(0xFF6B7280), fontSize: 15),
          ),
          const SizedBox(height: 10,),
          Flexible(
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    children: [
                      Container(
                        decoration: BoxDecoration(color: const Color(0xFFEBEDEF),borderRadius: BorderRadius.circular(6)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        child: Text("/dh"),
                      )
                    ],
                  ),
                ),
                actions ??
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: 24,
                            height: 24,
                            child: const Icon(
                              Icons.edit,
                              size: 19,
                              color: Color(0xFFA7B2BF),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: 24,
                            height: 24,
                            child: const Icon(
                              Icons.delete,
                              size: 19,
                              color: Color(0xFFA7B2BF),
                            ),
                          ),
                        )
                      ],
                    ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
