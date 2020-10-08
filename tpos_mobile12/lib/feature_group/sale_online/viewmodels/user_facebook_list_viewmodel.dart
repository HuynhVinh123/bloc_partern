import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/facebook_account.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class UserFaceBookListViewModel extends ViewModelBase {
  UserFaceBookListViewModel(
      {ITposApiService tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<ITposApiService>();
    _dialog = dialogService ?? locator<DialogService>();
  }
  ITposApiService _tposApi;
  DialogService _dialog;

  List<FaceBookAccount> _userFacebooks = [];
  List<FaceBookAccount> get userFacebooks => _userFacebooks;
  set userFacebooks(List<FaceBookAccount> value) {
    _userFacebooks = value;
    notifyListeners();
  }

  Future<void> getUserFacebooks(String postId) async {
    setState(true);
    try {
      final result = await _tposApi.getUserFacebooks(postId);
      _userFacebooks = result;
      setState(false);
    } catch (e, s) {
      logger.error("getUserFacebooksFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }
}
