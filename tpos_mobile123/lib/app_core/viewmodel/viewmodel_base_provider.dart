import 'package:flutter/widgets.dart';
import 'package:tpos_mobile/services/log_services/log_service.dart';

import '../../locator.dart';

class ViewModelBase extends ChangeNotifier {
  LogService _log;

  ViewModelBase({LogService logService}) {
    _log = logService ?? locator<LogService>();
  }

  LogService get logger => _log;
  ViewModelState _viewModelState = new ViewModelState();

  ViewModelState get viewModelState => _viewModelState;

  void setState(bool isBusy,
      {String message = "", ViewModelState viewModelState, bool isError}) {
    _viewModelState.isBusy = isBusy;
    _viewModelState.message = message;
    if (isError != null) _viewModelState.isError = isError;

    notifyListeners();
  }
}

class ViewModelState {
  String message;
  bool isBusy;
  bool isError;

  ViewModelState({this.message, this.isBusy = false, this.isError = false});
}
