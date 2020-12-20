import 'package:flutter/material.dart';

class ItemExpandWidgetConversation extends StatefulWidget {
  /// Dùng mở rộng thu nhỏ của các widget trong hội thoại (Mở rộng theo nhân viên, theo nhãn,thời gian,....)
  ItemExpandWidgetConversation(
      {this.isCheck, this.itemExpanse, this.title, this.child})
      : assert(isCheck != null ||
            itemExpanse != null ||
            title != null ||
            child != null);

  ///Giá trị checkbox
  bool isCheck;

  ///Trạng thái mở rộng thu nhỏ của item
  bool itemExpanse;

  ///Tiêu đề
  final String title;

  ///Widget con khi mở rộng
  Widget child;
  @override
  _ItemExpandWidgetConversationState createState() =>
      _ItemExpandWidgetConversationState();
}

///Checlbox item
class _ItemExpandWidgetConversationState
    extends State<ItemExpandWidgetConversation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                    value: widget.isCheck,
                    onChanged: (bool value) {
                      setState(() {
                        widget.isCheck = value;
                      });
                    }),
                Text(
                  widget.title,
                  style: const TextStyle(color: Color(0xFF2C333A)),
                ),
              ],
            ),
            IconButton(
                icon: widget.itemExpanse
                    ? const Icon(Icons.keyboard_arrow_down,
                        color: Color(0xFFa7b2bf))
                    : const Icon(
                        Icons.keyboard_arrow_up,
                        color: Color(0xFFa7b2bf),
                      ),
                onPressed: () {
                  setState(() {
                    widget.itemExpanse = !widget.itemExpanse;
                  });
                }),
          ],
        ),
        if (widget.itemExpanse) widget.child else const SizedBox()
      ],
    );
  }
}
