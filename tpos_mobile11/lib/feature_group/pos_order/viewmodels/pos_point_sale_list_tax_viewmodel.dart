import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/point_sale.dart';
import 'package:tpos_mobile/feature_group/pos_order/sqlite_database/database_function.dart';

import 'package:tpos_mobile/services/dialog_service.dart';

import '../../../locator.dart';

class PosPointSaleListTaxViewModel extends ViewModelBase {
  PosPointSaleListTaxViewModel({DialogService dialogService}) {
    _dialog = dialogService ?? locator<DialogService>();
    _dbFunction = locator<IDatabaseFunction>();
  }

  DialogService _dialog;
  IDatabaseFunction _dbFunction;

  List<Tax> _pointSaleTaxs = [];

  List<Tax> get pointSaleTaxs => _pointSaleTaxs;
  set pointSaleTaxs(List<Tax> value) {
    _pointSaleTaxs = value;
    notifyListeners();
  }

  Future<void> getPointSaleTaxs() async {
    setState(true);
    try {
      final List<Tax> results = await _dbFunction.queryGetTaxs();
      if (results.isNotEmpty) {
        pointSaleTaxs.addAll(results);
      }
    } catch (e, s) {
      logger.error("handleTaxFail", e, s);
      _dialog.showError(error: e);
    }
    setState(false);
  }
}
