import 'package:flutter/material.dart';

import 'app_filter_expansion_tile.dart';

///Widget chọn điều kiện lọc theo đối tượng
///Ví dụ : Theo khách hàng, nhà cung cấp, sản phẩm, danh mục....
class AppFilterObject extends StatelessWidget {
  final Key key;
  final Widget title;
  final String content;
  final String hint;
  final bool isSelected;
  final bool isEnable;
  final ValueChanged<bool> onSelectChange;
  final VoidCallback onSelect;
  AppFilterObject({
    this.key,
    this.title,
    this.hint,
    this.content,
    this.onSelectChange,
    this.isEnable = true,
    @required this.isSelected,
    this.onSelect,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !isEnable,
      child: AppFilterExpansionTile(
        initiallyExpanded: isSelected,
        onExpansionChanged: onSelectChange,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: isSelected
              ? Icon(Icons.check_box)
              : Icon(Icons.check_box_outline_blank),
        ),
        title: title,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: OutlineButton(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: content == null ? Text("$hint") : Text(content),
                    ),
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
              onPressed: onSelect ?? null,
            ),
          ),
        ],
      ),
    );
  }
}
