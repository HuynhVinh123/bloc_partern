import 'package:logging/logging.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_line.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/sale_order_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class SaleOrderInfoViewModel extends ViewModel {
  ITposApiService _tposApi;
  SaleOrderApi _saleOrderApi;
  Logger _log = new Logger("SaleOrderViewModel");

  SaleOrderInfoViewModel({ITposApiService tposApi, SaleOrderApi saleOrderApi}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _saleOrderApi = saleOrderApi ?? locator<SaleOrderApi>();
    _initViewModelCommand();
  }

  SaleOrder _saleOrder;
  SaleOrder get saleOrder => _saleOrder;

  set saleOrder(SaleOrder value) {
    _saleOrder = value;
    notifyListeners();
  }

  List<SaleOrderLine> saleOrderLine;
  // Lọc
  Future<void> loadSaleOrderInfo() async {
    onStateAdd(true, message: "Đang tải");
    try {
      saleOrder = await _saleOrderApi.getSaleOrderById(saleOrder.id);
      saleOrderLine = await _tposApi.getSaleOrderInfo(saleOrder.id);
    } catch (e, s) {
      _log.severe("filter", e, s);
    }
    notifyListeners();
    onStateAdd(false);
  }

  Future<void> initCommand() async {
    try {
      await loadSaleOrderInfo();
    } catch (e, s) {
      _log.severe("init sale order info", e, s);
    }
  }

  Future init({SaleOrder editOrder}) async {
    saleOrder = editOrder;
    notifyListeners();
    if (_saleOrder == null || _saleOrder.id == null) {}
    onStateAdd(false);
  }

  // Hủy bỏ đơn đặt hàng
  Future cancelSaleOrderCommand() async {
    onStateAdd(true, message: "Đang thực hiện");
    try {
      var result = await _tposApi.cancelSaleOrder(saleOrder.id);
      if (result.result == true) {
        onDialogMessageAdd(OldDialogMessage.flashMessage("${result.message}"));
        await initCommand();
      } else {
        onDialogMessageAdd(OldDialogMessage.error("", result.message.toString(),
            title: "Thất bại!"));
      }
    } catch (e, s) {
      _log.severe("canncel order command", e, s);
      onDialogMessageAdd(OldDialogMessage.error(
          "Không thực hiện được!", e.toString(),
          title: "Lỗi không xác định!"));
    }
    onStateAdd(false);
  }

  // Xác nhận đơn hàng
  Future _submitOrder() async {
    onStateAdd(true, message: "Đang xác nhận...");
    try {
      var result = await _tposApi.confirmSaleOrder(saleOrder.id);
      if (result == true) {
        onDialogMessageAdd(
            new OldDialogMessage.flashMessage("Đã xác nhận hóa đơn"));
        await initCommand();
      } else {
        onDialogMessageAdd(
            new OldDialogMessage.error("Không thể xác nhận hóa đơn!", ""));
      }
    } catch (e, s) {
      _log.severe("submitOrder", e, s);
      onDialogMessageAdd(new OldDialogMessage.error("Lỗi không xác định!",
          "Xác nhận không thành công. Log: ${e.toString()}"));
    }
    onStateAdd(false);
  }

  // Tạo hóa đơn
  Future createSaleOrderInvoiceCommand() async {
    onStateAdd(true, message: "Đang thực hiện");
    try {
      var result = await _tposApi.createSaleOrderInvoice(saleOrder.id);
      if (result.result == true) {
        onDialogMessageAdd(OldDialogMessage.flashMessage("${result.message}"));
        await initCommand();
      } else {
        onDialogMessageAdd(OldDialogMessage.error("", result.message.toString(),
            title: "Thất bại!"));
      }
    } catch (e, s) {
      _log.severe("canncel order command", e, s);
      onDialogMessageAdd(OldDialogMessage.error(
          "Không thực hiện được!", e.toString(),
          title: "Lỗi không xác định!"));
    }
    onStateAdd(false);
  }

  void _initViewModelCommand() {
    _log.fine("state: ${saleOrder?.state}");
    _editCommand = new ViewModelCommand(
      name: "Sửa",
      actionName: "edit",
    );
//    _cancelInvoiceCommand = new ViewModelCommand(
//      name: "Hủy hóa đơn",
//      actionName: "cancelInvoice",
//      enable: () => (saleOrder.invoiceStatus == "invoiced"),
//      action: () async {},
//    );

    _confirmCommand = new ViewModelCommand(
      name: "Xác nhận",
      enable: () => (saleOrder.state == "draft"),
      actionName: "confirmOrder",
      action: () async {
        return await _submitOrder();
      },
    );
    _createInvoiceCommand = new ViewModelCommand(
      name: "Tạo hóa đơn",
      enable: () =>
          (saleOrder.state == "sale" && saleOrder.invoiceStatus != "invoiced"),
      actionName: "createInvoice",
      action: () async {
        createSaleOrderInvoiceCommand();
      },
    );
    _cancelOrderCommand = new ViewModelCommand(
      name: "Hủy đơn đặt hàng",
      enable: () => (saleOrder.state != "draft" && saleOrder.state != "cancel"),
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
  List<ViewModelCommand> _commands = new List<ViewModelCommand>();

  ViewModelCommand get editCommand => _editCommand;
  ViewModelCommand get cancelInvoiceCommand => _cancelInvoiceCommand;
  ViewModelCommand get cancelOrderCommand => _cancelOrderCommand;
  ViewModelCommand get confirmCommand => _confirmCommand;
  ViewModelCommand get createInvoiceCommand => _createInvoiceCommand;
  ViewModelCommand get printInvoiceCommand => _printInvoiceCommand;
}

class ViewModelCommand {
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
}
