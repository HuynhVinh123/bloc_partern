import 'package:logging/logging.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_config.dart';
import 'package:tpos_mobile/src/tpos_apis/models/printer_configs.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/company_api.dart';

class SettingCompanyPrinterViewModel extends ViewModel {
  SettingCompanyPrinterViewModel({ICompanyApi companyApi}) {
    _companyApi = companyApi ?? locator<ICompanyApi>();
  }
  ICompanyApi _companyApi;
  final Logger _log = Logger("SettingCompanyViewModel");

  CompanyConfig _config;
  CompanyConfig get config => _config;

  List<PrinterConfig> get printerConfigs => _config?.printerConfigs;
  List<PrinterConfig> get supportPrinterConfig {
    final supportId = ["08"];

    return printerConfigs?.where((f) => supportId.contains(f.code))?.toList();
  }

  Future<void> init() async {
    onStateAdd(true);
    _config = await _companyApi.getCompanyConfig();
    onStateAdd(false);
    notifyListeners();
  }

  Future save() async {
    onStateAdd(true);
    try {
      _config = await _companyApi.saveCompanyConfig(_config);
    } catch (e, s) {
      _log.severe("save company config", e, s);
    }
    onStateAdd(false);
  }
}
