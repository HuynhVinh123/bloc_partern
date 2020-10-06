import 'package:flutter/cupertino.dart';

abstract class NViewModel extends ChangeNotifier {
  NViewModel() {
    _handleInit();
  }
  bool isInit;
  bool isLoadSuccess;
  bool onlyOnetime = false;

  /// Init the ViewModel. this be called after [ViewModel] is contructor;
  @visibleForTesting
  Future<void> init();

  /// Load data. this function be called at anytime the UI needed.
  @visibleForTesting
  Future<void> load();

  void _handleInit() async {
    await init().then((value) {
      isInit = true;
    }).catchError((e, s) {
      isInit = false;
    });
  }

  /// Load data and notify change to UI. this function be called at anytime the UI needed.
  /// Set [onlyOneTime] =true to call it only onetime
  Future<void> handleLoad() async {
    if (isLoadSuccess && onlyOnetime) {
      return;
    }
    await load();
    isLoadSuccess = true;
    notifyListeners();
  }
}
