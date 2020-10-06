/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:53 AM
 *
 */

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/account/viewmodels/search_company_list_viewmodel.dart';
import 'package:tpos_mobile/feature_group/account/viewmodels/type_account_list_viewmodel.dart';
import 'package:tpos_mobile/feature_group/account/viewmodels/type_account_sale_list_viewmodel.dart';
import 'package:tpos_mobile/feature_group/account_payment/viewmodel/account_payment_add_edit_viewmodel.dart';
import 'package:tpos_mobile/feature_group/account_payment/viewmodel/search_type_account_payment_list_viewmodel.dart';
import 'package:tpos_mobile/feature_group/account_payment_sale/viewmodel/account_payment_sale_add_edit_viewmodel.dart';
import 'package:tpos_mobile/feature_group/account_payment_sale/viewmodel/account_payment_sale_info_viewmodel.dart';
import 'package:tpos_mobile/feature_group/account_payment_sale/viewmodel/account_payment_sale_list_viewmodel.dart';
import 'package:tpos_mobile/feature_group/category/viewmodel/control_service_viewmodel.dart';
import 'package:tpos_mobile/feature_group/category/viewmodel/tag_list_viewmodel.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/dialog_update_info_viewmodel.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/pos_close_point_sale_list_invoice_viewmodel.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/user_facebook_info_viewmodel.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/user_facebook_list_viewmodel.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_line_edit_viewmodel.dart';
import 'package:tpos_mobile/feature_group/sale_quotation/viewmodel/sale_quotation_add_edit_viewmodel.dart';
import 'package:tpos_mobile/feature_group/sale_quotation/viewmodel/sale_quotation_info_viewmodel.dart';
import 'package:tpos_mobile/feature_group/sale_quotation/viewmodel/sale_quotation_list_viewmodel.dart';
import 'package:tpos_mobile/feature_group/settings/viewmodels/setting_printer_pos_order_viewmodel.dart';

import 'package:tpos_mobile/services/analytics_service.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/services/authentication_service.dart';
import 'package:tpos_mobile/services/data_services/data_service.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/print_service.dart';
import 'package:tpos_mobile/services/remote_config_service.dart';
import 'package:tpos_mobile/services/report_service.dart';
import 'package:tpos_mobile/services/tpos_desktop_api_service.dart';

import 'package:tpos_mobile/src/tpos_apis/services/object_apis/fast_sale_order_line_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/partner_category_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/price_list_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/product_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/sale_order_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/stock_change_product_qty_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/stock_location_api.dart';
import 'package:tpos_mobile/helpers/tmt_flutter_locator.dart';
import 'package:tpos_mobile/services/log_services/log_server_service.dart';
import 'package:tpos_mobile/services/log_services/log_service.dart';
import 'package:tpos_mobile/services/navigation_service.dart';
import 'package:tpos_mobile/src/facebook_apis/facebook_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/application_user_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/authentication_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/company_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/fast_sale_order_api.dart';

import 'package:tpos_mobile/src/tpos_apis/services/object_apis/product_template_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/register_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/sale_setting_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';

import 'application/viewmodel/search_product_attribute_viewmodel.dart';
import 'feature_group/account/viewmodels/type_account_add_edit_viewmodel.dart';
import 'feature_group/account/viewmodels/type_account_sale_add_edit_viewmodel.dart';
import 'feature_group/account_payment/viewmodel/account_payment_add_contact_viewmodel.dart';
import 'feature_group/account_payment/viewmodel/account_payment_info_viewmodel.dart';
import 'feature_group/account_payment/viewmodel/account_payment_list_viewmodel.dart';
import 'feature_group/account_payment/viewmodel/search_contact_partner_viewmodel.dart';
import 'feature_group/account_payment/viewmodel/type_account_payment_list_viewmodel.dart';
import 'feature_group/category/mail_template/mail_template_add_edit_viewmodel.dart';
import 'feature_group/category/mail_template/mail_template_list_viewmodel.dart';
import 'feature_group/category/viewmodel/product_search_viewmodel.dart'
    as categoryProductSearch;

import 'feature_group/fast_purchase_order/view_model/fast_purchase_order_addedit_viewmodel.dart';
import 'feature_group/fast_purchase_order/view_model/fast_purchase_order_viewmodel.dart';
import 'feature_group/fast_sale_order/viewmodels/fast_sale_order_add_edit_full_viewmodel.dart';
import 'feature_group/fast_sale_order/viewmodels/fast_sale_order_line_edit_viewmodel.dart';
import 'feature_group/fast_sale_order/viewmodels/fast_sale_order_payment_viewmodel.dart';
import 'application/viewmodel/app_setting_viewmodel.dart';
import 'feature_group/pos_order/services/pos_tpos_api.dart';
import 'feature_group/pos_order/sqlite_database/database_function.dart';
import 'feature_group/pos_order/viewmodels/multi_chip_viewmodel.dart';
import 'feature_group/pos_order/viewmodels/pos_account_tax_viewmodel.dart';
import 'feature_group/pos_order/viewmodels/pos_cart_viewmodel.dart';
import 'feature_group/pos_order/viewmodels/pos_close_point_sale_viewmodel.dart';
import 'feature_group/pos_order/viewmodels/pos_invoice_list_viewmodel.dart';
import 'feature_group/pos_order/viewmodels/pos_method_payment_list_viewmodel.dart';
import 'feature_group/pos_order/viewmodels/pos_money_cart_viewmodel.dart';
import 'feature_group/pos_order/viewmodels/pos_order_info_viewmodel.dart';
import 'feature_group/pos_order/viewmodels/pos_order_list_viewmodel.dart';
import 'feature_group/pos_order/viewmodels/pos_partner_add_edit_viewmodel.dart';
import 'feature_group/pos_order/viewmodels/pos_partner_list_viewmodel.dart';
import 'feature_group/pos_order/viewmodels/pos_payment_print_viewmodel.dart';
import 'feature_group/pos_order/viewmodels/pos_payment_viewmodel.dart';
import 'feature_group/pos_order/viewmodels/pos_picking_type_viewmodel.dart';
import 'feature_group/pos_order/viewmodels/pos_point_sale_edit_viewmodel.dart';
import 'feature_group/pos_order/viewmodels/pos_point_sale_info_viewmodel.dart';
import 'feature_group/pos_order/viewmodels/pos_point_sale_list_tax_viewmodel.dart';
import 'feature_group/pos_order/viewmodels/pos_point_sale_list_viewmodel.dart';
import 'feature_group/pos_order/viewmodels/pos_price_list_viewmodel.dart';
import 'feature_group/pos_order/viewmodels/pos_product_list_viewmodel.dart';
import 'feature_group/pos_order/viewmodels/pos_stock_location_viewmodel.dart';
import 'feature_group/reports/viewmodels/business_result_viewmodel.dart';
import 'feature_group/reports/viewmodels/filter_search_viewmodel.dart';
import 'feature_group/reports/viewmodels/partner_detail_report_viewmodel.dart';
import 'feature_group/reports/viewmodels/partner_report_viewmodel.dart';
import 'feature_group/reports/viewmodels/partner_staff_detail_report_viewmodel.dart';
import 'feature_group/reports/viewmodels/supplier_detail_report_viewmodel.dart';
import 'feature_group/reports/viewmodels/supplier_report_viewmodel.dart';
import 'feature_group/sale_online/ui/product_search.dart';
import 'feature_group/sale_online/viewmodels/delivery_carrier_search_viewmodel.dart';
import 'feature_group/reports/statistic_report/viewmodels/report_dashboard_viewmodel.dart';
import 'feature_group/sale_online/viewmodels/sale_online_channel_list_viewmodel.dart';
import 'feature_group/sale_online/viewmodels/sale_online_facebook_post_viewmodel.dart';
import 'feature_group/sale_online/viewmodels/sale_online_order_edit_products_viewmodel.dart';
import 'feature_group/sale_online/viewmodels/sale_online_order_line_edit_viewmodel.dart';
import 'application/viewmodel/setting_viewmodel.dart';

TmtFlutterLocator locator = TmtFlutterLocator.instance;

// Cài đặt dưới chỉ hoạt động ở debug mode
const bool _isMockRemoteConfigService = false;
const bool _isMockNotificationApi = false;
const bool _isMockRegisterApi = false;

Future<void> setupLocator() async {
  Logger _log = new Logger("setupLocator");
  locator.allowReassignment = true;
  _log.info("set up Locator");

  /* set up Locator*/
  /// Register app setting service
  locator.registerLazySingleton<ISettingService>(() => new AppSettingService());
  locator.registerLazySingleton<LogServerService>(() => CrashlyticLogService());
  locator.registerLazySingleton<LogService>(() => LoggerLogService());
  // Dịch vụ sẽ không đăng ký lại khi đăng xuất ứng dụng
  if (!App.isAppLogOut) {
    locator.registerLazySingleton<DialogService>(() => MainDialogService());

    locator.registerLazySingleton<NavigationService>(() => NavigationService());

    /// Register App crash report service
    locator.registerLazySingleton<IReportService>(() => new ReportService());
  }

  /// Register TPOS API Client Base
  locator.registerLazySingleton<TposApiClient>(() => new TposApiClient());

  /// Register tpos api client service
  locator.registerLazySingleton<ITposApiService>(() => new TposApiService());

  locator.registerLazySingleton<PosCartViewModel>(() => PosCartViewModel());
  locator.registerLazySingleton<DialogUpdateInfoViewModel>(
      () => DialogUpdateInfoViewModel());

  /* TPOS API */

  locator.registerFactory<ICompanyApi>(() => CompanyService());
  locator.registerFactory<FastSaleOrderApi>(() => FastSaleOrderApi());
  locator.registerFactory<ISaleSettingApi>(() => SaleSettingApi());
  // Register Notification API
  locator.registerFactory<ProductTemplateApi>(() => ProductTemplateApi());
  locator.registerFactory<IAuthenticationApi>(() => AuthenticationApi());
  locator.registerFactory<IApplicationUserApi>(() => ApplicationUserApi());
  locator.registerFactory<IStockChangeProductQtyApi>(
      () => StockChangeProductQtyApi());

  locator.registerFactory<ProductApi>(() => ProductApi());
  locator.registerFactory<SaleOrderApi>(() => SaleOrderApi());
  locator.registerFactory<StockLocationApi>(() => StockLocationApi());
  locator.registerFactory<FastSaleOrderLineApi>(() => FastSaleOrderLineApi());
  locator.registerFactory<PartnerCategoryApi>(() => PartnerCategoryApi());
  locator.registerFactory<PriceListApi>(() => PriceListApi());
  locator.registerFactory<IPosTposApi>(() => PosTposApi());
  locator.registerFactory<IDatabaseFunction>(() => DatabaseFunction());
  locator.registerFactory<SettingPrinterPosOrderViewModel>(
      () => SettingPrinterPosOrderViewModel());
  locator.registerFactory<AccountPaymentListViewmodel>(
      () => AccountPaymentListViewmodel());
  locator.registerFactory<SearchTypeAccountPaymentListViewModel>(
      () => SearchTypeAccountPaymentListViewModel());
  locator.registerFactory<AccountPaymentInfoViewModel>(
      () => AccountPaymentInfoViewModel());
  locator.registerFactory<AccountPaymentAddEditViewModel>(
      () => AccountPaymentAddEditViewModel());
  locator.registerFactory<SearchContactPartnerViewModel>(
      () => SearchContactPartnerViewModel());
  locator.registerFactory<AccountPaymentAddContactViewmodel>(
      () => AccountPaymentAddContactViewmodel());
  locator.registerFactory<AccountPaymentSaleListViewModel>(
      () => AccountPaymentSaleListViewModel());
  locator.registerFactory<AccountPaymentSaleInfoViewModel>(
      () => AccountPaymentSaleInfoViewModel());
  locator.registerFactory<AccountPaymentSaleAddEditViewModel>(
      () => AccountPaymentSaleAddEditViewModel());
  locator.registerFactory<TypeAccountPaymentListViewModel>(
      () => TypeAccountPaymentListViewModel());
  locator.registerFactory<TypeAccountListViewModel>(
      () => TypeAccountListViewModel());
  locator.registerFactory<TypeAccountSaleListViewModel>(
      () => TypeAccountSaleListViewModel());
  locator.registerFactory<TypeAccountSaleAddEditViewModel>(
      () => TypeAccountSaleAddEditViewModel());
  locator.registerFactory<SearchCompanyListViewModel>(
      () => SearchCompanyListViewModel());
  locator.registerFactory<TypeAccountAddEditViewModel>(
      () => TypeAccountAddEditViewModel());
  locator.registerFactory<UserFaceBookListViewModel>(
      () => UserFaceBookListViewModel());
  locator.registerFactory<UserFacebookInfoViewModel>(
      () => UserFacebookInfoViewModel());
  locator.registerFactory<SaleQuotationListViewModel>(
      () => SaleQuotationListViewModel());
  locator.registerFactory<SaleQuotationInfoViewModel>(
      () => SaleQuotationInfoViewModel());
  locator.registerFactory<SaleQuotationAddEditViewModel>(
      () => SaleQuotationAddEditViewModel());
  locator.registerFactory<SaleOrderLineEditViewModel>(
      () => SaleOrderLineEditViewModel());
  locator.registerFactory<ControlServiceViewModel>(
      () => ControlServiceViewModel());
  locator.registerFactory<TagListViewModel>(
      () => TagListViewModel());

  // Regsiter API
  locator.registerFactory<IRegisterApi>(() => RegisterApi());

  /*  APPLICATION SERVICE*/

  // Register Authentication Service
  locator
      .registerFactory<IAuthenticationService>(() => AuthenticationService());
  locator
      .registerLazySingleton<RemoteConfigService>(() => RemoteConfigService());

  /*END APPLICATION SERVICE*/

  locator.registerLazySingleton<ReportDashboardViewModel>(
      () => ReportDashboardViewModel());

  /*END SINGLETON VIEWMODEL*/

  locator
      .registerLazySingleton<IFacebookApiService>(() => FacebookApiService());
  locator
      .registerLazySingleton<ITPosDesktopService>(() => TPosDesktopService());

  ///  Register print service locator
  locator.registerLazySingleton<PrintService>(() => PosPrintService());

  // Lưu cấu hình tạm
  locator.registerLazySingleton<ApplicationSettingViewModel>(() {
    return ApplicationSettingViewModel();
  });

  /// Data service
  locator.registerLazySingleton<DataService>(() => DataService());

  /// Tìm sản phẩm luôn luôn hoạt động
  locator.registerLazySingleton<ProductSearchViewModel>(
      () => ProductSearchViewModel());

  locator.registerLazySingleton<categoryProductSearch.ProductSearchViewModel>(
      () => categoryProductSearch.ProductSearchViewModel());

  //Register homep age

  _setupIndependentService();
  _setupDependentService();
  _setupViewModelService();

  await locator<ISettingService>().initService();
  await locator<RemoteConfigService>().setupRemoteConfig();
  return;
}

/// setup Independent service
/// caller on [setupLocator]
void _setupIndependentService() {
  locator.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
}

/// set up Dependent service
/// caller on [setupLocator]
void _setupDependentService() {}

/// setup the [ViewModel]
/// caller on [setupLocator] bellow [setupIndependentService] and [_setupIndependentService]
void _setupViewModelService() {
  locator.registerFactory<SaleOnlineFacebookPostViewModel>(
      () => SaleOnlineFacebookPostViewModel());
  locator.registerFactory(() => FastSaleOrderLineEditViewModel());
  locator.registerFactory(() => SaleOnlineOrderEditProductsViewModel());
  locator.registerFactory(() => SaleOnlineOrderLineEditViewModel());
  locator.registerFactory(() => DeliveryCarrierSearchViewModel());
  locator.registerFactory(() => SaleOnlineChannelListViewModel());
  locator.registerFactory(() => FastSaleOrderPaymentViewModel());
  locator.registerFactory(() => MailTemplateListViewModel());
  locator.registerFactory(() => MailTemplateAddEditViewModel());
  locator.registerFactory(() => BusinessResultViewModel());
  locator.registerFactory(() => PosOrderListViewModel());
  locator.registerFactory(() => PosOrderInfoViewModel());

  /// Tạo/ Sửa hóa đơn bán hàng nhanh
  locator.registerFactory(() => FastSaleOrderAddEditFullViewModel());
  // Cài đặt
  locator.registerFactory(() => SettingViewModel());

  ///viewmodel phiếu bán hàng FastPurchaseViewmodel
  locator.registerFactory<FastPurchaseOrderViewModel>(
    () => FastPurchaseOrderViewModel(),
  );

  ///viewmodel thêm sửa phiếu bán hàng FastPurchaseOrderAddEditViewModel
  locator.registerFactory<FastPurchaseOrderAddEditViewModel>(
    () => FastPurchaseOrderAddEditViewModel(),
  );

  // Xử lý điểm bán hàng
  locator.registerFactory<PosPointSaleListViewModel>(
    () => PosPointSaleListViewModel(),
  );
//  locator.registerFactory<PosCartViewModel>(
//    () => PosCartViewModel(),);

  locator.registerFactory<PosProductListViewmodel>(
    () => PosProductListViewmodel(),
  );
  locator.registerFactory<PosMoneyCartViewModel>(() => PosMoneyCartViewModel());
  locator.registerFactory<PosPartnerListViewModel>(
      () => PosPartnerListViewModel());
  locator.registerFactory<PosPartnerAddEditViewModel>(
      () => PosPartnerAddEditViewModel());
  locator.registerFactory<PosPriceListViewModel>(() => PosPriceListViewModel());
  locator.registerFactory<PosPaymentViewModel>(() => PosPaymentViewModel());
  locator.registerFactory<PosPointSaleInfoViewModel>(
      () => PosPointSaleInfoViewModel());
  locator.registerFactory<PosPointSaleEditViewModel>(
      () => PosPointSaleEditViewModel());
  locator.registerFactory<PosPickingTypeViewModel>(
      () => PosPickingTypeViewModel());
  locator.registerFactory<PosStockLocationViewModel>(
      () => PosStockLocationViewModel());
  locator
      .registerFactory<PosAccountTaxViewModel>(() => PosAccountTaxViewModel());
  locator.registerFactory<PosPointSaleListTaxViewModel>(
      () => PosPointSaleListTaxViewModel());
  locator.registerFactory<PosMethodPaymentListViewModel>(
      () => PosMethodPaymentListViewModel());
  locator.registerFactory<PosInvoiceListViewModel>(
      () => PosInvoiceListViewModel());
  locator.registerFactory<PosClosePointSaleViewModel>(
      () => PosClosePointSaleViewModel());
  locator
      .registerFactory<PartnerReportViewModel>(() => PartnerReportViewModel());
  locator.registerFactory<FilterSearchViewModel>(() => FilterSearchViewModel());
  locator.registerFactory<PartnerDetailReportViewModel>(
      () => PartnerDetailReportViewModel());
  locator.registerFactory<PartnerStaffDetailReportViewModel>(
      () => PartnerStaffDetailReportViewModel());
  locator.registerFactory<SupplierReportViewModel>(
      () => SupplierReportViewModel());
  locator.registerFactory<SupplierDetailReportViewModel>(
      () => SupplierDetailReportViewModel());

  locator.registerFactory<SearchProductAttributeViewModel>(
      () => SearchProductAttributeViewModel());
  locator.registerFactory<PosPaymentPrintViewModel>(
      () => PosPaymentPrintViewModel());
  locator.registerFactory<MultiChipViewModel>(() => MultiChipViewModel());
  locator.registerFactory<PosClosePointSaleListInvoiceViewModel>(
      () => PosClosePointSaleListInvoiceViewModel());

  return;
}

/// Đăng kí lại các dịch vụ
Future<void> resetLocator() async {
  App.isAppLogOut = true;
  await setupLocator();
}
