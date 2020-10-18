import 'package:flutter/foundation.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

import 'package:tpos_mobile/feature_group/category/mail_template/mail_template.dart';

import 'package:tpos_mobile/feature_group/pos_order/models/pos_make_payment.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_order.dart';
import 'package:tpos_mobile/feature_group/reports/business_result.dart';
import 'package:tpos_mobile/feature_group/reports/thong_ke_giao_hang/report_delivery.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/FacebookWinner.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/fetch_comment.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_service/calculate_fee_result.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_service/create_invoice_from_app_request.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_service/odata_filter.dart';
import 'package:tpos_mobile/feature_group/sale_online/services/tpos_api_service.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_line.dart';
import 'package:tpos_mobile/feature_group/sale_quotation/models/base_model_sale_quotation.dart';
import 'package:tpos_mobile/src/tpos_apis/models/facebook_account.dart';

import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order.dart';

import 'package:tpos_mobile/src/facebook_apis/facebook_api.dart';
import 'package:tpos_mobile/src/facebook_apis/src/models/get_facebook_partner_result.dart';
import 'package:tpos_mobile/src/facebook_apis/src/models/get_saved_facebook_post_result.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_account_tax.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_application_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_partner.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_payment.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_stock_picking_type.dart';

import 'package:tpos_mobile/src/tpos_apis/models/get_ship_token_result_model.dart';
import 'package:tpos_mobile/src/tpos_apis/models/order_line.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner_detail_report.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner_report.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner_staff_detail_report.dart';
import 'package:tpos_mobile/src/tpos_apis/models/product_cateogry_for_stock_ware_house_report.dart';
import 'package:tpos_mobile/src/tpos_apis/models/sale_quotation_detail.dart';

import 'package:tpos_mobile/src/tpos_apis/models/status_extra.dart';
import 'package:tpos_mobile/src/tpos_apis/models/stock_report_result.dart';
import 'package:tpos_mobile/src/tpos_apis/models/supplier_report.dart';
import 'package:tpos_mobile/src/tpos_apis/models/tpos_city.dart';
import 'package:tpos_mobile/src/tpos_apis/models/user_activities.dart';
import 'package:tpos_mobile/src/tpos_apis/models/user_facebook_comment.dart';

import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';

abstract class ITposApiService {
  /// Lấy danh sách tỉnh  thành đăng kí ứng dụng
  Future<List<TPosCity>> getTposCity();

  /// Lấy thông tin người đang đăng nhập
  Future<TposUser> getLoginedUserInfo();

  /// Kiểm token còn hiệu lực
  Future<bool> checkTokenIsValid();

  Future<CheckFacebookIdResult> checkFacebookId(
      String asUid, String postId, int teamId,
      {int timeoutSecond});

  Future<String> getFacebookUidFromAsuid(String asuid, int teamId);

  /// Kiểm tra khách hàng theo Asuid
  Future<Map<String, dynamic>> checkPartnerJson({
    @required String aSUId,
  });

  /// Lấy danh sách trạng thái đơn hàng
  Future<List<SaleOnlineStatusType>> getSaleOnlineOrderStatus();

  /// Lấy trạng thái đơn hàng
  Future<List<SaleOnlineStatusType>> getSaleOnlineStatus();

  /// Lấy danh sách chiến dịch live còn hoạt động
  Future<List<LiveCampaign>> getAvaibleLiveCampaigns();

  /// Lấy danh sách chiến dịch
  Future<List<LiveCampaign>> getLiveCampaigns();

  /// Lấy chiến dịch của bài đăng hiện tại
  Future<LiveCampaign> getLiveCampaignByPostId(String postId);

  /// Lấy chi chiến dịch live theo Id
  Future<LiveCampaign> getDetailLiveCampaigns(String liveCampaignId);

  /// Thêm chiến dịch live mới
  Future<bool> addLiveCampaign({@required LiveCampaign newLiveCampaign});

  /// Sửa chiến dịch live
  Future<bool> editLiveCampaign(LiveCampaign editLiveCampaign);

  // SaleOnlineLiveCampaign-Update| Cập nhật thông tin chiến dịch
  Future<bool> updateLiveCampaignFacebook(
      {@required LiveCampaign campaign,
      TposFacebookPost tposFacebookPost,
      bool isCancel = false});

  /// Lấy tất cả danh sách khách hàng facebook
  Future<Map<String, GetFacebookPartnerResult>> getFacebookPartners(int teamId);

  /// Tìm kiếm danh mục sản phẩm
  Future<ProductSearchResult<List<ProductCategory>>> productCategorySearch(
      String keyword,
      {int top,
      int skip,
      OdataSortItem sortBy});



  /// Lấy danh sách report delivery order line
  Future<List<ReportDeliveryOrderLine>> getReportDeliveryOrderDetail(int id);

  /// Lấy đơn hàng sale online theo Id
  Future<SaleOnlineOrder> getOrderById(String orderId);

  /// Xóa đơn hàng online
  Future<void> deleteSaleOnlineOrder(String orderId);

  /// Lấy Fast sale order line theo Id
  Future<List<SaleOrderLine>> getSaleOrderLineById(int orderId);

  /// Cập nhật trạng thái giao hàng tất cả hóa đơn
  Future<void> refreshFastSaleOnlineOrderDeliveryState();

  /// Cập nhật trạng thái giao hàng hóa đơn được chọn
  Future<void> refreshFastSaleOrderDeliveryState(List<int> ids);

  /// Lây danh sách đơn hàng sale online theo Facebook Post Id
  Future<List<SaleOnlineOrder>> getOrdersByFacebookPostId(String postId);
  Future<int> getProductQuantityByPostId(String postId);

  /// Tạo đơn hàng từ app
  Future<SaleOnlineOrder> insertSaleOnlineOrderFromApp(SaleOnlineOrder order,
      {int timeoutSecond});

  /// Sửa đơn hàng từ app
  Future<void> updateSaleOnlineOrder(SaleOnlineOrder order);

  /// Lấy danh sách bài đăng đã lưu (id, liveCampaignId, liveCampaignName)
  Future<List<SavedFacebookPost>> getSavedFacebookPost(
      String fromId, List<String> postIds);

  /// Sale order info
  Future<List<SaleOrderLine>> getSaleOrderInfo(int id);

  /// Reset số thứ tự đơn hàng sale online
  Future<bool> resetSaleOnlineOrderSessionIndex();

  /// Check địa chỉ
  Future<List<CheckAddress>> quickCheckAddress(String keyword);

  /// Lấy
  Future<GetSaleOnlineOrderFromAppResult> getSaleOnlineOrderFromApp(
      List<String> listOrderId);

  Future<bool> changeLiveCampaignStatus(String liveCampaignId);

  /// Lấy danh sách trạng thái giao hàng từ ngày tới ngày
  Future<List<DeliveryStatusReport>> getFastSaleOrderDeliveryStatusReports(
      {@required DateTime startDate, @required DateTime endDate});

  /// Lấy SaleOnlineFacebookPostSummaryUser
  Future<SaleOnlineFacebookPostSummaryUser>
      getSaleOnlineFacebookPostSummaryUser(String id,
          {@required int crmTeamId});

  /// Lấy lượt share facebook
  /// /api/facebook
  Future<List<FacebookShareInfo>> getSharedFacebook(
    String postId,
    String uId, {
    bool mapUid = false,
    @required int teamId,
  });

  ///Lấy danh mục sản phẩm
  Future<List<ProductCategory>> getProductCategories();

  /// Lấy danh mục sản phẩm theo Id
  Future<OdataResult<ProductCategory>> getProductCategory(int id);

  /// Xóa nhóm khách hàng
  Future<void> deletePartnerCategory(int categoryId);

  ///Lấy phương thức thanh toán
  Future<List<PaymentMethod>> getPaymentMethod();

  /// Khởi tạo thông tin bán hàng
  Future<FastSaleOrderAddEditData> prepareFastSaleOrder(saleOnlineIds);

  /// Get status report
  Future<List<StatusReport>> getStatusReport(startDate, endDate);

  /// Tính phí giao hàng
  Future<CalculateFeeResultData> calculateShipingFee(
      {int partnerId,
      @required int companyId,
      int carrierId,
      double weight,
      ShipReceiver shipReceiver,
      List<ShipServiceExtra> shipServiceExtras,
      double shipInsuranceFee,
      String shipServiceId,
      String shipServiceName,
      int cashOnDelivery // Dùng cho MyVNPost
      });

  /// Tạo hóa đơn bán hàng
  Future<TPosApiResult<FastSaleOrderAddEditData>> createFastSaleOrder(
      FastSaleOrderAddEditData order,
      [bool isDraft = false]);

  /// SaleOnlineFacebookCommment  | Lây danh sách bình luận từ post
  Future<List<SaleOnlineFacebookComment>> getCommentsByUserAndPost(
      {String userId, String postId});

  Future<List<CompanyOfUser>> getCompanyOfUser();
  Future<List<UserReportStaff>> getUserReportStaff();

  /// Thêm danh mục sản phẩm
  Future<ProductCategory> insertProductCategory(
      ProductCategory productCategory);

  /// Get SaleOnlineOrders
  Future<List<SaleOnlineOrder>> getSaleOnlineOrders(
      {int take,
      int skip,
      int partnerId,
      String facebookPostId,
      int crmTeamId,
      DateTime fromDate,
      DateTime toDate});

  /// Lấy sanh sách đơn hàng online filter
  Future<List<SaleOnlineOrder>> getSaleOnlineOrdersFilter(
      {int take, int skip, OdataFilter filter, OdataSortItem sort});

  /// Lấy danh sách đơn hàng online view
  Future<List<ViewSaleOnlineOrder>> getViewSaleOnlineOrderWithFitter(
      {int take, int skip, OdataFilter filter, OdataSortItem sort});

  /// Lấy đơn vị sản phẩm
  Future<List<ProductUOM>> getProductUOM({uomCateogoryId});

  /// Lấy Product UOMLine
  Future<List<ProductUOMLine>> getProductUOMLine(int productId);

  /// Lấy ProductAttribute
  Future<List<ProductAttributeLine>> getProductAttribute(int productId);

  /// Lấy điều khoản thanh toán
  Future<List<AccountPaymentTerm>> getAccountPayments();

  /// Edit Product Category
  Future<TPosApiResult<bool>> editProductCategory(
      ProductCategory productCategory);

  /// Lấy thông tin hóa đơn để chỉnh sửa
  Future<FastSaleOrderAddEditData> getFastSaleOrderForEdit(int id);

  /// Lấy barcode phiếu ship
  Future<String> getBarcodeShip(String id);

  /// Lấy danh sách kênh bán hàng facebook
  Future<List<CRMTeam>> getSaleChannelList();

  /// Kiểm tra địa chỉ nhanh
  Future<List<CheckAddress>> checkAddress(String text);

  /// Sửa kênh bán hàng facebook
  Future<bool> editSaleChannelById({CRMTeam crmTeam});

  /// Thêm kênh bán hàng facebook
  Future<bool> addSaleChannel({CRMTeam crmTeam});

  /// Lấy danh sách PrinterConfigs
  Future<List<PrinterConfig>> getPrinterConfigs();

  Future<PrinterConfig> getPrintShipConfig();

  /// Lấy cấu hình in hóa đơn
  Future<PrinterConfig> getPrintInvoiceConfig();

  /// Cancel ship, Hủy vận đơn giao hàng
  Future<TPosApiResult<bool>> fastSaleOrderCancelShip(int orderId);

  /// Hủy hóa đơn giao/ bán hàng
  Future<TPosApiResult<bool>> fastSaleOrderCancelOrder(List<int> orderIds);

  /// Xác nhận hóa đơn bán hàng nhanh/ hóa đơn giao hàng
  Future<TPosApiResult<bool>> fastSaleOrderConfirmOrder(List<int> orderIds);

  /// Xác nhận sale order
  Future<bool> confirmSaleOrder(int orderId);

  /// Xóa sale order
  Future<TPosApiResult<bool>> deleteSaleOrder(int id);

  /// hủy sale order
  Future<TPosApiResult<bool>> cancelSaleOrder(int orderId);

  /// Tạo hóa đơn sale order
  Future<TPosApiResult<bool>> createSaleOrderInvoice(int orderId,
      {List<int> orderIds});

  /// Chuẩn bị thanh toán đơn hàng
  Future<TPosApiResult<AccountPayment>> accountPaymentPrepairData(int orderId);

  /// Thanh toán hóa đơn
  Future<TPosApiResult<int>> accountPaymentCreatePost(AccountPayment data);

  /// Lấy danh sách phương thức thanh toán
  Future<TPosApiResult<List<AccountJournal>>> accountJournalGetWithCompany();

  Future<OdataResult<List<PaymentInfoContent>>> getPaymentInfoContent(
      int orderId);

  Future<OdataResult<AccountPayment>> accountPaymentOnChangeJournal(
      int journalId, String paymentType);

  /// Xóa khách hàng
  Future<void> deletePartner(int id);

  /// Xóa danh mục sản phẩm
  Future<TPosApiResult<bool>> deleteProductCategory(int id);

  Future<OdataResult<List<ApplicationUser>>> getApplicationUsersSaleOrder(
      String keyword);

  /// Lấy danh sách kho hàng
  /// Tạo hóa đơn bán hàng nhanh
  Future<OdataResult<List<StockWareHouse>>>
      getStockWareHouseWithCurrentCompany();

  /// Lấy danh sách tất cả kho hàng
  Future<List<StockWareHouse>> getStockWarehouse();

  /// Lấy danh sách tồn kho sản phẩm
  /// Kết quả trả về ở dạng MapEntry <int, int> . Ví dụ: <IdSanPham, Tồn kho>
  Future<Map<String, dynamic>> getProductInventory();

  /// Lấy tồn kho 1 sản phẩm kết quả trả về là danh sách tồn kho theo công ty
  /// Input tmplId
  /// Return GetInventoryProductResult
  Future<GetInventoryProductResult> getProductInventoryById({int tmplId});

  /// Xóa hóa đơn bán hàng
  Future<void> deleteFastSaleOrder(int orderId);

  /// Lấy chi tiết đơn hàng nếu tạo hóa đơn từ đơn hàng online
  Future<OdataResult<FastSaleOrderSaleLinePrepareResult>>
      getDetailsForCreateInvoiceFromOrder(List<String> saleOnlineIds);

  Future<FastSaleOrderLine> getFastSaleOrderLineProductForCreateInvoice({
    FastSaleOrderLine orderLine,
    FastSaleOrder order,
  });

  Future<SaleOrderLine> getSaleOrderLineProductForCreateInvoice({
    SaleOrderLine orderLine,
    SaleOrder order,
  });

  /// Lấy thống kê tổng quan trang chủ
  Future<DashboardReport> getDashboardReport(
      {String columnChartValue = "W",
      String columnCharText = "TUẦN NÀY",
      String barChartValue = "W",
      String barChartText = "TUẦN NÀY",
      int barChartOrderValue = 1,
      String barChartOrderText = "THEO DOANH SỐ",
      String lineChartValue = "WNWP",
      String lineChartText = "TUẦN NÀY",
      String overViewValue = "T",
      String overViewText = "HÔM NAY"});

  /// Lấy thống kê overview trang chủ
  Future<DashboardReportOverView> getDashboardReportOverview(
      {String columnChartValue = "W",
      String columnCharText = "TUẦN NÀY",
      String barChartValue = "W",
      String barChartText = "TUẦN NÀY",
      int barChartOrderValue = 1,
      String barChartOrderText = "THEO DOANH SỐ",
      String lineChartValue = "WNWP",
      String lineChartText = "TUẦN NÀY",
      String overViewValue = "T",
      String overViewText = "HÔM NAY"});

  /// Lấy danh sách phường /xã
  Future<List<WardAddress>> getWardAddress(String districtCode);

  /// Hàm lấy Danh sách District
  Future<List<DistrictAddress>> getDistrictAddress(String cityCode);

  /// Lấy danh sách thành phố
  Future<List<CityAddress>> getCityAddress();

  /// Lấy nội dung in html
  /// type (ship,orderA4, orderA5)
  Future<String> getFastSaleOrderPrintDataAsHtml(
      {@required fastSaleOrderId, String type, int carrierId});

  /// Lấy danh sách mẫu trả lời comment, tin nhắn facebook
  Future<List<MailTemplate>> getMailTemplates();

  /// Thêm mẫu tin nhắn
  Future<void> addMailTemplate(MailTemplate template);

  /// Lấy puid facebook theo asuid và page id
  /// /api/facebook
  Future<String> getFacebookPSUID(
      {@required String asuid, @required String pageId});

  /// Lưu bình luận facebook
  /// Param post
  /// Return String: id Của bài viết
  Future<String> insertFacebookPostComment(
      List<TposFacebookPost> posts, int crmTeamId);

  /// Gửi lại vận đơn của hóa đơn giao hàng nhah
  Future<void> sendFastSaleOrderToShipper(int fastSaleOrderId);

  /// Tắt mở tính năng số  thứ tự đơn hàng sale online
  Future<ApplicationConfigCurrent> updateSaleOnlineSessionEnable();

  /// Kiểm tra phiên bán hàng online có mở hay không
  Future<ApplicationConfigCurrent> getCheckSaleOnlineSessionEnable();

  ///Lấy danh sách Phiếu nhập hàng
  Future<List<FastPurchaseOrder>> getFastPurchaseOrderList(
      take, skip, page, pageSize, sort, filter);

  ///Xóa nhiều Phiếu nhập hàng
  Future<String> unlinkPurchaseOrder(List<int> ids);

  Future<void> sendFacebookPageInbox(
      {@required String message,
      @required int cmrTeamid,
      @required FacebookComment comment,
      @required String facebookPostId});

  ///xem chi tiết hóa đơn nhập hàng bằng ID
  Future<FastPurchaseOrder> getDetailsPurchaseOrderById(int id);

  ///Lấy form mẫu payment
  Future<FastPurchaseOrderPayment> getPaymentFastPurchaseOrderForm(int id);

  ///thanh toán hóa đơn
  Future<Map<String, dynamic>> doPaymentFastPurchaseOrder(
      FastPurchaseOrderPayment fastPurchaseOrder);

  ///lấy danh sách phương thức thanh toán nhập hàng
  Future<List<JournalFPO>> getJournalOfFastPurchaseOrder();

  ///hủy hóa đơn nhập hàng
  Future<String> cancelFastPurchaseOrder(List<int> ids);

  ///lấy mẫu hóa đơn nhập hàng mặc định
  Future<FastPurchaseOrder> getDefaultFastPurchaseOrder();

  ///Lấy danh sách thuế của hóa đơn nhập hàng
  Future<List<AccountTaxFPO>> getListAccountTaxFPO();

  ///Lấy danh sách nhà cung cấp
  Future<List<PartnerFPO>> getListPartnerFPO();

  ///Lấy danh sách loại hoạt động
  Future<List<StockPickingTypeFPO>> getStockPickingTypeFPO();

  ///Tìm kiếm nhà cung cấp
  Future<List<PartnerFPO>> getListPartnerByKeyWord(String text);

  ///Lấy danh sách Application User FPO
  Future<List<ApplicationUserFPO>> getApplicationUserFPO();

  ///Lấy model Account khi thay đổi partner trong hóa đơn gia hàng
  Future<Account> onChangePartnerFPO(FastPurchaseOrder fastPurchaseOrder);

  ///Lấy ProductUOM và Account của product khi thay đẩy orderlines của hóa đơn nhập hàng
  Future<OrderLine> onChangeProductFPO(
      FastPurchaseOrder fastPurchaseOrder, OrderLine orderLine);

  ///Lấy UOM của  product
  Future<ProductUOM> getUomFPO(int id);

  ///Lấy thuế
  Future<List<AccountTaxFPO>> getTextFPO();

  /// /odata/SaleSettings/ODataService.DefaultGet?$expand=SalePartner,DeliveryCarrier,Tax
  /// Lấy setting cấu hình cho hiện CK-Giảm tiền

  ///Lưu hóa đơn nhập hàng
  Future<FastPurchaseOrder> actionInvoiceDraftFPO(FastPurchaseOrder item);

  /// Xác nhận hóa đơn nhập hàng bằng id
  Future<bool> actionInvoiceOpenFPO(FastPurchaseOrder item);

  /// Sửa hóa đơn nhập hàng
  Future<FastPurchaseOrder> actionEditInvoice(FastPurchaseOrder item);

  ///input id phiếu nhập hàng , output phiếu trả hàng
  Future<int> createRefundOrder(int id);

  /// Lấy thống kê overview trang chủ
  Future<dynamic> getDashBoardChart(
      {@required String chartType,
      String columnChartValue = "W",
      String columnCharText = "TUẦN NÀY",
      String barChartValue = "W",
      String barChartText = "TUẦN NÀY",
      int barChartOrderValue = 1,
      String barChartOrderText = "THEO DOANH SỐ",
      String lineChartValue = "WNWP",
      String lineChartText = "TUẦN NÀY",
      String overViewValue = "T",
      String overViewText = "HÔM NAY"});

  Future<Map<String, dynamic>> getPriceListItems(int priceListId);

  ///Lấy dữ liệu hoạt động của user hiện tại
  Future<UserActivities> getUserActivities({int skip, int limit});

  ///Đổi mật khẩu user
  Future<bool> doChangeUserPassWord(
      {String oldPassword, String newPassword, String confirmPassWord});

  Future<List<String>> getCommentIdsByPostId(String postId);

  Future<FacebookWinner> updateFacebookWinner(FacebookWinner facebookWinner);

  Future<List<FacebookWinner>> getFacebookWinner();

  /// Lấy báo cáo nhập xuất tồn
  Future<StockReport> getStockReport({
    DateTime fromDate,
    DateTime toDate,
    bool isIncludeCanceled = false,
    bool isIncludeReturned = false,
    int wareHouseId,
    int productCategoryId,
  });

  Future<List<ProductCategoryForStockWareHouseReport>>
      getProductCategoryForStockReport();

  Future<PosOrderResult> getPosOrders(
      {int page,
      int pageSize,
      int skip,
      int take,
      OdataFilter filter,
      List<OdataSortItem> sorts});

  Future<TPosApiResult<bool>> deletePosOrder(int id);

  Future<PosOrder> getPosOrderInfo(int id);

  Future<List<PosOrderLine>> getPosOrderLines(int id);

  Future<List<PosAccountBankStatement>> getPosAccountBankStatement(int id);

  Future<TPosApiResult<String>> refundPosOrder(int id);

  Future<TPosApiResult<PosMakePayment>> getPosMakePayment(int id);

  Future<TPosApiResult<bool>> posMakePayment(
      PosMakePayment payment, int posOrderId);

  // MAIL TEMPLATE
  Future<MailTemplateResult> getMailTemplateResult();
  Future<MailTemplate> getMailTemplateById(int id);
  Future<TPosApiResult<bool>> deleteMailTemplate(int id);
  Future<List<MailTemplateType>> getMailTemplateType();
  Future<bool> updateMailTemplate(MailTemplate template);

  // REPORT
  Future<BusinessResult> getBusinessResult(
      DateTime dateFrom, DateTime dateTo, String companyId);

  /*DELIVERY CARRIER*/
  Future<List<DeliveryCarrier>> getDeliveryCarriers();
  Future<DeliveryCarrier> getDeliveryCarrierById(int id);
  Future<void> deleteDeliveryCarrier(int carrierId);
  Future<void> updateDeliveryCarrier(DeliveryCarrier edit);
  Future<void> createDeliveryCarrier(DeliveryCarrier item);

  /// Lấy danh sách đối tác giao hàng cho thêm mới, chỉnh sửa...
  Future<List<DeliveryCarrier>> getDeliveryCarriersList();

  /// Lấy giá trị mặc định khi thêm đối tác giao hàng mới
  Future<DeliveryCarrier> getDeliverCarrierCreateDefault();

  /*DELIVERY CARRIER*/

/* ASHIP API*/
  Future<GetShipTokenResultModel> getShipToken(
      {String apiKey,
      String email,
      String host,
      String password,
      String provider});

  Future<String> getTokenShip();
/* ASHIP API*/

  /// Lấy danh sách trạng thái sale online tùy chỉnh
  Future<List<StatusExtra>> getStatusExtra();

  Future<bool> saveChangeStatus(List<String> ids, String status);

  Future<List<PartnerReport>> getPartnerReports(
      {String display,
      String dataFrom,
      String dateTo,
      int take,
      int skip,
      int page,
      int pageSize,
      String resultSelection,
      String companyId,
      String partnerId,
      String userId,
      String categid,
      String typeReport});

  Future<List<PartnerFPO>> getPartnerSearchReport();

  Future<List<ApplicationUserFPO>> getApplicationUserSearchReport();

  Future<List<CompanyOfUser>> getCompanies();

  Future<List<PartnerDetailReport>> getPartnerDetailReports(
      {String dataFrom,
      String dateTo,
      int take,
      int skip,
      int page,
      int pageSize,
      String resultSelection,
      String companyId,
      String partnerId});

  Future<List<PartnerStaffDetailReport>> getPartnerStaffDetailReports(
      {String dataFrom,
      String dateTo,
      int take,
      int skip,
      int page,
      int pageSize,
      String resultSelection,
      String partnerId});

  Future<List<SupplierReport>> getSupplierReports(
      {String display,
      String dateFrom,
      String dateTo,
      int take,
      int skip,
      int page,
      int pageSize,
      String resultSelection,
      String companyId,
      String partnerId,
      String userId,
      String categId,
      String typeReport});

  Future<List<PartnerFPO>> getSupplierSearchs();

  Future<List<PartnerDetailReport>> getSupplierDetailReports(
      {String dataFrom,
      String dateTo,
      int take,
      int skip,
      int page,
      int pageSize,
      String resultSelection,
      String companyId,
      String partnerId});

  Future<List<ProductAttribute>> getProductAttributeSearch();

  Future<List<ProductAttribute>> getProductAttributeValueSearch();

  // Lấy danh sách người dùng
  Future<List<FaceBookAccount>> getUserFacebooks(String postId);

  // Lấy danh sách người dùng
  Future<Partner> getDetailUserFacebook(String id, int teamId);

  // Lấy danh sách comment người dùng
  Future<List<UserFacebookComment>> getCommentUserFacebook(
      {String userId, String postId});

  // Lấy danh sách đơn hàng người dùng
  Future<List<SaleOnlineOrder>> getOrderSaleOnline(
      {String userId, String postId});

  // Xuất file excel
  Future<String> exportExcel(String postId);

  // Xuất file excel có số điện thoại
  Future<String> exportExcelByPhone(String postId);

  //Fetch Comment Facebook by body
  Future<FetchComment> fetchCommentFacebookByBody(String videoId, String ASUid);

  // Xuất file excel chiến dịch live
  Future<String> exportExcelLiveCampaign(
      String campaignId, String campaignName);

  /// Lấy danh sách phiếu báo giá
  Future<BaseModelSaleQuotation> getSaleQuotations(
      {String keySearch,
      String fromDate,
      String toDate,
      int accountId,
      int take,
      int skip,
      int page,
      int pageSize,
      List<String> states});

  /// Lấy thông tin chi tiết phiếu báo giá
  Future<SaleQuotationDetail> getInfoSaleQuotation(String id);

  /// Lấy danh sách sản phẩm cho phiếu báo giá
  Future<List<OrderLines>> getOrderLineForSaleQuotation(String id);

  /// Xóa phiếu báo giá
  Future<void> deleteSaleQuotation(int id);

  /// Xóa nhìu phiếu báo giá
  Future<void> deleteMultiSaleQuotation(List<int> ids);

  ///Lấy danh sách điếu khoản thanh toán
  Future<List<AccountPaymentTerm>> getAccountPaymentTerms();

  /// Cập nhật thông tin phiếu báo giá
  Future<void> updateSaleQuotation(SaleQuotationDetail saleQuotationDetail);

  /// Get Default thông tin phiếu báo giá
  Future<SaleQuotationDetail> getDefaultSaleQuotation();

  /// Thêm thông tin phiếu báo giá
  Future<SaleQuotationDetail> addInfoSaleQuotation(
      SaleQuotationDetail saleQuotationDetail);

  /// Đánh dấu đã báo giá phiếu báo giá
  Future<void> markSaleQuotation(int id);

  /// Export Excel
  Future<String> exportExcelSaleQuotation(String id);

  /// export PDF
  Future<String> exportPDFSaleQuotation(String id);

  /// get PriceList
  Future<SaleQuotationDetail> getPriceListSaleQuotation(
      SaleQuotationDetail saleQuotationDetail);

  /// Xuất excel đơn hàng online
  Future<String> exportInvoiceSaleOnline(
      {String campaignId,
      int crmTeamId,
      String keySearch,
      List<String> statusTexts,
      String fromDate,
      String toDate,
      List<String> ids});

  /// Xuất excel hóa đơn giao hàng
  Future<String> exportExcelDeliveryInvoice(
      {String keySearch,
      String fromDate,
      String toDate,
      String statusTexts,
      List<int> ids,
      String deliveryType,
      bool isFilterStatus});

  /// Xuất excel chi tiết hóa đơn giao hàng
  Future<String> exportExcelDeliveryInvoiceDetail(
      {String keySearch,
      String fromDate,
      String toDate,
      String statusTexts,
      List<int> ids,
      String deliveryType,
      bool isFilterStatus});
}
