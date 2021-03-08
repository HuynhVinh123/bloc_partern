import 'package:flutter/material.dart';

import 'alert_type.dart';

const EdgeInsets _defaultInsetPadding =
    EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0);

class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    Key key,
    this.title,
    this.titlePadding,
    this.titleTextStyle,
    this.content,
    this.contentPadding = const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
    this.contentTextStyle,
    this.actions,
    this.actionsPadding = EdgeInsets.zero,
    this.actionsOverflowDirection,
    this.actionsOverflowButtonSpacing,
    this.buttonPadding,
    this.backgroundColor,
    this.elevation,
    this.semanticLabel,
    this.insetPadding = _defaultInsetPadding,
    this.clipBehavior = Clip.none,
    this.shape,
    this.scrollable = false,
    this.titleColor,
    this.type = AlertDialogType.info,
  })  : assert(contentPadding != null),
        assert(clipBehavior != null),
        super(key: key);

  final AlertDialogType type;
  final Widget title;

  final EdgeInsetsGeometry titlePadding;

  final TextStyle titleTextStyle;

  final Widget content;

  final EdgeInsetsGeometry contentPadding;

  final TextStyle contentTextStyle;

  final List<Widget> actions;

  final EdgeInsetsGeometry actionsPadding;

  final VerticalDirection actionsOverflowDirection;

  final double actionsOverflowButtonSpacing;

  final EdgeInsetsGeometry buttonPadding;

  final Color backgroundColor;
  final Color titleColor;

  final double elevation;

  final String semanticLabel;

  final EdgeInsets insetPadding;

  final Clip clipBehavior;

  final ShapeBorder shape;

  @Deprecated('Set scrollable to `true`. This parameter will be removed and '
      'was introduced to migrate AlertDialog to be scrollable by '
      'default. For more information, see '
      'https://flutter.dev/docs/release/breaking-changes/scrollable_alert_dialog. '
      'This feature was deprecated after v1.13.2.')
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme = Theme.of(context);
    final DialogTheme dialogTheme = DialogTheme.of(context);

    String label = semanticLabel;
    if (title == null) {
      switch (theme.platform) {
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          label = semanticLabel;
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          label = semanticLabel ??
              MaterialLocalizations.of(context)?.alertDialogLabel;
      }
    }

    Widget titleWidget;
    Widget contentWidget;
    Widget actionsWidget;
    if (title != null)
      titleWidget = Padding(
        padding: titlePadding ??
            EdgeInsets.fromLTRB(24.0, 24.0, 24.0, content == null ? 20.0 : 0.0),
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: titleTextStyle ??
              dialogTheme.titleTextStyle ??
              theme.textTheme.headline6.copyWith(color: type.textColor),
          child: Semantics(
            child: title,
            namesRoute: true,
            container: true,
          ),
        ),
      );

    if (content != null)
      contentWidget = Padding(
        padding: contentPadding,
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: contentTextStyle ??
              dialogTheme.contentTextStyle?.copyWith(
                color: type.textColor,
              ) ??
              theme.textTheme.subtitle1,
          child: content,
        ),
      );

    if (actions != null) {
      actionsWidget = Padding(
        padding: actionsPadding,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Row(
            children: actions
                .map(
                  (e) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: e,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    }

    List<Widget> columnChildren;
    if (scrollable) {
      columnChildren = <Widget>[
        if (title != null || content != null)
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (title != null) titleWidget,
                  if (content != null) contentWidget,
                ],
              ),
            ),
          ),
        if (actions != null) actionsWidget,
      ];
    } else {
      columnChildren = <Widget>[
        Container(
          height: 63,
          color: type.backgroundColor,
        ),
        const SizedBox(
          height: 50,
        ),
        if (title != null) titleWidget,
        if (content != null) Flexible(child: contentWidget),
        if (actions != null) actionsWidget,
      ];
    }

    Widget dialogChild = IntrinsicWidth(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: columnChildren,
          ),
          Positioned(
            child: type.getIcon(),
            top: 30,
          ),
        ],
      ),
    );

    if (label != null)
      dialogChild = Semantics(
        namesRoute: true,
        label: label,
        child: dialogChild,
      );

    return Dialog(
      backgroundColor: backgroundColor,
      elevation: elevation,
      insetPadding: insetPadding,
      clipBehavior: clipBehavior,
      shape: shape ??
          OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
      child: dialogChild,
    );
  }
}
