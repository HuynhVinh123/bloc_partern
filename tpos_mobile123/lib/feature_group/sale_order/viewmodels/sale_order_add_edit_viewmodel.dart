import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:tpos_api_client/tpos_api_client.dart' as tpos_api;
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/sale_online/services/tpos_api_service.dart';
import 'package:tpos_mobile/feature_group/sale_order/partner_shipping.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_line.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/account.dart';
import 'package:tpos_mobile/src/tpos_apis/models/product.dart';

import 'package:tpos_mobile/src/tpos_apis/models/stock_warehouse.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/price_list_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/sale_order_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';

import '../partner_invoice.dart';

class SaleOrderAddEditViewModel extends ViewModel {
  ISettingService _setting;
  ITposApiService _tposApi;
  SaleOrderApi _saleOrderApi;
  tpos_api.PartnerApi _partnerApi;
  PriceListApi _priceListApi;
  Logger _log = Logger("SaleOrderAddEditViewModel");
  DialogService _dialog;

  static const String EVENT_CLOSE_UI = "close.ui";

  SaleOrderAddEditViewModel(
      {ISettingService setting,
      ITposApiService tposApi,
      tpos_api.PartnerApi partnerApi,
      PriceListApi priceListApi,
      DialogService dialogService,
      SaleOrderApi saleOrderApi}) {
    _setting = setting ?? locator<ISettingService>();
    _tposApi = tposApi ?? locator<ITposApiService>();
    _dialog = dialogService ?? locator<DialogService>();
    _partnerApi = partnerApi ?? GetIt.I<tpos_api.PartnerApi>();
    _saleOrderApi = saleOrderApi ?? locator<SaleOrderApi>();
    _priceListApi = priceListApi ?? locator<PriceListApi>();
  }

  /// Danh sách bảng giá
  List<tpos_api.ProductPrice> _priceLists;

  int _editOrderId;
  int _partnerId;

  /// Hóa đơn mới/ sửa
  SaleOrder _order;

  /// Khách hàng
  tpos_api.Partner _partner;

  /// Danh sách hàng hóa / dịch vụ
  List<SaleOrderLine> _orderLines;
  List<SaleOrderLine> get orderLines => _orderLines;

  Account _account;

  /// Phương thức thanh toán
  AccountJournal _paymentJournal;
  AccountJournal get paymentJournal => _paymentJournal;

  set paymentJournal(AccountJournal value) {
    _paymentJournal = value;
    _order.paymentJournal = value;
  }

  /// Bảng giá
  tpos_api.ProductPrice _productPrice;
  PartnerInvoice partnerInvoice;
  PartnerShipping partnerShipping;

  /// Kho hàng
  StockWareHouse _wareHouse;

  /*--------------- THÔNG TIN CHUNG -------------*/

  /// Nhân viên bán
  tpos_api.ApplicationUser _saleUser;

  /// Công ty bán
  tpos_api.Company _company;

  /*--------------------PUBLIC ------------------*/

  List<tpos_api.ProductPrice> get priceLists => _priceLists;
  SaleOrder get order => _order;
  Account get account => _account;
  tpos_api.Partner get partner => _partner;
  tpos_api.ApplicationUser get user => _saleUser;
  StockWareHouse get wareHouse => _wareHouse;
  tpos_api.Company get company => _company;
  tpos_api.ProductPrice get priceList => _productPrice;

  bool get isValidToConfirm {
    var result = true;
    if (_partner == null) return false;
    if (_orderLines == null || _orderLines.isEmpty) return false;
    return result;
  }

  double get subTotal => _orderLines == null || _orderLines.isEmpty
      ? 0
      : _orderLines?.map((f) => f.priceTotal ?? 0)?.reduce((a, b) => a + b) ??
          0;
  double get total {
    final double total = (subTotal ?? 0);

    order?.amountTotal = total;
    return order?.amountTotal ?? 0;
  }

  double get amountUntaxed => _order?.amountUntaxed ?? 0;
  double get deliveryPrice => _order?.deliveryPrice ?? 0;
  String get note => _order?.note;
  bool isDiscountPercent = true;

  /* CONDITION VISIBLE


   */
  bool get isPaymentInfoEnable =>
      _partner != null && _orderLines != null && _orderLines.isNotEmpty;

  ///Có được chỉnh sửa danh sách đơn hàng hay không
  bool get cantEditProduct => (_order == null ||
      _order.id == null ||
      _order.id == 0 ||
      _order?.state == "draft");

  bool get cantChangePartner => (_order == null ||
      _order.id == null ||
      _order.id == 0 ||
      _order.state == "draft");

  bool get cantEditPayment => (_order == null ||
      _order.id == null ||
      _order.id == 0 ||
      _order.state == "draft");

  bool get cantEditDateOrder => cantEditPayment;
  bool get cantEditDateExpect => cantEditPayment;
  bool get canConfirm => (_order == null ||
      _order.id == null ||
      _order.id == 0 ||
      _order.state == "draft");

  set note(String text) {
    _order.note = text;
  }

  set user(tpos_api.ApplicationUser value) {
    _saleUser = value;
    notifyListeners();
  }

  set orderLines(List<SaleOrderLine> value) {
    this._order.orderLines = value;
    this._orderLines = value;
  }

  set priceList(tpos_api.ProductPrice priceList) {
    _order.priceList = priceList;
    this._productPrice = priceList;
    notifyListeners();
  }

  /* COMMAND
  * */

  void init(
      {SaleOrder editOrder,
      int editOrderId,
      List<String> saleOnlineIds,
      int partnerId}) {
    this._order = editOrder;
    this._editOrderId = editOrderId;
    this._partnerId = partnerId;
    onStateAdd(false);
  }

  /// Lệnh khởi tạo giá trị mặc định viewmodel
  Future<void> initCommand() async {
    onStateAdd(true, message: "Đang khởi tạo dữ liệu...");

    try {
      // Tải bảng giá
      await _loadPriceList();
      // Nếu là thêm mới
      if (_editOrderId == null && _order == null) {
        var getDefaultResult = await _saleOrderApi.getSaleOrderDefault();
        if (getDefaultResult.value != null) {
          _order = getDefaultResult.value;
          // update price list

          this._saleUser = _order.user;
          this._productPrice = _priceLists?.firstWhere(
              (f) => f.id == _order.priceList?.id,
              orElse: () => null);
          this.partnerInvoice = _order.partnerInvoice;
          this.partnerShipping = _order.partnerShipping;
          this._paymentJournal = _order.paymentJournal;
          this._company = _order.company;
          this._partner = _order.partner;
          this._wareHouse = _order.warehouse;

          // Cập nhật thông tin liên quan tới khách hàng
          if (_partner != null) {
            onStateAdd(true, message: "Lấy thông tin khách hàng...");
            await selectPartnerCommand(_partner);
          }
        }
      } else {
        //  Tạo hóa đơn mới
        // Sửa hóa đơn
        var orderResult =
            await _saleOrderApi.getSaleOrderById(_editOrderId ?? _order.id);
        if (orderResult != null) {
          _order = orderResult;
          // update price list
          this._saleUser = _order.user;
          this._productPrice = _priceLists?.firstWhere(
              (f) => f.id == _order.priceList?.id,
              orElse: () => null);
          this.partnerShipping = _order.partnerShipping;
          this.partnerInvoice = _order.partnerInvoice;
          this._company = _order.company;
          this._partner = _order.partner;
          this._saleUser = _order.user;
          this._paymentJournal = _order.paymentJournal;
          this._wareHouse = _order.warehouse;

          // update other info

          await _loadOrderLine();
        }
      }
    } catch (e, s) {
      _log.severe("init", e, s);
      var dialogResult = await _dialog.showError(error: e, isRetry: true);
      if (dialogResult?.type == DialogResultType.RETRY) this.initCommand();
      if (dialogResult?.type == DialogResultType.GOBACK)
        onEventAdd(EVENT_CLOSE_UI, null);
    }

    notifyListeners();
    onStateAdd(false);
  }

  /// Lệnh thêm sản phẩm mới vào danh sách
  Future<void> addOrderLineCommand(Product product) async {
    var existsItem = _orderLines?.firstWhere((f) => f.productId == product.id,
        orElse: () => null);

    Future _addNew() async {
      SaleOrderLine line = new SaleOrderLine(
        productName: product.name,
        productNameGet: product.nameGet,
        productId: product.id,
        productUOMId: product.uOMId,
        productUOMName: product.uOMName,
        priceUnit: product.price,
        productUOMQty: 1,
        discount: 0,
        discountFixed: 0,
        type: "percent",
        priceSubTotal: product.price,
        priceTotal: product.price,
        product: product,
      );

      if (_orderLines == null) {
        _orderLines = new List<SaleOrderLine>();
      }

      //Update order line info
      try {
        _updateOrderInfo();
        var orderLine = await _tposApi.getSaleOrderLineProductForCreateInvoice(
            orderLine: line, order: this._order);
        if (orderLine != null) {
          line.productUOMId = orderLine.productUOMId;
          line.productUOM = orderLine.productUOM;
          line.priceUnit = orderLine.priceUnit;
          line.priceSubTotal = orderLine.priceUnit;
          line.priceTotal = orderLine.priceUnit;
          line.name = orderLine.name;
          line.id = orderLine.id;
        }
      } catch (e, s) {
        _log.severe("", e, s);
        onDialogMessageAdd(OldDialogMessage.error(
            "Thêm sản phẩm thất bại!. Vui lòng thử lại\n", e.toString()));
      }

      _orderLines.add(line);
    }

    if (existsItem != null) {
      if (_setting.addExistsProductWarning ==
          SettingAddExistsProductWarning.ADD_QUANTITY) {
        existsItem.productUOMQty += 1;
        calculateOrderLinePrice(existsItem);
      } else if (_setting.addExistsProductWarning ==
          SettingAddExistsProductWarning.CONFIRM_QUESTION) {
        onDialogMessageAdd(new OldDialogMessage.confirm(
            "Sản phẩm ${existsItem.productName} đã có. Bạn có muốn thêm dòng mới",
            (result) async {
          if (result == OldDialogResult.Yes) {
            await _addNew();
          }
        }));
      }
    } else {
      await _addNew();
    }

    onPropertyChanged("");
    print("added");
  }

  /// Lệnh xóa sản phẩm trong danh sách
  Future<void> deleteOrderLineCommand(SaleOrderLine item) async {
    if (_orderLines.contains(item)) {
      _orderLines.remove(item);
      onPropertyChanged("orderLines");
    }
  }

  /// Lựa chọn khách hàng
  Future<void> selectPartnerCommand(tpos_api.Partner partner,
      [int partnerId]) async {
    // Cập nhật lại thông tin giao hàng
    // Chọn lại partner
    assert(partner != null || partnerId != null);

    try {
      _partner = await _partnerApi.getById(partner?.id ?? partnerId);
      print(partner.id);
      // Cập nhật lại thông tin đơn hàng
      _updateOrderInfo();
      final OdataResult<SaleOrder> result =
          await _saleOrderApi.getSaleOrderWhenChangePartner(_order);

      if (result.error == null) {
        this._productPrice = _priceLists?.firstWhere(
            (f) => f.id == result?.value?.priceList?.id,
            orElse: () => null);
        this.partnerShipping = result.value.partnerShipping;
        this.partnerInvoice = result.value.partnerInvoice;
      } else {
        throw new Exception(result.error.message);
      }
      onPropertyChanged("");
    } catch (e, s) {
      _log.severe("load parnter", e, s);
      onDialogMessageAdd(
          new OldDialogMessage.error("Lỗi không xác định", e.toString()));
    }
  }

  void _updateOrderInfo() {
    _order.partnerId = _partner?.id ?? null;
    _order.partner = _partner;
    if (_productPrice != null) {
      _order.priceListId = _productPrice.id;
      _order.priceList = _productPrice;
    }

    if (partnerInvoice != null) {
      _order.partnerInvoiceId = partnerInvoice.id;
      _order.partnerInvoice = partnerInvoice;
    }

    if (partnerShipping != null) {
      _order.partnerShippingId = partnerShipping.id;
      _order.partnerShipping = partnerShipping;
    }
    _order.userId = _saleUser.id;
    _order.user = _saleUser;
//    _order.companyId = _company.id;
    _order.warehouseId = _wareHouse?.id;
    _order.orderLines = _orderLines;
    _order.amountTax = 0;
    _order.amountTotal = total;
    _order.amountUntaxed = total;
    _order.paymentJournalId = _paymentJournal?.id;
    _order.paymentJournal = _paymentJournal;
//    _order.dateOrder = order.dateOrder;
  }

  bool _checkConditionForCreateInvoce() {
    List<String> conditions = new List<String>();
    if (partner == null) {
      conditions.add("Khách hàng");
    }

    if (priceList == null) {
      conditions.add("Bảng giá");
    }

    if (_order.orderLines == null || _order.orderLines.isEmpty) {
      conditions.add("Danh sách sản phẩm");
    }

    if (conditions.isNotEmpty) {
      _log.info("Không đủ điều kiện tạo hóa đơn");
      onDialogMessageAdd(
          OldDialogMessage.warning("${conditions.join(", ")} cần có dữ liệu"));
      return false;
    }
    return true;
  }

  /// Lệnh lưu dữ liệu và xem phiếu
  Future<bool> confirmAndPreviewCommand;

  void changeProductQuantityCommand(SaleOrderLine item, double value) {
    item.productUOMQty = value;
    calculateOrderLinePrice(item);
  }

  void calculateOrderLinePrice(SaleOrderLine item) {
    item.priceSubTotal = item.productUOMQty * item.priceUnit;
    item.priceTotal = item.priceSubTotal * (100 - item.discount) / 100;
  }

  bool isCopy;

  /// Command lưu nháp hóa đơn
  Future<bool> saveDraftCommand() async {
    onStateAdd(true, message: "Đang lưu thành nháp...");
    bool result = await _saveInvoice(false);
    onIsBusyAdd(false);
    return result;
  }

  /// Command Lưu và xác nhận hóa đơn
  Future<bool> saveAndConfirmCommand() async {
    onStateAdd(true, message: "Đang lưu...");
    bool result = await _saveInvoice(true);
    onIsBusyAdd(false);
    return result;
  }

  /// Lưu nháp
  Future<bool> _saveInvoice([bool confirmOrder = false]) async {
    _updateOrderInfo();

    if (_order.id != null && _order.id == 0 || isCopy) {
      _order.id = null;
      _order.state = "draft";
      _order.showState = "Nháp";
    }

    if (_checkConditionForCreateInvoce() == false) {
      return false;
    }

    assert(_order.id != 0);
    assert(_order.partnerId != null);
    assert(_order.priceListId != null);
    assert(_order.userId != null);
//    assert(_order.state == "draft");

    int createdOrderId;
    bool isComplete = false;
    try {
      if (isCopy) _order.id = null;
      if (_order.id == null && isCopy) {
        // Tạo mới
        var createdOrder = await _saleOrderApi.insertSaleOrder(_order, true);
        createdOrderId = createdOrder.id;
        this._order.id = createdOrder.id;
        onDialogMessageAdd(
            OldDialogMessage.flashMessage("Đã lưu đơn đặt hàng"));
      } else {
        // Cập nhật
        await _saleOrderApi.updateSaleOrder(_order);
        createdOrderId = _order.id;
        onDialogMessageAdd(
            OldDialogMessage.flashMessage("Đã lưu đơn đặt hàng"));
      }
    } catch (e, s) {
      _log.severe("saveDraft", e, s);
      onDialogMessageAdd(OldDialogMessage.error("Lưu đơn đặt hàng thất bại!. ",
          e.toString().replaceAll("Exception:", "")));
    }

    if (createdOrderId != null) {
      // Xác nhận hóa đơn
      if (confirmOrder) {
        try {
          onStateAdd(true, message: "Xác nhận...");
          var confirmResult = await _tposApi.confirmSaleOrder(
            createdOrderId,
          );
          if (confirmResult == true) {
            onDialogMessageAdd(OldDialogMessage.flashMessage(
                "Đã xác nhận đơn đặt hàng. ID: $createdOrderId"));
          } else {
            onDialogMessageAdd(OldDialogMessage.error(
                "Không thể xác nhận đơn ĐH", confirmResult.toString(),
                title: "Xác nhận hóa đơn thất bại!"));
          }
        } catch (e, s) {
          _log.severe("confirm Order", e, s);
          onDialogMessageAdd(OldDialogMessage.error("Không thể xác nhận đơn ĐH",
              e.toString().replaceAll("Exception:", ""),
              title: "Xác nhận hóa đơn thất bại!"));
        }
      }

      isComplete = true;
    } else {
      isComplete = false;
    }

    return isComplete;
  }

  Future _loadOrderLine() async {
    orderLines = await _tposApi.getSaleOrderLineById(this.order.id);
  }

  /// Lấy danh sách bảng giá
  Future _loadPriceList() async {
    _priceLists = await _priceListApi.getProductPrices();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
