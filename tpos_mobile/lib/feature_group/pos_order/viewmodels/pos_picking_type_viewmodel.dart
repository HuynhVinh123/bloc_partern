import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/point_sale.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

class PosPickingTypeViewModel extends ViewModelBase {
  PosPickingTypeViewModel(
      {IPosTposApi tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<IPosTposApi>();
    _dialog = dialogService ?? locator<DialogService>();
  }

  DialogService _dialog;
  IPosTposApi _tposApi;

  List<PickingType> _pickingTypes = [];
  List<PickingType> get pickingTypes => _pickingTypes;
  set pickingTypes(List<PickingType> value) {
    _pickingTypes = value;
    notifyListeners();
  }

  Future<void> getPickingTypes() async {
    setState(true);
    try {
      final result = await _tposApi.getPickingTypes();
      if (result != null) {
        pickingTypes = result;
      }
    } catch (e, s) {
      logger.error("loadPickingTypeFail", e, s);
      _dialog.showError(error: e);
    }
    setState(false);
  }
}
