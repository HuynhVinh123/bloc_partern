import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/application/home_page/home_page_event.dart';
import 'package:tpos_mobile/application/home_page/home_page_state.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/analytics_service.dart';
import 'package:tpos_mobile/services/cache_service.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({HomeState initialState})
      : super(
          initialState ?? HomeUnInitial(),
        ) {
    _logger.i('HomeBloc created');
  }

  final Logger _logger = Logger();
  final AuthenticationApi _authenticationApi =
      GetIt.instance<AuthenticationApi>();
  final SecureConfigService _secureConfig =
      GetIt.instance<SecureConfigService>();
  final CacheService _cacheService = GetIt.instance<CacheService>();
  final CommonApi _commonApi = GetIt.instance<CommonApi>();
  final ApplicationUserApi _applicationUserApi =
      GetIt.instance<ApplicationUserApi>();
  final NotificationApi _notificationApi = GetIt.instance<NotificationApi>();
  final AnalyticsService _analyticsService = GetIt.I<AnalyticsService>();
  final ConfigService _configService = GetIt.instance<ConfigService>();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeLoaded) {
      yield HomeLoading();
      // Kiểm tra token hết hạn bằng cách gửi 1 requet tới server và nhận về lỗi 401.
      final String token = await _secureConfig.shopToken;

      try {
        final checkTokenResult = await _authenticationApi.checkToken(token);
        if (!checkTokenResult) {
          // Token hết hạn. Đăng xuất tài khoản hiện tại và quay trở lại trang đăng nhậpp
          yield HomeRequestLogout();
          return;
        }

        _cacheService.webUserConfig = await _commonApi.getUserConfig();
        _cacheService.companyCurrentWithBranch =
            await _applicationUserApi.changeCurrentCompanyGet();
        _cacheService.companyCurrent = await _commonApi.getCompanyCurrent();

        final bool isExpired =
            _cacheService.companyCurrentWithBranch.dateExpired.isBefore(
          DateTime.now().add(
            const Duration(days: 3),
          ),
        );

        _analyticsService.setUserId(userId: _configService.shopUrl);

        yield HomeLoadSuccess(
          menuIndex: 0,
          isExprired: isExpired,
          expriredTime: _cacheService.companyCurrentWithBranch.expiredInShort,
        );
      } catch (e, s) {
        _logger.e('', e, s);
        yield HomeLoadFailure(e);
      }
    }
  }
}
