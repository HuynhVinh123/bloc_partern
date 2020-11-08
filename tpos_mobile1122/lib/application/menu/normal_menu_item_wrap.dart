import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'package:tpos_mobile/application/menu/menu_widget.dart';
import 'package:tpos_mobile/application/menu/other_menu_page.dart';

/// Wrappber bên ngoài danh sách menu
class NormalMenuItemWrap extends StatelessWidget {
  const NormalMenuItemWrap(
      {Key key,
      this.children = const [],
      this.title,
      this.background = Colors.grey,
      @required this.onReorder,
      this.reorderEnable = false,
      this.onAddPressed,
      this.onUpPressed,
      this.onDownPressed,
      this.onDeleted,
      this.maxLine,
      this.onTitlePressed,
      this.contentPadding})
      : super(key: key);
  final List<Widget> children;
  final Text title;
  final Color background;
  final Function(int lastIndex, int newIndex) onReorder;
  final bool reorderEnable;
  final int maxLine;
  final VoidCallback onAddPressed;
  final VoidCallback onUpPressed;
  final VoidCallback onDownPressed;
  final VoidCallback onDeleted;
  final VoidCallback onTitlePressed;
  final EdgeInsets contentPadding;

  Widget get container => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 16, right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: LayoutBuilder(
          builder: (context, constraint) {
            /// Số cột tính theo tỉ lệ [width] màn hình
            final int columnCount = constraint.maxWidth < 700 ? 4 : 6;

            /// Kích thước [widt] một phần tử được tính theo số cột
            final double itemWidth = constraint.maxWidth / columnCount;

            /// Số menu tối đa được hiển thị
            int maxItem = 0;
            if (maxLine == null || maxLine == 0) {
              maxItem = children.length;
            } else {
              maxItem = maxLine * columnCount - 1;
            }

            final List<Widget> child = <Widget>[
              //

              ...children
                  .take(maxItem)
                  .map(
                    (e) => SizedBox(
                      width: itemWidth,
                      child: e,
                    ),
                  )
                  .toList(),
              // Hiện nút xem thêm nếu [maxline] được cài đặt và [children] có số phần tử lớn hơn maxItem -1
              if (maxLine != null && children.length >= maxItem)
                SizedBox(
                  width: itemWidth,
                  child: Hero(
                    tag: title ?? 'hero',
                    transitionOnUserGestures: true,
                    createRectTween: (begin, end) =>
                        MaterialRectCenterArcTween(begin: begin, end: end),
                    child: NormalMenuItem(
                      name: 'Xem thêm',
                      icon: const Icon(Icons.more_horiz),
                      canDelete: false,
                      hasPermission: true,
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            opaque: false,
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            pageBuilder: (_, __, ___) => Hero(
                              tag: title ?? 'hero',
                              child: OtherMenuPage(
                                menuItems: children.skip(maxItem).toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ];
            return Wrap(
              runSpacing: 10,
              children: child,
            );
          },
        ),
      );

  Widget get container2 => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 16, right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: LayoutBuilder(
          builder: (context, constraint) {
            final int columnCount = constraint.maxWidth < 700 ? 4 : 6;
            final double itemWidth = constraint.maxWidth / columnCount;
            return ReorderableWrap(
              runSpacing: 10,
              children: children
                  .map(
                    (e) => SizedBox(
                      width: constraint.maxWidth / 4,
                      child: e,
                    ),
                  )
                  .toList(),
              onReorder: onReorder,
              footer: SizedBox(
                width: itemWidth,
                child: NormalMenuItem(
                  onPressed: onAddPressed,
                  isEdit: false,
                  icon: const Icon(Icons.add),
                  name: 'Thêm ',
                  canDelete: false,
                  hasPermission: true,
                ),
              ),
            );
          },
        ),
      );

  Widget get normalHeader => Padding(
        padding: const EdgeInsets.only(left: 16, right: 12),
        child: DecoratedBox(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
            child: title,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: background,
          ),
        ),
      );

  Widget get reorderHeader => Padding(
        padding: const EdgeInsets.only(left: 16, right: 12),
        child: Row(
          children: [
            Expanded(
              child: DecoratedBox(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 4, bottom: 4),
                  child: title,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: background,
                ),
              ),
            ),
            InkWell(
              child: const Icon(
                Icons.edit,
                color: Colors.grey,
                size: 24,
              ),
              onTap: onTitlePressed,
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.blue,
              ),
              onPressed: onUpPressed,
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_downward,
                color: Colors.grey,
              ),
              onPressed: onDownPressed,
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever),
              color: Colors.red,
              onPressed: onDeleted,
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (title != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (reorderEnable) reorderHeader else normalHeader,
          const SizedBox(height: 10),
          if (reorderEnable) container2 else container,
          const SizedBox(height: 10),
        ],
      );
    }

    return container;
  }
}
