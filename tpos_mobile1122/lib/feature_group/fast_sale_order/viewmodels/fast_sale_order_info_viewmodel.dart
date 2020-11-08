/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/4/19 6:25 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/4/19 5:46 PM
 *
 */

import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/services/analytics_service.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/services/data_services/data_service.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/dialog_service/new_dialog_service.dart';
import 'package:tpos_mobile/services/print_service.dart';

import 'package:tpos_mobile/src/tpos_apis/models/payment_info_content.dart';

import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/fast_sale_order_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/fast_sale_order_line_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/sale_setting_api.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';
import 'package:timeago/timeago.dart' as time;
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class FastSaleOrderInfoViewModel extends ViewModel implements ViewModelBase {
  FastSaleOrderInfoViewModel({
    ITposApiService tposApi,
    FastSaleOrderApi fastSaleOrderApi,
    FastSaleOrderLineApi fastSaleOrderLineApi,
    DataService dataService,
    ISettingService setting,
    PrintService print,
    AnalyticsService analyticService,
    NewDialogService newDialogService,
    ISaleSettingApi saleSettingApi,
    DialogService dialogService,
  }) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _print = print ?? locator<PrintService>();
    _dataService = dataService ?? locator<DataService>();
    _fastSaleOrderApi = fastSaleOrderApi ?? locator<FastSaleOrderApi>();
    _fastSaleOrderLineApi =
        fastSaleOrderLineApi ?? locator<FastSaleOrderLineApi>();
    _setting = setting ?? locator<ISettingService>();
    _analyticService = analyticService ?? GetIt.I<AnalyticsService>();
    _newDialog = newDialogService ?? GetIt.I<NewDialogService>();
    _saleSettingApi = saleSettingApi ?? locator<ISaleSettingApi>();
    _dialog = dialogService ?? locator<DialogService>();
    _initViewModelCommand();
  }
  //log
  final _log = Logger("FastSaleEditOrderViewModel");

  ITposApiService _tposApi;
  FastSaleOrderApi _fastSaleOrderApi;
  FastSaleOrderLineApi _fastSaleOrderLineApi;
  PrintService _print;
  DataService _dataService;
  ISettingService _setting;
  AnalyticsService _analyticService;
  NewDialogService _newDialog;
  ISaleSettingApi _saleSettingApi;
  SaleSetting _saleSetting;
  DialogService _dialog;

  ViewModelCommand _editCommand;
  ViewModelCommand _printShipCommand;
  ViewModelCommand _printInvoiceCommand;
  ViewModelCommand _cancelShipCommand;
  ViewModelCommand _cancelInvoiceCommand;
  ViewModelCommand _makePaymentCommand;
  ViewModelCommand _confirmCommand;
  ViewModelCommand _sendToShipperCommand;
  final List<ViewModelCommand> _commands = <ViewModelCommand>[];

  ViewModelCommand get printShipCommand => _printShipCommand;
  ViewModelCommand get printInvoiceCommand => _printInvoiceCommand;
  ViewModelCommand get cancelShipCommand => _cancelShipCommand;
  ViewModelCommand get cancelInvoiceCommand => _cancelInvoiceCommand;
  ViewModelCommand get makePaymentCommand => _makePaymentCommand;
  ViewModelCommand get confirmCommand => _confirmCommand;
  ViewModelCommand get sendToShipperCommand => _sendToShipperCommand;

  bool isConfirmAndPrintShip = false;
  bool isConfirmAndPrintOrder = false;

  void _initViewModelCommand() {
    _log.fine("state: ${editOrder?.state}");
    _editCommand = ViewModelCommand(
      name: "Sửa",
      actionName: "edit",
    );
    _printShipCommand = ViewModelCommand(
      name: "In phiếu ship",
      actionName: "printShip",
      action: _printShip,
      actionBusy: () async {
        onStateAdd(true, message: S.current.processing);
        final rs = await _printShip();
        onStateAdd(false);
        return rs;
      },
    );

    _printInvoiceCommand = ViewModelCommand(
      name: "In hóa đơn",
      actionName: "printInvoice",
      action: _printInvoice,
      actionBusy: () async {
        onStateAdd(true, message: S.current.processing);
        final rs = await _printInvoice();
        onStateAdd(false);
        return rs;
      },
    );
    _cancelShipCommand = ViewModelCommand(
      name: "Hủy vận đơn",
      actionName: "cancelShip",
      action: cancelShipOderCommand,
      enable: () =>
          editOrder.carrierId != null && editOrder.trackingRef != null,
    );
    _cancelInvoiceCommand = ViewModelCommand(
      name: "Hủy hóa đơn",
      actionName: "cancelInvoice",
      enable: () => editOrder.state != "cancel" && editOrder.state != "draft",
      action: cancelFastSaleOrderCommand,
    );

    _confirmCommand = ViewModelCommand(
      name: "Xác nhận",
      enable: () => _editOrder.state == "draft",
      actionName: "confirmOrder",
      action: () async {
        return await _submitOrder();
      },
    );

    _makePaymentCommand = ViewModelCommand(
        name: "Thanh toán",
        actionName: "makePayment",
        execute: () =>
            !isBusy &&
            editOrder?.state == "open" &&
            _editOrder?.residual != null &&
            _editOrder.residual > 0,
        enable: () =>
            !isBusy &&
            editOrder?.state == "open" &&
            _editOrder?.residual != null &&
            _editOrder.residual > 0,
        action: prepareAccountPaymentCommand,
        actionBusy: () async {
          onStateAdd(true);
          return await prepareAccountPaymentCommand();
        });

    _sendToShipperCommand = ViewModelCommand(
      name: "Gửi lại vận đơn",
      actionName: "sendToShipper",
      action: () {
        _resentDeliveryCommandAction();
      },
      enable: () =>
          editOrder.state != "cancel" &&
          editOrder.state != "draft" &&
          editOrder.trackingRef == null &&
          editOrder.carrierId != null,
    );

    _commands.add(_editCommand);
    _commands.add(_confirmCommand);
    _commands.add(_printShipCommand);
    _commands.add(_cancelShipCommand);
    _commands.add(_cancelInvoiceCommand);

    onPropertyChanged("");
  }

  String get timeAgo {
    if (editOrder.dateInvoice != null) {
      return '${time.format(editOrder.dateInvoice)})';
    }
    return '(N/A)';
  }

  //editOrder
  FastSaleOrder _editOrder;
  FastSaleOrder get editOrder => _editOrder;

  String get shipAddress {
    String address = "";
    if (_editOrder.shipReceiver != null &&
        _editOrder.shipReceiver.street != null) {
      address =
          "${_editOrder.shipReceiver.name ?? "<${S.current.noName}>"}, ${_editOrder.shipReceiver.phone ?? "<${S.current.noPhoneNumber}>"} | ${_editOrder.shipReceiver.street ?? "<${S.current.noAddress}>"}";
    } else {
      // Lấy thông tin khách hàng
      address =
          "${_editOrder.partner?.name ?? "<${S.current.noName}>"}, ${_editOrder.partner?.phone ?? "<${S.current.noPhoneNumber}>"} | ${_editOrder.partner?.street ?? "<${S.current.noAddress}>"}";
    }
    return address;
  }

  String get getAddress {
    String address = "";
    if (_editOrder.shipReceiver != null &&
        _editOrder.shipReceiver.street != null) {
      address = _editOrder.shipReceiver.street ?? '';
    } else {
      // Lấy thông tin khách hàng
      address = _editOrder.partner?.street ?? '';
    }
    return address;
  }

  set editOrder(FastSaleOrder value) {
    _editOrder = value;
    if (_editOrderController.isClosed == false) {
      _editOrderController.add(value);
    }
  }

  final BehaviorSubject<FastSaleOrder> _editOrderController = BehaviorSubject();
  Stream<FastSaleOrder> get editOrderStream => _editOrderController.stream;
  Sink<FastSaleOrder> get editOrderSink => _editOrderController.sink;

  //
  List<PaymentInfoContent> _paymentInfoContent;

  List<PaymentInfoContent> get paymentInfoContent => _paymentInfoContent;

  set paymentInfoContent(List<PaymentInfoContent> value) {
    _paymentInfoContent = value;
    _paymentInfoContentController.add(value);
  }

  final BehaviorSubject<List<PaymentInfoContent>>
      _paymentInfoContentController = BehaviorSubject();
  Stream<List<PaymentInfoContent>> get paymentInfoContentStream =>
      _paymentInfoContentController.stream;
  Sink<List<PaymentInfoContent>> get paymentInfoContentSink =>
      _paymentInfoContentController.sink;

  //FastSaleOrderLine
  List<FastSaleOrderLine> _orderLines;

  List<FastSaleOrderLine> get orderLines => _orderLines;

  double get subTotal => _editOrder?.subTotal;
  double get totalProductQuantity {
    double count = 0;
    if (orderLines != null && orderLines.isNotEmpty) {
      for (final FastSaleOrderLine line in orderLines) {
        count += line.productUOMQty;
      }
    }
    return count;
  }

  set orderLines(List<FastSaleOrderLine> value) {
    _orderLines = value;
    _orderLinesController.add(value);
  }

  final BehaviorSubject<List<FastSaleOrderLine>> _orderLinesController =
      BehaviorSubject();
  Stream<List<FastSaleOrderLine>> get orderLinesStream =>
      _orderLinesController.stream;
  Sink<List<FastSaleOrderLine>> get orderLinesSink =>
      _orderLinesController.sink;

  Future _loadOrderInfo() async {
    orderLines =
        await _fastSaleOrderLineApi.getFastSaleOrderLineById(editOrder.id);
    editOrder = await _fastSaleOrderApi.getById(editOrder.id);
  }

  Future _loadPaymentInfo() async {
    final getResult = await _tposApi.getPaymentInfoContent(editOrder.id);
    if (getResult.error == null) {
      _paymentInfoContent = getResult.value;
      if (_paymentInfoContentController.isClosed == false)
        _paymentInfoContentController.add(_paymentInfoContent);

      onPropertyChanged("");
    } else {
      _newDialog.showError(content: getResult.error?.message ?? '');
    }
  }

  Future init({FastSaleOrder editOrder}) async {
    _editOrder = editOrder;
    editOrderSink.add(_editOrder);
    if (_editOrder == null || _editOrder.id == null) {}
    onStateAdd(false);
  }

  Future initCommand() async {
    onStateAdd(true, message: "${S.current.loading}...");
    try {
      _saleSetting = await _saleSettingApi.getDefault();
      await _loadOrderInfo();
      await _loadPaymentInfo();
      onPropertyChanged("");
    } catch (e, s) {
      _log.severe("init", e, s);
      onDialogMessageAdd(
        OldDialogMessage.error(
          "",
          e.toString(),
          title: S.current.exception,
          isRetryRequired: true,
          callback: (value) {
            initCommand();
          },
        ),
      );
    }

    onStateAdd(false);
  }

  // Xác nhận đơn hàng
  // Đang xác nhận
  Future _submitOrder() async {
    onStateAdd(true, message: "${S.current.processing}...");
    try {
      final result =
          await _tposApi.fastSaleOrderConfirmOrder(<int>[editOrder.id]);
      if (result.result == true) {
        // Đã xác nhận hóa đơn
        _newDialog.showToast(message: S.current.saleOrder_invoiceConfirmed);

        if (_editOrder?.carrier != null) {
          _analyticService.logFastSaleOrderCreatedWithCarrier(
            carrierType: _editOrder?.carrierDeliveryType,
            shopUrl: _setting.shopUrl,
          );
        }

        // In phiêu ship & hóa đơn
        try {
          if (isConfirmAndPrintShip) {
            isConfirmAndPrintShip = false;
            await _print.printShip(fastSaleOrderId: editOrder.id);
          }
          if (isConfirmAndPrintOrder) {
            isConfirmAndPrintOrder = false;
            await _print.printOrder(fastSaleOrderId: editOrder.id);
          }
        } catch (e, s) {
          _log.severe("", e, s);
        }

        await initCommand();
        _dataService.addDataNotify(
            value: editOrder,
            type: DataMessageType.UPDATE,
            valueTargetType: FastSaleOrder);
      } else {
        await initCommand();
        // Không gửi được vận đơn
        _newDialog.showError(
            title: '${S.current.saleOrder_resentFailed}!',
            content: result.message);
      }
    } catch (e, s) {
      _log.severe("submitOrder", e, s);
      // Lỗi không xác định
      _newDialog.showError(
          title: '${S.current.exception}!', content: e.toString());
    }
    onStateAdd(false);
  }

  Future cancelShipOderCommand() async {
    onStateAdd(true, message: S.current.processing);
    try {
      final result = await _tposApi.fastSaleOrderCancelShip(editOrder.id);
      if (result.error == false) {
        // Đã hủy vận đơn
        _newDialog.showToast(message: S.current.billOfLadingCanceled);
        await initCommand();
      } else {
        _newDialog.showError(content: result.message);
      }
    } catch (e, s) {
      _log.severe("canncel ship command", e, s);
      _newDialog.showError(content: e.toString());
    }
    onStateAdd(false);
  }

  // Hủy bờ hóa đơn
  Future cancelFastSaleOrderCommand() async {
    onStateAdd(true, message: S.current.processing);
    try {
      final result =
          await _tposApi.fastSaleOrderCancelOrder(<int>[editOrder.id]);
      if (result.error == false) {
        // Đã hủy hóa đơn
        _newDialog.showToast(message: S.current.invoiceCanceled);
        await initCommand();
      } else {
        _newDialog.showError(content: result.message);
      }
    } catch (e, s) {
      _log.severe("canncel order command", e, s);
      _newDialog.showError(content: e.toString());
    }
    onStateAdd(false);
  }

  // Chuẩn bị thanh toán
  Future<AccountPayment> prepareAccountPaymentCommand() async {
    onStateAdd(true);
    try {
      final result = await _tposApi.accountPaymentPrepairData(editOrder.id);

      if (result.error == false) {
        onStateAdd(false);
        return result.result;
      } else {
        _newDialog.showError(content: result.message);
      }
    } catch (e, s) {
      _log.severe("preparePayment", e, s);
      _newDialog.showError(content: e.toString());
    }
    onStateAdd(false);
    return null;
  }

  Future<bool> checkConditionToBeginEditInvoice() async {
    var isAllowEdit = true;
    if (_editOrder.state != "draft") {
      isAllowEdit = false;
    }
    return isAllowEdit;
  }

  Future<void> _printShip() async {
    try {
      if (_saleSetting.statusDenyPrintShip.isNotEmpty) {
        final bool isExist = _saleSetting.statusDenyPrintShip
            .any((item) => item["Value"] == editOrder.state);
        if (isExist) {
          _dialog.showNotify(
              title: S.current.notification,
              message:
                  "${S.current.notifyPrintShip} '${editOrder.showState}'. ${S.current.notifyPrintPleaseAccess}");
        } else {
          if (_saleSetting.groupDenyPrintNoShippingConnection) {
            if (editOrder.carrierId != null) {
              await handlePrint(editOrder.id);
            } else {
              _dialog.showNotify(
                  title: S.current.notification,
                  message:
                      "${S.current.notifyPrintShipWithPartner} ${S.current.notifyPrintPleaseAccess}");
            }
          } else {
            await handlePrint(editOrder.id);
          }
        }
      } else {
        if (_saleSetting.groupDenyPrintNoShippingConnection) {
          if (editOrder.carrierId != null) {
            await handlePrint(editOrder.id);
          } else {
            _dialog.showNotify(
                title: S.current.notification,
                message:
                    "${S.current.notifyPrintShipWithPartner} ${S.current.notifyPrintPleaseAccess}");
          }
        } else {
          await handlePrint(editOrder.id);
        }
      }
      // await _print.printShip(fastSaleOrderId: editOrder.id);
    } catch (e, s) {
      _log.severe("printShip", e, s);
      // In phiếu thất bại
      _newDialog.showError(
          title: '${S.current.saleOrder_printFailed}!. ',
          content: e.toString());
    }
  }

  Future<void> handlePrint(int orderId) async {
    // onStateAdd(true, message: "Đang in...");
    await _print.printShip(
      fastSaleOrderId: orderId,
    );
  }

  Future<void> printShipOkiela() async {
    try {
      await _print.printShip(fastSaleOrderId: editOrder.id, download: true);
    } catch (e, s) {
      _log.severe("printShip", e, s);
      // In phiếu thất bại
      _newDialog.showError(
          title: '${S.current.saleOrder_printFailed}!. ',
          content: e.toString());
    }
  }

  Future<void> _printInvoice() async {
    try {
      if (_saleSetting.statusDenyPrintSale.isNotEmpty) {
        final bool isExist = _saleSetting.statusDenyPrintSale
            .any((item) => item["Value"] == editOrder.state);
        if (isExist) {
          _dialog.showNotify(
              title: S.current.notification,
              message:
                  "${S.current.notifyPrintInvoice} '${editOrder.showState}'. ${S.current.notifyPrintPleaseAccess}.");
        } else {
          onStateAdd(true, message: "Đang in...");
          await _print.printOrder(
            fastSaleOrderId: editOrder.id,
          );
        }
      } else {
        onStateAdd(true, message: "Đang in...");
        await _print.printOrder(
          fastSaleOrderId: editOrder.id,
        );
      }
      // await _print.printOrder(fastSaleOrderId: editOrder.id);
    } catch (e, s) {
      // In phiếu thất bại
      _newDialog.showError(
          title: '${S.current.saleOrder_printFailed}!. ',
          content: e.toString());
      _log.severe("", e, s);
    }
  }

  /// Gửi lại vận đơn
  Future<void> _resentDeliveryCommandAction() async {
    if (editOrder.carrierId == null) {
      return;
    }
    if (editOrder.trackingRef != null) {
      return;
    }
    try {
      //Đang gửi
      onStateAdd(true, message: "${S.current.processing}...");
      await _tposApi.sendFastSaleOrderToShipper(editOrder.id);
      // Đã thực hiện gửi lại vận đơn
      _newDialog.showToast(message: S.current.saleOrder_performedResend);
    } catch (e, s) {
      _log.severe("re send ship", e, s);
      // Không gửi được vận đơn
      _newDialog.showError(
          title: '${S.current.saleOrder_resentFailed}. ',
          content: e.toString());
    }
    onStateAdd(false);
  }

  /// Chuyển sang trình gời điện của máy
  Future<void> callPhone(String phone) async {
    if (phone != null && phone != "") {
      final String url = "tel:$phone";
      if (await canLaunch(url)) {
        await launch(url);
      } else {}
    }
  }

  /// Mở google map xem địa chỉ khách hàng
  Future<void> openGoogleMap(String address) async {
    if (address != null && address != "" && address != "null") {
      final String query = Uri.encodeComponent(address);
      final String googleUrl =
          "https://www.google.com/maps/search/?api=1&query=$query";

      if (await canLaunch(googleUrl)) {
        await launch(googleUrl);
      }
    }
  }

  @override
  void dispose() {
    _editOrderController.close();
    _paymentInfoContentController.close();

    super.dispose();
  }
}

class ViewModelCommand {
  ViewModelCommand({
    this.name,
    this.description,
    this.tag,
    this.action,
    this.actionBusy,
    this.actionName,
    this.active,
    this.enable,
    this.execute,
  });
  final String name;
  final String description;
  final String tag;
  final Function action;
  final Function actionBusy;
  final String actionName;
  final Function active;
  final Function enable;
  final Function execute;

  bool get isActive => active != null ? active() : true;
  bool get isEnable => enable != null ? enable() : true;
  bool get canExecute => execute != null ? execute() : true;
}
