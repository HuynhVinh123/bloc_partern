import 'package:flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tpos_mobile/application/about_page.dart';
import 'package:tpos_mobile/application/application/application_bloc.dart';
import 'package:tpos_mobile/application/application/application_controller.dart';
import 'package:tpos_mobile/application/application/language_bloc.dart';
import 'package:tpos_mobile/application/home_page/home_page_bloc.dart';
import 'package:tpos_mobile/application/intro_slide/app_intro_page.dart';
import 'package:tpos_mobile/application/not_found_page.dart';
import 'package:tpos_mobile/application/notification_page/notification_bloc.dart';
import 'package:tpos_mobile/application/notification_page/notification_event.dart';
import 'package:tpos_mobile/application/register_page.dart';
import 'package:tpos_mobile/feature_group/account_payment_sale/uis/account_payment_sale_list_page.dart';
import 'package:tpos_mobile/feature_group/category/partner_list_page.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/live_session/live_sesssion_setting_page.dart';
import 'package:tpos_mobile/feature_group/fast_sale_order/ui/fast_sale_order_add_edit_full_page.dart';
import 'package:tpos_mobile/feature_group/fast_sale_order/ui/fast_sale_order_list_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_order_list_page.dart';
import 'package:tpos_mobile/feature_group/pos_session/uis/pos_session_list_page.dart';
import 'package:tpos_mobile/feature_group/reports/business_result_page.dart';
import 'package:tpos_mobile/feature_group/reports/partner_report_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/uis/report_delivery_order_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/report_order_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/uis/report_stock_overview_page.dart';
import 'package:tpos_mobile/feature_group/reports/supplier_report_page.dart';

import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_order_list_page.dart';
import 'package:tpos_mobile/feature_group/settings/setting_fast_sale_order_add_edit_full_page.dart';
import 'package:tpos_mobile/feature_group/settings/setting_page.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile/widgets/menu/add_menu_page.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import 'app.dart';
import 'application/about_page.dart';
import 'application/application/aplication_state.dart';
import 'application/application/application_event.dart';
import 'application/home_page/home_page.dart';
import 'application/loading/app_loading_page.dart';
import 'application/login/login_page.dart';
import 'feature_group/account/uis/type_account_list_page.dart';
import 'feature_group/account/uis/type_account_sale_list_page.dart';
import 'feature_group/account_payment/uis/account_payment_list_page.dart';
import 'feature_group/category/delivery_carrier_partner_add_list_page.dart';
import 'feature_group/category/mail_template/mail_template_list_page.dart';
import 'feature_group/category/partner/partner_page.dart';
import 'feature_group/close_sale_online_order/live_session/live_session_page.dart';
import 'feature_group/fast_purchase_order/ui/fast_purchase_order_list.dart';
import 'feature_group/fast_sale_order/ui/fast_sale_order_delivery_invoice_list_page.dart';
import 'feature_group/pos_order/ui/pos_point_sale_list_page.dart';
import 'feature_group/reports/statistic_report/report_dashboard_other_report_page.dart';
import 'feature_group/reports/statistic_report/report_dashboard_page_user_activities.dart';
import 'feature_group/reports/stock_report_page.dart';
import 'feature_group/category/partner/partner_category_page.dart';
import 'feature_group/sale_online/ui/product_category_page.dart';
import 'feature_group/sale_online/ui/product_list_page.dart';
import 'feature_group/sale_online/ui/product_template_quick_add_edit_page.dart';
import 'feature_group/sale_online/ui/product_template_search_page.dart';
import 'feature_group/sale_online/ui/sale_facebook_create_order_setting_page.dart';
import 'feature_group/sale_online/ui/sale_online_channel_list_page.dart';
import 'feature_group/sale_online/ui/sale_online_facebook_channel_list_page.dart';
import 'feature_group/sale_online/ui/sale_online_live_campaign_management_page.dart';
import 'feature_group/sale_order/sale_order_add_edit_page.dart';
import 'feature_group/sale_order/sale_order_list_page.dart';
import 'feature_group/sale_quotation/uis/sale_quotation_list_page.dart';
import 'feature_group/settings/setting_home_page.dart';
import 'feature_group/settings/setting_printer.dart';
import 'feature_group/settings/setting_printer_edit_printer_fast_sale_order_option_page.dart';
import 'feature_group/settings/setting_printer_edit_printer_ship_option_page.dart';
import 'feature_group/settings/setting_printer_list.dart';
import 'feature_group/settings/setting_printer_pos_order_page.dart';
import 'feature_group/settings/setting_printer_saleonline_page.dart';
import 'feature_group/settings/setting_sale_online_print_ship_via_lan_printer.dart';
import 'locator.dart';
import 'resources/app_route.dart';
import 'services/analytics_service.dart';
import 'widgets/app_wrapper.dart';

class NewApp extends StatefulWidget {
  @override
  _NewAppState createState() => _NewAppState();
}

class _NewAppState extends State<NewApp> {
  HomeBloc _homeBloc;

  final ApplicationBloc _applicationBloc = ApplicationBloc();

  @override
  void initState() {
    _applicationBloc.add(ApplicationLoaded());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ApplicationBloc>.value(value: _applicationBloc),
        BlocProvider<HomeBloc>(
          create: (context) => _homeBloc ?? (_homeBloc = HomeBloc()),
        ),
        BlocProvider<LanguageBloc>(
          create: (context) => LanguageBloc(),
        ),
        BlocProvider<NotificationBloc>(
          create: (context) => NotificationBloc(),
        ),
      ],
      child: BlocConsumer<ApplicationBloc, ApplicationState>(
          listener: (context, ApplicationState applicationState) async {
        if (applicationState is ApplicationResetSuccess) {
          AppWrapper.reset(context);
        } else if (applicationState is ApplicationLoadSuccess) {
          context.bloc<LanguageBloc>().add(LanguageLoaded());
        }
      }, builder: (context, ApplicationState applicationState) {
        return BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, languageState) {
          return MaterialApp(
            routes: _buildRoute(),
            onGenerateRoute: _onGenerateRoute,
            home: _getInitHome(),
            onUnknownRoute: (context) => _materialRoute(NotFoundPage()),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: languageState.locale,
            theme: ThemeData(
              textTheme: GoogleFonts.latoTextTheme(),
              buttonTheme: ButtonThemeData(
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
                height: 42,
              ),
              accentColor: AppColors.access,
              primaryColor: AppColors.access,
              primarySwatch: Colors.green,
            ),
            navigatorObservers: _getNavigatorObserver(applicationState),
            navigatorKey: App.navigatorKey,
          );
        });
      }),
    );
  }

  List<NavigatorObserver> _getNavigatorObserver(ApplicationState state) {
    if (state is ApplicationLoadSuccess) {
      return [locator<AnalyticsService>().getAnalyticsObserver()];
    }
    return [];
  }

  Widget _getInitHome() {
    return BlocBuilder<ApplicationBloc, ApplicationState>(
      builder: (context, state) {
        if (state is ApplicationUnInitial) {
          return const HomeLoadingScreen();
        } else if (state.isLogin) {
          return HomePage();
        } else if (state.isNeverLogin) {
          return IntroPage();
        } else {
          return LoginPage();
        }
      },
    );
  }

  /// Generate route base on setting
  // ignore: missing_return
  Route _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.addMenu:
        //return _materialRoute(AddMenuPage());

        return PageRouteBuilder(
          opaque: false,
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => AddMenuPage(),
        );

        break;
    }
  }

  Map<String, WidgetBuilder> _buildRoute() => {
        AppRoute.home: (context) => HomePage(),
        AppRoute.about: (context) => AboutPage(),
        AppRoute.login: (context) => LoginPage(),
        AppRoute.register: (context) => RegisterPage(),
        AppRoute.history: (context) => UserActivitiesPage(),
        AppRoute.intro: (context) => IntroPage(),
        AppRoute.loading: (context) => const HomeLoadingScreen(),

        AppRoute.setting: (context) => SettingPage(),
        AppRoute.saleOnlineSetting: (context) =>
            SaleFacebookCreateOrderSettingPage(),
        AppRoute.fastSaleOrderSetting: (context) =>
            SettingFastSaleOrderAddEditFullPage(),
        AppRoute.printersSetting: (context) => SettingPrinterListPage(),
        AppRoute.printSetting: (context) => SettingPrinterPage(),
        AppRoute.homeSetting: (context) => SettingHomePage(),
        AppRoute.saleOnlinePrinterSetting: (context) =>
            SettingPrinterSaleOnlinePage(),
        AppRoute.shipPrinterSetting: (context) =>
            SettingPrinterEditPrinterShipOptionPage(),
        AppRoute.fastSaleOrderPrinterSetting: (context) =>
            SettingPrinterEditPrinterFastSaleOrderOptionPage(),
        AppRoute.posOrderPrinterSetting: (context) =>
            SettingPrinterPosOrderPage(),
        AppRoute.saleOnlinePrintContentSetting: (context) =>
            SettingSaleOnlinePrintShipViaLanPrinter(),
        // Sale online
        AppRoute.facebookLiveCampaign: (context) =>
            SaleOnlineLiveCampaignManagementPage(),
        AppRoute.facebookSaleChannel: (context) =>
            const SaleOnlineFacebookChannelListPage(),
        AppRoute.saleOnlineOrders: (context) => const SaleOnlineOrderListPage(),
        AppRoute.facebookSessions: (context) => LiveSessionPage(),
        AppRoute.addFacebookSession: (context) => LiveSessionConfigPage(),
        AppRoute.addFastSaleOrder: (context) =>
            const FastSaleOrderAddEditFullPage(),
        AppRoute.fastSaleOrders: (context) => FastSaleOrderListPage(),
        AppRoute.deliveryOrder: (context) => FastSaleDeliveryInvoicePage(),
        AppRoute.saleOrders: (context) => SaleOrderListPage(),
        AppRoute.posOrder: (context) => const PosOrderListPage(),
        AppRoute.posSale: (context) => PosPointSaleListPage(),
        AppRoute.saleQuotations: (context) => SaleQuotationListPage(),
        // Sản phẩm
        AppRoute.productTemplates: (context) => const ProductTemplateSearchPage(
              closeWhenDone: false,
              isSearchMode: false,
            ),
        AppRoute.addProductTemplate: (context) =>
            const ProductTemplateQuickAddEditPage(),
        AppRoute.fastPurchaseOrders: (context) => FastPurchaseOrderListPage(),
        AppRoute.refundFastPurchseOrder: (context) => FastPurchaseOrderListPage(
              isRefund: true,
            ),
        // Khách hàng
        AppRoute.customers: (context) => const PartnerListPage(
              isSearchMode: false,
              isSupplier: false,
            ),

        AppRoute.addCustomer: (context) => const PartnerAddEditPage(
              isCustomer: true,
            ),
        AppRoute.suppliers: (context) => const PartnerListPage(
              isSearchMode: false,
              isSupplier: true,
            ),
        AppRoute.deliveryCarriers: (context) => DeliveryCarrierAddListPage(),

        // Report
        AppRoute.inventoryReport: (context) => ReportStockOverviewPage(),
        AppRoute.invoiceReport: (context) => ReportOrderPage(),
        AppRoute.deliveryReport: (context) => ReportDeliveryOrderPage(),
        AppRoute.businessResultReport: (context) => const BusinessResultPage(),
        AppRoute.customerDeptReport: (context) => PartnerReportPage(),
        AppRoute.supplierDeptReport: (context) => SupplierReportPage(),

        AppRoute.product: (context) => const ProductListPage(
              closeWhenDone: false,
              isSearchMode: false,
            ),
        AppRoute.productGroup: (context) => const ProductCategoryPage(
              closeWhenDone: false,
              isSearchMode: false,
            ),
        AppRoute.partnerGroup: (context) =>
            const PartnerCategoryPage(isSearchMode: false),
        AppRoute.addOrder: (context) => const SaleOrderAddEditPage(
              isCopy: true,
            ),
        AppRoute.saleChannel: (context) => const SaleOnlineChannelListPage(),
        AppRoute.mailTemplate: (context) => const MailTemplateListPage(),
        AppRoute.accountPayment: (context) => AccountPaymentListPage(),
        AppRoute.accountSalePayment: (context) => AccountPaymentSaleListPage(),
        AppRoute.typeAccountPayment: (context) => TypeAccountListPage(),
        AppRoute.typeAccountSalePayment: (context) => TypeAccountSaleListPage(),

        // Report
        AppRoute.reportMenu: (context) => ReportDashboardOtherReportPage(),
        AppRoute.posSession: (context) => PosSessionListPage()
      };

  Route _materialRoute(Widget page) {
    return MaterialPageRoute(builder: (context) => page);
  }
}
