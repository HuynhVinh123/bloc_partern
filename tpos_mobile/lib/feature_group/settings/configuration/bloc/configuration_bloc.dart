import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/settings/configuration/bloc/configuration_event.dart';
import 'package:tpos_mobile/feature_group/settings/configuration/bloc/configuration_state.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';
import 'package:tpos_mobile/services/config_service/shop_config_service.dart';

class MobileConfigBloc extends Bloc<MobileConfigEvent, MobileConfigState> {
  MobileConfigBloc(
      {MobileConfigApi configApi,
      ConfigService configService,
      ApplicationUserApi applicationUserApi,
      SecureConfigService secureConfigService})
      : super(ConfigurationLoading()) {
    _configApi = configApi ?? GetIt.I<MobileConfigApi>();
    _shopCoinfig = configService ?? GetIt.I<ShopConfigService>();
    _applicationUserApi = applicationUserApi ?? GetIt.I<ApplicationUserApi>();
    _secureConfig = secureConfigService ?? GetIt.I<SecureConfigService>();
  }
  final Logger _logger = Logger();
  MobileConfigApi _configApi;
  ShopConfigService _shopCoinfig;
  ApplicationUserApi _applicationUserApi;
  SecureConfigService _secureConfig;

  String _shopUrl;
  String _shopUsername;

  String _deviceId;
  String _deviceBranch;
  String _deviceModel;
  ApplicationUser _applicationUser;

  // Cache data....

  @override
  Stream<MobileConfigState> mapEventToState(MobileConfigEvent event) async* {
    if (event is MobileConfigLoaded) {
      _shopUrl ??= _secureConfig.shopUrl;

      _applicationUser = await _applicationUserApi.getCurrentUser();

      _shopUsername = _applicationUser.userName;

      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        _deviceId = androidInfo.androidId;
        _deviceModel = androidInfo.model;
        _deviceBranch = androidInfo.brand;
      } else {
        final iosInfo = await deviceInfo.iosInfo;
        _deviceId = iosInfo.identifierForVendor;
      }

      yield MobileConfigLoadSuccess(
        url: _shopUrl,
        username: _shopUsername,
        loginUsername: _applicationUser.userName,
        deviceBranch: _deviceBranch,
        deviceModel: _deviceModel,
      );
    } else if (event is MobileConfigLoaded) {
    } else if (event is MobileConfigValidated) {
      /// Làm mới data
      final _allConfig = await _configApi.getAllConfigs();
      final _thisConfig = _allConfig.firstWhere(
          (element) =>
              element.deviceId == _deviceId &&
              element.userId == _applicationUser.id,
          orElse: () => null);
      if (_thisConfig != null) {
        yield MobileConfigValidateSuccess(true);
      } else {
        yield MobileConfigValidateSuccess(false);
      }
    } else if (event is MobileConfigUpLoaded) {
      try {
        yield ConfigurationBusy();

        /// Validate data ở đây.
        /// Trường hợp 1. Nếu trên server đã có một bản có version lớn hơn thì thông báo ghi đè hoặc tải cấu hình xuống.
        /// Trường hợp 2. Nếu cấu hình trên máy có phiên bản = cấu hình trên server thì thông báo ghi đè.
        /// Trường hợp 3. Trên server ko có bản nào. Lưu luông ko hỏi han gì.
        ///
        ///
        ///

        final MobileConfig localConfig = MobileConfig(
          deviceId: _deviceId,
          userId: _applicationUser.id,
          jsonValues: _shopCoinfig.toJson(),
        );

        await _configApi.createUpdate(localConfig);
      } catch (e, stack) {
        _logger.e('ConfigurationError', e, stack);
        yield ConfigurationError(error: e.toString());
      }
    }
  }
}
