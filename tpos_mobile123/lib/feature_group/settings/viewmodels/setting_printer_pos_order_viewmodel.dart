import 'package:logging/logging.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/print_service/printer_device.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_config.dart';
import 'package:tpos_mobile/src/tpos_apis/models/printer_configs.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/company_api.dart';

class SettingPrinterPosOrderViewModel extends ViewModel {
  DialogService _dialog;
  ICompanyApi _companyApi;
  ISettingService _setting;
  Logger _log = new Logger("SettingPrintPosOrderViewModel");
  SettingPrinterPosOrderViewModel(
      {ISettingService setting,
      DialogService dialogService,
      ICompanyApi companyApi}) {
    _dialog = dialogService ?? locator<DialogService>();
    _companyApi = companyApi ?? locator<ICompanyApi>();
    _setting = setting ?? locator<ISettingService>();
  }

  PrinterDevice _selectedPrintDevice;
  PrinterDevice get selectedPrintDevice => _selectedPrintDevice;
  String _selectedPrintName;
  String _customTemplate;
  var _isShowCompanyAddress;
  var _isShowCompanyEmail;
  var _isShowCompanyPhoneNumber;
  List<PrintTemplate> _supportTemplates;
  CompanyConfig _compnayConfig;

  String get selectedPrintName => _selectedPrintName;
  String get customTemplate => _customTemplate;

  bool get isShowCompanyAddress => _isShowCompanyAddress;
  set isShowCompanyAddress(bool value) {
    _isShowCompanyAddress = value;
  }

  bool get isShowCompanyEmail => _isShowCompanyEmail;
  set isShowCompanyEmail(bool value) {
    _isShowCompanyEmail = value;
  }

  bool get isShowCompanyPhoneNumber => _isShowCompanyPhoneNumber;
  set isShowCompanyPhoneNumber(bool value) {
    _isShowCompanyPhoneNumber = value;
  }

  List<PrintTemplate> get supportTemplates => _supportTemplates;

  PrinterConfig get webPrinterConfig => _compnayConfig?.printerConfigs
      ?.firstWhere((f) => f.code == "04", orElse: () => null);

  Future<void> initCommand() async {
    onStateAdd(true, message: "Đang tải...");
    // Refresh print info
    _selectedPrintName = _setting.posOrderPrinterName;
    _selectedPrintDevice = _setting.printers
        .firstWhere((f) => f.name == _selectedPrintName, orElse: () => null);
    _isShowCompanyAddress = _setting.isShowCompanyAddressPosOrder;
    _isShowCompanyEmail = _setting.isShowCompanyEmailPosOrder;
    _isShowCompanyPhoneNumber = _setting.isShowCompanyPhoneNumberPosOrder;

    _customTemplate = _setting.posOrderPrintSize;
    print(_selectedPrintDevice.type);
    _supportTemplates = _setting.getSuportPrintTemplateByPrinterType(
        "pos_order", _selectedPrintDevice.type);
    if (_supportTemplates.any((f) => f.code == _setting.posOrderPrintSize)) {
      _customTemplate = _setting.posOrderPrintSize;
    } else {
      _customTemplate = _supportTemplates.first?.code;
    }

    try {
      await _loadPrinterConfig();
    } catch (e) {}
    onStateAdd(false);
    notifyListeners();
  }

  Future<void> _loadPrinterConfig() async {
    _compnayConfig = await _companyApi.getCompanyConfig();
  }

  /// Chọn máy in
  Future<void> setPrinterCommand(PrinterDevice printDevice) async {
    this._selectedPrintDevice = printDevice;
    this._selectedPrintName = printDevice.name;

    // Tìm mẫu in hỗ trợ
    _supportTemplates = _setting.getSuportPrintTemplateByPrinterType(
        "pos_order", _selectedPrintDevice.type);
    if (_supportTemplates.any((f) => f.code == _setting.posOrderPrintSize)) {
      _customTemplate = _setting.posOrderPrintSize;
    } else {
      _customTemplate = _supportTemplates.first?.code;
    }
    notifyListeners();
  }

  // Chọn mẫu in A4, A5, BILL80
  Future<void> setPrinterTemplateCommand(String template) async {
    _customTemplate = template;
    notifyListeners();
  }

  Future<bool> saveCommand() async {
    onStateAdd(true, message: "Đang lưu...");
    try {
      _setting.posOrderPrinterName = this._selectedPrintName;
      _setting.posOrderPrintSize = this._customTemplate;
      _setting.isShowCompanyAddressPosOrder = this._isShowCompanyAddress;
      _setting.isShowCompanyEmailPosOrder = this._isShowCompanyEmail;
      _setting.isShowCompanyPhoneNumberPosOrder =
          this._isShowCompanyPhoneNumber;

      await _companyApi.saveCompanyConfig(_compnayConfig);

      return true;
    } catch (e, s) {
      _log.severe("save pos order config", e, s);
      _dialog.showError(error: e);
    }
    onStateAdd(false, message: "Đang lưu...");
    return false;
  }
}
