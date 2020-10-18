import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tpos_mobile/feature_group/reports/statistic_report/report_dashboard_other_report_page.dart';
import 'package:tpos_mobile/resources/permission.dart';
import 'package:tpos_mobile/services/cache_service.dart';
import 'package:tpos_mobile/services/config_service/config_model/home_menu_config.dart';
import 'package:tpos_mobile/widgets/menu/add_menu_page.dart';
import 'app_route.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class MenuItem {
  MenuItem({
    this.iconColor,
    @required this.id,
    @required this.name,
    this.shortName,
    this.route,
    this.icon,
    this.iconBuilder,
    this.permission,
    @required this.type,
    this.gradient,
    this.tooltip,
    this.context,
    this.visible = true,
    this.onPressed,
  });
  final String id;
  final String Function() name;
  final String shortName;
  final String route;
  final Widget icon;
  final Widget iconColor;
  final Widget Function(BuildContext context, Color color) iconBuilder;
  final String permission;
  final MenuGroupType type;
  final Gradient gradient;
  final BuildContext context;
  final String tooltip;
  final bool visible;

  /// override default onPressed callback
  final Function(BuildContext context) onPressed;
}

enum MenuGroupType {
  saleOnline,
  fastSaleOrder,
  posOrder,
  inventory,
  category,
  setting,
  report,
  tpage,
  menu,
}

extension MenuGroupTypeExtension on MenuGroupType {
  String get describe => describeEnum(this);
  // ignore: missing_return
  Widget get icon {
    switch (this) {
      case MenuGroupType.saleOnline:
        return const Icon(FontAwesomeIcons.facebookF);
      case MenuGroupType.fastSaleOrder:
        return const Icon(FontAwesomeIcons.shoppingCart);
      case MenuGroupType.posOrder:
        // TODO: Handle this case.
        break;
      case MenuGroupType.inventory:
        // TODO: Handle this case.
        break;
      case MenuGroupType.category:
        // TODO: Handle this case.
        break;
      case MenuGroupType.setting:
        // TODO: Handle this case.
        break;
      case MenuGroupType.report:
        // TODO: Handle this case.
        break;
      case MenuGroupType.tpage:
        // TODO: Handle this case.
        break;
      case MenuGroupType.menu:
        // TODO: Handle this case.
        break;
    }
  }

  String get description {
    switch (this) {
      case MenuGroupType.saleOnline:
        return S.current.menuGroupType_saleOnline;
      case MenuGroupType.fastSaleOrder:
        return S.current.menuGroupType_fastSaleOrder;
      case MenuGroupType.posOrder:
        return S.current.menuGroupType_posOrder;
      case MenuGroupType.inventory:
        return S.current.menuGroupType_inventory;
      case MenuGroupType.category:
        return S.current.menuGroupType_category;
      case MenuGroupType.setting:
        return S.current.menuGroupType_setting;
      case MenuGroupType.report:
        return S.current.menuGroup_report;
      case MenuGroupType.menu:
        return S.current.menuGroupType_category;
      default:
        return 'N/A';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case MenuGroupType.saleOnline:
        return const Color(0xff3B7AD9);
      case MenuGroupType.fastSaleOrder:
        return const Color(0xff2EB2E8);
      case MenuGroupType.posOrder:
        return const Color(0xff2EB2E9);
      case MenuGroupType.inventory:
        return const Color(0xffE56D41);
      case MenuGroupType.category:
        return const Color(0xff42526E);
      case MenuGroupType.setting:
        return const Color(0xff42526B);
      case MenuGroupType.report:
        return const Color(0xff28A745);
      default:
        return const Color(0xff42526E);
    }
  }
}

MenuItem getMenuByRoute(String route) => applicationMenu.firstWhere(
      (element) => element.route == route,
      orElse: () => null,
    );

MenuItem getMenuByRouteWithPermission(String route) {
  final _cache = GetIt.instance<CacheService>();
  final MenuItem menu = applicationMenu.firstWhere(
    (element) => element.route == route,
    orElse: () => null,
  );

  if (menu == null) {
    return null;
  }
  if (menu.permission == null) {
    return menu;
  }
  if (_cache.functions.contains(menu.permission)) {
    return menu;
  }
  return null;
}

bool checkPermission(String route) {
  final _cache = GetIt.instance<CacheService>();
  final MenuItem menu = applicationMenu.firstWhere(
    (element) => element.route == route,
    orElse: () => null,
  );

  if (menu == null) {
    return false;
  }
  if (menu.permission == null || menu.permission.isEmpty) {
    return true;
  }

  if (_cache.functions.contains(menu.permission)) {
    return true;
  }

  return false;
}

/// Dự kiến các nhóm chức năng
/// - Sale online ( DS Đơn hàng, kênh bán, chiến dịch, Tạo đơn)
/// - FastSale (DS bán hàng, DS giao hàng, Tạo đơn, Trả hàng)
/// - Kho hàng (Sản phẩm,
/// - Danh mục (Khách hàng, đối tác, nhà vận chuyển, Thu, chi)
List<MenuItem> applicationMenu = [
  MenuItem(
    id: 'facebookChannelList',
    name: () => S.current.menu_FacebookSaleChannel,
    tooltip:
        'Xem kênh bán hàng, xem bài viết, tạo đơn hàng từ comment trong bài viết đó',
    type: MenuGroupType.saleOnline,
    route: AppRoute.facebookSaleChannel,
    permission: PermissionFunction.saleOnlineFacebook_Feed,
    icon: Icon(
      FontAwesomeIcons.facebookF,
      color: MenuGroupType.saleOnline.backgroundColor,
    ),
    iconBuilder: (context, color) => Icon(
      FontAwesomeIcons.facebookF,
      color: color,
    ),
    gradient: const LinearGradient(colors: [
      Color(0xff305698),
      Color(0xff589AEF),
    ]),
  ),
  MenuItem(
    id: 'createSaleOnlineOrder',
    name: () => S.current.menu_CloseOrderLivestram,
    type: MenuGroupType.saleOnline,
    route: AppRoute.facebookSessions,
    permission: PermissionFunction.saleOnlineFacebook_Feed,
    gradient: const LinearGradient(colors: [
      Color(0xff305698),
      Color(0xff589AEF),
    ]),
    icon: SvgPicture.asset(
      "assets/icon/close-order.svg",
      alignment: Alignment.center,
    ),
    iconBuilder: (context, color) => SvgPicture.asset(
      "assets/icon/close-order.svg",
      alignment: Alignment.center,
      color: color,
    ),
  ),
  MenuItem(
    id: 'liveCampaign',
    name: () => S.current.menu_LiveCampaign,
    type: MenuGroupType.saleOnline,
    route: AppRoute.facebookLiveCampaign,
    permission: PermissionFunction.liveCampaign_Read,
    icon: SvgPicture.asset(
      "assets/icon/camera-multicolor.svg",
      alignment: Alignment.center,
    ),
    iconBuilder: (context, color) => SvgPicture.asset(
      "assets/icon/camera-multicolor.svg",
      alignment: Alignment.center,
      color: color,
    ),
  ),
  MenuItem(
    id: 'saleOnlineOrderList',
    name: () => S.current.menu_SaleOnlineOrder,
    type: MenuGroupType.saleOnline,
    route: AppRoute.saleOnlineOrders,
    permission: PermissionFunction.saleOnlineOrder_Read,
    icon: SvgPicture.asset(
      "assets/icon/bag-multicolor.svg",
      alignment: Alignment.center,
    ),
    iconBuilder: (context, color) => SvgPicture.asset(
      "assets/icon/bag-multicolor.svg",
      alignment: Alignment.center,
      color: color,
    ),
  ),

  /// Bán hàng nhanh
  MenuItem(
    id: 'fastSaleOrders',
    name: () => S.current.menu_fastSaleOrders,
    type: MenuGroupType.fastSaleOrder,
    route: AppRoute.fastSaleOrders,
    permission: PermissionFunction.fastSaleOrder_Read,
    icon: SvgPicture.asset(
      "assets/icon/menu_icon_fastsaleorder.svg",
      alignment: Alignment.center,
    ),
    iconBuilder: (context, color) => SvgPicture.asset(
      "assets/icon/menu_icon_fastsaleorder.svg",
      alignment: Alignment.center,
      color: color,
    ),
  ),
  // Hóa đơn giao hàng
  MenuItem(
    id: 'deliveryOrders',
    name: () => S.current.menu_deliverySaleOrders,
    type: MenuGroupType.fastSaleOrder,
    permission: PermissionFunction.fastSaleOrderDelivery_Read,
    route: AppRoute.deliveryOrder,
    icon: SvgPicture.asset(
      "assets/icon/truck-multicolor-blue.svg",
      alignment: Alignment.center,
    ),
    iconBuilder: (context, color) => SvgPicture.asset(
      "assets/icon/truck-multicolor-blue.svg",
      alignment: Alignment.center,
    ),
  ),
  // Hóa đơn trả hàng
  MenuItem(
    id: 'refundOrder',
    name: () => 'HĐ trả hàng',
    type: MenuGroupType.fastSaleOrder,
  ),
  // Tạo hóa đơn bán hàng online
  MenuItem(
    id: 'createFastOnlineOrder',
    name: () => S.current.menu_createFastSaleOrder,
    type: MenuGroupType.fastSaleOrder,
    route: AppRoute.addFastSaleOrder,
    permission: PermissionFunction.fastSaleOrder_Insert,
    gradient: const LinearGradient(colors: [
      Color(0xff22A1D1),
      Color(0xff75C9FF),
    ]),
    icon: Icon(
      Icons.add,
      color: MenuGroupType.fastSaleOrder.backgroundColor,
    ),
    iconBuilder: (context, color) => Icon(
      Icons.add,
      color: color,
    ),
  ),
  MenuItem(
    id: 'createFastSaleOrderRefund',
    name: () => 'Tạo trả hàng',
    type: MenuGroupType.fastSaleOrder,
  ),

  /// Báo giá
  MenuItem(
    route: AppRoute.saleQuotations,
    permission: PermissionFunction.saleQuotation_Read,
    id: 'saleQuotations',
    name: () => S.current.menu_quotation,
    type: MenuGroupType.fastSaleOrder,
    icon: SvgPicture.asset(
      "assets/icon/tag-green.svg",
    ),
    iconBuilder: (context, color) => SvgPicture.asset(
      "assets/icon/tag-green.svg",
      color: color,
    ),
  ),
// Điểm bán hàng
  MenuItem(
    id: 'posSale',
    name: () => S.current.menu_posOfSale,
    type: MenuGroupType.posOrder,
    route: AppRoute.posSale,
    permission: PermissionFunction.posOrderSale_Read,
    icon: SvgPicture.asset(
      "assets/icon/cart-multicolor.svg",
      alignment: Alignment.center,
    ),
    iconBuilder: (context, color) => SvgPicture.asset(
      "assets/icon/cart-multicolor.svg",
      alignment: Alignment.center,
    ),
    gradient: const LinearGradient(colors: [
      Color(0xff029729),
      Color(0xff29CE6B),
    ]),
  ),

  // Hóa đơn điểm bán hàng
  MenuItem(
    id: 'posOrders',
    name: () => S.current.posOrder,
    type: MenuGroupType.posOrder,
    permission: PermissionFunction.posOrderSale_Read,
    route: AppRoute.posOrder,
    icon: SvgPicture.asset(
      "assets/icon/cart-multicolor-green.svg",
      alignment: Alignment.center,
    ),
    iconBuilder: (context, color) => SvgPicture.asset(
      "assets/icon/cart-multicolor-green.svg",
      alignment: Alignment.center,
    ),
    gradient: const LinearGradient(colors: [
      Color(0xff029729),
      Color(0xff29CE6B),
    ]),
  ),
  MenuItem(
    id: 'posSession',
    name: () => S.current.menu_posSession,
    type: MenuGroupType.posOrder,
    route: AppRoute.posSession,
    icon: SvgPicture.asset(
      "assets/icon/cart-multicolor-green.svg",
      alignment: Alignment.center,
    ),
    iconBuilder: (context, color) => SvgPicture.asset(
      "assets/icon/cart-multicolor-green.svg",
      alignment: Alignment.center,
    ),
    gradient: const LinearGradient(colors: [
      Color(0xff029729),
      Color(0xff29CE6B),
    ]),
  ),

  // Báo giá
  MenuItem(
    id: 'saleOrders',
    name: () => S.current.menu_purchaseOrder,
    type: MenuGroupType.fastSaleOrder,
    route: AppRoute.saleOrders,
    permission: PermissionFunction.saleOrder_Read,
    icon: SvgPicture.asset(
      "assets/icon/pre-order-multicolor-blue.svg",
      alignment: Alignment.center,
    ),
    gradient: const LinearGradient(colors: [
      Color(0xff029729),
      Color(0xff29CE6B),
    ]),
  ),

  /// Kho
  MenuItem(
    route: AppRoute.productTemplates,
    id: 'productTemplates',
    name: () => S.current.menu_product,
    type: MenuGroupType.inventory,
    permission: PermissionFunction.productTemplate_Read,
    icon: SvgPicture.asset(
      "assets/icon/menu_icon_product.svg",
      alignment: Alignment.center,
    ),
  ),

  /// phiếu mua hàng nhanh
  MenuItem(
    route: AppRoute.fastPurchaseOrders,
    permission: PermissionFunction.fastPurchaseOrder_Read,
    id: 'stockInInvoice',
    name: () => S.current.menu_import,
    type: MenuGroupType.inventory,
    icon: SvgPicture.asset(
      "assets/icon/menu_icon_inventory_import.svg",
      alignment: Alignment.center,
    ),
  ),

  /// Phiếu trả hàng nhà cung cấp
  MenuItem(
    route: AppRoute.refundFastPurchseOrder,
    permission: PermissionFunction.fastPurchaseRefund_Read,
    id: 'stockOutInvoice',
    name: () => 'Trả hàng NCC',
    shortName: "Trả hàng",
    type: MenuGroupType.inventory,
    icon: SvgPicture.asset(
      "assets/icon/back-arrow-multicolor.svg",
      alignment: Alignment.center,
    ),
  ),

  /// Danh mục

  // Khách hàng
  MenuItem(
    route: AppRoute.customers,
    id: 'customers',
    name: () => S.current.menu_customer,
    type: MenuGroupType.category,
    permission: PermissionFunction.partnerCustomer_Read,
    icon: SvgPicture.asset(
      "assets/icon/menu_icon_customer.svg",
      alignment: Alignment.center,
    ),
  ),
  // Nhà cung cấp
  MenuItem(
    route: AppRoute.suppliers,
    permission: PermissionFunction.partnerSupplier_Read,
    id: 'suppliers',
    name: () => S.current.menu_supplier,
    type: MenuGroupType.category,
    icon: SvgPicture.asset(
      "assets/icon/menu_icon_supplier.svg",
      alignment: Alignment.center,
    ),
  ),
  // Đối tác giao hàng
  MenuItem(
    route: AppRoute.deliveryCarriers,
    permission: PermissionFunction.deliveryCarrier_Read,
    id: 'deliveryPartners',
    name: () => S.current.menu_deliveryCarrier,
    type: MenuGroupType.category,
    icon: SvgPicture.asset(
      "assets/icon/menu_icon_delivery_carrier.svg",
      alignment: Alignment.center,
    ),
    iconBuilder: (context, color) => SvgPicture.asset(
      "assets/icon/menu_icon_delivery_carrier.svg",
      alignment: Alignment.center,
      color: color,
    ),
  ),

  // Thêm khách hàng mới
  MenuItem(
    route: AppRoute.addCustomer,
    shortName: 'Thêm',
    id: 'customerAdd',
    name: () => S.current.menu_addCustomer,
    permission: PermissionFunction.partnerCustomer_Insert,
    type: MenuGroupType.setting,
    icon: Icon(Icons.add_circle),
    iconBuilder: (context, color) => SvgPicture.asset(
      "assets/icon/menu_icon_customer.svg",
      alignment: Alignment.center,
      color: color,
    ),
    gradient: const LinearGradient(colors: [
      Color(0xff029729),
      Color(0xff29CE6B),
    ]),
  ),

  // Thêm sản phẩm mới
  MenuItem(
    route: AppRoute.addProductTemplate,
    shortName: 'Thêm',
    id: 'addProductTemplate',
    name: () => S.current.menu_addProduct,
    permission: PermissionFunction.productTemplate_Insert,
    type: MenuGroupType.setting,
    icon: const Icon(
      Icons.add_circle,
      color: Colors.green,
    ),
    iconBuilder: (context, color) => Icon(Icons.add_circle, color: color),
    gradient: const LinearGradient(colors: [
      Color(0xffF25D27),
      Color(0xffF9A17F),
    ]),
  ),

  /// Config
  MenuItem(
    route: AppRoute.setting,
    id: 'settings',
    name: () => S.current.setting,
    type: MenuGroupType.setting,
    icon: SvgPicture.asset(
      "assets/icon/menu_icon_setting.svg",
      alignment: Alignment.center,
    ),
    iconBuilder: (context, color) => SvgPicture.asset(
      "assets/icon/menu_icon_setting.svg",
      alignment: Alignment.center,
      color: color,
    ),
    gradient: const LinearGradient(colors: [
      Color(0xff42526E),
      Color(0xffA5B4CE),
    ]),
  ),

  /// Cấu hình
  MenuItem(
    route: AppRoute.printSetting,
    id: 'settings',
    name: () => S.current.menu_settingPrinter,
    shortName: 'In ấn',
    type: MenuGroupType.setting,
  ),
  // Cài đặt điểm bán hàng
  MenuItem(
    route: AppRoute.fastSaleOrderSetting,
    id: 'Cài đặt bán hàng',
    name: () => S.current.menu_settingSaleOrder,
    type: MenuGroupType.setting,
  ),

// Danh mục khác
  MenuItem(
    route: AppRoute.product,
    id: 'product',
    name: () => 'Biến thể',
    icon: SvgPicture.asset(
      "assets/icon/menu_ic_product.svg",
      alignment: Alignment.center,
    ),
    type: MenuGroupType.category,
  ),
  // Nhóm sản phẩm
  MenuItem(
    route: AppRoute.productGroup,
    id: 'productGroup',
    name: () => S.current.menu_productGroup,
    icon: SvgPicture.asset(
      "assets/icon/menu_ic_group_product.svg",
      alignment: Alignment.center,
    ),
    type: MenuGroupType.category,
  ),
  // Nhóm khách hàng
  MenuItem(
    route: AppRoute.partnerGroup,
    id: 'partnerGroup',
    type: MenuGroupType.category,
    name: () => S.current.menu_customerGroup,
    icon: SvgPicture.asset(
      "assets/icon/menu_ic_partner_group.svg",
      alignment: Alignment.center,
    ),
  ),
  // Thêm đơn đặt hàng
  MenuItem(
    route: AppRoute.addOrder,
    permission: PermissionFunction.saleQuotation_Read,
    type: MenuGroupType.category,
    id: 'addOrder',
    name: () => 'Thêm đơn đặt hàng',
    icon: SvgPicture.asset(
      "assets/icon/menu_ic_add_order.svg",
      alignment: Alignment.center,
    ),
  ),

  // Kênh bán hàng
  MenuItem(
    route: AppRoute.saleChannel,
    type: MenuGroupType.category,
    id: 'saleChannel',
    name: () => S.current.menu_saleChannels,
    icon: SvgPicture.asset(
      "assets/icon/menu_ic_channel.svg",
      alignment: Alignment.center,
    ),
  ),
  // Mail template
  MenuItem(
    route: AppRoute.mailTemplate,
    type: MenuGroupType.category,
    id: 'mailTemplate',
    name: () => 'Mail template',
    icon: SvgPicture.asset(
      "assets/icon/menu_ic_mail_template.svg",
      alignment: Alignment.center,
    ),
  ),
  MenuItem(
      route: AppRoute.accountPayment,
      type: MenuGroupType.category,
      permission: PermissionFunction.accountingPhieuThu_Read,
      id: 'accountPayment',
      name: () => S.current.menu_cashReceipt,
      icon: SvgPicture.asset(
        "assets/icon/menu_ic_receipt.svg",
        alignment: Alignment.center,
      )),
  MenuItem(
    route: AppRoute.accountSalePayment,
    type: MenuGroupType.category,
    id: 'accountSalePayment',
    name: () => S.current.menu_paymentReceipt,
    permission: PermissionFunction.loaiThuChi_Read,
    icon: SvgPicture.asset(
      "assets/icon/menu_ic_payment.svg",
      alignment: Alignment.center,
    ),
  ),
  MenuItem(
    route: AppRoute.typeAccountPayment,
    type: MenuGroupType.category,
    id: 'typeAccountPayment',
    name: () => S.current.menu_receiptType,
    permission: PermissionFunction.loaiThuChi_Read,
    icon: SvgPicture.asset(
      "assets/icon/menu_ic_receipt.svg",
      alignment: Alignment.center,
    ),
  ),
  MenuItem(
    route: AppRoute.typeAccountSalePayment,
    type: MenuGroupType.category,
    id: 'typeAccountSalePayment',
    name: () => S.current.menu_paymentReceipt,
    icon: SvgPicture.asset(
      "assets/icon/menu_ic_payment.svg",
      alignment: Alignment.center,
    ),
  ),

  // Thống kê hóa đơn
  MenuItem(
    route: AppRoute.invoiceReport,
    type: MenuGroupType.report,
    id: AppRoute.invoiceReport,
    name: () => S.current.menu_invoiceReport,
    icon: SvgPicture.asset(
      "assets/icon/menu_icon_fastsaleorder.svg",
      alignment: Alignment.center,
      color: Colors.green,
    ),
  ),
  // Thống kê giao hàng
  MenuItem(
    route: AppRoute.deliveryReport,
    type: MenuGroupType.report,
    id: AppRoute.deliveryReport,
    name: () => S.current.menu_deliveryReport,
    icon: SvgPicture.asset(
      "assets/icon/menu_icon_delivery_carrier.svg",
      alignment: Alignment.center,
      color: Colors.green,
    ),
  ),
  // Thống kê tồn kho
  MenuItem(
    route: AppRoute.inventoryReport,
    type: MenuGroupType.report,
    id: AppRoute.inventoryReport,
    name: () => S.current.menu_inventoryReport,
    icon: SvgPicture.asset(
      "assets/icon/menu_icon_inventory_report.svg",
      alignment: Alignment.center,
      color: Colors.green,
    ),
  ),
  // Báo cáo kết quả kinh doanh
  MenuItem(
    route: AppRoute.businessResultReport,
    type: MenuGroupType.report,
    id: AppRoute.businessResultReport,
    name: () => S.current.menu_businessReport,
    icon: SvgPicture.asset(
      "assets/icon/menu_icon_business_report.svg",
      alignment: Alignment.center,
      color: Colors.green,
    ),
  ),
  // Công nợ khách hàng
  MenuItem(
    route: AppRoute.customerDeptReport,
    type: MenuGroupType.report,
    id: AppRoute.customerDeptReport,
    name: () => S.current.menu_customerDeptReport,
    icon: SvgPicture.asset(
      "assets/icon/menu_icon_customer.svg",
      alignment: Alignment.center,
      color: Colors.green,
    ),
  ),
  // Công nợ nhà cung cấp
  MenuItem(
    route: AppRoute.supplierDeptReport,
    type: MenuGroupType.report,
    id: AppRoute.supplierDeptReport,
    name: () => S.current.menu_supplierDeptReport,
    icon: SvgPicture.asset(
      "assets/icon/menu_icon_supplier.svg",
      alignment: Alignment.center,
      color: Colors.green,
    ),
  ),
  MenuItem(
      route: AppRoute.reportMenu,
      type: MenuGroupType.report,
      id: AppRoute.reportMenu,
      name: () => S.current.menuGroup_report,
      icon: const Icon(
        FontAwesomeIcons.chartBar,
        color: Colors.green,
      ),
      iconBuilder: (context, color) => const Icon(
            FontAwesomeIcons.chartBar,
            color: Colors.grey,
          ),
      visible: false,
      onPressed: (context) {
        Navigator.push(
          context,
          PageRouteBuilder(
            opaque: false,
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => Hero(
              tag: AppRoute.reportMenu,
              child: ReportDashboardOtherReportPage(),
            ),
          ),
        );
      }),
  MenuItem(
    route: AppRoute.addMenu,
    type: MenuGroupType.report,
    id: AppRoute.addMenu,
    name: () => S.current.add,
    icon: const Icon(
      Icons.add,
      color: Colors.green,
    ),
    iconBuilder: (context, color) => const Icon(
      CupertinoIcons.add_circled,
      color: Colors.grey,
    ),
    visible: false,
  ),
];

/// Get drawer menu config
HomeMenuConfig drawerMenu() {
  return HomeMenuConfig(name: 'Drawer menu', version: '1.0', menuGroups: [
    HomeMenuConfigGroup(
        name: MenuGroupType.saleOnline.description,
        menuGroupType: MenuGroupType.saleOnline,
        children: [
          AppRoute.facebookSaleChannel,
          AppRoute.saleOnlineOrders,
          AppRoute.facebookLiveCampaign,
        ]),
    HomeMenuConfigGroup(
        name: MenuGroupType.fastSaleOrder.description,
        menuGroupType: MenuGroupType.fastSaleOrder,
        children: [
          AppRoute.fastSaleOrders,
          AppRoute.deliveryOrder,
        ]),

    /// Điểm bán hàng
    HomeMenuConfigGroup(
        name: MenuGroupType.posOrder.description,
        menuGroupType: MenuGroupType.posOrder,
        children: [
          AppRoute.posSale,
          AppRoute.posOrder,
          AppRoute.posSession,
        ]),

    // Kho hàng
    HomeMenuConfigGroup(
        name: MenuGroupType.inventory.description,
        menuGroupType: MenuGroupType.inventory,
        children: [
          AppRoute.product,
          AppRoute.productGroup,
          AppRoute.fastPurchaseOrders,
          AppRoute.refundFastPurchseOrder,
        ]),

    /// Danh mục
    HomeMenuConfigGroup(
        name: MenuGroupType.category.description,
        menuGroupType: MenuGroupType.category,
        children: [
          AppRoute.customers,
          AppRoute.suppliers,
          AppRoute.deliveryCarriers,
        ]),
    // Cài đặt
    HomeMenuConfigGroup(
        name: MenuGroupType.setting.description,
        menuGroupType: MenuGroupType.setting,
        children: [
          AppRoute.setting,
          AppRoute.saleSetting,
          AppRoute.saleOnlineSetting,
          AppRoute.printSetting,
        ]),
  ]);
}

/// Get home all menu
HomeMenuConfig homeMenuAll() {
  return HomeMenuConfig(name: 'Menu tùy chỉnh', version: '1.0', mainMenus: [
    AppRoute.addFastSaleOrder,
    AppRoute.addMenu,
    AppRoute.reportMenu,
    AppRoute.setting,
  ], menuGroups: [
    HomeMenuConfigGroup(
        name: 'Bán hàng online',
        menuGroupType: MenuGroupType.saleOnline,
        color: MenuGroupType.saleOnline.backgroundColor.value,
        children: [
          AppRoute.facebookSaleChannel,
          AppRoute.facebookSessions,
          AppRoute.saleOnlineOrders,
          AppRoute.facebookLiveCampaign,
        ]),
    HomeMenuConfigGroup(
        name: 'Bán hàng nhanh',
        menuGroupType: MenuGroupType.fastSaleOrder,
        color: MenuGroupType.fastSaleOrder.backgroundColor.value,
        children: [
          AppRoute.addFastSaleOrder,
          AppRoute.fastSaleOrders,
          AppRoute.deliveryOrder,
          AppRoute.saleOrders,
          AppRoute.saleQuotations,
        ]),
    HomeMenuConfigGroup(
        name: 'Điểm bán hàng',
        menuGroupType: MenuGroupType.posOrder,
        color: MenuGroupType.posOrder.backgroundColor.value,
        children: [
          AppRoute.posSale,
          AppRoute.posSession,
          AppRoute.posOrder,
        ]),
    HomeMenuConfigGroup(
        name: 'Kho hàng',
        menuGroupType: MenuGroupType.inventory,
        color: MenuGroupType.inventory.backgroundColor.value,
        children: [
          AppRoute.productTemplates,
          AppRoute.fastPurchaseOrders,
          AppRoute.refundFastPurchseOrder,
        ]),
    HomeMenuConfigGroup(
        name: 'Danh mục',
        menuGroupType: MenuGroupType.category,
        color: MenuGroupType.category.backgroundColor.value,
        maxLine: 2,
        children: [
          AppRoute.customers,
          AppRoute.suppliers,
          AppRoute.deliveryCarriers,
          AppRoute.accountPayment,
          AppRoute.accountSalePayment,
          AppRoute.mailTemplate,
          AppRoute.saleChannel,
          AppRoute.partnerGroup,
          AppRoute.productGroup,
          AppRoute.typeAccountPayment,
          AppRoute.typeAccountSalePayment,
        ]),
    HomeMenuConfigGroup(
        menuGroupType: MenuGroupType.setting,
        name: 'Cài đặt',
        color: MenuGroupType.setting.backgroundColor.value,
        children: [
          AppRoute.setting,
          AppRoute.fastSaleOrderSetting,
          AppRoute.printSetting,
        ]),
  ]);
}
