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
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SettingPrintFastSaleOrderViewModel extends ScopedViewModel {
  SettingPrintFastSaleOrderViewModel(
      {ISettingService setting,
      ICompanyApi companyApi,
      DialogService dialogService,
      ShopConfigService configService}) {
    _setting = setting ?? locator<ISettingService>();
    _dialog = dialogService ?? locator<DialogService>();
    _companyApi = companyApi ?? locator<ICompanyApi>();
    _shopConfig = configService ?? GetIt.I<ShopConfigService>();
  }

  ISettingService _setting;
  ShopConfigService _shopConfig;
  ICompanyApi _companyApi;
  final Logger _log = Logger("SettingPrintFastSaleOrderViewModel");
  DialogService _dialog;

  String _selectedPrintName;
  PrinterDevice _selectedPrintDevice;
  String _customTemplate;
  CompanyConfig _compnayConfig;
  List<PrintTemplate> _supportTemplates;

  PrinterConfig get webPrinterConfig => _compnayConfig?.printerConfigs
      ?.firstWhere((f) => f.code == "01", orElse: () => null);

  String get selectedPrintName => _selectedPrintName;
  PrinterDevice get selectedPrintDevice => _selectedPrintDevice;
  String get printerType => _selectedPrintDevice?.type;
  String get customTemplate => _customTemplate;
  List<PrintTemplate> get supportTemplates => _supportTemplates;

  FontScale get fontScale => _shopConfig.printerConfig.invoiceFontScale;

  Future<void> initCommand() async {
    setBusy(true, message: "${S.current.loading}...");
    // Refresh print info
    _selectedPrintName = _shopConfig.printerConfig.invoicePrinterName;
    _selectedPrintDevice = _shopConfig.printerConfig.printerDevices
        .firstWhere((f) => f.name == _selectedPrintName, orElse: () => null);
    _customTemplate = _shopConfig.printerConfig.invoicePaperSize;
    _supportTemplates = _setting.getSuportPrintTemplateByPrinterType(
        "fast_sale_order", _selectedPrintDevice.type);
    if (_supportTemplates?.any(
            (f) => f.code == _shopConfig.printerConfig.invoicePaperSize) ==
        true) {
      _customTemplate = _shopConfig.printerConfig.invoicePaperSize;
    } else {
      _customTemplate = _supportTemplates?.first?.code;
    }

    try {
      await _loadPrinterConfig();
    } catch (e, s) {
      _log.severe("", e, s);
    }
    setBusy(false);
    notifyListeners();
  }

  Future<void> _loadPrinterConfig() async {
    _compnayConfig = await _companyApi.getCompanyConfig();
  }

  /// Chọn máy in
  void setPrinterCommand(PrinterDevice printDevice) {
    _selectedPrintDevice = printDevice;
    _selectedPrintName = printDevice.name;
    // Tìm mẫu in hỗ trợ
    _supportTemplates = _setting.getSuportPrintTemplateByPrinterType(
        "fast_sale_order", _selectedPrintDevice.type);
    if (_supportTemplates
            ?.any((f) => f.code == _shopConfig.printerConfig.shipPaperSize) ==
        true) {
      _customTemplate = _shopConfig.printerConfig.shipPaperSize;
    } else {
      _customTemplate = _supportTemplates?.first?.code;
    }
    notifyListeners();
  }

  // Chọn mẫu in A4, A5, BILL80
  Future<void> setPrinterTemplateCommand(String template) async {
    _customTemplate = template;
    notifyListeners();
  }

  void setFontScale(FontScale fontScale) {
    _shopConfig.printerConfig.invoiceFontScale = fontScale;
    notifyListeners();
  }

  Future<bool> saveCommand() async {
    setBusy(true, message: "${S.current.saving}...");
    try {
      _shopConfig.printerConfig.invoicePrinterName = _selectedPrintName;
      _shopConfig.printerConfig.invoicePaperSize = _customTemplate;

      await _companyApi.saveCompanyConfig(_compnayConfig);
      return true;
    } catch (e, s) {
      _log.severe("save ship config", e, s);
      _dialog.showError(error: e);
    }
    setBusy(false, message: "${S.current.saving}...");
    return false;
  }
}
