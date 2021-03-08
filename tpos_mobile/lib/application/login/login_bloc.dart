import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/application/login/login_event.dart';
import 'package:tpos_mobile/application/login/login_state.dart';
import 'package:tpos_mobile/feature_group/sale_online/services/service.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../../locator.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(
      {LoginState initialState,
      AuthenticationApi authenticationApi,
      ConfigService configService,
      SecureConfigService securityConfigService})
      : super(initialState ?? LoginInitial()) {
    _authenticationApi =
        authenticationApi ?? GetIt.instance<AuthenticationApi>();
    _configService = configService ?? GetIt.instance<ConfigService>();
    _secureConfig =
        securityConfigService ?? GetIt.instance<SecureConfigService>();

    _settingService = locator<ISettingService>();
  }
  final Logger _logger = Logger();
  AuthenticationApi _authenticationApi;
  ConfigService _configService;
  SecureConfigService _secureConfig;
  ISettingService _settingService;

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginLoaded) {
      yield LoginLoadSuccess(
        shopUrl: _secureConfig.shopUrl,
        username: _secureConfig.shopUsername,
      );
    } else if (event is LoginButtonPressed) {
      // validate data
      if (!event.shopUrl.isUrl() ||
          event.shopUrl
              .replaceAll('https://', '')
              .replaceAll('.tpos.dev', '')
              .isNullOrEmpty()) {
        //Vui lòng nhập một đường dẫn máy chủ hợp lệ
        yield LoginValidateFailure(S.current.homePage_enterServerPath);
        return;
      }
      if (event.username.isNullOrEmpty() || event.password.isNullOrEmpty()) {
        // 'Vui lòng nhập tên đăng nhập và mật khẩu
        yield LoginValidateFailure(S.current.homePage_enterUserNameAndPassword);
        return;
      }
      yield LoginLogging();
      try {
        final loginResult = await _authenticationApi.login(
          username: event.username,
          url: event.shopUrl,
          password: event.password,
        );

        _secureConfig.setShopUrl(event.shopUrl);
        _secureConfig.setShopUsername(event.username);
        _configService.setLoginCount(_configService.loginCount + 1);
        _secureConfig.setShopToken(loginResult.accessToken);
        _secureConfig.setRefreshToken(loginResult.refreshToken);

        yield LoginSuccess();
      } catch (e, s) {
        _logger.e('', e, s);
        yield LoginFailure(
          message: e.toString(),
        );
      }
    }
  }
}
