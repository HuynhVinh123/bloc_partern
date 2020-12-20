import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'package:tpos_mobile/resources/menus.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import 'favorite_menu_item.dart';
import 'package:tmt_flutter_untils/tmt_flutter_utils.dart';

class FavoriteMenuContainer extends StatelessWidget {
  const FavoriteMenuContainer({
    Key key,
    this.items = const <FavoriteMenuItem>[],
    this.column,
    this.isCustomize = false,
    this.onReorder,
    this.onAddPressed,
  })  : assert(items != null),
        assert(isCustomize != null),
        super(key: key);
  final List<FavoriteMenuItem> items;
  final int column;
  final bool isCustomize;
  final ReorderCallback onReorder;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    Widget wrap(double itemSize) => Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          runSpacing: 10,
          children: items
              .map(
                (e) => SizedBox(
                  width: itemSize,
                  child: e,
                ),
              )
              .toList(),
        );

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

    final int numberOfColumn = column ?? context.isTablet ? 8 : 4;
    return Container(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: LayoutBuilder(builder: (context, constraint) {
        final double itemSize = constraint.maxWidth / numberOfColumn;
        return isCustomize ? wrapOrder(itemSize) : wrap(itemSize);
      }),
    );
  }
}
