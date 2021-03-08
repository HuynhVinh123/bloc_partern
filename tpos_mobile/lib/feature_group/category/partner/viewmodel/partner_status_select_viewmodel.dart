import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tmt_flutter_viewmodel/tmt_flutter_viewmodel.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/services/cache_service/cache_service.dart';
import 'package:tpos_mobile/services/dialog_service/new_dialog_service.dart';
import 'package:tpos_mobile/state_management/viewmodel/base_viewmodel.dart';

class PartnerStatusSelectViewModel extends PViewModel {
  PartnerStatusSelectViewModel(
      {CommonApi commonApi,
      NewDialogService newDialog,
      CacheService cacheService}) {
    _commonApi = commonApi ?? GetIt.I<CommonApi>();
    _newDialog = newDialog ?? GetIt.I<NewDialogService>();
    _cacheService = cacheService ?? GetIt.I<CacheService>();
  }

  final Logger _logger = Logger();
  NewDialogService _newDialog;
  CommonApi _commonApi;
  CacheService _cacheService;
  List<PartnerStatus> _partnerStatus;
  List<PartnerStatus> get partnerStatus => _partnerStatus;
  @override
  void init() {
    // TODO: implement init
  }

  @override
  Future<PCommandResult> initData() async {
    PCommandResult result;
    try {
      setState(PViewModelLoading());
      await _cacheService.refreshPartnerStatus();
      await _fetchStatus();
      notifyListeners();
      result = PCommandResult(true);
    } catch (e, s) {
      _logger.e('', e, s);
      _newDialog.showError(content: e.toString());
      result = PCommandResult(false);
    }

    setState();
    return result;
  }

  Future<void> _fetchStatus() async {
    _partnerStatus = await _commonApi.getPartnerStatus(fromCache: true);
  }
}
