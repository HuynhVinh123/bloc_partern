/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/5/19 4:54 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/5/19 8:31 AM
 *
 */

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const Duration _kBottomSheetDuration = Duration(milliseconds: 200);

// PERSISTENT BOTTOM SHEETS

// See scaffold.dart

// MODAL BOTTOM SHEETS

class _ModalBottomSheetLayout extends SingleChildLayoutDelegate {
  _ModalBottomSheetLayout(this.progress);

  final double progress;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: constraints.maxHeight * 12 / 16,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0.0, size.height - childSize.height * progress);
  }

  @override
  bool shouldRelayout(_ModalBottomSheetLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

class _ModalBottomSheet<T> extends StatefulWidget {
  const _ModalBottomSheet({Key key, this.route}) : super(key: key);

  final _ModalBottomSheetRoute<T> route;

  @override
  _ModalBottomSheetState<T> createState() => _ModalBottomSheetState<T>();
}

class _ModalBottomSheetState<T> extends State<_ModalBottomSheet<T>> {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    String routeLabel;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        routeLabel = '';
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        routeLabel = localizations.dialogLabel;
        break;
      case TargetPlatform.linux:
        routeLabel = '';
        break;
      case TargetPlatform.macOS:
        routeLabel = '';
        break;
      case TargetPlatform.windows:
        routeLabel = '';
        break;
    }

    return GestureDetector(
      excludeFromSemantics: true,
      onTap: () => Navigator.pop(context),
      child: AnimatedBuilder(
        animation: widget.route.animation,
        builder: (BuildContext context, Widget child) {
          // Disable the initial animation when accessible navigation is on so
          // that the semantics are added to the tree at the correct time.
          final double animationValue = mediaQuery.accessibleNavigation
              ? 1.0
              : widget.route.animation.value;
          return Semantics(
            scopesRoute: true,
            namesRoute: true,
            label: routeLabel,
            explicitChildNodes: true,
            child: ClipRect(
              child: CustomSingleChildLayout(
                delegate: _ModalBottomSheetLayout(animationValue),
                child: BottomSheet(
                  animationController: widget.route._animationController,
                  onClosing: () => Navigator.pop(context),
                  builder: widget.route.builder,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ModalBottomSheetRoute<T> extends PopupRoute<T> {
  _ModalBottomSheetRoute({
    this.builder,
    this.theme,
    this.barrierLabel,
    RouteSettings settings,
  }) : super(settings: settings);

  final WidgetBuilder builder;
  final ThemeData theme;

  @override
  Duration get transitionDuration => _kBottomSheetDuration;

  @override
  bool get barrierDismissible => true;

  @override
  final String barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // By definition, the bottom sheet is aligned to the bottom of the page
    // and isn't exposed to the top padding of the MediaQuery.
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _ModalBottomSheet<T>(route: this),
    );
    if (theme != null) bottomSheet = Theme(data: theme, child: bottomSheet);
    return bottomSheet;
  }
}

/// Shows a modal material design bottom sheet.
///
/// A modal bottom sheet is an alternative to a menu or a dialog and prevents
/// the user from interacting with the rest of the app.
///
/// A closely related widget is a persistent bottom sheet, which shows
/// information that supplements the primary content of the app without
/// preventing the use from interacting with the app. Persistent bottom sheets
/// can be created and displayed with the [showBottomSheet] function or the
/// [ScaffoldState.showBottomSheet] method.
///
/// The `context` argument is used to look up the [Navigator] and [Theme] for
/// the bottom sheet. It is only used when the method is called. Its
/// corresponding widget can be safely removed from the tree before the bottom
/// sheet is closed.
///
/// Returns a `Future` that resolves to the value (if any) that was passed to
/// [Navigator.pop] when the modal bottom sheet was closed.
///
/// See also:
///
///  * [BottomSheet], which is the widget normally returned by the function
///    passed as the `builder` argument to [showModalBottomSheet].
///  * [showBottomSheet] and [ScaffoldState.showBottomSheet], for showing
///    non-modal bottom sheets.
///  * <https://material.io/design/components/sheets-bottom.html#modal-bottom-sheet>
Future<T> showModalBottomSheetFullPage<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
}) {
  assert(context != null);
  assert(builder != null);
  assert(debugCheckHasMaterialLocalizations(context));
  return Navigator.push(
      context,
      _ModalBottomSheetRoute<T>(
        builder: builder,
        theme: Theme.of(context),
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
      ));
}

/// Shows a persistent material design bottom sheet in the nearest [Scaffold].
///
/// Returns a controller that can be used to close and otherwise manipulate the
/// bottom sheet.
///
/// To rebuild the bottom sheet (e.g. if it is stateful), call
/// [PersistentBottomSheetController.setBusy] on the controller returned by
/// this method.
///
/// The new bottom sheet becomes a [LocalHistoryEntry] for the enclosing
/// [ModalRoute] and a back button is added to the appbar of the [Scaffold]
/// that closes the bottom sheet.
///
/// To create a persistent bottom sheet that is not a [LocalHistoryEntry] and
/// does not add a back button to the enclosing Scaffold's appbar, use the
/// [Scaffold.bottomSheet] constructor parameter.
///
/// A persistent bottom sheet shows information that supplements the primary
/// content of the app. A persistent bottom sheet remains visible even when
/// the user interacts with other parts of the app.
///
/// A closely related widget is a modal bottom sheet, which is an alternative
/// to a menu or a dialog and prevents the user from interacting with the rest
/// of the app. Modal bottom sheets can be created and displayed with the
/// [showModalBottomSheet] function.
///
/// The `context` argument is used to look up the [Scaffold] for the bottom
/// sheet. It is only used when the method is called. Its corresponding widget
/// can be safely removed from the tree before the bottom sheet is closed.
///
/// See also:
///
///  * [BottomSheet], which is the widget typically returned by the `builder`.
///  * [showModalBottomSheet], which can be used to display a modal bottom
///    sheet.
///  * [Scaffold.of], for information about how to obtain the [BuildContext].
///  * <https://material.io/design/components/sheets-bottom.html#standard-bottom-sheet>
PersistentBottomSheetController<T> showBottomSheet<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
}) {
  assert(context != null);
  assert(builder != null);
  return Scaffold.of(context).showBottomSheet<T>(builder);
}
