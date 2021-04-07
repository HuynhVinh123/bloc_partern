import 'package:logger/logger.dart';
import 'package:tdental_api_client/abstractions/res_config_setting_api.dart';
import 'package:tdental_api_client/models/entities/res_config_setting.dart';
import 'package:tdentalmobile/core/blocs/bloc_base.dart';
import 'package:tdentalmobile/helpes/logger_help.dart';
import 'package:tdentalmobile/pages/categories/ui/config/setting_general_event.dart';
import 'package:tdentalmobile/pages/categories/ui/config/setting_general_state.dart';

import '../../../../locator.dart';

class SettingGeneralBloc
    extends TBlocBase<SettingGeneralEvent, SettingGeneralState> {
  SettingGeneralBloc({ResconfigSettingApi? resconfigSettingApi})
      : super(SettingGeneralLoading()) {
    _resconfigApi = resconfigSettingApi ?? locator<ResconfigSettingApi>();
  }
  ResconfigSettingApi? _resconfigApi;
  final Logger _logger = getLogger('Set Config log');
  @override
  Future<void> close() {
    return super.close();
  }

  @override
  Stream<SettingGeneralState> mapEventToState(
      SettingGeneralEvent event) async* {
    if (event is SettingGeneralLoaded) {
      try {
        final ResConfigSetting resConfigSetting =
            await _resconfigApi!.getDefault();
        // ignore: avoid_function_literals_in_foreach_calls

        event.titles[0]['key'] = resConfigSetting.isGroupSaleCouponPromotion;
        event.titles[1]['key'] = resConfigSetting.isGroupServiceCard;
        event.titles[2]['key'] = resConfigSetting.groupTCare;
        event.titles[3]['key'] = resConfigSetting.isGroupLoyaltyCard;
        event.titles[4]['key'] = resConfigSetting.isGroupUom;
        event.titles[5]['key'] = resConfigSetting.groupMedicine;
        event.titles[6]['key'] = resConfigSetting.groupSurvey;
        event.titles[7]['key'] = resConfigSetting.isGroupMultiCompany;

        event.checkCompanies[0]['key'] = resConfigSetting.isCompanySharePartner;
        event.checkCompanies[1]['key'] = resConfigSetting.isCompanyShareProduct;
        event.checkCompanies[2]['key'] =
            resConfigSetting.isProductListPriceRestrictCompany;

        yield SettingGeneralSuccess(
            resConfigSetting: resConfigSetting,
            titles: event.titles,
            checkCompanies: event.checkCompanies);
      } catch (e, stack) {
        _logger.e('Set Config blocd', e, stack);

        yield SettingGeneralLoadError(content: e.toString(), title: 'Lỗi');
      }
    }
    if (event is SettingGeneralInserted) {
      yield SettingGeneralLoading();
      try {
        ResConfigSetting resConfigSettingConfig = ResConfigSetting();
        resConfigSettingConfig = event.resConfigSetting;
        resConfigSettingConfig.loyaltyPointExchangeRate  = event.amount;
        resConfigSettingConfig.isGroupSaleCouponPromotion =
            event.titles[0]['key'];
        resConfigSettingConfig.isGroupServiceCard = event.titles[1]['key'];
        resConfigSettingConfig.groupTCare = event.titles[2]['key'];
        resConfigSettingConfig.isGroupLoyaltyCard = event.titles[3]['key'];
        resConfigSettingConfig.isGroupUom = event.titles[4]['key'];
        resConfigSettingConfig.groupMedicine = event.titles[5]['key'];
        resConfigSettingConfig.groupSurvey = event.titles[6]['key'];
        resConfigSettingConfig.isGroupMultiCompany = event.titles[7]['key'];

        resConfigSettingConfig.isCompanySharePartner =
            event.checkCompanies[0]['key'];
        resConfigSettingConfig.isCompanyShareProduct =
            event.checkCompanies[1]['key'];
        resConfigSettingConfig.isProductListPriceRestrictCompany =
            event.checkCompanies[2]['key'];

        final ResConfigSetting resConfigSetting =
            await _resconfigApi!.insert(event.resConfigSetting);

        await _resconfigApi!.getExcute(resConfigSetting.id!);
        yield SettingGeneralInsertSuccess(
            title: 'Thông báo', content: 'Cập nhật thông tin thành công.');
      } catch (e, stack) {
        _logger.e('Set Config bloc', e, stack);
        yield SettingGeneralInsertFailure(
            title: 'Lỗi', content: e.toString());
      }
    }
  }
}
