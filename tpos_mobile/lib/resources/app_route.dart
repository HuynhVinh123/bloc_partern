class AppRoute {
  static const String intro = '/intro';
  static const String login = "/login";
  static const String home = "/home";
  static const String register = '/register';
  static const String about = '/about';
  static const String history = '/history';
  static const String loading = '/loading';

  /// Sale online
  static const String facebookSaleChannel = '/crmTeams/facebook';
  static const String facebookLiveCampaign = '/liveCampaigns';
  static const String saleOnlineOrders = '/saleOnlineOrder/list';
  static const String facebookSessions = '/saleOnlineOrder/session';
  static const String addFacebookSession = '/saleOnlineOrder/addSession';

  /// Fast Sale Order
  static const String fastSaleOrders = '/fastSaleOrders/list';
  static const String deliveryOrder = '/fastSaleOrders/delivery';
  static const String addFastSaleOrder = '/fastSaleOrder/add';
  static const String editFastSaleOrder = '/fastSaleOrder/edit';

  static const fast_sale_order_add_edit_ship_receiver =
      "/app/fastSaleOrder/addEditShipReceiver";

  /// Sale Order | Đơn đặt hàng
  static const String saleOrders = '/saleOrders/list';
  static const String addSaleOrder = '/saleOrders/add';
  static const String editSaleOrder = "/saleOrders/edit";
  static const String saleOrderInfo = "/saleOrders/info";

  // Danh mục
  static const String customers = '/partners/customers';
  static const String suppliers = '/partners/suppliers';
  static const String deliveryCarriers = '/deliveryCarriers';

  static const String addCustomer = '/partners/addCustomer';
  static const String addSupplier = '/partners/addSupplier';
  static const String editCustomer = '/partners/editCustomer';
  static const String editSupplier = '/partners/editSupplier';
  static const String productAttributeValues = '/productAttributeValues';
  static const String productAttributes = '/productAttributes';
  static const String productUoms = '/productUoms';

  // Cài đặt
  static const String setting = '/settings/all';
  static const String printSetting = '/settings/print';
  static const String saleSetting = '/settings/sale';
  static const String saleOnlineSetting = '/settings/saleOnline';
  static const String fastSaleOrderSetting = '/settings/fastSaleOrder';
  static const String printersSetting = '/settings/printers';
  static const String homeSetting = '/settings/home';
  static const String saleOnlinePrinterSetting = '/settings/saleOnline/printer';
  static const String shipPrinterSetting = '/settings/ship/printer';
  static const String fastSaleOrderPrinterSetting =
      '/settings/fastSaleOrder/printer';
  static const String posOrderPrinterSetting = '/settings/pos/printer';
  static const String saleOnlinePrintContentSetting =
      '/settings/saleOnline/printerContent';
  // Kho hàng
  static const String fastPurchaseOrders = '/fastPurchaseOrders';
  static const String refundFastPurchseOrder = '/fastPurchaseOrders/refund';
  static const String productTemplates = '/productTemplates';
  static const String addProductTemplate = '/productTemplates/add';
  static const String stockInventories =
      '/stockInventory'; // Điều chỉnh tồn kho

  // Điểm bán hàng
  static const String posSale = '/posSale';
  static const String posSession = "/posSession";
  static const String posOrder = "/posOrders";

  /// Báo giá
  static const String saleQuotations = "/saleQuatations";

  /*Báo cáo*/

  /// Thống kê tồn kho
  static const String inventoryReport = "/report/inventory";

  /// Thống kê hóa đơn
  static const String invoiceReport = '/report/OrderReport';

  /// Thống kê giao hàng
  static const String deliveryReport = '/report/deliveryReport';

  /// Báo cáo kết quả kinh doanh
  static const String businessResultReport = '/report/businessResult';

  /// Báo cáo công nợ khách hàng
  static const String customerDeptReport = '/report/customerDeptReport';

  /// Báo cáo công nợ nhà cung cấp
  static const String supplierDeptReport = '/report/supplierDeptReport';

  /* Danh mục*/
  static const String product = "/inventory";
  static const String productGroup = "/productGroup";
  static const String partnerGroup = "/partnerGroup";
  static const String addOrder = "/addOrder";
  static const String saleChannel = "/saleChannel";
  static const String mailTemplate = "/mailTemplate";
  static const String accountPayment = "/accountPayment";
  static const String accountSalePayment = "/accountSalePayment";
  static const String typeAccountPayment = "/typeAccountPayment";
  static const String typeAccountSalePayment = "/typeAccountSalePayment";
  static const String productTemplateList = "/productTemplateList";
  static const String tag = "/tag";

  /*Menu*/
  /// Menu report
  static const String reportMenu = '/menu/report';
  static const String addMenu = '/menu/add';

  /// TPage
  static const String conversations_tpage = "/conversations";
  static const String configs_tpage = "/configs";
  static const String channels_tpage = "/channels";

  /// Route thay đổi công ty
  static const String changeCompany = "/changeCompany";
  ///Đồng bộ cấu hình
  static const String configurationSync = '/configurationSync';
}
