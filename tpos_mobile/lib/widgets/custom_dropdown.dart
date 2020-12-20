import 'package:flutter/material.dart';

/// Looks like a DropdownButton but has a few differences:
///
/// 1. Can be opened by a single tap even if the keyboard is showing (this might be a bug of the DropdownButton)
///
/// 2. The width of the overlay can be different than the width of the child
///
/// 3. The current selection is highlighted in the overlay
class CustomDropdown<T> extends PopupMenuButton<T> {
  CustomDropdown({
    Key key,
    @required PopupMenuItemBuilder<T> itemBuilder,
    @required T selectedValue,
    PopupMenuItemSelected<T> onSelected,
    PopupMenuCanceled onCanceled,
    String tooltip,
    double elevation = 8.0,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
    Icon icon,
    Offset offset = Offset.zero,
    Widget child,
    String placeholder = "Please select",
  }) : super(
          key: key,
          itemBuilder: itemBuilder,
          initialValue: selectedValue,
          onSelected: onSelected,
          onCanceled: onCanceled,
          tooltip: tooltip,
          elevation: elevation,
          padding: padding,
          icon: icon,
          offset: offset,
          child: child ??
              Stack(
                children: <Widget>[
                  Builder(
                    builder: (BuildContext context) => Container(
                      height: 48,
                      alignment: AlignmentDirectional.centerStart,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          DefaultTextStyle(
                            style: selectedValue != null
                                ? Theme.of(context).textTheme.subhead
                                : Theme.of(context).textTheme.subhead.copyWith(color: Theme.of(context).hintColor),
                            child: Expanded(child: selectedValue == null ? Text(placeholder) : child),
                          ),
                          IconTheme(
                            data: IconThemeData(
                              color: Theme.of(context).brightness == Brightness.light
                                  ? Colors.grey.shade700
                                  : Colors.white70,
                            ),
                            child: const Icon(Icons.arrow_drop_down),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    bottom: 8,
                    child: Container(
                      height: 1,
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xFFBDBDBD), width: 0.0)),
                      ),
                    ),
                  ),
                ],
              ),
        );
}
