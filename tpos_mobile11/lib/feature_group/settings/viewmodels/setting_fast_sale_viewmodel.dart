import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';

import 'package:tpos_mobile/services/dialog_service.dart';

import 'package:tpos_mobile/src/tpos_apis/models/sale_setting.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/sale_setting_api.dart';

class SettingFastSaleViewModel extends ViewModel {
  ISettingService _setting;
  ISaleSettingApi _saleSettingApi;
  DialogService _dialog;
  SettingFastSaleViewModel(
      {ISettingService settingService,
      ISaleSettingApi saleSettingApi,
      DialogService dialogService}) {
    _setting = settingService ?? locator<ISettingService>();
    _saleSettingApi = saleSettingApi ?? locator<ISaleSettingApi>();
    _dialog = dialogService ?? locator<DialogService>();
  }

  SaleSetting _saleSetting;
  SaleSetting get saleSetting => _saleSetting;

  void init() {}

  void initData() async {
    onStateAdd(true);
    try {
      _saleSetting = await _saleSettingApi.getDefault();
      notifyListeners();
    } catch (e, s) {
      logger.error("", e, s);
      var dialogResult = await _dialog.showError(error: e, isRetry: true);
      if (dialogResult != null &&
          dialogResult.type == DialogResultType.GOBACK) {
        onEventAdd("DIALOG_GOBACK_ACTION", null);
      } else if (dialogResult != null &&
          dialogResult.type == DialogResultType.RETRY) {
        this.initData();
      }
    }
    onStateAdd(false);
  }

  Future<bool> save() async {
    bool isSuccess = false;
    onStateAdd(true, message: "Đang lưu");
    try {
      await _saleSettingApi.updateAndExecute(_saleSetting);
      _dialog.showNotify(
          message: "Đã lưu cấu hình bán hàng",
          showOnTop: false,
          type: DialogType.NOTIFY_INFO);
      isSuccess = true;
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
    }
    onStateAdd(false, message: "Đang lưu");
    return isSuccess;
  }

  void setProduct(Product product) {
    this._saleSetting?.productId = product.id;
    this._saleSetting?.product = product;
    notifyListeners();
  }
}
