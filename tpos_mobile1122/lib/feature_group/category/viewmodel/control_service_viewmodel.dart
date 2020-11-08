import 'package:flutter/cupertino.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/service_custom.dart';

class ControlServiceViewModel extends ViewModelBase {
  DialogService _dialog;
  ControlServiceViewModel({DialogService dialogService}) {
    _dialog = dialogService ?? locator<DialogService>();
  }

  bool _isDefault = false;
  bool get isDefault => _isDefault;
  set isDefault(bool value) {
    _isDefault = value;
    notifyListeners();
  }

  // Cập nhật thông tin cho customservice
  void updateInfoCustomService(BuildContext context,
      {String serviceId,
      String serviceName,
      List<ServiceCustom> serviceCustoms}) {
    ServiceCustom serviceCustom = ServiceCustom();
    serviceCustom.isDefault = _isDefault;
    serviceCustom.serviceId = serviceId;
    serviceCustom.name = serviceName;
    serviceCustoms.add(serviceCustom);
    Navigator.pop(context, true);
  }

  // Hiện thị thông báo khi chưa điền đủ thông tin
  void showNotify(String content) {
    _dialog.showNotify(title: "Thông báo", message: "$content");
  }
}
