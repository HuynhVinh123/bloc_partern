import 'package:flutter/cupertino.dart';

abstract class ApplicationState {
  const ApplicationState({this.isLogin, this.isNeverLogin});
  final bool isLogin;
  final bool isNeverLogin;

  @override
  String toString() =>
      '$runtimeType(isLogin: $isLogin, isNeverLogin: $isNeverLogin)';
}

class ApplicationUnInitial extends ApplicationState {
  const ApplicationUnInitial({bool isLogin, bool isNeverLogin, Locale locale})
      : super(
          isLogin: isLogin,
          isNeverLogin: isNeverLogin,
        );
}

class ApplicationLoadSuccess extends ApplicationState {
  ApplicationLoadSuccess({bool isLogin = false, bool isNeverLogin = false})
      : super(
          isLogin: isLogin,
          isNeverLogin: isNeverLogin,
        );
}

class ApplicationLoadFailure extends ApplicationState {}

class ApplicationResetSuccess extends ApplicationState {
  ApplicationResetSuccess({bool isLogin, bool isNeverLogin})
      : super(
          isLogin: isLogin,
          isNeverLogin: isNeverLogin,
        );
}
