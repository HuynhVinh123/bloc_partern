import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/services/service.dart';
import 'package:tpos_mobile/locator_2.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';
import 'package:tpos_mobile/services/migrations/config_migrations.dart';

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
      try {
        await App.getAppVersion();
        await GetIt.instance.reset();
        locator.reset();
        setupNewLocator();
        setupLocator();

        final TPosApi _tPosApi = GetIt.instance<TPosApi>();
        final ConfigService _config = GetIt.instance<ConfigService>();
        final SecureConfigService _secureConfig =
            GetIt.instance<SecureConfigService>();

        await _secureConfig.init();

        await MigrationManager().startAppMigration();

        final String accessToken = _secureConfig.shopToken;
        final String shopUrl = _secureConfig.shopUrl;

        /// must call.

        // start migration

        if (shopUrl.isNotNullOrEmpty() && accessToken.isNotNullOrEmpty()) {
          _tPosApi.config(
            config: ApiConfig(
              url: _secureConfig.shopUrl,
              token: _secureConfig.shopToken,
              version: App.appVersion,
            ),
          );
          await Future.delayed(const Duration(milliseconds: 1000));
          yield ApplicationLoadSuccess(
            isLogin: true,
          );
        } else {
          yield ApplicationLoadSuccess(
            isLogin: false,
            isNeverLogin: _config.loginCount == 0,
          );
        }

        /// Save token to database
        ///
      } catch (e, s) {
        _logger.e('', e, s);
        yield ApplicationLoadFailure();
      }
    } else if (event is ApplicationLogout) {
      final ISettingService _settingService = locator<ISettingService>();
      final SecureConfigService _secureConfig =
          GetIt.instance<SecureConfigService>();
      // Reset token
      _secureConfig.setShopToken('');
      _secureConfig.setRefreshToken('');
      // Restart app
      yield ApplicationResetSuccess();
    } else if (event is ApplicationRestarted) {
      GetIt.instance.reset();
      locator.reset();
      yield ApplicationResetSuccess();
    }
  }
}
