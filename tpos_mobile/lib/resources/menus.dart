import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tpos_mobile/application/menu_v2/model.dart';
import 'package:tpos_mobile/feature_group/reports/statistic_report/report_dashboard_other_report_page.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/resources/permission.dart';
import 'package:tpos_mobile/resources/tpos_mobile_icons.dart';
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
    this.badge,
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
  final String badge;

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
      case MenuGroupType.tpage:
        return S.current.menuGroupType_tpage;
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
        return const Color(0xff28A745);
      case MenuGroupType.inventory:
        return const Color(0xffE56D41);
      case MenuGroupType.category:
        return const Color(0xff42526E);
      case MenuGroupType.setting:
        return const Color(0xff42526B);
      case MenuGroupType.report:
        return const Color(0xff28A745);
      case MenuGroupType.tpage:
        return const Color(0xff6BBE40);
      default:
        return const Color(0xff42526E);
    }
  }

  Color get textColor {
    switch (this) {
      case MenuGroupType.saleOnline:
        return Colors.white;
      case MenuGroupType.fastSaleOrder:
        return Colors.white;
      case MenuGroupType.posOrder:
        return Colors.white;
      case MenuGroupType.inventory:
        return Colors.white;
      case MenuGroupType.category:
        return Colors.white;
      case MenuGroupType.setting:
        return Colors.white;
      case MenuGroupType.report:
        return Colors.white;
      case MenuGroupType.tpage:
        return Colors.white;
      default:
        return const Color(0xff42526E);
    }
  }

  LinearGradient get linearGradient {
    switch (this) {
      case MenuGroupType.saleOnline:
        return const LinearGradient(
            colors: [Color(0xff3B7AD9), Color(0xff6EB3F8)]);
      case MenuGroupType.fastSaleOrder:
        return const LinearGradient(
            colors: [Color(0xff2EB2E8), Color(0xff79D8FF)]);
      case MenuGroupType.posOrder:
        return const LinearGradient(
            colors: [Color(0xff28A745), Color(0xff45CC64)]);
      case MenuGroupType.inventory:
        return const LinearGradient(
            colors: [Color(0xffE56D41), Color(0xffFDAB8D)]);
      case MenuGroupType.category:
        return const LinearGradient(
            colors: [Color(0xff42526E), Color(0xff62769A)]);
      case MenuGroupType.setting:
        return const LinearGradient(
            colors: [Color(0xff42526E), Color(0xff62769A)]);
      case MenuGroupType.report:
        return const LinearGradient(
            colors: [Color(0xff42526E), Color(0xff62769A)]);
      case MenuGroupType.tpage:
        return const LinearGradient(
            colors: [Color(0xff6BBE40), Color(0xff9AE871)]);
      default:
        return const LinearGradient(
            colors: [Color(0xff42526E), Color(0xff62769A)]);
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
    icon: const Icon(
      TPosIcons.facebook_fill_blue,
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
    icon: const Icon(
      TPosIcons.live_session_fill,
    ),
    iconBuilder: (context, color) =>
        SvgIcon(SvgIcon.menuCloseOrder, color: color),
  ),
  MenuItem(
    id: 'liveCampaign',
    name: () => S.current.menu_LiveCampaign,
    type: MenuGroupType.saleOnline,
    route: AppRoute.facebookLiveCampaign,
    permission: PermissionFunction.liveCampaign_Read,
    icon: const Icon(
      TPosIcons.camera_fill,
    ),
    iconBuilder: (context, color) => Icon(TPosIcons.camera_fill, color: color),
  ),
  MenuItem(
    id: 'saleOnlineOrderList',
    name: () => S.current.menu_SaleOnlineOrder,
    type: MenuGroupType.saleOnline,
    route: AppRoute.saleOnlineOrders,
    permission: PermissionFunction.saleOnlineOrder_Read,
    icon: const Icon(
      TPosIcons.bag_fill_blue,
    ),
    iconBuilder: (context, color) =>
        Icon(TPosIcons.bag_fill_blue, color: color),
  ),

  /// Bán hàng nhanh
  MenuItem(
    id: 'fastSaleOrders',
    name: () => S.current.menu_fastSaleOrders,
    type: MenuGroupType.fastSaleOrder,
    route: AppRoute.fastSaleOrders,
    permission: PermissionFunction.fastSaleOrder_Read,
    icon: const Icon(
      TPosIcons.invoice_fill,
    ),
    iconBuilder: (context, color) => Icon(
      TPosIcons.invoice_fill,
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
    icon: const Icon(
      TPosIcons.truck_fill_blue,
    ),
    iconBuilder: (context, color) => Icon(
      TPosIcons.truck_fill_blue,
      color: color,
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
    icon: const Icon(
      TPosIcons.create_order_fill,
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
    icon: const Icon(
      TPosIcons.bag_fill_blue,
    ),
    iconBuilder: (context, color) => SvgIcon(SvgIcon.menuTag, color: color),
  ),
// Điểm bán hàng
  MenuItem(
    id: 'posSale',
    name: () => S.current.menu_posOfSale,
    type: MenuGroupType.posOrder,
    route: AppRoute.posSale,
    permission: PermissionFunction.posOrderSale_Read,
    icon: const Icon(
      TPosIcons.cart_fill_green,
    ),
    iconBuilder: (context, color) => Icon(
      TPosIcons.cart_fill_green,
      color: color,
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
    icon: const Icon(
      TPosIcons.invoice_fill,
    ),
    iconBuilder: (context, color) => const Icon(TPosIcons.bag_fill_blue),
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
    icon: const Icon(
      TPosIcons.bag_fill_blue,
    ),
    iconBuilder: (context, color) => const Icon(TPosIcons.bag_fill_blue),
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
    icon: const Icon(
      TPosIcons.pre_order_fill_blue,
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
    icon: const Icon(
      TPosIcons.product_fill,
    ),
  ),

  /// phiếu mua hàng nhanh
  MenuItem(
    route: AppRoute.fastPurchaseOrders,
    permission: PermissionFunction.fastPurchaseOrder_Read,
    id: 'stockInInvoice',
    name: () => S.current.menu_import,
    type: MenuGroupType.inventory,
    icon: const Icon(
      TPosIcons.bag_fill_blue,
    ),
  ),

  /// Phiếu trả hàng nhà cung cấp
  MenuItem(
    route: AppRoute.refundFastPurchseOrder,
    permission: PermissionFunction.fastPurchaseRefund_Read,
    id: 'stockOutInvoice',
    name: () => S.current.menu_returnToSupplier,
    shortName: "Trả hàng",
    type: MenuGroupType.inventory,
    icon: const Icon(
      TPosIcons.return_icon,
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
    icon: const Icon(
      TPosIcons.user_fill,
    ),
  ),
  // Nhà cung cấp
  MenuItem(
    route: AppRoute.suppliers,
    permission: PermissionFunction.partnerSupplier_Read,
    id: 'suppliers',
    name: () => S.current.menu_supplier,
    type: MenuGroupType.category,
    icon: const Icon(
      TPosIcons.warehouse_fill,
    ),
  ),
  // Đối tác giao hàng
  MenuItem(
    route: AppRoute.deliveryCarriers,
    permission: PermissionFunction.deliveryCarrier_Read,
    id: 'deliveryPartners',
    name: () => S.current.menu_deliveryCarrier,
    type: MenuGroupType.category,
    icon: const Icon(
      TPosIcons.truck_fill_blue,
    ),
    iconBuilder: (context, color) => const Icon(
      TPosIcons.truck_fill_blue,
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
    icon: const Icon(TPosIcons.bag_fill_blue),
    iconBuilder: (context, color) => Icon(TPosIcons.bag_fill_blue,
        color: MenuGroupType.report.backgroundColor),
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
    icon: const Icon(TPosIcons.bag_fill_blue),
    iconBuilder: (context, color) => Icon(Icons.add_circle, color: color),
    gradient: const LinearGradient(colors: [
      Color(0xffF25D27),
      Color(0xffF9A17F),
    ]),
  ),
  MenuItem(
    route: AppRoute.productAttributeValues,
    id: 'productAttributeValues',
    name: () => S.current.menu_product_attribute_values,
    type: MenuGroupType.category,
    permission: PermissionFunction.partnerCustomer_Read,
    icon: Icon(
      TPosIcons.bag_fill_blue,
      color: MenuGroupType.category.backgroundColor,
    ),
  ),
  MenuItem(
      route: AppRoute.productAttributes,
      id: 'productAttributes',
      name: () => S.current.menu_product_attributes,
      type: MenuGroupType.category,
      permission: PermissionFunction.partnerCustomer_Read,
      icon: Icon(TPosIcons.unit_fill,
          color: MenuGroupType.category.backgroundColor)),
  MenuItem(
    route: AppRoute.productUoms,
    id: 'productUoms',
    name: () => S.current.menu_product_uoms,
    type: MenuGroupType.category,
    permission: PermissionFunction.partnerCustomer_Read,
    icon: Icon(
      TPosIcons.unit_fill,
      color: MenuGroupType.category.backgroundColor,
    ),
  ),

  /// Config
  MenuItem(
    route: AppRoute.setting,
    id: 'settings',
    name: () => S.current.setting,
    type: MenuGroupType.setting,
    icon: const Icon(
      TPosIcons.gear_fill_light_green,
    ),
    iconBuilder: (context, color) => SvgIcon(
      SvgIcon.menuSetting,
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
    icon: const Icon(
      TPosIcons.setting_print_fill,
    ),
  ),
  // Cài đặt điểm bán hàng
  MenuItem(
    route: AppRoute.fastSaleOrderSetting,
    id: 'Cài đặt bán hàng',
    name: () => S.current.menu_settingSaleOrder,
    type: MenuGroupType.setting,
    icon: const Icon(
      TPosIcons.setting_sale_fill,
    ),
  ),

// Danh mục khác
  MenuItem(
    route: AppRoute.product,
    id: 'product',
    name: () => S.current.productVariation,
    icon: const Icon(
      TPosIcons.variant_fill,
    ),
    type: MenuGroupType.category,
  ),
  // Nhóm sản phẩm
  MenuItem(
    route: AppRoute.productGroup,
    id: 'productGroup',
    name: () => S.current.menu_productGroup,
    icon: const Icon(
      TPosIcons.group_product_fill,
    ),
    type: MenuGroupType.category,
  ),
  // Nhóm khách hàng
  MenuItem(
    route: AppRoute.partnerGroup,
    id: 'partnerGroup',
    type: MenuGroupType.category,
    name: () => S.current.menu_customerGroup,
    icon: const Icon(
      TPosIcons.team_fill,
    ),
  ),
  // Thêm đơn đặt hàng
  MenuItem(
    route: AppRoute.addOrder,
    permission: PermissionFunction.saleQuotation_Read,
    type: MenuGroupType.category,
    id: 'addOrder',
    name: () => 'Thêm đơn đặt hàng',
    icon: const Icon(
      TPosIcons.pre_order_fill_blue,
    ),
  ),

  // Kênh bán hàng
  MenuItem(
    route: AppRoute.saleChannel,
    type: MenuGroupType.category,
    id: 'saleChannel',
    name: () => S.current.menu_saleChannels,
    icon: const Icon(
      TPosIcons.multi_chanel_fill,
    ),
  ),
  // Mail template
  MenuItem(
    route: AppRoute.mailTemplate,
    type: MenuGroupType.category,
    id: 'mailTemplate',
    name: () => 'Mail template',
    icon: const Icon(
      TPosIcons.envelope_fill,
    ),
  ),

  /// PHiếu thu
  MenuItem(
      route: AppRoute.accountPayment,
      type: MenuGroupType.category,
      permission: PermissionFunction.accountingPhieuThu_Read,
      id: 'accountPayment',
      name: () => S.current.menu_cashReceipt,
      icon: const Icon(
        TPosIcons.receipt_fill,
      )),

  /// Phiếu chi
  MenuItem(
    route: AppRoute.accountSalePayment,
    type: MenuGroupType.category,
    id: 'accountSalePayment',
    name: () => S.current.menu_paymentReceipt,
    permission: PermissionFunction.loaiThuChi_Read,
    icon: const Icon(
      TPosIcons.payment_fill,
    ),
  ),
  MenuItem(
    route: AppRoute.typeAccountPayment,
    type: MenuGroupType.category,
    id: 'typeAccountPayment',
    name: () => S.current.menu_receiptType,
    permission: PermissionFunction.loaiThuChi_Read,
    icon: const Icon(
      TPosIcons.receipt_fill,
    ),
  ),
  MenuItem(
    route: AppRoute.typeAccountSalePayment,
    type: MenuGroupType.category,
    id: 'typeAccountSalePayment',
    name: () => S.current.menu_paymentType,
    icon: const Icon(
      TPosIcons.payment_fill,
    ),
  ),
  MenuItem(
    route: AppRoute.tag,
    type: MenuGroupType.category,
    id: 'tags',
    name: () => S.current.tags,
    icon: const Icon(
      TPosIcons.tag,
    ),
  ),

  // Thống kê hóa đơn
  MenuItem(
    route: AppRoute.invoiceReport,
    type: MenuGroupType.report,
    id: AppRoute.invoiceReport,
    name: () => S.current.menu_invoiceReport,
    icon: const Icon(
      TPosIcons.invoice_fill,
    ),
  ),
  // Thống kê giao hàng
  MenuItem(
      route: AppRoute.deliveryReport,
      type: MenuGroupType.report,
      id: AppRoute.deliveryReport,
      name: () => S.current.menu_deliveryReport,
      icon: const Icon(
        TPosIcons.truck_fill_blue,
      )),
  // Thống kê tồn kho
  MenuItem(
      route: AppRoute.inventoryReport,
      type: MenuGroupType.report,
      id: AppRoute.inventoryReport,
      name: () => S.current.menu_inventoryReport,
      icon: const Icon(
        TPosIcons.stock_fill,
      )),
  // Báo cáo kết quả kinh doanh
  MenuItem(
      route: AppRoute.businessResultReport,
      type: MenuGroupType.report,
      id: AppRoute.businessResultReport,
      name: () => S.current.menu_businessReport,
      icon: const Icon(
        TPosIcons.revenue_fill,
      )),
  // Công nợ khách hàng
  MenuItem(
      route: AppRoute.customerDeptReport,
      type: MenuGroupType.report,
      id: AppRoute.customerDeptReport,
      name: () => S.current.menu_customerDeptReport,
      icon: const Icon(
        TPosIcons.user_fill,
      )),
  // Công nợ nhà cung cấp
  MenuItem(
      route: AppRoute.supplierDeptReport,
      type: MenuGroupType.report,
      id: AppRoute.supplierDeptReport,
      name: () => S.current.menu_supplierDeptReport,
      icon: const Icon(
        TPosIcons.warehouse_fill,
      )),

  // Tổng hợp report
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

  /// Menu tổng hợp các menu thêm
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

  /// Menu quản lý hội thoại
  MenuItem(
      route: AppRoute.conversations_tpage,
      type: MenuGroupType.tpage,
      id: AppRoute.conversations_tpage,
      name: () => S.current.menu_tpageConversation,
      icon: const Icon(
        TPosIcons.facebook_fill_blue,
      ),
      iconBuilder: (context, color) => const Icon(
            CupertinoIcons.add_circled,
            color: Colors.grey,
          ),
      visible: false,
      badge: S.current.newa),

  /// Menu Cấu hình Tpage
  MenuItem(
    route: AppRoute.configs_tpage,
    type: MenuGroupType.tpage,
    id: AppRoute.configs_tpage,
    name: () => S.current.menu_tpageConfig,
    icon: const Icon(
      TPosIcons.gear_fill_light_green,
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
          AppRoute.productUoms,
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
        name: 'Bán hàng facebook',
        menuGroupType: MenuGroupType.saleOnline,
        color: MenuGroupType.saleOnline.backgroundColor.value,
        children: [
          AppRoute.facebookSaleChannel,
          if (kDebugMode) //TODO(namnv): Bỏ If này sau khi tính năng chốt đơn hoàn thànhAppRoute.facebookSessions,
            AppRoute.saleOnlineOrders,
          AppRoute.facebookLiveCampaign,
          AppRoute.conversations_tpage,
          AppRoute.configs_tpage,
        ]),
    // HomeMenuConfigGroup(
    //     name: 'Quản lý page',
    //     menuGroupType: MenuGroupType.tpage,
    //     color: MenuGroupType.tpage.backgroundColor.value,
    //     children: [
    //       AppRoute.conversations_tpage,
    //       AppRoute.configs_tpage,
    //     ]),
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
          AppRoute.tag,
          AppRoute.productAttributeValues,
          AppRoute.productAttributes,
          AppRoute.productUoms,
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

/// Get Menu All V2. Tất cả menu, Định nghĩa theo group
HomeMenuV2FavoriteModel getFavoriteMenu() {
  return HomeMenuV2FavoriteModel(maxItem: 16, maxPage: 2, routes: [
    AppRoute.facebookSaleChannel,
    AppRoute.saleOnlineOrders,
    AppRoute.facebookLiveCampaign,
    AppRoute.conversations_tpage,
    AppRoute.addFastSaleOrder,
    AppRoute.fastSaleOrders,
    AppRoute.deliveryOrder,
    AppRoute.setting,
    AppRoute.customers,
    AppRoute.productTemplates,
  ]);
}
