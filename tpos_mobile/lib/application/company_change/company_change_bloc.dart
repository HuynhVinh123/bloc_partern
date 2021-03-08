import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';

import 'company_change_event.dart';
import 'company_change_state.dart';

class CompanyChangeBloc extends Bloc<CompanyChangeEvent, CompanyChangeState> {
  CompanyChangeBloc({CompanyChangeState initialState}) : super(initialState);

  final ApplicationUserApi _applicationUserApi =
      GetIt.instance<ApplicationUserApi>();
  final SecureConfigService _secureConfig =
      GetIt.instance<SecureConfigService>();
  final AuthenticationApi _authenticationApi =
      GetIt.instance<AuthenticationApi>();
  final Logger _logger = Logger();
  @override
  Stream<CompanyChangeState> mapEventToState(event) async* {
    if (event is CompanyChangeLoaded) {
      yield CompanyChangeLoading();
      try {
        final companyCurrent =
            await _applicationUserApi.changeCurrentCompanyGet();
        yield CompanyChangeLoadSuccess(companyGetResult: companyCurrent);
      } catch (e, s) {
        _logger.e('', e, s);
        yield CompanyChangeLoadFailure();
      }
    } else if (event is CompanyChangeSelected) {
      try {
        yield CompanyChangeLoading();
        await _applicationUserApi.switchCompany(int.parse(event.item.value));
        // Reset token
        final String refreshToken = await _secureConfig.refreshToken;
        if (refreshToken != null) {
          final LoginResult loginResult = await _authenticationApi.refreshToken(
              refreshToken: await _secureConfig.refreshToken);

          _secureConfig.setShopToken(loginResult.accessToken);
          _secureConfig.setRefreshToken(loginResult.refreshToken);
          // _tPosApi.config(
          //   config: ApiConfig(
          //       url: _configService.shopUrl, token: loginResult.accessToken),
          // );
        }

        yield CompanyChangeSuccess();
      } catch (e, s) {
        _logger.e('', e, s);
      }
    }
  }
}
