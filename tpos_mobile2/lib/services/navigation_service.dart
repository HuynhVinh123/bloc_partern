import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tpos_mobile/app.dart';

class NavigationService {
  final Logger _logger = Logger();
  GlobalKey<NavigatorState> get navigatorKey => App.navigatorKey;

  Future<dynamic> navigateTo(String routeName, [Object params]) {
    _logger.d("navigateTo $routeName with $params");
    return navigatorKey.currentState.pushNamed(routeName, arguments: params);
  }

  Future<dynamic> navigateAndReplaceTo(String routeName, [Object params]) {
    _logger.d("navigateAndReplaceTo $routeName to $routeName");
    return navigatorKey.currentState
        .pushReplacementNamed(routeName, arguments: params);
  }

  Future<dynamic> navigateAndPopUntil(String routeName,
      [Object params, String popRouteName]) {
    _logger.d("navigateAndPopUntil $popRouteName to $routeName");
    return navigatorKey.currentState.pushNamedAndRemoveUntil(
        routeName, (Route<dynamic> route) => false,
        arguments: params);
  }

  void goBack({dynamic result}) {
    navigatorKey.currentState.pop(result);
  }
}
