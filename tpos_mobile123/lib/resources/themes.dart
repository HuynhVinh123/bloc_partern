import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary1Color = Color.fromRGBO(23, 95, 66, 1);
  static const Color primary2Color = Color.fromRGBO(107, 168, 76, 1);

  final String name;
  final ThemeData themeData;

  AppTheme._(this.name, this.themeData);
}

TextTheme _buildTextTheme(TextTheme base) {
  return base.copyWith(
    title: base.title.copyWith(
      fontFamily: 'Lato',
    ),
  );
}

const Color primaryColor = Color.fromRGBO(78, 143, 73, 1);
const Color secondaryColor = Color(0xFF13B9FD);
final AppTheme defaultAppTheme = AppTheme._('Default', _builDefaultTheme());
final ColorScheme colorScheme = const ColorScheme.light().copyWith(
  primary: primaryColor,
  secondary: secondaryColor,
);
final ThemeData base = ThemeData(
  brightness: Brightness.light,
  accentColorBrightness: Brightness.dark,
  colorScheme: colorScheme,
  primaryColor: primaryColor,
  primarySwatch: Colors.green,
  buttonColor: primaryColor,
  indicatorColor: Colors.white,
  toggleableActiveColor: const Color(0xFF1E88E5),
  splashColor: Colors.white24,
  splashFactory: InkRipple.splashFactory,
  accentColor: secondaryColor,
  canvasColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  backgroundColor: Colors.grey,
  errorColor: const Color(0xFFB00020),
);
ThemeData _builDefaultTheme() {
  return base.copyWith(
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme)
        .copyWith(title: TextStyle(color: Colors.white)),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
    iconTheme: IconThemeData(color: primaryColor),
  );
}

AppBarTheme getAppSearchAppbarTheme() {
  return AppBarTheme(
    color: Colors.white,
    actionsIconTheme: const IconThemeData(
      color: Colors.green,
    ),
    iconTheme: const IconThemeData(
      color: Colors.green,
    ),
    textTheme: base.textTheme.copyWith(
      headline6: const TextStyle(color: Colors.blue),
    ),
  );
}
