import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/services/service.dart';
import 'package:tpos_mobile/locator_2.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';
import '../../app.dart';
import '../../locator.dart';
import 'aplication_state.dart';
import 'application_event.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  ApplicationBloc({ApplicationState initialState})
      : super(initialState ??
            const ApplicationUnInitial(isLogin: false, isNeverLogin: false)) {
    _logger.i('ApplicationBloc created');
  }
  final Logger _logger = Logger();
  @override
  Stream<ApplicationState> mapEventToState(event) async* {
    if (event is ApplicationLoaded) {
      // setup locator
      await App.getAppVersion();
      GetIt.instance.reset();
      locator.reset();
      setupNewLocator();
      setupLocator();

      // initial config service
      await GetIt.instance<ConfigService>().init();

      final TPosApi _tPosApi = GetIt.instance<TPosApi>();
      final ConfigService _config = GetIt.instance<ConfigService>();
      final SecureConfigService _secureConfig =
          GetIt.instance<SecureConfigService>();

      final String accessToken = await _secureConfig.shopToken;
      if (accessToken != null && accessToken.isNotEmpty) {
        _tPosApi.config(
          config: ApiConfig(
            url: _config.shopUrl,
            token: await _secureConfig.shopToken,
            version: App.appVersion,
          ),
        );
        await Future.delayed(const Duration(seconds: 1));
        yield ApplicationLoadSuccess(
          isLogin: true,
        );
      } else {
        yield ApplicationLoadSuccess(
          isLogin: false,
          isNeverLogin: _config.loginCount == 0,
        );
      }
    } else if (event is ApplicationLogout) {
      final ISettingService _settingService = locator<ISettingService>();
      final SecureConfigService _secureConfig =
          GetIt.instance<SecureConfigService>();
      // Reset token
      _secureConfig.setShopToken('');
      _secureConfig.setRefreshToken('');
      _settingService.shopAccessToken = '';
      _settingService.shopRefreshAccessToken = '';
      // Clear app app locator
      GetIt.instance.reset();
      locator.reset();

      // Restart app
      yield ApplicationResetSuccess();
    } else if (event is ApplicationRestarted) {
      GetIt.instance.reset();
      locator.reset();
      yield ApplicationResetSuccess();
    }
  }
}
