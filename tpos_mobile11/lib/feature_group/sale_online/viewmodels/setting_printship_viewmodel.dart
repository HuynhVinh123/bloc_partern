import 'package:logging/logging.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/print_service/printer_device.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/company_api.dart';

import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';

import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';

class SettingPrintShipViewModel extends ViewModel {
  SettingPrintShipViewModel(
      {ISettingService setting, ICompanyApi companyApi, DialogService dialog}) {
    _setting = setting ?? locator<ISettingService>();
    _dialog = dialog ?? locator<DialogService>();
    _companyApi = companyApi ?? locator<ICompanyApi>();
  }
  ISettingService _setting;
  ICompanyApi _companyApi;
  DialogService _dialog;
  final Logger _log = Logger("SettingPrintShipViewModel");

  String _selectedPrintName;
  PrinterDevice _selectedPrintDevice;
  String _customTemplate;
  CompanyConfig _compnayConfig;
  List<PrintTemplate> _supportTemplates;

  ISettingService get setting => _setting;

  PrinterConfig get webPrinterConfig => _compnayConfig?.printerConfigs
      ?.firstWhere((f) => f.code == "08", orElse: () => null);

  String get selectedPrintName => _selectedPrintName;
  PrinterDevice get selectedPrintDevice => _selectedPrintDevice;
  String get printerType => _selectedPrintDevice?.type;
  String get customTemplate => _customTemplate;
  List<PrintTemplate> get supportTemplates => _supportTemplates;

  Future<void> initCommand() async {
    onStateAdd(true, message: "Đang tải...");
    // Refresh print info
    _selectedPrintName = _setting.shipPrinterName;
    _selectedPrintDevice = _setting.printers
        .firstWhere((f) => f.name == _selectedPrintName, orElse: () => null);
    _customTemplate = _setting.shipSize;
    _supportTemplates = _setting.getSuportPrintTemplateByPrinterType(
        "ship", _selectedPrintDevice.type);
    if (_supportTemplates.any((f) => f.code == _setting.shipSize)) {
      _customTemplate = _setting.shipSize;
    } else {
      _customTemplate = _supportTemplates.first?.code;
    }

    try {
      await _loadPrinterConfig();
    } catch (e) {
      print(e);
    }
    onStateAdd(false);
    notifyListeners();
  }

  Future<void> _loadPrinterConfig() async {
    _compnayConfig = await _companyApi.getCompanyConfig();
  }

  /// Chọn máy in
  Future<void> setPrinterCommand(PrinterDevice printDevice) async {
    _selectedPrintDevice = printDevice;
    _selectedPrintName = printDevice.name;
    // Tìm mẫu in hỗ trợ
    _supportTemplates = _setting.getSuportPrintTemplateByPrinterType(
        "ship", _selectedPrintDevice.type);
    if (_supportTemplates.any((f) => f.code == _setting.shipSize)) {
      _customTemplate = _setting.shipSize;
    } else {
      _customTemplate = _supportTemplates.first?.code;
    }
    notifyListeners();
  }

  // Chọn mẫu in A4, A5, BILL80
  Future<void> setPrinterTemplateCommand(String template) async {
    _customTemplate = template;
    _setting.shipSize = template;
    notifyListeners();
  }

  Future<bool> saveCommand() async {
    onStateAdd(true, message: "Đang lưu...");
    try {
      _setting.shipPrinterName = _selectedPrintName;
      _setting.shipSize = _customTemplate;

      await _companyApi.saveCompanyConfig(_compnayConfig);

      return true;
    } catch (e, s) {
      _log.severe("save ship config", e, s);
      _dialog.showError(error: e);
    }
    onStateAdd(false, message: "Đang lưu...");
    return false;
  }
}
