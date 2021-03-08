/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/4/19 6:25 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/4/19 11:14 AM
 *
 */

import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
import 'package:tmt_flutter_untils/tmt_flutter_utils.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/feature_group/category/viewmodel/product_search_viewmodel.dart'
    as category_product_search;
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_service/calculate_fee_result.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/product_search.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/models/enums/delivery_carrier_type.dart';
import 'package:tpos_mobile/services/analytics_service.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/services/cache_service/cache_service.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';
import 'package:tpos_mobile/services/data_services/data_service.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/dialog_service/new_dialog_service.dart';
import 'package:tpos_mobile/services/log_services/log_service.dart';
import 'package:tpos_mobile/services/print_service.dart';
import 'package:tpos_mobile/services/remote_config_service.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/fast_sale_order_line_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/sale_setting_api.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

enum EditType {
  ADD_NEW,
  EDIT_DRAFT,
  EDIT_CONFIRM,
  EDIT_DELIVERY,
}

class FastSaleOrderAddEditFullViewModel extends ScopedViewModel {
  static const String SAVE_DRAFT_SUCCESS_EVENT = "SAVE_DRAFT_SUCCESS";
  static const String SAVE_CONFIRM_SUCCESS_EVENT = "SAVE_CONFIRM_SUCCESS";
  static const String REQUIRED_CLOSE_UI = "REQUIRED_CLOSE_UI";
  ISettingService _setting;
  ITposApiService _tposApi;
  PriceListApi _priceListApi;
  PartnerApi _partnerApi;
  FastSaleOrderApi _fastSaleOrderApi;
  FastSaleOrderLineApi _fastSaleOrderLineApi;
  ISaleSettingApi _saleSettingApi;
  PrintService _printService;
  DialogService _dialog;
  NewDialogService _newDialog;
  RemoteConfigService _remoteConfig;
  DataService _dataService;
  AnalyticsService _analyticService;
  SecureConfigService _secureConfig;

  CacheService _cacheService;
  EditType _editType = EditType.ADD_NEW;
  int _editOrderId;

  int _partnerId;

  /// Id của [FastSaleOrder]
  int _id;

  /// Cấu hình bán hàng
  SaleSetting _saleSetting;

  /// Danh sách bảng giá
  List<ProductPrice> _priceLists;

  /// Danh sách id của đơn hàng facebook.
  List<String> _saleOrderIds;

  /// Hóa đơn mới/ sửa
  FastSaleOrder _order;

  /// có ẩn cảnh báo địa chỉ khách hàng khác địa chỉ giao hàng hanh không?
  bool isHideWarningDeliverAddress = false;

  Partner _partner;

  /// Danh sách hàng hóa / dịch vụ
  List<FastSaleOrderLine> _orderLines;

  Account _account;

  /// Phương thức thanh toán
  Journal _journal;

  /// Phương thức thanh toán
  AccountJournal _paymentJournal;

  // Partner get partner => _partner;

  /// Bảng giá
  ProductPrice _productPrice;

  /// Kho hàng
  StockWareHouse _wareHouse;

  /// Danh sách dịch vụ của đối tác giao hàng cung cấp
  List<CalculateFeeResultDataService> _deliveryCarrierServices =
      <CalculateFeeResultDataService>[];

  /// Nhân viên bán
  ApplicationUser _saleUser;

  /// Công ty bán
  Company _company;

  /// Dịch vụ của đối tác giao hàng được chọn sau khi tính phí giao hàng
  CalculateFeeResultDataService _carrierService;

  /*--------------- THÔNG TIN CHUNG -------------*/

  /// Tùy chọn dịch vụ sau khi tính phí giao hàng .
  /// Được trả về trong [_carrierService.extras]
  List<CalculateFeeResultDataExtra> _carrierServiceExtras;

  /// Thêm một vài thông tin giao hàng
  ShipExtra _shipExtra;

  /*--------------- THÔNG ĐƠN HÀNG -----------*/

  bool _cantEditPartner = true;

  bool _cantEditPayment = true;
  bool _cantEditDeliveryAddress = true;

  bool _cantEditDelivery = true;
  bool _cantEditOtherInfo = true;

  final bool _cantSave = true;
  final bool _cantConfirm = true;

  bool isDiscountPercent = true;

  /// Lệnh lưu dữ liệu và xem phiếu
  Future<bool> confirmAndPreviewCommand;

  Map<String, String> shifts = {
    "0": "Không chọn",
    "1": "Sáng",
    "2": "Chiều",
    "3": "Tối"
  };

  /// xác định khai giá hàng hóa = giá trị đơn hàng
  bool isInsuranceFeeEquaTotal = true;

  int _carrierId;
  FastSaleOrderAddEditFullViewModel({
    ISettingService setting,
    ITposApiService tposApi,
    FastSaleOrderApi fastSaleOrderApi,
    FastSaleOrderLineApi fastSaleOrderLineApi,
    ISaleSettingApi saleSettingApi,
    PartnerApi partnerApi,
    PriceListApi priceListApi,
    PrintService printService,
    LogService log,
    DataService dataService,
    DialogService dialog,
    NewDialogService newDialog,
    AnalyticsService analyticsService,
    RemoteConfigService remoteConfigService,
    CacheService cacheService,
    SecureConfigService configService,
  }) : super(logService: log) {
    _setting = setting ?? locator<ISettingService>();
    _tposApi = tposApi ?? locator<ITposApiService>();
    _printService = printService ?? locator<PrintService>();
    _dialog = dialog ?? locator<DialogService>();
    _dataService = dataService ?? locator<DataService>();
    _fastSaleOrderApi = fastSaleOrderApi ?? GetIt.I<FastSaleOrderApi>();
    _saleSettingApi = saleSettingApi ?? locator<ISaleSettingApi>();
    _partnerApi = partnerApi ?? GetIt.I<PartnerApi>();
    _fastSaleOrderLineApi =
        fastSaleOrderLineApi ?? locator<FastSaleOrderLineApi>();
    _priceListApi = priceListApi ?? GetIt.I<PriceListApi>();
    _analyticService = analyticsService ?? GetIt.I<AnalyticsService>();
    _remoteConfig = remoteConfigService ?? GetIt.I<RemoteConfigService>();
    _cacheService = cacheService ?? GetIt.instance<CacheService>();
    _newDialog = newDialog ?? GetIt.instance<NewDialogService>();
    _secureConfig = _secureConfig ?? GetIt.I<SecureConfigService>();
  }

  Account get account => _account;

  double get amountUntaxed => _order?.amountUntaxed ?? 0;
  String get bottomActionName {
    if (_editType == EditType.ADD_NEW || _editType == EditType.EDIT_DRAFT) {
      return S.current.confirm.toUpperCase();
    } else if (_editType == EditType.EDIT_CONFIRM) {
      return S.current.save.toUpperCase();
    } else if (_editType == EditType.EDIT_DELIVERY) {
      return S.current.save.toUpperCase();
    } else
      return "N/A";
  }

  /*--------------- PROPERTY -----------*/

  bool get canEditPriceList {
    if (_order.id == null || _order.id == 0 || _order?.state == "draft") {
      return true;
    }
    return false;
  }

  bool get cantChangePartner {
    if (_order.id == null || _order.id == 0 || _order.state == "draft")
      return true;
    if (isCreateFromSaleOnlineOrder) {
      return false;
    }
    if (_order.trackingRef != null) {
      return false;
    }

    return false;
  }

  /// Trả về giá trị [true |false] xem là hóa đơn có đủ điều kiện để xác nhận hay không
  bool get cantConfirm => _cantConfirm;

  bool get cantEditAndChangePartner => _cantEditPartner && _cantEditOtherInfo;

  bool get cantEditDelivery => _cantEditDelivery;

  bool get cantEditDeliveryAddress => _cantEditDeliveryAddress;

  bool get cantEditOtherInfo => _cantEditOtherInfo;

  bool get cantEditPartner => _cantEditPartner;
  bool get cantEditPayment => _cantEditPayment;
  bool get cantEditProduct {
    if (_partner == null) {
      return false;
    }
    if (_order?.id == null || _order?.id == 0 || _order?.state == "draft")
      return true;
    else
      return false;
  }

  bool get cantSave => _cantSave;

  /// Trả về [_order.carrier] Đối tác giao hàng đang chọn
  DeliveryCarrier get carrier => _order.carrier;
  CalculateFeeResultDataService get carrierService => _carrierService;
  /*--------------------PUBLIC ------------------*/
  set carrierService(CalculateFeeResultDataService value) {
    _carrierService = value;
    _order.shipServiceId = value?.serviceId;
  }

  List<CalculateFeeResultDataExtra> get carrierServiceExtras =>
      _carrierServiceExtras;

  /// Trả vè [cashOnDelivery] (Tiền thu hộ)
  double get cashOnDelivery => _order.cashOnDelivery ?? 0;
  set cashOnDelivery(double value) {
    _order.cashOnDelivery = value;
  }

  Company get company => _company;

  /// Trả về [_order.customerDeliveryPrice] (Phí giao hàng được đối tác giao hàng tính qua API)
  double get customerDeliveryPrice => _order.customerDeliveryPrice ?? 0;
  List<CalculateFeeResultDataService> get deliveryCarrierServices =>
      _deliveryCarrierServices;

  set deliveryCarrierServices(value) {
    _deliveryCarrierServices = value;
  }

  /// Trả về [_order.deliveryNode] (Ghi chú giao hàng)
  String get deliveryNode => _order.deliveryNote;
  set deliveryNode(String value) {
    _order.deliveryNote = value;
  }

  /// Trả về [_order.deliveryNote] (Ghi chú giao hàng)
  String get deliveryNote => _order.deliveryNote;
  set deliveryNote(String value) {
    _order.deliveryNote = value;
  }

  /// Trả về [deliveryPrice] (Phí giao hàng)
  double get deliveryPrice => _order?.deliveryPrice ?? 0;

  set deliveryPrice(double value) {
    _order?.deliveryPrice = value;
    _calculateCashOnDelivery();
  }

  /// Trả về [depositAmount] (Tiền cọc)
  double get depositAmount => _order.amountDeposit ?? 0;

  set depositAmount(double value) {
    _order.amountDeposit = value;
    _calculateCashOnDelivery();
  }

  double get discount => _order?.discount ?? 0;

  double get discountAmount => _order?.discountAmount ?? 0;

  EditType get editType => _editType;

  /// Có tạo từ đơn hàng saleonline hay không
  bool get isCreateFromSaleOnlineOrder =>
      _saleOrderIds != null && _saleOrderIds.isNotEmpty;

  /// Có đang bật Khai giá hàng hóa hay không
  bool get isInsuranceFeeEnable => order.shipServiceExtras
      .any((f) => f.name.toLowerCase().contains("khai giá"));
  bool get isPartnerShipAddressValid {
    if (_partner.phone == null || _partner.phone == "") {
      return false;
    }
    if (_partner.street == null || _partner.street == "") {
      return false;
    }
    if (_partner.city == null || _partner.city.code == null) {
      return false;
    }
    if (_partner.district == null || _partner.district.code == null)
      return false;
    return true;
  }

  bool get isPaymentInfoEnable =>
      _partner != null && _orderLines != null && _orderLines.isNotEmpty;

  bool get isProductListEnable => _partner != null;

  /// Địa chỉ giao hàng có hợp hay không
  bool get isShipAddressValid {
    if (shipAddressName == null || shipAddressName.isEmpty) {
      return false;
    }
    if (shipAddressPhone == null || shipAddressPhone.isEmpty) {
      return false;
    }
    if (shipAddressStreet == null || shipAddressStreet.isEmpty) {
      return false;
    }
    return true;
  }

  bool get isShippingAddressEnable =>
      _partner != null && _orderLines != null && _orderLines.isNotEmpty;
  bool get isShippingCarrierEnable =>
      _partner != null && isShippingAddressEnable;

  /// check ShipReceiver đã hợp lệ hay chưa
  ///
  bool get isShipReceiverValid {
    if (_order.shipReceiver == null) {
      return false;
    }
    if (_order.shipReceiver.name != null && _order.shipReceiver.name.isNotEmpty)
      return true;
    if (_order.shipReceiver.phone != null &&
        _order.shipReceiver.phone.isNotEmpty) {
      return true;
    }
    if (_order.shipReceiver.street != null &&
        _order.shipReceiver.street.isNotEmpty) {
      return true;
    }
    if (_order.shipReceiver.city != null &&
        _order.shipReceiver.city.code != null) {
      return true;
    }
    if (_order.shipReceiver.district != null &&
        _order.shipReceiver.district.code != null) {
      return true;
    }
    if (_order.shipReceiver.ward != null &&
        _order.shipReceiver.ward.code != null) {
      return true;
    }
    return false;
  }

  bool get isValidToConfirm {
    const result = true;
    if (_partner == null) {
      return false;
    }
    if (_orderLines == null || _orderLines.isEmpty) {
      return false;
    }
    //if (_carrierService == null) return false;
    return result;
  }

  Journal get journal => _journal;

  String get note => _order?.comment;

  set note(String text) {
    _order.comment = text;
  }

  FastSaleOrder get order => _order;

  List<FastSaleOrderLine> get orderLines => _orderLines;

  set orderLines(List<FastSaleOrderLine> value) {
    _order.orderLines = value;
    _orderLines = value;
  }

  Partner get partner => _partner;
  double get paymentAmount => _order?.paymentAmount ?? 0;
  AccountJournal get paymentJournal => _paymentJournal;
  set paymentJournal(AccountJournal value) {
    _paymentJournal = value;
    _order.paymentJournal = value;
  }

  ProductPrice get priceList => _productPrice;

  set priceList(ProductPrice priceList) {
    _productPrice = priceList;
    _order.priceList = priceList;
    _order.priceListId = priceList.id;
    notifyListeners();
  }

  List<ProductPrice> get priceLists => _priceLists;
  /* CONDITION VISIBLE


   */

  double get rechargeAmount {
    return total - paymentAmount;
  }

  String get shipAddressName {
    if (!isShipReceiverValid) {
      return partner?.name;
    }
    return shipReceiver?.name;
  }

  String get shipAddressPhone {
    if (!isShipReceiverValid) {
      return partner?.phone;
    }
    return shipReceiver?.phone;
  }

  String get shipAddressStreet {
    if (!isShipReceiverValid) {
      return partner?.addressFull;
    }
    return shipReceiver?.street;
  }

  ShipExtra get shipExtra => _shipExtra;

  set shipExtra(ShipExtra value) {
    _shipExtra = value;
  }

  /// Trả về [_order.shipInsuranceFee] (Phí bảo hiểm hàng hóa)
  double get shipInsuranceFee => _order.shipInsuranceFee ?? 0;

  set shipInsuranceFee(double value) {
    _order.shipInsuranceFee = value;
  }

  ShipReceiver get shipReceiver => _order?.shipReceiver;

  String get shipReceiverAddress {
    if (shipReceiver != null) {
      final StringBuffer _stringBuffer = StringBuffer();

      if (shipReceiver.street != null) {
        _stringBuffer.write(shipReceiver.street);
      }

      return _stringBuffer?.toString();
    } else {
      return null;
    }
  }

  String get shipReceiverNameAndPhone {
    final StringBuffer _stringBuffer = StringBuffer();
    if (shipReceiver?.name != null && shipReceiver?.name != "") {
      _stringBuffer.write("");
      _stringBuffer.write(shipReceiver.name);
    }

    if (shipReceiver?.phone != null && shipReceiver?.phone != "") {
      _stringBuffer.write(" | ");
      _stringBuffer.write(shipReceiver.phone);
    }

    return _stringBuffer?.toString();
  }

  /// Trả về [_order.shipServiceExtras] (Danh sách tùy chọn thêm của dịch vụ giao hàng)
  /// Ví dụ: Gửi hàng tại điểm, khai giá hàng hóa
  List<ShipServiceExtra> get shipServiceExtras =>
      _order.shipServiceExtras ??
      (_order.shipServiceExtras = <ShipServiceExtra>[]);

  /// Cân nặng của gói hàng ship
  double get shipWeight => _order?.shipWeight ?? 0;

  set shipWeight(double value) {
    _order?.shipWeight = value;
  }

  double get subTotal => (_orderLines == null || _orderLines.isEmpty)
      ? 0
      : _orderLines?.map((f) => f.priceTotal ?? 0)?.reduce((a, b) => a + b) ??
          0;

  double get total {
    final double total =
        (subTotal ?? 0) * (100 - discount) / 100 - (order?.decreaseAmount ?? 0);

    order?.amountTotal = total;
    return order?.amountTotal ?? 0;
  }

  double get totalDiscountAmount =>
      discountAmount + (order?.decreaseAmount ?? 0);

  /* COMMAND
  * */

  double get totalQuantity {
    double quantity = 0;

    if (_orderLines != null && _orderLines.isNotEmpty) {
      for (final element in _orderLines) {
        quantity += element.productUOMQty;
      }
    }

    return quantity;
  }

  ApplicationUser get user => _saleUser;

  StockWareHouse get wareHouse => _wareHouse;

  /// Set giá trị cho [order.carrier]
  set _carrier(DeliveryCarrier value) {
    _order.carrier = value;
  }

  set _customerDeliveryPrice(double value) {
    _order.customerDeliveryPrice = value;
  }

  /// Lệnh thêm sản phẩm mới vào danh sách
  /// Event thêm sản phẩm mới
  Future<void> addOrderLineCommand(Product product) async {
    final existsItem = _orderLines?.firstWhere((f) => f.productId == product.id,
        orElse: () => null);

    Future _addNew() async {
      final FastSaleOrderLine line = FastSaleOrderLine(
        productName: product.name,
        productNameGet: product.nameGet,
        productId: product.id,
        productUOMId: product.uOMId,
        productUomName: product.uOMName,
        priceUnit: product.price,
        productUOMQty: 1,
        discount: 0,
        discountFixed: 0,
        type: "percent",
        priceSubTotal: product.price,
        priceTotal: product.price,
        product: product,
      );

      _orderLines ??= <FastSaleOrderLine>[];

      //Update order line info
      try {
        _updateOrderInfo();
        setBusy(true, message: "${S.current.update}...");
        final orderLine =
            await _tposApi.getFastSaleOrderLineProductForCreateInvoice(
                orderLine: line, order: _order);
        if (orderLine != null) {
          line.accountId = orderLine.account?.id;
          line.account = orderLine.account;
          line.productUOMId = orderLine.productUOMId;
          line.productUOM = orderLine.productUOM;
          line.priceUnit = orderLine.priceUnit;
          line.priceSubTotal = orderLine.priceUnit;
          line.priceTotal = orderLine.priceUnit;
        }
        setBusy(false, message: "${S.current.update}...");
      } catch (e, s) {
        logger.error("", e, s);
        _dialog.showError(
            content: "thêm sản phẩm không thành công. \n${e.toString()}");
      }

      _orderLines.add(line);
    }

    if (existsItem != null) {
      if (_setting.addExistsProductWarning ==
          SettingAddExistsProductWarning.ADD_QUANTITY) {
        existsItem.productUOMQty += 1;
        onOrderLineChanged(existsItem);
      } else if (_setting.addExistsProductWarning ==
          SettingAddExistsProductWarning.CONFIRM_QUESTION) {
        final dialogResult = await _newDialog.showConfirm(
            title: S.current.confirm,
            content:
                "${S.current.product} ${existsItem.productNameGet} ${S.current.fastSaleOrder_productExisted}");

        if (dialogResult == true) {
          await _addNew();
        }
      }
    } else {
      await _addNew();
    }

    calculatePaymentAmount();
    calculateCashOnDelivery();
    _calculateTotalWeight(notify: false);
    onPropertyChanged("");
    print("added");
  }

  ///Cộng trừ tính phí giao hàng
  void calculateCashOnDelivery() {
    final double cod = (total ?? 0) +
        (order?.deliveryPrice ?? 0) -
        (order?.amountDeposit ?? 0);

    print("amountTotal: ${order.amountTotal}");
    print("cod: $cod");

    order?.cashOnDelivery = cod;
    notifyListeners();
  }

  /// Tính phí giao hàng khi đối tác thay đổi
  /// Truyền biến [onSelectService] = true nếu tính phí sau khi chọn dịch vụ hoặc muốn tính lại phí giao hàng
  Future<void> calculateDeliveryFee(
      {bool isSelectService = false, bool isReCalculate = false}) async {
    if (!_remoteConfig.calculateFeeCarriers.contains(carrier?.deliveryType)) {
      // fastSaleOrder_donNotSupportDeliveryFee
      _dialog.showNotify(
          message:
              "${carrier?.name} ${S.current.fastSaleOrder_donNotSupportDeliveryFee}");
      _customerDeliveryPrice = 0;
      return;
    }
    setBusy(true);

    if (shipWeight == null || shipWeight == 0) {
      shipWeight = 100;
    }
    try {
      final result = await _tposApi.calculateShipingFee(
        partnerId: partner?.id,
        carrierId: carrier.id,
        companyId: _cacheService.companyCurrent?.companyId,
        weight: shipWeight,
        shipReceiver: isShipReceiverValid ? shipReceiver : null,
        shipServiceId: _carrierService?.serviceId ??
            _getDefaultServiceIdByCarrierType(carrier),
        cashOnDelivery: cashOnDelivery?.toInt(),
        shipInsuranceFee: shipInsuranceFee,
        shipServiceExtras: shipServiceExtras,
      );

      if (_deliveryCarrierServices != null &&
          _deliveryCarrierServices.isNotEmpty) {
        // Cập nhật dịch vụ + extra khi api có trả về danh sách dịch vụ
        for (final itm in result.services) {
          final existsService = _deliveryCarrierServices.firstWhere(
              (element) => element.serviceId == itm.serviceId,
              orElse: () => null);

          if (existsService != null) {
            existsService.serviceName = itm.serviceName;
            existsService.fee = itm.fee;
            existsService.totalFee = itm.totalFee;

            existsService.extras = itm.extras;
          } else {
            _deliveryCarrierServices.add(itm);
          }

          if (existsService?.id == carrierService?.id) {
            _carrierServiceExtras = itm.extras;
          }
        }

        // Cập nhật service hiện tại

        _customerDeliveryPrice = carrierService?.totalFee;
        if (_carrierService?.totalFee == 0) {
          _customerDeliveryPrice = result.totalFee;
        }
      } else {
        // add new
        if (result.services != null && result.services.isNotEmpty) {
          _deliveryCarrierServices = result.services;
        } else {
          _deliveryCarrierServices.clear();
        }

        _customerDeliveryPrice = result.totalFee;
      }

      // Gắn mặc định dịch vụ đầu tiên nếu chưa có dịch vụ nào được chọn
      if (carrierService == null &&
          deliveryCarrierServices != null &&
          deliveryCarrierServices.isNotEmpty) {
        carrierService = _deliveryCarrierServices.first;
        _carrierServiceExtras = carrierService.extras;
      }

      if (_carrierService != null &&
          _carrierService.extras != null &&
          (isSelectService || (!isSelectService & !isReCalculate))) {
        // Thiết lập mặc định gửi hàng tại điểm
        if (carrier.extrasFromText != null &&
            carrier.extrasFromText.isDropoff) {
          // Nếu mặc định [Gửi hàng tại điểm]
          final dropOffExtra = _carrierService.extras.firstWhere(
            (element) =>
                element.serviceName
                    .toLowerCase()
                    .contains('gửi hàng tại điểm') ||
                element.serviceName.toLowerCase().contains('tại bưu cục') ||
                element.serviceId == 'GNG',
            orElse: () => null,
          );
          if (dropOffExtra != null) {
            _addShipServiceExtra(
              ShipServiceExtra(
                  id: dropOffExtra.serviceId,
                  fee: dropOffExtra.fee,
                  name: dropOffExtra.serviceName),
            );
          }
        }

        // Thiết lập mặc định khai giá hàng hóa
        if (carrier.extrasFromText != null &&
            carrier.extrasFromText.isInsurance == true) {
          // Nếu mặc định [Gửi hàng tại điểm]
          final dropOffExtra = _carrierService.extras.firstWhere(
              (element) =>
                  element.serviceName.toLowerCase().contains('khai giá') ||
                  element.serviceName.toLowerCase().contains('giá trị'),
              orElse: () => null);
          if (dropOffExtra != null) {
            _addShipServiceExtra(
              ShipServiceExtra(
                  id: dropOffExtra.serviceId,
                  fee: dropOffExtra.fee,
                  name: dropOffExtra.serviceName),
            );
          }
        }

        // Thiết lập mặc định cho xem hàng

        if (carrier.extrasFromText != null &&
            carrier.extrasFromText.isPackageViewable == true) {
          // Nếu mặc định [Gửi hàng tại điểm]
          final dropOffExtra = _carrierService.extras.firstWhere(
            (element) => element.serviceName.toLowerCase().contains('xem hàng'),
            orElse: () => null,
          );
          if (dropOffExtra != null) {
            _addShipServiceExtra(
              ShipServiceExtra(
                  id: dropOffExtra.serviceId,
                  fee: dropOffExtra.fee,
                  name: dropOffExtra.serviceName),
            );
          }
        }

        await calculateDeliveryFee(isReCalculate: true);
      }
    } catch (e, s) {
      _deliveryCarrierServices?.clear();
      order.customerDeliveryPrice = null;
      logger.error("calcuateDeliveryFee", e, s);
      _dialog.showNotify(message: e.toString(), type: AlertDialogType.error);
    }

    setBusy(false);
    notifyListeners();
  }

  /// Tính cột thanh toán
  void calculatePaymentAmount() {
    if (!_saleSetting.groupAmountPaid) {
      _order.paymentAmount = total;
    }
    notifyListeners();
  }

  void changeProductQuantityCommand(FastSaleOrderLine item, double value) {
    item.productUOMQty = value;
    onOrderLineChanged(item);
  }

  Future<void> copyOrderLinecommand(FastSaleOrderLine line) async {
    final FastSaleOrderLine newOrderLine = FastSaleOrderLine(
        productName: line.productName,
        productNameGet: line.productNameGet,
        productId: line.productId,
        productUOMId: line.productUOMId,
        productUomName: line.productUomName,
        priceUnit: line.priceUnit,
        productUOMQty: line.productUOMQty,
        discount: line.discount,
        discountFixed: line.discountFixed,
        type: line.type,
        priceSubTotal: line.priceSubTotal,
        priceTotal: line.priceTotal,
        product: line.product,
        account: line.account,
        accountId: line.accountId,
        productUOM: line.productUOM);

    _orderLines.insert(_orderLines.indexOf(line) + 1, newOrderLine);
    notifyListeners();
  }

  /// Lệnh xóa sản phẩm trong danh sách
  Future<void> deleteOrderLineCommand(FastSaleOrderLine item) async {
    if (_orderLines.contains(item)) {
      _orderLines.remove(item);
      calculatePaymentAmount();
      calculateCashOnDelivery();
      onPropertyChanged("orderLines");
    }
  }

  Future<void> getDefaultInsuranceFeeCommand() async {
    if (isInsuranceFeeEquaTotal) {
      order.shipInsuranceFee = total;
    }

    notifyListeners();
  }

  // Tính tổng chi tiết
  void init(
      {FastSaleOrder editOrder,
      int editOrderId,
      List<String> saleOnlineIds,
      int partnerId}) {
    _order = editOrder; // Tạo mới nếu không phải chỉnh sửa
    _saleOrderIds = saleOnlineIds;
    _editOrderId = editOrderId;
    _partnerId = partnerId;

    setBusy(false);

    if (_saleOrderIds != null)
      assert(_saleOrderIds != null && _partnerId != null);
  }

  /// Lệnh khởi tạo giá trị mặc định viewmodel
  Future<bool> initCommand(
      {FastSaleOrder editOrderCopy, bool isCopy = false}) async {
    assert(isCopy != null);
    setBusy(true, message: "${S.current.fastSaleOrder_InitializingData}...");

    bool result = true;
    try {
      _cacheService.clearProducts();
      _cacheService.refreshPartnerStatus();
      await _loadPriceList();
      await _loadSaleSetting();
      // Lấy thông tin fastSaleOrder để copy

      String shipExtrasId;
      if ((_order != null && _order.id != null && _order.id != 0) ||
          (_editOrderId != null && _editOrderId != 0)) {
        // Sửa hóa đơn. Tải thông tin hóa đơn từ [GetById]
        final orderResult =
            await _fastSaleOrderApi.getById(_editOrderId ?? _order.id);
        if (orderResult != null) {
          _order = orderResult;
          // update price list

          _account = _order.account;
          _wareHouse = _order.wareHouse;
          _saleUser = _order.user;
          _productPrice = _priceLists?.firstWhere(
              (f) => f.id == _order.priceList?.id,
              orElse: () => null);
          _company = _order.company;
          _journal = _order.journal;
          _paymentJournal = _order.paymentJournal;
          _partner = _order.partner;
          _carrier = _order.carrier;
          _saleUser = _order.user;
          _shipExtra = _order.shipExtra;

          if (_order.carrier != null) {
            _shipExtra = carrier.extras;
          }

          // update other info

          await _loadOrderLine();
        }
      } else if (_saleOrderIds != null && _saleOrderIds.isNotEmpty) {
        // Tạo hóa đơn từ đơn hàng

        //Warehouse,User,PriceList,Company,Journal,PaymentJournal,Partner,Carrier,Tax,SaleOrder
        final defaultInvoice = await _fastSaleOrderApi.getDefault(
          type: 'invoice',
        );

        if (defaultInvoice != null) {
          _order = defaultInvoice;
          // update price list
          _account = _order.account;
          _wareHouse = _order.wareHouse;
          _saleUser = _order.user;
          _productPrice = _priceLists?.firstWhere(
              (f) => f.id == _order.priceList?.id,
              orElse: () => null);
          _company = _order.company;
          _journal = _order.journal;
          _paymentJournal = _order.paymentJournal;
          _partner = _order.partner;
          _carrier = _order.carrier;
          _shipExtra = _order.shipExtra;

          if (_order.carrier != null) {
            _shipExtra = carrier.extras;
          }

          _order.saleOnlineIds = _saleOrderIds;

          // Nếu là tạo từ đơn hàng

          // Lấy chi tiết đơn hàng
          final getOrderLineResult =
              await _tposApi.getDetailsForCreateInvoiceFromOrder(_saleOrderIds);

          if (getOrderLineResult.error != null) {
            throw Exception(
                "${S.current.fastSaleOrder_GetOrderDetailFailed}. ${getOrderLineResult.error.message}");
          } else {
            _orderLines = getOrderLineResult.value.orderLines;
            _order.orderLines = _orderLines;
            _order.comment = getOrderLineResult.value.comment;
            _calculateTotal();
          }

          // Lấy thông tin khách hàng
          setBusy(true,
              message: "${S.current.purchaseOrder_getPartnerInfo}...");
          await selectPartnerCommand(null, _partnerId);
        }
      } else {
        //  Tạo hóa đơn mới
        FastSaleOrder defaultInvoice = await _fastSaleOrderApi.getDefault();
        FastSaleOrder infoOrderResult;
        if (isCopy) {
          infoOrderResult = await _fastSaleOrderApi.getById(
            editOrderCopy.id,
            query: GetFastSaleOrderByIdQuery.allInfo(),
          );

          infoOrderResult.state = "draft";
          infoOrderResult.trackingRefSort =
              infoOrderResult.trackingRefSort ?? "";
          final FastSaleOrder fastSaleOrder = await _fastSaleOrderApi
              .getOnChangePartnerOrPriceList(infoOrderResult);
          shipExtrasId = infoOrderResult.shipServiceId;
          fastSaleOrder.dateInvoice = defaultInvoice.dateInvoice;
          fastSaleOrder.receiverAddress = fastSaleOrder.shipReceiver?.street;
          fastSaleOrder.receiverName = fastSaleOrder.shipReceiver?.name;
          fastSaleOrder.phone = fastSaleOrder.shipReceiver?.phone;
          fastSaleOrder.receiverDate = infoOrderResult.receiverDate;
          defaultInvoice = fastSaleOrder;
        }

        if (defaultInvoice != null) {
          _order = defaultInvoice;
          // update price list
          _account = _order.account;
          _wareHouse = _order.wareHouse;
          _saleUser = _order.user;
          _productPrice = _priceLists?.firstWhere(
              (f) => f.id == _order.priceList?.id,
              orElse: () => null);
          _company = _order.company;
          _journal = _order.journal;
          _paymentJournal = _order.paymentJournal;
          _partner = _order.partner;
          _carrier = _order.carrier;
          _shipExtra = _order.shipExtra;
          if (_order.carrier != null) {
            _shipExtra = carrier.extras;
          }

          // Cập nhật thông tin liên quan tới khách hàng
          if (isCopy) {
            _order.decreaseAmount = _order.decreaseAmount ?? 0;
            _order.discount = _order.discount ?? 0;
            _order.discountAmount = _order.discountAmount ?? 0;
            _saleUser = infoOrderResult.user;
            _journal = infoOrderResult.journal;
            _company = infoOrderResult.company;
            _wareHouse = infoOrderResult.wareHouse;
            _paymentJournal = infoOrderResult.paymentJournal;
            _shipExtra = infoOrderResult.shipExtra;
            _carrier = infoOrderResult.carrier;

//            orderLines = _order.orderLines;

            setBusy(true,
                message: "${S.current.purchaseOrder_getPartnerInfo}...");
            await _loadOrderLine();
            await selectPartnerCommand(null, _order.partnerId);
            // Lấy xong danh sách sản phẩm cập nhật Id về 0 để thêm
            _order.id = 0;
          } else {
            if (_partner != null) {
              setBusy(true,
                  message: "${S.current.purchaseOrder_getPartnerInfo}...");
              await selectPartnerCommand(_partner);
            }
          }
        }
      }

      // Nếu có đối tác giao hàng
      if (_order.carrier != null) {
        _order.shipServiceExtras =
            _order.shipServiceExtraFromText ?? <ShipServiceExtra>[];

        if (isCopy) {
          _order.shipServiceId = shipExtrasId;
        }

        // Nếu có dịch vụ đối tác giao hàng
        if (_order.shipServiceId.isNotNullOrEmpty()) {
          _carrierService = CalculateFeeResultDataService(
            serviceId: _order.shipServiceId,
            serviceName: _order.shipServiceName.isNotNullOrEmpty()
                ? _order.shipServiceName
                : _order.shipServiceId,
            totalFee: 0,
          );

          _deliveryCarrierServices = <CalculateFeeResultDataService>[
            _carrierService
          ];
        }

        _carrierServiceExtras = shipServiceExtras
            .map(
              (e) => CalculateFeeResultDataExtra(
                serviceId: e.id,
                serviceName: e.name,
                fee: e.fee,
              ),
            )
            .toList();
      } else {
        _order.shipServiceExtras = <ShipServiceExtra>[];
      }

      isInsuranceFeeEquaTotal = total == (_order?.shipInsuranceFee ?? 0);

      // Kiểm tra xem được chỉnh sửa những gì
      if (_order.id == null || _order.id == 0) {
        _editType = EditType.ADD_NEW;
      } else if (_order.state == "draft") {
        _editType = EditType.EDIT_DRAFT;
      } else if (_order.state == "paid" || _order.state == "open") {
        _editType = EditType.EDIT_CONFIRM;
      } else if (_order.trackingRef != null && _order.trackingRef != "") {
        _editType = EditType.EDIT_DELIVERY;
      }

      _cantEditPartner = true;

      _cantEditPayment = _order.id == null || _order.state == "draft";
      _cantEditDeliveryAddress =
          _order?.trackingRef == null || _order?.trackingRef == "";
      _cantEditDelivery =
          _order.trackingRef == null || _order?.trackingRef == "";
      _cantEditOtherInfo = true;

      //get inventory

      await locator<ProductSearchViewModel>().loadInventory();
      await locator<category_product_search.ProductSearchViewModel>()
          .refreshInventory();
      await locator<category_product_search.ProductSearchViewModel>()
          .initData();
      calculatePaymentAmount();
      calculateCashOnDelivery();
    } catch (e, s) {
      logger.error("", e, s);
      _dialog
          .showError(title: "Đã xảy ra lỗi!.", error: e, isRetry: true)
          .then((result) {
        if (result.type == DialogResultType.RETRY) {
          initCommand(isCopy: isCopy, editOrderCopy: editOrderCopy);
        } else if (result.type == DialogResultType.GOBACK) {
          onEventAdd(REQUIRED_CLOSE_UI, null);
        }
      });
      result = false;
    }

    onPropertyChanged("");
    setBusy(false);
    return result;
  }

  void onOrderLineChanged(FastSaleOrderLine item) {
    item.calculateTotal();
    calculatePaymentAmount();
    calculateCashOnDelivery();
    _calculateTotalWeight(notify: false);
    notifyListeners();
  }

  Future<void> refreshPartnerInfo() async {
    try {
      _partner = await _partnerApi.getById(_partner?.id);
      notifyListeners();
    } catch (e, s) {
      logger.error("", e, s);
    }
  }

  /// Command Lưu và xác nhận hóa đơn
  Future<void> saveAndConfirmCommand(
      {bool isPrintShip = false, isPrintOrder = false}) async {
    // Confirm
    final dialogResult = await _newDialog.showConfirm(
      title: S.current.confirm,
      content: S.current.saleOrder_confirmInvoice,
    );

    if (!dialogResult) {
      return false;
    }
    // validate
    // Cảnh báo
    // Bạn cần phải chọn khách hàng trước
    if (_partner == null) {
      _dialog.showError(
          title: S.current.warning,
          content: S.current.fastSaleOrder_needChooseCustomerFirst);
      return false;
    }

    if (_orderLines == null || _orderLines.isEmpty) {
      _dialog.showError(
          title: S.current.warning,
          content: S.current.fastSaleOrder_PleaseChooseProduct);
      return false;
    }

    // Vui lòng cập nhật Địa chỉ giao hàng: Tên, SĐT, Địa chỉ đầy đủ cho khách hàng
    if (carrier != null) {
      if (carrier.deliveryType.toLowerCase().contains("viettel") ||
          carrier.deliveryType.toLowerCase().contains("ghn") ||
          carrier.deliveryType.toLowerCase().contains('vnpost')) {
        if (_partner.name == null ||
            _partner.phone == null ||
            _partner.street == null) {
          if (shipReceiver.name == null ||
              shipReceiver.phone == null ||
              shipReceiver.street == null) {
            _dialog.showError(
                title: S.current.warning,
                content: S.current.fastSaleOrder_PleaseUpdateDeliveryAddress);
            return false;
          }
        }
      }
    }

    setBusy(true, message: "${S.current.saving}...");

    try {
      final int result = await _saveDraft();
      if (result != null && result != 0) {
        // Xác nhận
        setBusy(true, message: "${S.current.confirm}...");
        final bool confirmResult = await _confirmOrder(result);

        if (confirmResult) {
          _dialog.showNotify(
              message: S.current.saleOrder_invoiceConfirmed,
              type: AlertDialogType.info,
              showOnTop: true);
          // In phiếu
          if (isPrintShip) {
            setBusy(true, message: S.current.printing);
            _printShip(result);
          }

          if (isPrintOrder) {
            try {
              setBusy(true, message: S.current.printing);
              await _printService.printOrder(fastSaleOrderId: result);
            } catch (e, s) {
              logger.error("print order", e, s);
            }
          }
        }
        onEventAdd(FastSaleOrderAddEditFullViewModel.SAVE_CONFIRM_SUCCESS_EVENT,
            result);
      }
    } catch (e, s) {
      logger.error("confirm order", e, s);
      _dialog.showError(error: e);
    }

    setBusy(false, message: "${S.current.saving}...");
  }

  /// Command lưu nháp hóa đơn
  Future<void> saveDraftCommand() async {
    //validate data
    if (_partner == null) {
      // Cảnh báo
      // Bạn cần phải chọn khách hàng trước
      _dialog.showError(
          title: S.current.warning,
          content: S.current.fastSaleOrder_needChooseCustomerFirst);
      return false;
    }

    if (_orderLines == null || _orderLines.isEmpty) {
      _dialog.showError(
          title: S.current.warning,
          content: S.current.fastSaleOrder_PleaseChooseProduct);
      return false;
    }
    // Đang lưu hóa đơn
    setBusy(true, message: "${S.current.saving}...");
    final result = await _saveDraft();
    if (result != null && result != 0) {
      onEventAdd(
          FastSaleOrderAddEditFullViewModel.SAVE_DRAFT_SUCCESS_EVENT, result);
    }
    setBusy(false);
    return result != null;
  }

  /// Lựa chọn khách hàng
  ///   Cập nhật lại thông tin giao hàng
  //    Chọn lại partner
  //    Cập nhật lại thông tin mặc định
  // Đang kiểm tra
  Future<void> selectPartnerCommand(Partner partner, [int partnerId]) async {
    assert(partner != null || partnerId != null);
    setBusy(true, message: "${S.current.checking}...");
    try {
      final newPartnerResult =
          await _partnerApi.getById(partner?.id ?? partnerId);
      // Cập nhật lại thông tin đơn hàng

      _partner = newPartnerResult;

      _updateOrderInfo();
      final FastSaleOrder newOrderResult =
          await _fastSaleOrderApi.getOnChangePartnerOrPriceList(_order);

      if (newOrderResult == null) {
        _productPrice = _priceLists?.firstWhere(
            (f) => f.id == newOrderResult?.priceList?.id,
            orElse: () => null);
        _account = newOrderResult?.account;

        _productPrice ??= newOrderResult?.priceList;
      }
      setBusy(false, message: "${S.current.checking}...");
      onPropertyChanged("");
    } catch (e, s) {
      logger.error("load parnter", e, s);
      _dialog.showError(
          title: S.current.dialog_errorTitle,
          content: S.current.fastSaleOrder_chooseCustomerFailed,
          error: e);
    }
  }

  /// Chọn dịch vụ thêm ship extra
  Future<void> selectShipExtraCommand(value) async {
    shipExtra ??= ShipExtra();
    shipExtra.pickWorkShift = value;
    shipExtra.pickWorkShiftName = shifts[value];
    notifyListeners();
  }

  Future<void> selectShipReceiverCityCommand(CityAddress city) async {
    shipReceiver?.city = city;
    onPropertyChanged("");
  }

  Future<void> selectShipReceiverDistrictCommand(
      DistrictAddress district) async {
    shipReceiver?.district = district;
    onPropertyChanged("");
  }

  Future<void> selectShipReceiverWardCommand(WardAddress ward) async {
    shipReceiver?.ward = ward;
    onPropertyChanged("");
  }

  /// Thêm hoặc xóa [ShipServiceExtra]
  /// Nếu đối tượng đã tồn tại và yêu cầu thêm mới thì [fee] sẽ được cập nhật
  /// Nếu đối tượng chưa có sẽ được thêm mới
  void setDeliverCarrierServiceExtra(
      CalculateFeeResultDataExtra item, bool value) {
    if (value == true) {
      _addShipServiceExtra(
        ShipServiceExtra(
            id: item.serviceId, fee: item.fee, name: item.serviceName),
      );
    } else {
      final existsItem = order.shipServiceExtras
          .firstWhere((f) => f.id == item.serviceId, orElse: () => null);
      _deleteShipServiceExtra(existsItem);
    }

    notifyListeners();
  }

  /// Chọn đối tác giao hàng.
  /// Nếu là đối tác giao hàng đã chọn thì không thay đổi gì.
  /// Nếu là đối tác giao hàng khác thì bắt đầu tính lại phí giao hàng,
  /// và thiết lập các thông số mặc định
  /// Nếu là null thì bỏ chọn đối tác giao hàng
  Future<void> setDeliveryCarrier(DeliveryCarrier value) async {
    if (value == null) {
      // Bỏ chọn
      _carrier = null;
      _deliveryCarrierServices?.clear();

      carrierService = null;
      _carrierServiceExtras?.clear();
      shipServiceExtras?.clear();
      _customerDeliveryPrice = 0;
    } else {
      if (value.id != carrier?.id) {
        // Thiết lập đối tác mới
        _carrier = value;
        _carrierService = null;
        _carrierServiceExtras?.clear();
        shipServiceExtras?.clear();
        _deliveryCarrierServices?.clear();
        _customerDeliveryPrice = 0;

        // Thiết lập giá trị mặc định của đối tác giao hàng.
        if (carrier.configDefaultWeight != null &&
            carrier.configDefaultWeight != 0) {
          shipWeight = carrier.configDefaultWeight;
          if (shipWeight == null || shipWeight == 0) {
            shipWeight = 100;
          }
        }

        deliveryPrice = carrier.configDefaultFee ?? 0;
        if (carrier.extrasFromText?.isInsurance == true) {
          shipInsuranceFee = carrier.extrasFromText?.insuranceFee ?? 0;
        }

        // Tính phí giao hàng

        // Thiết lập dịch vụ mặc định cho viettel
        if (carrier.deliveryType == "ViettelPost" &&
            carrier.viettelPostServiceId.isNotNullOrEmpty()) {
          final defaultService = _getDefaultServiceIdByCarrierType(carrier);
          if (defaultService != null) {
            _carrierService = _deliveryCarrierServices?.firstWhere(
                (element) => element.serviceId == defaultService,
                orElse: () => null);

            if (_carrierService == null) {
              _carrierService = CalculateFeeResultDataService(
                serviceId: defaultService,
                serviceName:
                    DeliveryCarryType.ViettelPost.getService(defaultService)
                        ?.name,
                totalFee: 0,
              );

              _deliveryCarrierServices = <CalculateFeeResultDataService>[
                _carrierService
              ];

              _carrierService.extras = [];

              if (carrier.extrasFromText?.isDropoff == true) {
                _carrierService.extras.add(
                  CalculateFeeResultDataExtra(
                      serviceId: 'GNG',
                      serviceName: 'Gửi tại bưu cục (Giảm 10%)',
                      fee: 0),
                );
              }

              _carrierServiceExtras.addAll(_carrierService.extras);
            }
          }
          // Thiết lập tùy chọn đối tác mặc định
        }

        notifyListeners();
        await calculateDeliveryFee();
      }
    }

    notifyListeners();
  }

  /// Thiết lập dịch vụ của đối tác giao hàng
  /// gọi khi thay đổi dịch vụ
  Future<void> setDeliveryCarrierService(
      CalculateFeeResultDataService value) async {
    setBusy(true);
    carrierService = value;
    _carrierServiceExtras = value.extras;
    await calculateDeliveryFee(isSelectService: true);
    setBusy(false);
    notifyListeners();
  }

  /// Thêm một [ShipServiceExtra] (Dịch vụ kèm theo) vào [shipServiceExtras] (Danh sách dịch vụ cộng thêm)
  /// Nếu là [Khai giá hàng hóa] thì giá trị hàng hóa sẽ được lấy tự động
  void _addShipServiceExtra(ShipServiceExtra shipServiceExtra) {
    if (!shipServiceExtras
        .any((element) => element.id == shipServiceExtra.id)) {
      shipServiceExtras.add(shipServiceExtra);

      if (shipServiceExtra.name.toLowerCase().contains('khai giá')) {
        if (carrier.extrasFromText?.insuranceFee != null &&
            carrier.extrasFromText.insuranceFee > 0) {
          shipInsuranceFee = carrier.extrasFromText.insuranceFee;
        } else {
          shipInsuranceFee = total;
        }
      }
    } else {
      // update
      final serviceExtra = shipServiceExtras.firstWhere(
          (element) => element.id == shipServiceExtra.id,
          orElse: () => null);

      serviceExtra?.fee = shipServiceExtra.fee;
    }
  }

  /// Tính số tiền thu hộ
  /// Hoạt động tính toán có thể được gọi khi một trong các trường dữ liệu liên quan thay đổi như
  /// + Tổng tiền hóa đơn
  /// + Phí giao hàng
  /// + Tiền cọc
  void _calculateCashOnDelivery() {
    cashOnDelivery = total + deliveryPrice - depositAmount;
    notifyListeners();
  }

  Future<void> _calculateTotal() async {
    if (_orderLines == null || _orderLines.isEmpty) {
      return;
    }

    for (final f in _orderLines) {
      f.priceSubTotal = (f.productUOMQty ?? 0) * (f.priceUnit ?? 0);
      f.priceTotal = f.priceSubTotal * (100 - (f.discount ?? 0)) / 100 -
          (f.discountFixed ?? 0);
    }
  }

  /// Tính tổng khối lượng sản phẩm trong danh sách [OrderLines]
  void _calculateTotalWeight({bool notify = true}) {
    final double totalWeight = _orderLines.sumByDouble((e) => e.weight ?? 0);
    order?.weightTotal = totalWeight;
    if (notify) {
      notifyListeners();
    }
  }

  // List ShipExtras
  /// Xác nhận hóa đơn sau khi lưu nháp thành công
  Future<bool> _confirmOrder(int orderId) async {
    // Xác nhận.
    try {
      setBusy(true, message: "${S.current.confirm}...");
      final confirmResult = await _tposApi.fastSaleOrderConfirmOrder([
        orderId,
      ]);
      if (confirmResult.result == true) {
        _order.state = "open";
        _order.showState = "Đã thanh toán";
        _dialog.showNotify(
            message: "Đã xác nhận hóa đơn. ID: $orderId",
            type: AlertDialogType.info,
            showOnTop: true);
        _dataService.addDataNotify(
            value: _order.id,
            type: DataMessageType.UPDATE,
            valueTargetType: FastSaleOrder);

        if (carrier != null) {
          _analyticService.logFastSaleOrderCreatedWithCarrier(
            carrierType: carrier?.deliveryType,
            shopUrl: _secureConfig.shopUrl,
          );
        }
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      logger.error("confirm Order", e, s);
      return false;
    }
  }

  /// Xác nhận hóa đơn
  /// TODO(namnv): Làm lại xác nhận hóa đơn
  void _confirmOrder1() {}

  /// Xóa một [ShipServiceExtra] rả khỏi [shipServiceExtras]
  void _deleteShipServiceExtra(ShipServiceExtra shipServiceExtra) {
    if (shipServiceExtras.any((element) => element.id == shipServiceExtra.id)) {
      shipServiceExtras
          .removeWhere((element) => element.id == shipServiceExtra.id);
    }
  }

  String _getDefaultServiceIdByCarrierType(DeliveryCarrier carrier) {
    if (carrier == null) {
      return null;
    }
    switch (carrier.deliveryType) {
      case "MyVNPost":
        return carrier.viettelPostServiceId;
        break;
      case "ViettelPost":
        return carrier.viettelPostServiceId;
      case "GHN":
        return carrier.gHNServiceId;
        break;
      case "TinToc":
        return carrier.viettelPostServiceId;
        break;
      default:
        return carrier.viettelPostServiceId;
    }
  }

  Future _loadOrderLine() async {
    orderLines = await _fastSaleOrderLineApi.getFastSaleOrderLineById(order.id);
  }

  /// Lấy danh sách bảng giá
  Future<void> _loadPriceList() async {
    final result =
        await _priceListApi.getPriceListAvailable(data: DateTime.now());
    _priceLists = result.value;
    notifyListeners();
  }

  Future<void> _loadSaleSetting() async {
    _saleSetting = await _saleSettingApi.getDefault();
  }

  ///TODO(namnv): Convert các thuộc tính trong ViewModel sang FastSaleOrder để tiến hành lưu dữ liệu
  void _mapViewModelToFastSaleOrder() {
    _order.id = _id;
    //_order.taxId
    _order.accountId = _account?.id;
    _order.account = _account;
    _order.carrierId = _carrierId;
    //_order.carrier = _carrier;
    _order.companyId = _company?.id;
    _order.company = _company;
    _order.journalId = _journal?.id;
    _order.journal = _journal;
    _order.partnerId = _partnerId;
    _order.partner = _partner;
    _order.paymentJournalId = _paymentJournal?.id;
    _order.paymentJournal = _paymentJournal;
    _order.priceListId = _productPrice?.id;
    _order.priceList = _productPrice;
    //_order.refundOrderId =
    //_order.shipServiceId = _carrierService?id;
    _order.warehouseId = _wareHouse?.id;
    _order.wareHouse = _wareHouse;

    _order.orderLines = _orderLines;
    _order.weightTotal = shipWeight;
  }

  Future<void> _printShip(int fastSaleOrderId) async {
    try {
      await _printService.printShip(fastSaleOrderId: fastSaleOrderId);
    } catch (e, s) {
      logger.error("print ship after confirm", e, s);
      _dialog.showError(title: S.current.printFailed, error: e);
    }
  }

  /// Lưu dữ liệu
  /// TODO(namnv): Làm lại hàm lưu dữ liệu
  void _save() {}
  //DeliveryCarrier _carrier;

  //TODO(namnv): Validate dữ liệu và thông báo nếu dữ liệu không hợp lệ trước khi lưu
  /// Lưu nháp hóa đơn
  /// Return int | Saved Order Id
  Future<int> _saveDraft() async {
    _updateOrderInfo();

    if (_order.id == null || _order.id == 0) {
      _order.id = null;
      _order.state = "draft";
      _order.showState = "Nháp";
    }

    assert(_order.id != 0);
    assert(_order.partnerId != null);
    assert(_order.priceListId != null);
    assert(_order.userId != null);
    // assert(_order.state == "draft");
    assert(_order.accountId != null);
    assert(_order.accountId != 0);
    assert(_order.journalId != null);

    int createdOrderId;
    try {
      if (_order.id == null) {
        // Tạo mới
        final createdOrder = await _fastSaleOrderApi.insert(_order);
        createdOrderId = createdOrder.id;
        _order.id = createdOrder.id;
        _dataService.addDataNotify(value: _order, type: DataMessageType.INSERT);
        _dialog.showNotify(
            message: S.current.orderSaved,
            type: AlertDialogType.info,
            showOnTop: true);
      } else {
        // Cập nhật
        await _fastSaleOrderApi.update(_order);
        createdOrderId = _order.id;
        _dataService.addDataNotify(
            value: _order,
            type: DataMessageType.UPDATE,
            valueTargetType: FastSaleOrder);
        _dialog.showNotify(
            message: S.current.orderSaved,
            type: AlertDialogType.info,
            showOnTop: true);
      }
      return createdOrderId;
    } catch (e, s) {
      logger.error("saveDraft", e, s);
      _dialog.showError(
          title: S.current.fastSaleOrder_InvoiceSaveFailed, error: e);
      return null;
    }
  }

  void _updateOrderInfo() {
    if (_account != null) {
      _order.accountId = _account.id;
      _order.account = _account;
    }

    _order.partnerId = _partner?.id;
    _order.partner = _partner;
    if (_productPrice != null) {
      _order.priceListId = _productPrice.id;
      _order.priceList = _productPrice;
    }

    if (_carrierService != null) {
      _order.shipServiceId = _carrierService.serviceId;
    } else {
      _order.shipServiceId = null;
    }

    _order.saleOnlineIds = _saleOrderIds;
    _order.userId = _saleUser.id;
    _order.user = _saleUser;
    _order.journalId = _journal.id;
    _order.journal = journal;
    _order.carrierId = carrier?.id;
    _order.carrier = carrier;
    _order.companyId = _company.id;
    _order.company = _company;
    _order.warehouseId = _wareHouse.id;
    _order.wareHouse = _wareHouse;
    _order.paymentJournalId = _paymentJournal.id;
    _order.paymentJournal = _paymentJournal;
    _order.orderLines = _orderLines;

    _order.shipReceiver = shipReceiver;
    _order.shipExtra = _shipExtra;

    _order.amountTax = 0;
    _order.amountTotal = total;
    _order.amountUntaxed = total;
    _order.newCredit = total;
    _order.weightTotal = 0;
  }

  /// Có thể để hàm này publish để UI kiểm tra trước khi gọi hàm lưu
  void _validateModel() {}
}
