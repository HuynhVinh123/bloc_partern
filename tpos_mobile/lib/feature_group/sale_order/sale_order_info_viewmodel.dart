import 'package:logging/logging.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_line.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/sale_order_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SaleOrderInfoViewModel extends ScopedViewModel {
  SaleOrderInfoViewModel({ITposApiService tposApi, SaleOrderApi saleOrderApi}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _saleOrderApi = saleOrderApi ?? locator<SaleOrderApi>();
    _initViewModelCommand();
  }

  ITposApiService _tposApi;
  SaleOrderApi _saleOrderApi;
  final Logger _log = Logger("SaleOrderViewModel");

  SaleOrder _saleOrder;
  SaleOrder get saleOrder => _saleOrder;

  set saleOrder(SaleOrder value) {
    _saleOrder = value;
    notifyListeners();
  }

  List<SaleOrderLine> saleOrderLine;
  // Lọc
  Future<void> loadSaleOrderInfo(int saleOrderId) async {
    setBusy(true, message: S.current.loading);
    try {
      if (saleOrderId != null) {
        saleOrder = await _saleOrderApi.getSaleOrderById(saleOrderId);
        saleOrderLine = await _tposApi.getSaleOrderInfo(saleOrderId);
      } else {
        saleOrder = await _saleOrderApi.getSaleOrderById(saleOrder.id);
        saleOrderLine = await _tposApi.getSaleOrderInfo(saleOrder.id);
      }
    } catch (e, s) {
      _log.severe("filter", e, s);
    }
    notifyListeners();
    setBusy(false);
  }

  Future<void> initCommand({int saleOrderId}) async {
    try {
      await loadSaleOrderInfo(saleOrderId);
    } catch (e, s) {
      _log.severe("init sale order info", e, s);
    }
  }

  Future init({SaleOrder editOrder}) async {
    saleOrder = editOrder;
    notifyListeners();
    if (_saleOrder == null || _saleOrder.id == null) {}
    setBusy(false);
  }

  // Hủy bỏ đơn đặt hàng
  Future cancelSaleOrderCommand() async {
    /// Đang thực hiện
    setBusy(true, message: S.current.processing);
    try {
      final result = await _tposApi.cancelSaleOrder(saleOrder.id);
      if (result.result == true) {
        onDialogMessageAdd(OldDialogMessage.flashMessage(result.message ?? ""));
        await initCommand();
      } else {
        onDialogMessageAdd(OldDialogMessage.error("", result.message.toString(),
            title: S.current.posOfSale_failed));
      }
    } catch (e, s) {
      _log.severe("canncel order command", e, s);
      onDialogMessageAdd(OldDialogMessage.error(S.current.error, e.toString(),
          title: S.current.exception));
    }
    setBusy(false);
  }

  // Xác nhận đơn hàng
  Future _submitOrder() async {
    setBusy(true, message: S.current.processing);
    try {
      final result = await _tposApi.confirmSaleOrder(saleOrder.id);
      if (result == true) {
        onDialogMessageAdd(OldDialogMessage.flashMessage(
            S.current.purchaseOrder_orderConfirmed));
        await initCommand();
      } else {
        onDialogMessageAdd(
            OldDialogMessage.error(S.current.purchaseOrder_cannotConfirm, ""));
      }
    } catch (e, s) {
      _log.severe("submitOrder", e, s);
      onDialogMessageAdd(OldDialogMessage.error(S.current.exception,
          "${S.current.purchaseOrder_orderConfirmed}. Log: ${e.toString()}"));
    }
    setBusy(false);
  }

  // Tạo hóa đơn
  Future createSaleOrderInvoiceCommand() async {
    setBusy(true, message: S.current.processing);
    try {
      final result = await _tposApi.createSaleOrderInvoice(saleOrder.id);
      if (result.result == true) {
        onDialogMessageAdd(OldDialogMessage.flashMessage(result.message ?? ""));
        await initCommand();
      } else {
        onDialogMessageAdd(OldDialogMessage.error("", result.message.toString(),
            title: S.current.posOfSale_failed));
      }
    } catch (e, s) {
      _log.severe("canncel order command", e, s);
      onDialogMessageAdd(OldDialogMessage.error(S.current.error, e.toString(),
          title: S.current.exception));
    }
    setBusy(false);
  }

  void _initViewModelCommand() {
    _log.fine("state: ${saleOrder?.state}");
    _editCommand = ViewModelCommand(
      name: S.current.edit,
      actionName: "edit",
    );
//    _cancelInvoiceCommand = new ViewModelCommand(
//      name: "Hủy hóa đơn",
//      actionName: "cancelInvoice",
//      enable: () => (saleOrder.invoiceStatus == "invoiced"),
//      action: () async {},
//    );

    _confirmCommand = ViewModelCommand(
      name: S.current.confirm,
      enable: () => saleOrder.state == "draft",
      actionName: "confirmOrder",
      action: () async {
        return await _submitOrder();
      },
    );
    _createInvoiceCommand = ViewModelCommand(
      name: S.current.purchaseOrder_createInvoice,
      enable: () =>
          saleOrder.state == "sale" && saleOrder.invoiceStatus != "invoiced",
      actionName: "createInvoice",
      action: () async {
        createSaleOrderInvoiceCommand();
      },
    );
    _cancelOrderCommand = ViewModelCommand(
      name: S.current.purchaseOrder_cancel,
      enable: () => saleOrder.state != "draft" && saleOrder.state != "cancel",
      action: cancelSaleOrderCommand,
    );

    _commands.add(_editCommand);
    _commands.add(_confirmCommand);
    _commands.add(_cancelOrderCommand);
    _commands.add(_printInvoiceCommand);
    _commands.add(_cancelInvoiceCommand);
    _commands.add(_createInvoiceCommand);

    onPropertyChanged("");
  }

  ViewModelCommand _editCommand;
  ViewModelCommand _printInvoiceCommand;
  ViewModelCommand _cancelInvoiceCommand;
  ViewModelCommand _createInvoiceCommand;
  ViewModelCommand _confirmCommand;
  ViewModelCommand _cancelOrderCommand;
  final List<ViewModelCommand> _commands = <ViewModelCommand>[];

  ViewModelCommand get editCommand => _editCommand;
  ViewModelCommand get cancelInvoiceCommand => _cancelInvoiceCommand;
  ViewModelCommand get cancelOrderCommand => _cancelOrderCommand;
  ViewModelCommand get confirmCommand => _confirmCommand;
  ViewModelCommand get createInvoiceCommand => _createInvoiceCommand;
  ViewModelCommand get printInvoiceCommand => _printInvoiceCommand;
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
