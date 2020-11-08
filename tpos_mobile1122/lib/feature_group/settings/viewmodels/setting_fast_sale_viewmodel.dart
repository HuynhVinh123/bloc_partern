import 'dart:convert';

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

  List<Map<String, dynamic>> statePrintOrders = [];

  List<Map<String, dynamic>> statePrintShips = [];

  List<Map<String, dynamic>> states = [
    {"Text": "Đã xác nhận", "Value": "open"},
    {"Text": "Đã thanh toán", "Value": "paid"},
    {"Text": "Nháp", "Value": "draft"},
    {"Text": "Hủy", "Value": "cancel"}
  ];

  List<bool> statesChecked = [false, false, false, false];

  List<bool> checkedStatePrintShips = [false, false, false, false];

  void addState(Map<String, dynamic> value, int position, bool isPrintShip) {
    final bool exist = isPrintShip
        ? statePrintShips.any((element) => element["Text"] == value["Text"])
        : statePrintOrders.any((element) => element["Text"] == value["Text"]);
    if (!exist) {
      if (isPrintShip) {
        statePrintShips.add(value);
        checkedStatePrintShips[position] = true;
      } else {
        statePrintOrders.add(value);
        statesChecked[position] = true;
      }
    }
    notifyListeners();
  }

  void removeState(Map<String, dynamic> value, int index, bool isPrintShip) {
    if (isPrintShip) {
      checkedStatePrintShips[index] = false;
      statePrintShips.remove(value);
    } else {
      statesChecked[index] = false;
      statePrintOrders.remove(value);
    }

    notifyListeners();
  }

  void init() {}

  Future<void> setChecked() {
    // ignore: avoid_function_literals_in_foreach_calls
    statePrintShips.forEach((itemPrintShip) {
      final int index = states.indexWhere(
          (itemPrint) => itemPrintShip["Text"] == itemPrint["Text"]);
      checkedStatePrintShips[index] = true;
    });
    // ignore: avoid_function_literals_in_foreach_calls
    statePrintOrders.forEach((itemPrintSale) {
      final int index = states.indexWhere(
          (itemPrint) => itemPrintSale["Text"] == itemPrint["Text"]);
      statesChecked[index] = true;
    });
  }

  void initData() async {
    onStateAdd(true);
    try {
      _saleSetting = await _saleSettingApi.getDefault();
      statePrintOrders = _saleSetting.statusDenyPrintSale;
      statePrintShips = _saleSetting.statusDenyPrintShip;
      await setChecked();
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

  void showNotify() {
    _dialog.showNotify(
        message: "Đã lưu cấu hình bán hàng",
        showOnTop: false,
        type: DialogType.NOTIFY_INFO);
  }
}
