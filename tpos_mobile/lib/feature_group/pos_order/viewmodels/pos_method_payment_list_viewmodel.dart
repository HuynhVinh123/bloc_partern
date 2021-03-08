import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_make_payment.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

class PosMethodPaymentListViewModel extends ViewModelBase {
  PosMethodPaymentListViewModel(
      {IPosTposApi tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<IPosTposApi>();
    _dialog = dialogService ?? locator<DialogService>();
  }

  DialogService _dialog;
  IPosTposApi _tposApi;
  List<PosMakePaymentJournal> _accountJournals = [];
  List<PosMakePaymentJournal> get accountJournals => _accountJournals;
  set accountJournals(List<PosMakePaymentJournal> value) {
    _accountJournals = value;
    notifyListeners();
  }

  Future<void> getAccountJournalsPointSale() async {
    setState(true);
    try {
      final result = await _tposApi.getAccountJournalsPointSale();
      if (result != null) {
        accountJournals = result;
      }
    } catch (e, s) {
      logger.error("getAccountJournalsPointSaleFail", e, s);
      _dialog.showError(error: e);
    }
    setState(false);
  }
}
