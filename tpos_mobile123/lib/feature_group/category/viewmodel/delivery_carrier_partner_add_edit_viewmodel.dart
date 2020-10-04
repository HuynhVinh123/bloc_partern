import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';

class DeliveryCarrierPartnerAddEditViewModel extends ViewModel {
  ITposApiService _tposApi;
  DialogService _dialog;
  DeliveryCarrierPartnerAddEditViewModel(
      {ITposApiService tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<ITposApiService>();
    _dialog = dialogService ?? locator<DialogService>();
  }

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
    _carrier.extras = new ShipExtra(posId: value);
  }

  set isDropOff(bool value) {
    if (_carrier.extras == null) _carrier.extras = new ShipExtra();
    _carrier.extras?.isDropoff = value;
    notifyListeners();
  }

  void setPickWorkShift(String value, String name) {
    if (_carrier.extras == null) _carrier.extras = new ShipExtra();
    _carrier.extras?.pickWorkShift = value != 0 ? value : null;
    _carrier.extras.pickWorkShiftName = name;
    notifyListeners();
  }

  void init({
    DeliveryCarrier carrier,
    String addCarrierType,
    String addCarrierName,
  }) {
    this._carrier = carrier;
    this._addCarrierType = addCarrierType;
    this._addCarrierName = addCarrierName;
  }

  void initData() async {
    onStateAdd(true);
    try {
      if (_carrier == null || _carrier.id == null || _carrier.id == 0) {
        _carrier = await _tposApi.getDeliverCarrierCreateDefault();

        // set default value

        _carrier.name = this._addCarrierName;
        _carrier.deliveryType = this._addCarrierType;
      } else {
        _carrier = await _tposApi.getDeliveryCarrierById(_carrier.id);
        this._addCarrierType = _carrier.deliveryType;
        this._addCarrierName = _carrier.name;
        this.service = carrier?.viettelPostServiceId ?? "0";
        this.typePayment = carrier?.extras?.paymentTypeId ?? "0";
      }
      notifyListeners();
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
    }
    onStateAdd(false);
  }

  Future<bool> save() async {
    onStateAdd(true, message: "Đang lưu");
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
    onStateAdd(false, message: "Đang lưu");
    return isSuccess;
  }

  Future<void> getViettelPostShipToken() async {
    onStateAdd(true);
    try {
      var result = await _tposApi.getShipToken(
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
    onStateAdd(true, message: "Đang gửi...");
    bool value = false;
    try {
      var result = await _tposApi.getShipToken(
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
    onStateAdd(true, message: "Đang gửi...");
    String value = "";

    try {
      var result = await _tposApi.getShipToken(
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
    onStateAdd(true, message: "Đang gửi...");
    String value = "";

    try {
      var result = await _tposApi.getShipToken(
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
    onStateAdd(true, message: "Đang gửi...");
    String value = "";

    try {
      var result = await _tposApi.getShipToken(
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
        title: "Thông báo",
        message: "Vui lòng nhập đầy đủ thông tin tài khoản và mật khẩu!");
  }
}
