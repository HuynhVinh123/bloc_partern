import 'dart:ui';

import 'package:flutter/material.dart';

Widget myFadeAnim({
  @required AnimationController controller,
  Widget child,
  bool fromTop = true,
  bool isFadeIn = true,
}) {
  Animation<Offset> lisTileTranslation;
  Animation<double> listTileOpacity;

  lisTileTranslation = Tween(
    begin: Offset(0.0, isFadeIn ? fromTop ? -0.35 : 0.35 : 0),
    end: Offset(0.0, isFadeIn ? 0.0 : fromTop ? -0.35 : 0.35),
  ).animate(
    CurvedAnimation(
      parent: controller,
      curve: Interval(0, 1, curve: Curves.ease),
    ),
  );
  double beginFade = isFadeIn ? 0.0 : 0.99;
  double endFade = isFadeIn ? 0.99 : 0;
  listTileOpacity = Tween(
    begin: beginFade,
    end: endFade,
  ).animate(
    CurvedAnimation(
      parent: controller,
      curve: Interval(0, 0.75, curve: Curves.linear),
    ),
  );
  return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget trashChild) {
        return FractionalTranslation(
          translation: lisTileTranslation.value,
          child: FadeTransition(
            opacity: listTileOpacity,
            child: child,
          ),
        );
      });
}

Widget fadeHorizontal({
  AnimationController controller,
  Widget child,
  double offset,
}) {
  Animation<Offset> lisTileTranslation;
  Animation<double> listTileOpacity;

  lisTileTranslation = Tween(
    begin: Offset(offset, 0.0),
    end: Offset(0.0, 0.0),
  ).animate(
    CurvedAnimation(
      parent: controller,
      curve: Interval(0.0, 1, curve: Curves.ease),
    ),
  );
  listTileOpacity = Tween(begin: 0.0, end: 0.99).animate(
    CurvedAnimation(
      parent: controller,
      curve: Interval(0.5, 1, curve: Curves.linear),
    ),
  );
  return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget trashChild) {
        return FractionalTranslation(
          translation: lisTileTranslation.value,
          child: FadeTransition(
            opacity: listTileOpacity,
            child: child,
          ),
        );
      });
}

Widget itemFadeAnimation(
    {AnimationController controller, Widget child, int length, int index}) {
  Animation<Offset> lisTileTranslation;
  Animation<double> listTileOpacity;
  length--;
  double end = ((index + 4) / (length));

  lisTileTranslation = Tween(
    begin: Offset(0.0, 0.35),
    end: Offset(0.0, 0.0),
  ).animate(
    CurvedAnimation(
      parent: controller,
      curve: Interval(index / (length), end > 1 ? 1 : end, curve: Curves.ease),
    ),
  );
  listTileOpacity = Tween(begin: 0.0, end: 0.99).animate(
    CurvedAnimation(
      parent: controller,
      curve:
          Interval(index / (length), end > 1 ? 1 : end, curve: Curves.linear),
    ),
  );
  return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget trashChild) {
        return FractionalTranslation(
          translation: index > 30 ? Offset(0.0, 0.0) : lisTileTranslation.value,
          child: FadeTransition(
            opacity: index > 30
                ? Tween(begin: 0.99, end: 0.99).animate(
                    CurvedAnimation(
                      parent: controller,
                      curve: Interval(index / (length), end > 1 ? 1 : end,
                          curve: Curves.easeInBack),
                    ),
                  )
                : listTileOpacity,
            child: child,
          ),
        );
      });
}
