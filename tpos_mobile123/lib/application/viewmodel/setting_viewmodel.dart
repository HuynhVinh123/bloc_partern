import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';

class SettingViewModel extends ViewModel {
  SettingViewModel({ISettingService settingService}) {
    settingService = settingService ?? locator<ISettingService>();
  }
}
