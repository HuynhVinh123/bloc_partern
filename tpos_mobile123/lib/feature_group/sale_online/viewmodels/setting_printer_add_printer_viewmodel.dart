import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/app_models/printer_type.dart';
import 'package:tpos_mobile/services/print_service/network_address.dart';
import 'package:tpos_mobile/services/print_service/printer_device.dart';

class SettingPrinterAddPrinterViewModel extends ViewModel {
  PrinterType _selectedPrinterType;
  bool isDiscovering = false;
  final List<PrinterDevice> _printers = <PrinterDevice>[];
  PrinterDevice _selectedPrinterDevice;
  PrinterDevice _newDevice;
  bool _isManual = false;

  List<PrinterDevice> get printers => _printers;
  PrinterType get selectedPrinterType => _selectedPrinterType;
  PrinterDevice get selectedPrinterDevice => _selectedPrinterDevice;
  PrinterDevice get newDevice => _selectedPrinterDevice;

  bool get isManual => _isManual;

  set selectedPrinterType(PrinterType value) {
    final oldValue = _selectedPrinterType;
    _selectedPrinterType = value;
    if (value?.code != oldValue?.code) {
      _selectedPrinterDevice = null;
      _newDevice = null;
      _printers.clear();
      discoveryPrinterCommand();
      notifyListeners();
    }
  }

  void discoveryPrinterCommand() {
    if (_selectedPrinterType == null) {
      return;
    }
    if (_selectedPrinterType.code == "esc_pos") {
      _findPrinter(9100);
    }

    if (_selectedPrinterType.code == "tpos_printer") {
      _findPrinter(8123);
    }
  }

  void setSelectedPrinterDeviceCommand(PrinterDevice value) {
    final oldValue = _selectedPrinterDevice;
    _selectedPrinterDevice = value;
    if (value != oldValue) {
      _newDevice ??= PrinterDevice();

      _newDevice.ip = value.ip;
      _newDevice.port = selectedPrinterType.port;
      _isManual = false;
      notifyListeners();
    }
  }

  void setIsManual(bool value) {
    if (value == true) {
      _isManual = value;
      _selectedPrinterDevice = null;
      notifyListeners();
    }
  }

  void _findPrinter(int port) {
    isDiscovering = true;
    _printers.clear();
    final stream = NetworkAnalyzer.discover("192.168.1", port);
    stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        print('Found device: ${addr.ip}');
        _printers.add(PrinterDevice(ip: addr.ip, port: port));
        notifyListeners();
      }
    })
      ..onDone(() {
        // Add Default param
        isDiscovering = false;
        notifyListeners();
      })
      ..onError((dynamic e) {
//        final snackBar = SnackBar(
//            content: Text('Unexpected exception', textAlign: TextAlign.center));
      });
  }
}
