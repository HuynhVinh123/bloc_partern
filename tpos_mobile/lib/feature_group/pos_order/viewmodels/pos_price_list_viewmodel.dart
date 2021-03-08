import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/price_list.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/feature_group/pos_order/sqlite_database/database_function.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

class PosPriceListViewModel extends ViewModelBase {
  PosPriceListViewModel(
      {IPosTposApi tposApiService, DialogService dialogService}) {
    _dialog = dialogService ?? locator<DialogService>();
    _dbFunction = dialogService ?? locator<IDatabaseFunction>();
    _tposApi = tposApiService ?? locator<IPosTposApi>();
  }

  DialogService _dialog;
  IDatabaseFunction _dbFunction;
  IPosTposApi _tposApi;

  List<PriceList> _priceLists = [];
  List<PriceList> get priceLists => _priceLists;
  set priceLists(List<PriceList> value) {
    _priceLists = value;
    notifyListeners();
  }

  Future<void> getPriceLists() async {
    priceLists = await _dbFunction.queryGetPriceLists();
  }

  Future<void> getPriceListPointSale() async {
    setState(true);
    try {
      final result = await _tposApi.getPriceListPointSale();
      if (result != null) {
        priceLists = result;
      }
    } catch (e, s) {
      logger.error("loadPriceListFail", e, s);
      _dialog.showError(error: e);
    }
    setState(false);
  }
}
