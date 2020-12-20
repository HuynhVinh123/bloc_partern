import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class DeliveryCarrierPartnerAddEditViewModel extends ViewModel {
  DeliveryCarrierPartnerAddEditViewModel(
      {ITposApiService tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<ITposApiService>();
    _dialog = dialogService ?? locator<DialogService>();
  }
  ITposApiService _tposApi;
  DialogService _dialog;

  DeliveryCarrier _carrier;
  String _addCarrierType;
  String _addCarrierName;
  String _service = "0";
  String _typePayment = "0";
  DeliveryCarrier get carrier => _carrier;
  String get carrierType => _addCarrierType;
  String get service => _service;
  String get typePayment => _typePayment;

  set service(String value) {
    _service = value;
    notifyListeners();
  }

  set typePayment(String value) {
    _typePayment = value;
    notifyListeners();
  }

  set isActive(bool value) {
    _carrier.active = value;
    notifyListeners();
  }

  set isPrintCustom(bool value) {
    _carrier.isPrintCustom = value;
    notifyListeners();
  }

  set postId(String value) {
    _carrier.extras = ShipExtra(posId: value);
  }

  set isDropOff(bool value) {
    _carrier.extras ??= ShipExtra();
    _carrier.extras?.isDropoff = value;
    notifyListeners();
  }

  void setPickWorkShift(String value, String name) {
    _carrier.extras ??= ShipExtra();
    _carrier.extras?.pickWorkShift = value != "0" ? value : null;
    _carrier.extras.pickWorkShiftName = name;
    notifyListeners();
  }

  void init({
    DeliveryCarrier carrier,
    String addCarrierType,
    String addCarrierName,
  }) {
    _carrier = carrier;
    _addCarrierType = addCarrierType;
    _addCarrierName = addCarrierName;
  }

  Future<void> initData() async {
    onStateAdd(true);
    try {
      if (_carrier == null || _carrier.id == null || _carrier.id == 0) {
        _carrier = await _tposApi.getDeliverCarrierCreateDefault();

        // set default value

        _carrier.name = _addCarrierName;
        _carrier.deliveryType = _addCarrierType;
      } else {
        _carrier = await _tposApi.getDeliveryCarrierById(_carrier.id);
        _addCarrierType = _carrier.deliveryType;
        _addCarrierName = _carrier.name;
        service = carrier?.viettelPostServiceId ?? "0";
        typePayment = carrier?.extras?.paymentTypeId ?? "0";
      }
      notifyListeners();
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
    }
    onStateAdd(false);
  }

  Future<bool> save() async {
    // Đang lưu
    onStateAdd(true, message: S.current.saving);
    bool isSuccess = false;
    try {
      if (_carrier.id == null || _carrier.id == 0) {
        // insert
        await _tposApi.createDeliveryCarrier(_carrier);
        isSuccess = true;
      } else {
        await _tposApi.updateDeliveryCarrier(_carrier);
        isSuccess = true;
      }
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
      isSuccess = false;
    }
    onStateAdd(false, message: S.current.saving);
    return isSuccess;
  }

  Future<void> getViettelPostShipToken() async {
    onStateAdd(true);
    try {
      final result = await _tposApi.getShipToken(
          email: _carrier.viettelPostUserName,
          password: _carrier.viettelPostPassword,
          apiKey: await _tposApi.getTokenShip(),
          provider: "ViettelPost");

      if (result != null && result.success) {
        _carrier.viettelPostToken = result.data.token;
        _carrier.vNPostClientId = result.data.code;
      } else {
        throw Exception(result.message);
      }
      notifyListeners();
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
    }
    onStateAdd(false);
  }

  Future<bool> getGhtkToken({String username, String password}) async {
    //Đang gửi.
    onStateAdd(true, message: "${S.current.sending}...");
    bool value = false;
    try {
      final result = await _tposApi.getShipToken(
          email: username,
          password: password,
          apiKey: await _tposApi.getTokenShip(),
          provider: "GHTK");

      if (result != null && result.success) {
        _carrier.gHTKToken = result.data?.token;
        _carrier.gHTKClientId = result.data.code.toString();
        value = true;
      } else {
        throw Exception(result.message);
      }
      notifyListeners();
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
      value = false;
    }
    onStateAdd(false);
    return value;
  }

  Future<String> getFullTimeShipToken(
      {String username, String password}) async {
    // Đang gửi
    onStateAdd(true, message: "${S.current.sending}...");
    String value = "";

    try {
      final result = await _tposApi.getShipToken(
          email: username,
          password: password,
          apiKey: await _tposApi.getTokenShip(),
          provider: "FulltimeShip");
      if (result != null && result.success) {
        value = result.data?.token;
      }
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
    }
    onStateAdd(false);
    return value;
  }

  Future<String> getBestToken({String username, String password}) async {
    onStateAdd(true, message: "${S.current.sending}...");
    String value = "";

    try {
      final result = await _tposApi.getShipToken(
          email: username,
          password: password,
          apiKey: await _tposApi.getTokenShip(),
          provider: "BEST");
      if (result != null && result.success) {
        value = result.data?.token;
      }
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
    }
    onStateAdd(false);
    return value;
  }

  Future<String> getFlashShipToken({String username, String password}) async {
    onStateAdd(true, message: "${S.current.sending}...");
    String value = "";

    try {
      final result = await _tposApi.getShipToken(
          email: username,
          password: password,
          apiKey: await _tposApi.getTokenShip(),
          provider: "FlashShip");
      if (result != null && result.success) {
        value = result.data?.token;
        carrier?.vNPostClientId = result.data.code;
      }
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
    }
    onStateAdd(false);
    return value;
  }

  void showNotify() {
    _dialog.showNotify(
        title: S.current.notification,
        message: S.current.deliveryPartner_EnterUserNameAndPassword);
  }
}
