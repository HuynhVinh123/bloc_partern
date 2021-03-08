import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import 'favorite_menu_item.dart';

/// S
class FavoriteMenuContainer extends StatelessWidget {
  const FavoriteMenuContainer({
    Key key,
    this.items = const <FavoriteMenuItem>[],
    @required this.column,
    this.isCustomize = false,
    this.onReorder,
    this.onAddPressed,
    this.maxRow,
  })  : assert(items != null),
        assert(isCustomize != null),
        super(key: key);
  final List<FavoriteMenuItem> items;

  /// Number of column of item.
  final int column;
  final int maxRow;

  /// Indicators whether the widget is on [custom mode] state.
  final bool isCustomize;
  final ReorderCallback onReorder;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    /// Wrap item in a Normal wrap
    Widget wrap(double itemSize) => Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          runSpacing: 10,
          spacing: 0,
          children: items
              .map(
                (e) => SizedBox(
                  width: itemSize,
                  child: e,
                ),
              )
              .toList(),
        );

    /// Wrap item in ReorderableWrap.
    Widget wrapOrder(double itemSize) => ReorderableWrap(
          runSpacing: 10,
          children: items
              .map(
                (e) => SizedBox(
                  width: itemSize,
                  child: e,
                ),
              )
              .toList(),
          onReorder: onReorder,
          // THêm
          footer: SizedBox(
            width: itemSize,
            child: FavoriteMenuItem(
              title: S.current.add,
              onPressed: onAddPressed,
              gradient: const LinearGradient(colors: [
                Color(0xff929DA9),
                Color(0xff929DA9),
              ]),
              icon: const Icon(Icons.add),
            ),
          ),
        );
    return Container(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: LayoutBuilder(builder: (context, constraint) {
        final double itemSize = (constraint.maxWidth / column) - 0.5;
        return isCustomize ? wrapOrder(itemSize) : wrap(itemSize);
      }),
    );
  }
}
