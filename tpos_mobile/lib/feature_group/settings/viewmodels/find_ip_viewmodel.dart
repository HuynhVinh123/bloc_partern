import 'package:flutter/material.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/services/print_service/network_address.dart';
import 'package:tpos_mobile/services/print_service/printer_device.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';
import 'package:wifi/wifi.dart';

class FindIpViewModel extends ViewModelBase {
  List<PrinterDevice> printers = [];
  bool isLoading = true;
  String subnet;

  Future<void> getIpWifi(BuildContext context) async {
    try {
      final String ip = await Wifi.ip;
      subnet = ip.substring(0, ip.lastIndexOf('.'));
    } catch (e) {
      App.showDefaultDialog(
        title: S.current.error,
        context: context,
        content: S.current.network_noInternetConnection,
        type: AlertDialogType.error,
      );
    }
  }

  void findPrinter(int port, BuildContext context, [bool isReload = false]) {
    isLoading = true;
    printers.clear();
    if (isReload) {
      notifyListeners();
    }

    final stream = NetworkAnalyzer.discover(subnet ?? "192.168.0", port);
    stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        printers.add(PrinterDevice(ip: addr.ip, port: port));
      }
    })
      ..onDone(() {
        // Add Default param
        isLoading = false;
        notifyListeners();
      })
      ..onError((dynamic e) {
        App.showConfirm(
            title: S.current.error, content: e.toString(), context: context);
        isLoading = false;
        notifyListeners();
      });
  }
}
