import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/services/cache_service.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';
import 'package:tpos_mobile/services/config_service/share_reference_config_service.dart';
import 'package:tpos_mobile/services/dialog_service/new_dialog_service.dart';
import 'package:tpos_mobile/services/navigation_service.dart';
import 'package:tpos_mobile/services/remote_config_service.dart';
import 'services/config_service/secure_storage_service.dart';

void setupNewLocator() {
  _setupIndependentService();
  //_setupDependentService(); TODO(namnv): setup this
  _setupTPosApiService();
  _configService();
}

void _setupIndependentService() {
  GetIt.instance
      .registerSingleton<ConfigService>(SharedPreferencesConfigService());
  GetIt.instance
      .registerLazySingleton<RemoteConfigService>(() => RemoteConfigService());
  GetIt.instance
      .registerLazySingleton<SecureConfigService>(() => SecureStorageService());
  GetIt.instance
      .registerLazySingleton<CacheService>(() => MemoryCacheService());
  GetIt.instance
      .registerLazySingleton<NewDialogService>(() => NewDialogService());

  GetIt.instance
      .registerLazySingleton<NavigationService>(() => NavigationService());
}

///Register API Service to the locator
void _setupTPosApiService() {
  GetIt.instance.registerLazySingleton<TPosApi>(
    () => TPosApiClient(apiConfig: null),
  );

  GetIt.instance
      .registerFactory<AuthenticationApi>(() => AuthenticationApiImpl());
  GetIt.instance.registerFactory<CommonApi>(() => CommonApiImpl());
  GetIt.instance
      .registerFactory<ApplicationUserApi>(() => ApplicationUserApiImpl());
  GetIt.instance.registerFactory<NotificationApi>(() => NotificationApiImpl());
  GetIt.instance
      .registerFactory<SaleOnlineOrderApi>(() => SaleOnlineOrderApiImpl());
  GetIt.instance.registerFactory<ReportOrderApi>(() => ReportOrderApiImpl());
  GetIt.instance.registerFactory<ReportDeliveryOrderApi>(
      () => ReportDeliveryOrderApiImpl());
  GetIt.instance
      .registerFactory<ChangePasswordApi>(() => ChangePasswordApiImpl());
  GetIt.instance.registerFactory<CrmTeamApi>(() => CrmTeamApiImpl());
  GetIt.instance.registerFactory<PosSessionApi>(() => PosSessionApiImpl());
  GetIt.instance.registerFactory<PartnerApi>(() => PartnerApiImpl());
  GetIt.instance.registerFactory<AlertApi>(() => AlertApiImpl());
  GetIt.instance.registerFactory<TagPartnerApi>(() => TagPartnerApiImpl());
  GetIt.instance.registerFactory<PriceListApi>(() => PriceListApiImpl());
  GetIt.instance.registerFactory<ReportStockApi>(() => ReportStockApiImpl());
}

/// Config all service. This function called after [setupLocator] is run
void _configService() {
  // Config interceptor service

  GetIt.I<ConfigService>().init();
  GetIt.I<RemoteConfigService>().init();
  if (!kReleaseMode) {
    print("config service");
    GetIt.instance<TPosApi>().dio.interceptors.add(
          LogInterceptor(
              requestHeader: true,
              requestBody: true,
              responseHeader: true,
              responseBody: true,
              request: true),
        );
  }
}
