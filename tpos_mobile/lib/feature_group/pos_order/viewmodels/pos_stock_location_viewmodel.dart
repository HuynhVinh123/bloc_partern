import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/point_sale.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

class PosStockLocationViewModel extends ViewModelBase {
  PosStockLocationViewModel(
      {IPosTposApi tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<IPosTposApi>();
    _dialog = dialogService ?? locator<DialogService>();
  }

  DialogService _dialog;
  IPosTposApi _tposApi;

  List<StockLocation> _stockLocations = [];
  List<StockLocation> get stockLocations => _stockLocations;
  set stockLocations(List<StockLocation> value) {
    _stockLocations = value;
    notifyListeners();
  }

  Future<void> getStockLocation() async {
    setState(true);
    try {
      final result = await _tposApi.getStockLocation();
      if (result != null) {
        stockLocations = result;
      }
    } catch (e, s) {
      logger.error("loadStockLocationFail", e, s);
      _dialog.showError(error: e);
    }
    setState(false);
  }
}
