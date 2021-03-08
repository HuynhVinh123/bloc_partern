import 'dart:async';

import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class SaleOnlineOrderInfoViewModel extends ScopedViewModel
    implements ViewModelBase {
  SaleOnlineOrderInfoViewModel({ITposApiService tposApi}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
  }
  //log
  final _log = Logger("SaleOnlineOrderInfoViewModel");

  ITposApiService _tposApi;

  //Order
  SaleOnlineOrder _order;
  String _orderId;

  SaleOnlineOrder get order => _order;

  set order(SaleOnlineOrder value) {
    _order = value;
    _orderController.add(value);
  }

  final BehaviorSubject<SaleOnlineOrder> _orderController = BehaviorSubject();
  Stream<SaleOnlineOrder> get orderStream => _orderController.stream;
  Sink<SaleOnlineOrder> get orderSink => _orderController.sink;

  //SaleOrderLine
  List<SaleOnlineOrderDetail> _orderLines;

  List<SaleOnlineOrderDetail> get orderLines => _orderLines;

  set orderLines(List<SaleOnlineOrderDetail> value) {
    _orderLines = value;
    _orderLinesController.add(value);
  }

  final BehaviorSubject<List<SaleOnlineOrderDetail>> _orderLinesController =
      BehaviorSubject();
  Stream<List<SaleOnlineOrderDetail>> get orderLinesStream =>
      _orderLinesController.stream;
  Sink<List<SaleOnlineOrderDetail>> get orderLinesSink =>
      _orderLinesController.sink;

  Future loadOrderInfo() async {
    try {
      _order = await _tposApi.getOrderById(_orderId);
      orderLines = _order.details;
      if (_orderController.isClosed == false) {
        _orderController.add(_order);
      }
      if (_orderLinesController.isClosed == false)
        _orderLinesController.add(_orderLines);
    } catch (ex, stack) {
      _log.severe("loadOrderInfo fail", ex, stack);
      onDialogMessageAdd(OldDialogMessage.error("Lỗi cập nhật", ex.toString()));
    }
  }

  Future init({SaleOnlineOrder editOrder, String orderId}) async {
    assert(editOrder != null || orderId != null);
    _order = editOrder;
    _orderId = orderId;

    _orderId ??= _order.id;
    orderSink.add(_order);
    await loadOrderInfo();
    onPropertyChanged("");
    onIsBusyAdd(false);
  }

  Future reloadCommand() async {
    setBusy(true);
    await loadOrderInfo();
    onPropertyChanged("");
    setBusy(false);
  }

  @override
  void dispose() {
    _orderController.close();
    _orderLinesController.close();
    super.dispose();
  }
}
