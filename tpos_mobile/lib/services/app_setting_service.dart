/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/5/19 4:54 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/5/19 2:58 PM
 *
 */

import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tpos_mobile/resources/constant.dart';
import 'package:tpos_mobile/services/print_service/printer_device.dart';
import 'package:tpos_mobile/src/tpos_apis/models/base_list_order_by_type.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

const String shopUrlKey = "shopUrl";
const String shopUsernameKey = "shopUsername";

const String isEnablePrintSaleOnlineKey = "isEnablePrintSaleOnline";
const String isSaleOnlinePrintAddressKey = "isSaleOnlinePrintAddress";
const String isSaleOnlinePrintCommentKey = 'isSaleOnlinePrintComment';
const String isSaleOnlinePrintPartnerNoteKey = "isSaleOnlinePrintPartnerNote";
const String isSaleOnlinePrintAllOrderNoteKey = "isSaleOnlinePrintAllOrderNote";
const String isSaleOnlineConnectFailEnableActionKey =
    "isSaleOnlineConnectFailEnableAction";
const String secondRefreshLiveCommentKey = "secondRefreshLiveComment";
const String isAllowPrintSaleOnlineManyTimeKey =
    "isAllowPrintSaleOnlineManyTime";
const String printSaleOnlineMethodKey = "printSaleOnlineMethod";

const String saleOnlineOrderListFilterByTimeIndexKey =
    "saleOnlineOrderListFilterByTimeIndex";

const String saleOnlineOrderListFilterByStatusIndexKey =
    "saleOnlineOrderListFilterByStatusIndex";

const String productSearchOrderByIndexKey = "productSearchOrderByIndex";
const String isProductSearchViewListKey = "isProductSearchViewList";
const String isSaleOnlinePrintCustomHeaderKey = "isSaleOnlinePrintCustoHeader";
const String saleOnlinePrintCustomHeaderContentKey =
    "saleOnlinePrintCustomHeader";
const String isSaleOnlineViewCommentTimeAgoOnLiveKey =
    "isSaleOnlineViewCommentTimeAgoOnLive";
const String isSaleOnlineViewCommentTimeAgoOnPostKey =
    "isSaleOnlineViewCommentTimeAgoOnPost";
const String isSaleOnlineAutoLoadAllCommentOnLiveKey =
    "isSaleOnlineAutoLoadAllCommentOnLive";
const String isSaleOnlineAutoLoadAllCommentOnPostKey =
    "isSaleOnlineAutoLoadAllCommentOnPost";

const String saleOnlineCommentDefaultOrderByOnLiveKey =
    "saleOnlineDefaultOrderByOnLive";
const String saleOnlineCommentDefaultOrderByOnPostKey =
    "saleOnlineDefaultOrderByOnPost";

const String saleOnlineFetchCommentOnRealtimeRateKey =
    "saleOnlineFetchCommentOnRealtimeRate";
const String addExistsProductWarningKey = "addExistsProductWarning";
const String locateKey = "setting_locate";
const String SETTING_FAST_SALE_ORDER_IS_HIDE_DELIVERY_ADDRESS_KEY =
    "setting_fast_sale_order_is_hide_delivery_address";
const String SETTING_FAST_SALE_ORDER_HIDE_DELIVERY_CARRIER_KEY =
    "setting_fast_sale_order_is_hide_delivery_carrier";
const String
    SETTING_FAST_SALE_ORDER_IS_PAYMENT_IS_NEXT_PAYMENT_TO_COMPLETE_INVOICE_KEY =
    "setting_fast_sale_order_is_next_payment_to_complete_invoice";
const String SETTING_FAST_SALE_ORDER_IS_AUTO_INPUT_PAYMENT_AMOUNT_KEY =
    "setting_fast_sale_order_is_auto_input_payment_amount";

const String SETTING_FAST_SALE_ORDER_SHOW_INFO_AFTER_SAVE_KEY =
    "setting_fast_sale_order_show_info_after_save";

const String SETTING_SALE_ORDER_SHOW_INFO_AFTER_SAVE_KEY =
    "setting_sale_order_show_info_after_save";

const String SETTING_IS_HIDE_HOME_PAGE_SUGGESS_KEY =
    "settig_is_hide_home_page_suggess_key";

const String SETTING_HOME_PAGE_MENU_KEY = "setting_home_page_menu";
const String SETTING_LAST_APP_VERSION_KEY = "setting_last_app_version";
const String SETTING_IS_APP_UPDATED_KEY = "setting_is_app_updated";
const String SETTING_PRINTER_LIST_KEY = "setting_printer_list";
const String SETTING_MENU_RECENT_KEY = "setting_menu_recent";
const String SETTING_IS_SHOW_ALL_MENU_IN_HOME_PAGE_KEY =
    "setting_is_show_all_menu_in_home_page";

const String SETTING_IS_SHOW_GROUP_HOME_KEY = "setting_is_show_group_home_key";
const String SETTING_SHIP_NOTE_KEY = "setting_ship_note";
const String SETTING_SHIP_SIZE_KEY = "setting_ship_size";
const String SETTING_POS_ORDER_SIZE_KEY = "setting_pos_order_size";
const String SETTING_IS_SHOW_COMPANY_ADDRESS_POS_ORDER =
    "setting_is_show_company_address_pos_order";
const String SETTING_IS_SHOW_COMPANY_EMAIL_POS_ORDER =
    "setting_is_show_company_email_pos_order";
const String SETTING_IS_SHOW_COMPANY_PHONE_NUMBER_POS_ORDER =
    "setting_is_show_company_phone_number_pos_order";
const String SETTING_FAST_SALE_ORDER_PRINT_SHIP_AFTER_CONFIRM_KEY =
    "setting_fast_sale_order_print_ship_after_confirm";
const String SETTING_FAST_SALE_ORDER_PRINTER_NAME =
    "setting_fast_sale_order_printer_name";
const String SETTING_FAST_SALE_ORDER_PRINT_SIZE =
    "setting_fast_sale_order_print_size";
const String SETTING_SALE_ONLINE_PRINT_NO_SIGN =
    "setting_sale_online_print_no_sign";

const String SETTING_SALE_ONLINE_PRINT_CONTENT_KEY =
    "setting_sale_online_print_content";
const String SETTING_SALE_ONLINE_SAVE_COMMENT_MINUTE_KEY =
    "setting_sale_online_save_comment_minute";

const String SETTING_IS_SHARE_GAME_KEY = "setting_is_share_game";

const String SETTING_IS_COMMENT_GAME_KEY = "setting_is_comment_game";

const String SETTING_IS_DAYS_GAME_KEY = "days";

const String SETTING_IS_ORDER_GAME_KEY = "setting_is_order_game";

const String SETTING_IS_WIN_GAME_KEY = "setting_is_win_game";

const String SETTING_IS_PRIOR_GAME_KEY = "setting_is_prior_game";
const String SETTING_SALE_ONLINE_HIDE_SHORT_COMMENT_KEY =
    "setting_sale_online_hide_short_comment";

const String SETTING_PRINT_SHIP_SHOW_PRODUCT_QUANTITY_KEY =
    "setting_print_ship_show_product_quantity";
const String SETTING_PRINT_SHIP_SHOW_DEPOSIT_AMOUNT_KEY =
    "setting_print_ship_show_deposit_amount";

enum SettingAddExistsProductWarning { ADD_QUANTITY, CONFIRM_QUESTION, SKIP }
enum SaleOnlineCommentOrderBy { DATE_CREATED_ASC, DATE_CREATE_DESC }

abstract class ISettingService {
  int productSearchOrderByIndex;
  bool isProductSearchViewList;
  SettingAddExistsProductWarning addExistsProductWarning;

  bool isHideDeliveryAddressInFastSaleOrder;
  bool isHideDeliveryCarrierInFastSaleOrder;
  bool isNextPaymentForCompleteInvoiceInFastSaleOrder;
  bool isAutoInputPaymentAmountInFastSaleOrder;
  bool isShowInfoInvoiceAfterSaveFastSaleOrder;
  bool isShowInfoInvoiceAfterSaveSaleOrder;
  bool isHideHomePageSuggess;
  Future initService();
  bool settingFastSaleOrderPrintShipAfterConfirm;

  String posOrderPrinterName;
  String posOrderPrintSize;
  bool isShowCompanyAddressPosOrder;
  bool isShowCompanyEmailPosOrder;
  bool isShowCompanyPhoneNumberPosOrder;

  List<PrintTemplate> getSuportPrintTemplateByPrinterType(
      String print, String printerType);

  /// save facebook accesstoken only on app run
  String facebookAccessToken;

  /// In không dấu nếu máy in không hỗ trợ
  bool settingPrintSaleOnlineNoSign;
  List<SupportPrintSaleOnlineRow> get supportSaleOnlinePrintRow;
  List<SupportPrintSaleOnlineRow> settingSaleOnlinePrintContents;
  List<SupportPrintSaleOnlineRow> get defaultSaleOnlinePrintRow;

  /// Cài đặt sale online
  /// Tải bình luận thủ công tự động
  bool saleOnlineFetchDurationEnableOnLive;

  /// Thời gian lọc sẽ lưu
  String saleOnlineOrderListFilterDate;
}

class AppSettingService implements ISettingService {
  AppSettingService() {
    // initService();
  }

  SharedPreferences prefs;

  Future<void> initService() async {
    prefs = await SharedPreferences.getInstance();
  }

  void initCommand() {}

  final List<SupportPrintSaleOnlineRow> _supportSaleOnlinePrintRow = [
    SupportPrintSaleOnlineRow(
        name: "header", description: "Header (${S.current.setting_header}..."),
    SupportPrintSaleOnlineRow(
        name: "uid",
        bold: true,
        fontSize: 2,
        description: "UID Facebook ${S.current.customer.toLowerCase()}"),
    SupportPrintSaleOnlineRow(
        name: "name",
        bold: true,
        fontSize: 2,
        description: S.current.customerName),
    //Số điện thoại khách hàng
    SupportPrintSaleOnlineRow(
        name: "phone",
        bold: true,
        fontSize: 2,
        description: S.current.customerPhone),
    //Số điện thoại khách hàng + Tên nhà mạng
    SupportPrintSaleOnlineRow(
        name: "phoneNameNetwork",
        bold: true,
        fontSize: 2,
        description: "${S.current.customerPhone} + ${S.current.carrieName}"),
    //Địa chỉ khách hàng
    SupportPrintSaleOnlineRow(
        name: "address",
        description: "${S.current.customerAddress}(${S.current.ifHave})"),
    //Mã khách hàng"
    SupportPrintSaleOnlineRow(
        name: "partnerCode", fontSize: 2, description: S.current.customerCode),
    // Tên sản phẩm
    SupportPrintSaleOnlineRow(
        name: "productName", description: S.current.productName),
    //"Số thứ tự đơn hàng"
    SupportPrintSaleOnlineRow(
        name: "orderIndex",
        bold: true,
        fontSize: 2,
        description: S.current.orderIndex),
    // Mã đơn hàng
    SupportPrintSaleOnlineRow(
        name: "orderCode",
        bold: true,
        fontSize: 2,
        description: S.current.orderCode),
    // Số thứ tự và mã đơn hàng
    SupportPrintSaleOnlineRow(
        name: "orderIndexAndCode",
        bold: true,
        fontSize: 2,
        description: "${S.current.orderIndex} & ${S.current.orderCode}"),
    //Giờ đặt hàng
    SupportPrintSaleOnlineRow(
        name: "orderTime", description: S.current.setting_Time),
    //Bình luận (Khi live)"
    SupportPrintSaleOnlineRow(
        name: "comment",
        description: "${S.current.comment} (${S.current.setting_AtLive})"),
    //Ghi chú đơn hàng
    SupportPrintSaleOnlineRow(
        name: "note", description: S.current.setting_note),
    //Thời gian in
    SupportPrintSaleOnlineRow(
        name: "printTime", description: S.current.setting_printingTime),
    //Trạng thái khách hàng
    SupportPrintSaleOnlineRow(
        name: "partnerStatus", description: S.current.setting_customerStatus),
    //Mã khách hàng và trạng thái
    SupportPrintSaleOnlineRow(
        name: "partnerCodeAndStatus",
        description:
            "${S.current.customerCode} & ${S.current.setting_customerStatus}"),
    // Ghi chú bên dưới đơn hàng
    SupportPrintSaleOnlineRow(
        name: "footer", description: S.current.setting_noteBelowOrder),
    //Số điện thoại (QRCode)
    SupportPrintSaleOnlineRow(
        name: "qrCodePhone", description: "${S.current.phoneNumber} (QRCode)"),
    SupportPrintSaleOnlineRow(
        name: "barCodePhone",
        description: "${S.current.phoneNumber} (Barcode)"),
    SupportPrintSaleOnlineRow(
        name: "qrCodeOrderCode",
        description: "${S.current.orderCode} (QRCode)"),
  ];

  final List<SupportPrintSaleOnlineRow> _defaultSaleOnlinePrintRow = [
    // /"Header (Tên công ty, sđt, địa chỉ..."
    SupportPrintSaleOnlineRow(
        name: "header", description: "Header (${S.current.setting_header}..."),
    SupportPrintSaleOnlineRow(
        name: "orderIndexAndCode", bold: true, fontSize: 2),
    //Tên khách hàng"
    SupportPrintSaleOnlineRow(
        name: "name",
        bold: true,
        fontSize: 2,
        description: S.current.customerName),
    SupportPrintSaleOnlineRow(name: "phone", bold: false, fontSize: 2),
    SupportPrintSaleOnlineRow(name: "uid", bold: true, fontSize: 2),
    SupportPrintSaleOnlineRow(
      name: "productName",
    ),
    SupportPrintSaleOnlineRow(name: "printTime", fontSize: 2),
    SupportPrintSaleOnlineRow(name: "address"),
    SupportPrintSaleOnlineRow(name: "comment"),
    SupportPrintSaleOnlineRow(name: "footer"),
  ];

  List<SupportPrintSaleOnlineRow> get supportSaleOnlinePrintRow =>
      _supportSaleOnlinePrintRow;

  List<SupportPrintSaleOnlineRow> get defaultSaleOnlinePrintRow =>
      _defaultSaleOnlinePrintRow;

  int _saleOnlineOrderListFilterByStatusIndex;

  int get saleOnlineOrderListFilterByStatusIndex =>
      _saleOnlineOrderListFilterByStatusIndex ??
      (_saleOnlineOrderListFilterByStatusIndex =
          prefs.get(saleOnlineOrderListFilterByStatusIndexKey)) ??
      0;

  set saleOnlineOrderListFilterByStatusIndex(int value) {
    _saleOnlineOrderListFilterByStatusIndex = value;
    prefs.setInt(saleOnlineOrderListFilterByStatusIndexKey, value);
  }

  int _productSearchOrderByIndex;

  int get productSearchOrderByIndex =>
      _productSearchOrderByIndex ??
      (_productSearchOrderByIndex = prefs.get(productSearchOrderByIndexKey)) ??
      BaseListOrderBy.NAME_ASC;

  set productSearchOrderByIndex(int value) {
    _productSearchOrderByIndex = value;
    prefs.setInt(productSearchOrderByIndexKey, value);
  }

  bool _isProductSearchViewList;

  bool get isProductSearchViewList =>
      _isProductSearchViewList ??
      (_isProductSearchViewList = prefs.get(isProductSearchViewListKey)) ??
      true;

  set isProductSearchViewList(bool value) {
    _isProductSearchViewList = value;
    prefs.setBool(isProductSearchViewListKey, value);
  }

  bool _isSaleOnlinePrintAllOrderNote;

  bool get isSaleOnlinePrintAllOrderNote =>
      _isSaleOnlinePrintAllOrderNote ??
      (_isSaleOnlinePrintAllOrderNote =
          prefs.get(isSaleOnlinePrintAllOrderNoteKey)) ??
      false;

  set isSaleOnlinePrintAllOrderNote(bool value) {
    _isSaleOnlinePrintAllOrderNote = value;
    prefs.setBool(isSaleOnlinePrintAllOrderNoteKey, value);
  }

  bool _isSaleOnlinePrintCustomHeader;

  bool get isSaleOnlinePrintCustomHeader =>
      _isSaleOnlinePrintCustomHeader ??
      (_isSaleOnlinePrintCustomHeader =
          prefs.get(isSaleOnlinePrintCustomHeaderKey)) ??
      false;

  set isSaleOnlinePrintCustomHeader(bool value) {
    _isSaleOnlinePrintCustomHeader = value;
    prefs.setBool(isSaleOnlinePrintCustomHeaderKey, value);
  }

  String _saleOnlinePrintCustomHeaderContent;

  String get saleOnlinePrintCustomHeaderContent =>
      _saleOnlinePrintCustomHeaderContent ??
      (_saleOnlinePrintCustomHeaderContent =
          prefs.get(saleOnlinePrintCustomHeaderContentKey)) ??
      "";

  set saleOnlinePrintCustomHeaderContent(String value) {
    _saleOnlinePrintCustomHeaderContent = value;
    prefs.setString(saleOnlinePrintCustomHeaderContentKey, value);
  }

  bool _isSaleOnlineViewTimeAgoOnLiveComment;

  bool get isSaleOnlineViewTimeAgoOnLiveComment =>
      _isSaleOnlineViewTimeAgoOnLiveComment ??
      (_isSaleOnlineViewTimeAgoOnLiveComment =
          prefs.getBool(isSaleOnlineViewCommentTimeAgoOnLiveKey)) ??
      true;

  set isSaleOnlineViewTimeAgoOnLiveComment(bool value) {
    _isSaleOnlineViewTimeAgoOnLiveComment = value;
    prefs.setBool(isSaleOnlineViewCommentTimeAgoOnLiveKey, value);
  }

  bool _isSaleOnlineViewTimeAgoOnPostComment;

  bool get isSaleOnlineViewTimeAgoOnPostComment =>
      _isSaleOnlineViewTimeAgoOnPostComment ??
      (_isSaleOnlineViewTimeAgoOnPostComment =
          prefs.getBool(isSaleOnlineViewCommentTimeAgoOnLiveKey)) ??
      true;

  set isSaleOnlineViewTimeAgoOnPostComment(bool value) {
    _isSaleOnlineViewTimeAgoOnPostComment = value;
    prefs.setBool(isSaleOnlineViewCommentTimeAgoOnPostKey, value);
  }

  SettingAddExistsProductWarning _addExistsProductWarning;

  SettingAddExistsProductWarning get addExistsProductWarning {
    if (_addExistsProductWarning == null) {
      final String value = prefs.getString(addExistsProductWarningKey);
      _addExistsProductWarning = SettingAddExistsProductWarning.values
          .firstWhere((f) => f.toString() == value,
              orElse: () => SettingAddExistsProductWarning.ADD_QUANTITY);
    }

    return _addExistsProductWarning;
  }

  set addExistsProductWarning(SettingAddExistsProductWarning value) {
    _addExistsProductWarning = value;
    prefs.setString(addExistsProductWarningKey, value.toString());
  }

  bool _isHideDeliveryAddressInFastSaleOrder;

  bool get isHideDeliveryAddressInFastSaleOrder =>
      _isHideDeliveryAddressInFastSaleOrder ??
      (_isHideDeliveryAddressInFastSaleOrder = prefs
          .getBool(SETTING_FAST_SALE_ORDER_IS_HIDE_DELIVERY_ADDRESS_KEY)) ??
      false;

  set isHideDeliveryAddressInFastSaleOrder(bool value) {
    _isHideDeliveryAddressInFastSaleOrder = value;
    prefs.setBool(SETTING_FAST_SALE_ORDER_IS_HIDE_DELIVERY_ADDRESS_KEY, value);
  }

  bool _isHideDeliveryCarrierInFastSaleOrder;

  bool get isHideDeliveryCarrierInFastSaleOrder =>
      _isHideDeliveryCarrierInFastSaleOrder ??
      (_isHideDeliveryCarrierInFastSaleOrder =
          prefs.getBool(SETTING_FAST_SALE_ORDER_HIDE_DELIVERY_CARRIER_KEY)) ??
      false;

  set isHideDeliveryCarrierInFastSaleOrder(bool value) {
    _isHideDeliveryCarrierInFastSaleOrder = value;
    prefs.setBool(SETTING_FAST_SALE_ORDER_HIDE_DELIVERY_CARRIER_KEY, value);
  }

  bool _isNextPaymentForCompleteInvoiceInFastSaleOrder;

  bool get isNextPaymentForCompleteInvoiceInFastSaleOrder =>
      _isNextPaymentForCompleteInvoiceInFastSaleOrder ??
      (prefs.getBool(
          SETTING_FAST_SALE_ORDER_IS_PAYMENT_IS_NEXT_PAYMENT_TO_COMPLETE_INVOICE_KEY)) ??
      false;

  set isNextPaymentForCompleteInvoiceInFastSaleOrder(bool value) {
    _isNextPaymentForCompleteInvoiceInFastSaleOrder = value;
    prefs.setBool(
        SETTING_FAST_SALE_ORDER_IS_PAYMENT_IS_NEXT_PAYMENT_TO_COMPLETE_INVOICE_KEY,
        value);
  }

  bool _isAutoInputPaymentAmountInFastSaleOrder;

  bool get isAutoInputPaymentAmountInFastSaleOrder =>
      _isAutoInputPaymentAmountInFastSaleOrder ??
      (_isAutoInputPaymentAmountInFastSaleOrder = prefs
          .getBool(SETTING_FAST_SALE_ORDER_IS_AUTO_INPUT_PAYMENT_AMOUNT_KEY)) ??
      false;

  set isAutoInputPaymentAmountInFastSaleOrder(bool value) {
    _isAutoInputPaymentAmountInFastSaleOrder = value;
    prefs.setBool(
        SETTING_FAST_SALE_ORDER_IS_AUTO_INPUT_PAYMENT_AMOUNT_KEY, value);
  }

  bool _isShowInfoInvoiceAfterSaveFastSaleOrder;

  bool get isShowInfoInvoiceAfterSaveFastSaleOrder =>
      _isShowInfoInvoiceAfterSaveFastSaleOrder ??
      (_isShowInfoInvoiceAfterSaveFastSaleOrder =
          prefs.getBool(SETTING_FAST_SALE_ORDER_SHOW_INFO_AFTER_SAVE_KEY)) ??
      true;

  set isShowInfoInvoiceAfterSaveFastSaleOrder(bool value) {
    _isShowInfoInvoiceAfterSaveFastSaleOrder = value;
    prefs.setBool(SETTING_FAST_SALE_ORDER_SHOW_INFO_AFTER_SAVE_KEY, value);
  }

  bool _isShowInfoInvoiceAfterSaveSaleOrder;

  bool get isShowInfoInvoiceAfterSaveSaleOrder =>
      _isShowInfoInvoiceAfterSaveSaleOrder ??
      (_isShowInfoInvoiceAfterSaveSaleOrder =
          prefs.getBool(SETTING_SALE_ORDER_SHOW_INFO_AFTER_SAVE_KEY)) ??
      true;

  set isShowInfoInvoiceAfterSaveSaleOrder(bool value) {
    _isShowInfoInvoiceAfterSaveSaleOrder = value;
    prefs.setBool(SETTING_SALE_ORDER_SHOW_INFO_AFTER_SAVE_KEY, value);
  }

  bool _isHideHomePageSuggess;

  bool get isHideHomePageSuggess =>
      _isHideHomePageSuggess ??
      (_isHideHomePageSuggess =
          prefs.getBool(SETTING_IS_HIDE_HOME_PAGE_SUGGESS_KEY)) ??
      false;

  set isHideHomePageSuggess(bool value) {
    _isHideHomePageSuggess = value;
    prefs.setBool(SETTING_IS_HIDE_HOME_PAGE_SUGGESS_KEY, value);
  }

  String _posOrderPrinterName;

  @override
  String get posOrderPrinterName =>
      _posOrderPrinterName ??
      (_posOrderPrinterName = prefs.getString("pos_order")) ??
      "Xem và in";

  set posOrderPrinterName(String value) {
    _posOrderPrinterName = value;
    prefs.setString("pos_order", value);
  }

  String _posOrderPrintSize;

  String get posOrderPrintSize =>
      _posOrderPrintSize ??
      (_posOrderPrintSize = prefs.getString(SETTING_POS_ORDER_SIZE_KEY)) ??
      "BILL80-IMAGE";

  set posOrderPrintSize(String value) {
    _posOrderPrintSize = value;
    prefs.setString(SETTING_POS_ORDER_SIZE_KEY, value);
  }

  bool _isShowCompanyAddressPosOrder;

  bool get isShowCompanyAddressPosOrder =>
      _isShowCompanyAddressPosOrder ??
      (_isShowCompanyAddressPosOrder =
          prefs.getBool(SETTING_IS_SHOW_COMPANY_ADDRESS_POS_ORDER)) ??
      false;

  set isShowCompanyAddressPosOrder(bool value) {
    _isShowCompanyAddressPosOrder = value;
    prefs.setBool(SETTING_IS_SHOW_COMPANY_ADDRESS_POS_ORDER, value);
  }

  bool _isShowCompanyEmailPosOrder;

  bool get isShowCompanyEmailPosOrder =>
      _isShowCompanyEmailPosOrder ??
      (_isShowCompanyEmailPosOrder =
          prefs.getBool(SETTING_IS_SHOW_COMPANY_EMAIL_POS_ORDER)) ??
      false;

  set isShowCompanyEmailPosOrder(bool value) {
    _isShowCompanyEmailPosOrder = value;
    prefs.setBool(SETTING_IS_SHOW_COMPANY_EMAIL_POS_ORDER, value);
  }

  bool _isShowCompanyPhoneNumberPosOrder;

  bool get isShowCompanyPhoneNumberPosOrder =>
      _isShowCompanyPhoneNumberPosOrder ??
      (_isShowCompanyPhoneNumberPosOrder =
          prefs.getBool(SETTING_IS_SHOW_COMPANY_PHONE_NUMBER_POS_ORDER)) ??
      false;

  set isShowCompanyPhoneNumberPosOrder(bool value) {
    _isShowCompanyPhoneNumberPosOrder = value;
    prefs.setBool(SETTING_IS_SHOW_COMPANY_PHONE_NUMBER_POS_ORDER, value);
  }

  bool _settingFastSaleOrderPrintShipAfterConfirm;

  bool get settingFastSaleOrderPrintShipAfterConfirm =>
      _settingFastSaleOrderPrintShipAfterConfirm ??
      (_settingFastSaleOrderPrintShipAfterConfirm = prefs
          .getBool(SETTING_FAST_SALE_ORDER_PRINT_SHIP_AFTER_CONFIRM_KEY)) ??
      false;

  set settingFastSaleOrderPrintShipAfterConfirm(bool value) {
    _settingFastSaleOrderPrintShipAfterConfirm = value;
    prefs.setBool(SETTING_FAST_SALE_ORDER_PRINT_SHIP_AFTER_CONFIRM_KEY, value);
  }

  List<PrintTemplate> getSuportPrintTemplateByPrinterType(
      String print, String printerType) {
    final Map printProfile = Const.supportPrinterProfiles[print];
    if (printProfile != null) {
      return (printProfile[printerType] as List)
          ?.map((f) => PrintTemplate.fromJson(f))
          ?.toList();
    } else {
      return null;
    }
  }

  String facebookAccessToken;

  bool _settingPrintSaleOnlineNoSign;

  bool get settingPrintSaleOnlineNoSign =>
      _settingPrintSaleOnlineNoSign ??
      (_settingPrintSaleOnlineNoSign =
          prefs.getBool(SETTING_SALE_ONLINE_PRINT_NO_SIGN)) ??
      false;

  set settingPrintSaleOnlineNoSign(bool value) {
    _settingPrintSaleOnlineNoSign = value;
    prefs.setBool(SETTING_SALE_ONLINE_PRINT_NO_SIGN, value);
  }

  List<SupportPrintSaleOnlineRow> _settingSaleOnlinePrintContents;

  List<SupportPrintSaleOnlineRow> get settingSaleOnlinePrintContents {
    if (_settingSaleOnlinePrintContents == null) {
      final String value =
          prefs.getString(SETTING_SALE_ONLINE_PRINT_CONTENT_KEY);
      if (value != null) {
        try {
          _settingSaleOnlinePrintContents = (jsonDecode(value) as List)
              .map((f) => SupportPrintSaleOnlineRow.fromJson(f))
              .toList();
        } catch (e, s) {
          print(s);
        }
      }
    }
    return _settingSaleOnlinePrintContents ?? _defaultSaleOnlinePrintRow;
  }

  set settingSaleOnlinePrintContents(List<SupportPrintSaleOnlineRow> value) {
    _settingSaleOnlinePrintContents = value;

    if (value != null && value.isNotEmpty) {
      final List<Map<String, dynamic>> jsonMap =
          value.map((f) => f.toJson()).toList();
      final json = jsonEncode(jsonMap);
      prefs.setString(SETTING_SALE_ONLINE_PRINT_CONTENT_KEY, json);
    }
  }

  bool _settingGameIsIgroneRecentWinner;

  bool get settingGameIsIgroneRecentWinner =>
      _settingGameIsIgroneRecentWinner ??
      (_settingGameIsIgroneRecentWinner =
          prefs.getBool("settingGameIsIgroneRecentWinner") ?? true);

  set settingGameIsIgroneRecentWinner(bool value) {
    _settingGameIsIgroneRecentWinner = value;
    prefs.setBool("settingGameIsIgroneRecentWinner", value);
  }

  bool _isSaleOnlineHideShortComment;

  bool get isSaleOnlineHideShortComment =>
      _isSaleOnlineHideShortComment ??
      (_isSaleOnlineHideShortComment =
          prefs.getBool(SETTING_SALE_ONLINE_HIDE_SHORT_COMMENT_KEY)) ??
      false;

  set isSaleOnlineHideShortComment(bool value) {
    _isSaleOnlineHideShortComment = value;
    prefs.setBool(SETTING_SALE_ONLINE_HIDE_SHORT_COMMENT_KEY, value);
  }

  bool _settingPrintShipShowDepositAmount;

  bool get settingPrintShipShowDepositAmount =>
      _settingPrintShipShowDepositAmount ??
      (_settingPrintShipShowDepositAmount =
          prefs.getBool(SETTING_PRINT_SHIP_SHOW_DEPOSIT_AMOUNT_KEY)) ??
      false;

  set settingPrintShipShowDepositAmount(bool value) {
    _settingPrintShipShowDepositAmount = value;
    prefs.setBool(SETTING_PRINT_SHIP_SHOW_DEPOSIT_AMOUNT_KEY, value);
  }

  bool _settingPrintShipShowProductQuantity;

  bool get settingPrintShipShowProductQuantity =>
      _settingPrintShipShowProductQuantity ??
      (_settingPrintShipShowProductQuantity =
          prefs.getBool(SETTING_PRINT_SHIP_SHOW_PRODUCT_QUANTITY_KEY)) ??
      false;

  set settingPrintShipShowProductQuantity(bool value) {
    _settingPrintShipShowProductQuantity = value;
    prefs.setBool(SETTING_PRINT_SHIP_SHOW_PRODUCT_QUANTITY_KEY, value);
  }

  bool _saleOnlineFetchDurationEnableOnLive;

  bool get saleOnlineFetchDurationEnableOnLive =>
      _saleOnlineFetchDurationEnableOnLive ??
      (_saleOnlineFetchDurationEnableOnLive =
          prefs.getBool("saleOnlineFetchDurationEnableOnLive")) ??
      true;

  set saleOnlineFetchDurationEnableOnLive(bool value) {
    _saleOnlineFetchDurationEnableOnLive = value;
    prefs.setBool("saleOnlineFetchDurationEnableOnLive", value);
  }

  // 0 is auto
  int _saleOnlineFetchDurationOnliveSecond;

  int get saleOnlineFetchDurationOnliveSecond =>
      _saleOnlineFetchDurationOnliveSecond ??
      (_saleOnlineFetchDurationOnliveSecond =
          prefs.getInt("saleOnlineFetchDurationOnliveSecond")) ??
      0;

  String _saleOnlineOrderListFilterDate;

  String get saleOnlineOrderListFilterDate =>
      _saleOnlineOrderListFilterDate ??
      (_saleOnlineOrderListFilterDate =
          prefs.get("saleOnlineOrderListFilterDate")) ??
      "Hôm nay";

  set saleOnlineOrderListFilterDate(String value) {
    _saleOnlineOrderListFilterDate = value;
    prefs.setString("saleOnlineOrderListFilterDate", value);
  }
}

class PrintTemplate {
  PrintTemplate({this.code, this.name});
  PrintTemplate.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    name = json["name"];
  }
  String code;
  String name;
}

class SupportPrintSaleOnlineRow {
  SupportPrintSaleOnlineRow(
      {this.name,
      this.description,
      this.isPrint = true,
      this.bold = false,
      this.itanic = false,
      this.fontSize = 1});

  SupportPrintSaleOnlineRow.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    description = json["description"];
    bold = json["bold"] ?? false;
    itanic = json[itanic] ?? false;
    fontSize = json["fontSize"] ?? 1;
  }

  String name;
  String description;
  bool isPrint;
  bool bold;
  bool itanic;
  int fontSize;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["bold"] = bold;
    data["itanic"] = itanic;
    data["fontSize"] = fontSize;
    data["description"] = description;

    return data;
  }
}
