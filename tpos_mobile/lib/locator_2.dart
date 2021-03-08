import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:facebook_api_client/facebook_api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/services/analytics_service.dart';
import 'package:tpos_mobile/services/cache_service/cache_service.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';
import 'package:tpos_mobile/services/config_service/h_config_service.dart';
import 'package:tpos_mobile/services/config_service/share_reference_config_service.dart';
import 'package:tpos_mobile/services/config_service/shop_config_service.dart';
import 'package:tpos_mobile/services/dialog_service/new_dialog_service.dart';
import 'package:tpos_mobile/services/navigation_service.dart';
import 'package:tpos_mobile/services/notification_service/fcm_service.dart';
import 'package:tpos_mobile/services/notification_service/fcm_service_impl.dart';
import 'package:tpos_mobile/services/remote_config_service.dart';

import 'services/config_service/secure_storage_service.dart';

void setupNewLocator() {
  _setupIndependentService();
  _setupDependentService();
  _setupTPosApiService();
  _setupFacebookApiService();
  _configService();
}

/// Config dependent service
void _setupDependentService() {
  GetIt.instance
      .registerLazySingleton<SecureConfigService>(() => SecureStorageService());
  // Config ShopConfigService
  GetIt.instance
      .registerLazySingleton<ShopConfigService>(() => HShopConfigService());
}

void _setupIndependentService() {
  GetIt.instance
      .registerLazySingleton<AnalyticsService>(() => AnalyticsService());
  GetIt.instance
      .registerSingleton<ConfigService>(SharedPreferencesConfigService());

  GetIt.instance
      .registerLazySingleton<RemoteConfigService>(() => RemoteConfigService());

  GetIt.instance
      .registerLazySingleton<CacheService>(() => MemoryCacheService());
  GetIt.instance
      .registerLazySingleton<NewDialogService>(() => NewDialogService());

  GetIt.instance
      .registerLazySingleton<NavigationService>(() => NavigationService());
  GetIt.I
      .registerLazySingleton<TPosApiCacheService>(() => TPosApiCacheService());
  GetIt.I.registerLazySingleton<FcmService>(() => FcmServiceImpl());
}

///Register API Service to the the locator
void _setupTPosApiService() {
  GetIt.instance.registerLazySingleton<TPosApi>(
    () => TPosApiClient(apiConfig: null),
  );

  GetIt.instance
      .registerFactory<AuthenticationApi>(() => AuthenticationApiImpl());
  GetIt.instance.registerFactory<TposFacebookApi>(() => TposFacebookApiImpl());
  GetIt.instance.registerFactory<CommonApi>(() => CommonApiImpl());
  GetIt.instance.registerFactory<PartnerExtApi>(() => PartnerExtApiImpl());
  GetIt.instance
      .registerFactory<ProductAttributeApi>(() => ProductAttributeApiImpl());
  GetIt.instance.registerFactory<ProductAttributeValueApi>(
      () => ProductAttributeValueApiImpl());
  GetIt.instance.registerFactory<StockMoveApi>(() => StockMoveApiImpl());
  GetIt.instance
      .registerFactory<ProductCategoryApi>(() => ProductCategoryApiImpl());
  GetIt.instance
      .registerFactory<ApplicationUserApi>(() => ApplicationUserApiImpl());
  GetIt.instance.registerFactory<NotificationApi>(() => NotificationApiImpl());
  GetIt.instance
      .registerFactory<SaleOnlineOrderApi>(() => SaleOnlineOrderApiImpl());
  GetIt.instance.registerFactory<ReportOrderApi>(() => ReportOrderApiImpl());
  GetIt.instance
      .registerFactory<OriginCountryApi>(() => OriginCountryApiImpl());
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
  GetIt.instance
      .registerFactory<AccountPaymentApi>(() => AccountPaymentApiImpl());
  GetIt.instance.registerFactory<AccountPaymentTypeApi>(
      () => AccountPaymentTypeApiImpl());
  GetIt.instance.registerFactory<AccountCommonPartnerReportApi>(
      () => AccountCommonPartnerReportApiImpl());
  GetIt.instance.registerFactory<ProductTPageApi>(() => ProductTPageApiImpl());
  GetIt.instance.registerFactory<CRMTagApi>(() => CRMTagApiImpl());
  GetIt.instance.registerFactory<MailTemplateApi>(() => MailTemplateApiImpl());

  GetIt.instance.registerFactory<ConversationApi>(() => ConversationApiImpl());
  GetIt.instance
      .registerFactory<ProductVariantApi>(() => ProductVariantApiImpl());
  GetIt.instance.registerFactory<MobileConfigApi>(() => ConfigApiImpl());
  GetIt.instance
      .registerFactory<PartnerCategoryApi>(() => PartnerCategoryApiImpl());
  GetIt.instance.registerFactory<LiveCampaignApi>(() => LiveCampaignApiImpl());
  GetIt.instance.registerFactory<StockProductionLotApi>(
      () => StockProductionLotApiImpl());
  GetIt.instance
      .registerFactory<FastSaleOrderApi>(() => FastSaleOrderApiImpl());
  GetIt.instance.registerFactory<TagProductTemplateApi>(
      () => TagProductTemplateApiImpl());
}

/// Register API from Facebook Api to then locator
void _setupFacebookApiService() {
  GetIt.instance.registerFactory<FacebookApi>(
    () => FacebookApiService(version: "v3.2"),
  );
  GetIt.instance
      .registerFactory<ProductTemplateApi>(() => ProductTemplateApiImpl());
  GetIt.instance.registerFactory<ProductUomApi>(() => ProductUomApiImpl());
  GetIt.instance.registerFactory<ProductUomCategoryApi>(
      () => ProductUomCategoryApiImpl());
}

/// Config all service. This function called after [setupLocator] is run
void _configService() {
  // Config interceptor service

  GetIt.I<ConfigService>().init();
  // Init [SecureConfigService]
  GetIt.I<SecureConfigService>().init();
  // Init [RemoteConfigService]
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
    GetIt.instance<TPosApi>().dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (rq) {
          return rq;
        },
      ),
    );
  }
}
