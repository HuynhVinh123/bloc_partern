import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/log_services/log_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/stock_warehouse.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class StockWareHouseSelectViewModel extends ViewModel {
  ITposApiService _tposApi;
  DialogService _dialog;
  StockWareHouseSelectViewModel(
      {ITposApiService tposApiService,
      LogService logService,
      DialogService dialogService})
      : super(logService: logService) {
    _tposApi = tposApiService ?? locator<ITposApiService>();
  }

  List<StockWareHouse> _stockWareHouses;
  List<StockWareHouse> get stockWareHouses => _stockWareHouses;

  void initData() async {
    onStateAdd(true);
    try {
      _stockWareHouses = await _tposApi.getStockWarehouse();
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
    }
    onStateAdd(false);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
