import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/point_sale.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/locator.dart';

class PosPointSaleInfoViewModel extends ViewModelBase {
  PosPointSaleInfoViewModel({IPosTposApi tposApiService}) {
    _tposApi = tposApiService ?? locator<IPosTposApi>();
  }

  IPosTposApi _tposApi;
  PointSale _pointSale = PointSale();
  PointSale get pointSale => _pointSale;
  set pointSale(PointSale value) {
    _pointSale = value;
    notifyListeners();
  }

  Future<void> getInfoPointSale(int id) async {
    setState(true);
    try {
      final result = await _tposApi.getInfoPointSale(id);
      if (result != null) {
        pointSale = result;
      }
    } catch (e, s) {
      logger.error("getInfoPointSale", e, s);
    }
    setState(false);
  }

  String showNamePayment() {
    String name = "";
    if (_pointSale.journals != null) {
      for (var i = 0; i < _pointSale.journals.length; i++) {
        if (i == _pointSale.journals.length - 1) {
          name += _pointSale.journals[i].name;
        } else {
          name += _pointSale.journals[i].name + ",";
        }
      }
    }
    return name;
  }
}
