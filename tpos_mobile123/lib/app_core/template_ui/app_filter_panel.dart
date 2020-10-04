import 'package:flutter/material.dart';

import 'app_filter_expansion_tile.dart';

///Filter panel bao gồm check box, tile
class AppFilterPanel extends StatelessWidget {
  final bool isSelected;
  final Key key;
  final Widget title;
  final List<Widget> children;
  final ValueChanged<bool> onSelectedChange;
  final bool isEnable;
  AppFilterPanel(
      {this.key,
      this.isSelected = false,
      this.title,
      this.children,
      this.isEnable = true,
      this.onSelectedChange});
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !isEnable,
      child: AppFilterExpansionTile(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: isSelected
              ? Icon(Icons.check_box)
              : Icon(Icons.check_box_outline_blank),
        ),
        title: title,
        children: children ?? new List<Widget>(),
        onExpansionChanged: onSelectedChange,
        initiallyExpanded: isSelected,
      ),
    );
  }
}
