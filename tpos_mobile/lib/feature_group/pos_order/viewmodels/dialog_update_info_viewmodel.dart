import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';

class DialogUpdateInfoViewModel extends ViewModelBase {
  DialogUpdateInfoViewModel();

  bool _isNoQuestion = false;
  bool get isNoQuestion => _isNoQuestion;
  set isNoQuestion(bool value) {
    _isNoQuestion = value;
    notifyListeners();
  }

  bool isLoadingData = true;
  bool isFirstAccess = true;
}
