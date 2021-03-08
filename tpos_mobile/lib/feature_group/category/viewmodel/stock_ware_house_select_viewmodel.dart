import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/log_services/log_service.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class StockWareHouseSelectViewModel extends ScopedViewModel {
  StockWareHouseSelectViewModel(
      {ITposApiService tposApiService, LogService logService})
      : super(logService: logService) {
    _tposApi = tposApiService ?? locator<ITposApiService>();
  }
  ITposApiService _tposApi;
  DialogService _dialog;

  List<StockWareHouse> _stockWareHouses;
  List<StockWareHouse> get stockWareHouses => _stockWareHouses;

  Future<void> initData() async {
    setBusy(true);
    try {
      _stockWareHouses = await _tposApi.getStockWarehouse();
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
    }
    setBusy(false);
    notifyListeners();
  }
}
