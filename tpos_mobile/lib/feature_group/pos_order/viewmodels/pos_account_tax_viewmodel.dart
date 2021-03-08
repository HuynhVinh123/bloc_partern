import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/point_sale.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

class PosAccountTaxViewModel extends ViewModelBase {
  PosAccountTaxViewModel(
      {IPosTposApi tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<IPosTposApi>();
    _dialog = dialogService ?? locator<DialogService>();
  }
  DialogService _dialog;
  IPosTposApi _tposApi;

  List<Tax> _accountTaxs = [];
  List<Tax> get accountTaxs => _accountTaxs;
  set accountTaxs(List<Tax> value) {
    _accountTaxs = value;
    notifyListeners();
  }

  Future<void> getAccountTax() async {
    setState(true);
    try {
      final result = await _tposApi.getAccountTaxs();
      if (result != null) {
        accountTaxs = result;
      }
    } catch (e, s) {
      logger.error("getAccountTaxFail", e, s);
      _dialog.showError(error: e);
    }
    setState(false);
  }
}
