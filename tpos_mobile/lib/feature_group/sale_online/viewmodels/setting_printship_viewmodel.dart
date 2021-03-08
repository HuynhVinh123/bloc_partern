import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/models/enums/font_scale.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/services/config_service/shop_config_service.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/print_service/printer_device.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/company_api.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';

class SettingPrintShipViewModel extends ScopedViewModel {
  SettingPrintShipViewModel(
      {ISettingService setting,
      ICompanyApi companyApi,
      DialogService dialog,
      ShopConfigService shopConfigService}) {
    _setting = setting ?? locator<ISettingService>();
    _dialog = dialog ?? locator<DialogService>();
    _companyApi = companyApi ?? locator<ICompanyApi>();
    _shopConfig = shopConfigService ?? GetIt.I<ShopConfigService>();
  }
  ISettingService _setting;
  ICompanyApi _companyApi;
  DialogService _dialog;
  ShopConfigService _shopConfig;
  final Logger _log = Logger("SettingPrintShipViewModel");

  String _selectedPrintName;
  PrinterDevice _selectedPrintDevice;
  String _customTemplate;
  CompanyConfig _compnayConfig;
  List<PrintTemplate> _supportTemplates;

  PrinterConfig get webPrinterConfig => _compnayConfig?.printerConfigs
      ?.firstWhere((f) => f.code == "08", orElse: () => null);

  String get selectedPrintName => _selectedPrintName;
  PrinterDevice get selectedPrintDevice => _selectedPrintDevice;
  String get printerType => _selectedPrintDevice?.type;
  String get customTemplate => _customTemplate;
  List<PrintTemplate> get supportTemplates => _supportTemplates;

  String get shipTemplateSize => _shopConfig.printerConfig.shipPaperSize;
  FontScale get shipFontScale => _shopConfig.printerConfig.shipFontScale;
  bool get isShowDepositAmount =>
      _shopConfig.printerConfig.printShipShowDepositAmount;

  bool get isShowProductQuantity =>
      _shopConfig.printerConfig.printShipShowProductQuantity;

  bool get isShowInvoiceNote =>
      _shopConfig.printerConfig.printShipShowInvoiceNote;

  void setShipTemplateSize(String value) {
    _shopConfig.printerConfig.shipPaperSize = value;
    notifyListeners();
  }

  void setShipFontScale(FontScale value) {
    _shopConfig.printerConfig.shipFontScale = value;
    notifyListeners();
  }

  void setShowDepositAmount(bool value) {
    _shopConfig.printerConfig.printShipShowDepositAmount = value;
    notifyListeners();
  }

  void setShowProductQuantity(bool value) {
    _shopConfig.printerConfig.printShipShowProductQuantity = value;
    notifyListeners();
  }

  void setShowInvoiceNote(bool value) {
    _shopConfig.printerConfig.printShipShowInvoiceNote = value;
    notifyListeners();
  }

  Future<void> initCommand() async {
    setBusy(true, message: "Đang tải...");
    // Refresh print info
    _selectedPrintName = _shopConfig.printerConfig.shipPrinterName;
    _selectedPrintDevice = _shopConfig.printerConfig.printerDevices
        .firstWhere((f) => f.name == _selectedPrintName, orElse: () => null);
    _customTemplate = _shopConfig.printerConfig.shipPaperSize;
    _supportTemplates = _setting.getSuportPrintTemplateByPrinterType(
        "ship", _selectedPrintDevice?.type);
    if (_supportTemplates
        .any((f) => f.code == _shopConfig.printerConfig.shipPaperSize)) {
      _customTemplate = _shopConfig.printerConfig.shipPaperSize;
    } else {
      _customTemplate = _supportTemplates.first?.code;
    }

    try {
      await _loadPrinterConfig();
    } catch (e) {
      print(e);
    }
    setBusy(false);
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
    if (_supportTemplates
        .any((f) => f.code == _shopConfig.printerConfig.shipPaperSize)) {
      _customTemplate = _shopConfig.printerConfig.shipPaperSize;
    } else {
      _customTemplate = _supportTemplates.first?.code;
    }
    notifyListeners();
  }

  // Chọn mẫu in A4, A5, BILL80
  Future<void> setPrinterTemplateCommand(String template) async {
    _customTemplate = template;
    _shopConfig.printerConfig.shipPaperSize = template;
    notifyListeners();
  }

  Future<bool> saveCommand() async {
    setBusy(true, message: "Đang lưu...");
    try {
      _shopConfig.printerConfig.shipPrinterName = _selectedPrintName;
      _shopConfig.printerConfig.shipPaperSize = _customTemplate;

      await _companyApi.saveCompanyConfig(_compnayConfig);

      return true;
    } catch (e, s) {
      _log.severe("save ship config", e, s);
      _dialog.showError(error: e);
    }
    setBusy(false, message: "Đang lưu...");
    return false;
  }
}
