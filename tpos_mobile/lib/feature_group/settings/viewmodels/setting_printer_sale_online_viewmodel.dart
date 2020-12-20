import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_config.dart';
import 'package:tpos_mobile/src/tpos_apis/models/printer_configs.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/company_api.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SettingPrinterSaleOnlineViewModel extends ViewModel {
  SettingPrinterSaleOnlineViewModel(
      {DialogService dialogService, ICompanyApi companyApi}) {
    _dialog = dialogService ?? locator<DialogService>();
    _companyApi = companyApi ?? locator<ICompanyApi>();
  }

  DialogService _dialog;
  ICompanyApi _companyApi;

  CompanyConfig _companyConfig;

  PrinterConfig get saleOnlinePrinterConfig => _companyConfig?.printerConfigs
      ?.firstWhere((f) => f.code == "03", orElse: () => null);

  Future<void> initData() async {
    onStateAdd(true);
    try {
      await _fetchCompanyConfig();
      notifyListeners();
    } catch (e, s) {
      logger.error("", e, s);
    }
    onStateAdd(false);
  }

  Future _fetchCompanyConfig() async {
    _companyConfig = await _companyApi.getCompanyConfig();
  }

  Future<bool> save() async {
    onStateAdd(true, message: "${S.current.saving}...");
    try {
      await _companyApi.saveCompanyConfig(_companyConfig);

      return true;
    } catch (e, s) {
      logger.error("save ship config", e, s);
      _dialog.showError(error: e);
    }
    onStateAdd(false, message: "${S.current.saving}...");
    return false;
  }
}
