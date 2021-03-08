import 'package:flutter/material.dart';

import 'app_filter_expansion_tile.dart';

///Filter panel bao gồm check box, tile
class AppFilterPanel extends StatelessWidget {
  const AppFilterPanel(
      {Key key,
      this.isSelected = false,
      @required this.title,
      this.children,
      this.isEnable = true,
      this.onSelectedChange})
      : assert(isEnable != null),
        assert(title != null),
        super(key: key);
  final bool isSelected;
  final Widget title;
  final List<Widget> children;
  final ValueChanged<bool> onSelectedChange;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !isEnable,
      child: AppFilterExpansionTile(
        leading: isSelected
            ? const Icon(Icons.check_box)
            : const Icon(Icons.check_box_outline_blank),
        title: title,
        children: children ?? <Widget>[],
        onExpansionChanged: onSelectedChange,
        initiallyExpanded: isSelected,
      ),
    );
  }
}
