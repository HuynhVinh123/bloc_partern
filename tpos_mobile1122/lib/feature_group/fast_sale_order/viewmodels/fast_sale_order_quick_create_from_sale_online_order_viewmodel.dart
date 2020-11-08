import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/log_services/log_service.dart';
import 'package:tpos_mobile/services/print_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/create_quick_fast_sale_order_model.dart';

import 'package:tpos_mobile/src/tpos_apis/services/object_apis/fast_sale_order_api.dart';

/// Tạo hóa đơn giao hàng với sản phẩm mặc định
///
class FastSaleOrderQuickCreateFromSaleOnlineOrderViewModel extends ViewModel {
  FastSaleOrderQuickCreateFromSaleOnlineOrderViewModel(
      {FastSaleOrderApi fastSaleOrderApi,
      LogService logService,
      PrintService printService,
      DialogService dialogService})
      : super(logService: logService) {
    _dialog = dialogService ?? locator<DialogService>();
    _print = printService ?? locator<PrintService>();
    _fastSaleOrderApi = fastSaleOrderApi ?? locator<FastSaleOrderApi>();
  }
  FastSaleOrderApi _fastSaleOrderApi;
  DialogService _dialog;
  List<String> _saleOnlineOrderIds;
  PrintService _print;

  CreateQuickFastSaleOrderModel _quickModel;
  CreateQuickFastSaleOrderModel get quickModel => _quickModel;
  List<ResultLineModel> _resultLineModel;

  DeliveryCarrier get carrier => _quickModel?.carrier;
  List<CreateQuickFastSaleOrderLineModel> get lines => _quickModel?.lines;
  List<ResultLineModel> get resultLineModels => _resultLineModel;

  set carrier(DeliveryCarrier carrier) {
    quickModel?.carrierId = carrier?.id;
    quickModel?.carrier = carrier;
    notifyListeners();
  }

  /// Khởi tạo và nhận param
  void init({@required List<String> saleOnlineOrderIds}) {
    _saleOnlineOrderIds = saleOnlineOrderIds;
  }

  /// Có thể nhấn in tất cả hay không.
  /// Để hiện thị nút bấm cho phù hợp
  bool get canSaveAll {
    if (_resultLineModel != null &&
        _resultLineModel
            .any((f) => f.status == "Chỉnh sửa" || f.status == "Lỗi"))
      return true;
    else
      return false;
  }

  /// Khởi tạo dữ liệu ban đầu
  Future<void> initData() async {
    onStateAdd(true);
    try {
      _quickModel = await _fastSaleOrderApi
          .getQuickCreateFastSaleOrderDefault(_saleOnlineOrderIds);
      // Map qua model
      _resultLineModel = _quickModel.lines
          .map(
            (f) => ResultLineModel(
              line: f,
              status: "Chỉnh sửa",
              createdOrder: null,
              trackingRef: null,
            ),
          )
          .toList();
      notifyListeners();
    } catch (e, s) {
      logger.error("init data", e, s);
      _dialog
          .showError(isRetry: true, error: e, buttonTitle: "Đồng ý")
          .then((result) {
        if (result != null && result.type == DialogResultType.RETRY)
          initData();
        else if (result != null && result.type == DialogResultType.GOBACK) {
          onEventAdd("GO_BACK", null);
        }
      });
    }
    onStateAdd(false);
  }

  void deleteSelected(ResultLineModel model) {
    if (_resultLineModel.any((f) => f == model)) {
      _resultLineModel.remove(model);
    }
    notifyListeners();
  }

  Future<void> saveSelected(
    ResultLineModel model, {
    bool printOrder = false,
    bool printShip = false,
  }) async {
    try {
      if (model.status == "Thành công") {
        throw Exception("Hóa đơn đã được tạo thành công rồi");
      }

      if (!model.line.partner.isAddressValidateToShip) {
        throw Exception("Thông tin địa chỉ giao hàng chưa hợp lệ");
      }
      onStateAdd(true, message: "Đang lưu...");
      model.setState(true);
      // Lưu 1 cái
      final dataModel = CreateQuickFastSaleOrderModel();
      dataModel.id = _quickModel.id;
      dataModel.carrierId = _quickModel.carrierId;
      dataModel.carrier = _quickModel.carrier;
      dataModel.lines = [model.line..cOD = null];
      final saveResults =
          await _fastSaleOrderApi.createQuickFastSaleOrder(dataModel);
      if (saveResults.success) {
        // Lưu thành công
        // Tải thông tin hóa đơn

        try {
          final order = await _fastSaleOrderApi.getById(saveResults.ids[0]);
          model.createdOrderId = order.id;
          model.createdOrder = order;
        } catch (e, s) {
          logger.error("", e, s);
          _dialog.showNotify(
              type: DialogType.NOTIFY_ERROR, message: e.toString());
        }

        model.status = "Thành công";

        if (printShip && model.createdOrder?.trackingRef != null) {
          onStateAdd(true, message: "Đang in phiếu ship...");
          await _print
              .printShip(fastSaleOrderId: dataModel.id)
              .catchError((e, s) {
            logger.error("", e, s);
            _dialog.showNotify(
                type: DialogType.NOTIFY_ERROR, message: e.toString());
          });
        }

        if (printOrder) {
          onStateAdd(true, message: "Đang in hóa đơn...");
          await _print
              .printOrder(fastSaleOrder: model.createdOrder)
              .catchError((e, s) {
            logger.error("", e, s);
            _dialog.showNotify(
                type: DialogType.NOTIFY_ERROR, message: e.toString());
          });
        }

        if (saveResults.error != null) {
          _dialog.showNotify(
              type: DialogType.NOTIFY_ERROR,
              message:
                  "${saveResults.error}\n${saveResults.errors.toString()}");

          print(saveResults.errors);
        }
      } else {
        throw Exception(
            "${saveResults.error}\n${saveResults.errors.toString()}");
      }
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
    } finally {
      model.setState(false);
      onStateAdd(false);
      notifyListeners();
    }
  }

  Future<void> printShip(ResultLineModel model) async {
    onStateAdd(true, message: "Đang in này...");
    try {
      await _print.printShip(fastSaleOrder: model.createdOrder);
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showNotify(type: DialogType.NOTIFY_ERROR, message: e.toString());
    } finally {
      onStateAdd(false);
    }
  }

  Future<void> printOrder(ResultLineModel model) async {
    onStateAdd(true, message: "Đang in này...");
    try {
      await _print.printOrder(
        fastSaleOrderId: model.createdOrderId,
        fastSaleOrder: model.createdOrder,
      );
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showNotify(type: DialogType.NOTIFY_ERROR, message: e.toString());
    } finally {
      onStateAdd(false);
    }
  }

  Future<void> printOrders(List<ResultLineModel> models) async {
    // ignore: avoid_function_literals_in_foreach_calls
    for (final model in models) {
      if (model.createdOrder != null) {
        await _print
            .printOrder(fastSaleOrder: model.createdOrder)
            .catchError((e, s) {
          logger.error("", e, s);
          _dialog.showNotify(
              type: DialogType.NOTIFY_ERROR, message: e.toString());
        });
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  Future<void> printShips(List<ResultLineModel> models) async {
    onStateAdd(true, message: 'Đang in');
    try {
      for (final itm in models) {
        await _print.printShip(fastSaleOrderId: itm.createdOrderId);
        await Future.delayed(const Duration(seconds: 2));
      }
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showNotify(type: DialogType.NOTIFY_ERROR, message: e.toString());
    }

    onStateAdd(false, message: 'Đang in');
  }

  ///Action Đồng ý tạo hóa đơn
  ///
  Future<bool> save({bool printOrder = false, bool printShip = false}) async {
    // validate
    // Cập nhật lại quickModelLine
    _quickModel.lines = _resultLineModel
        ?.where((f) => f.status == "Chỉnh sửa" || f.status == "Lỗi")
        ?.map((g) => g.line)
        ?.toList();
    if (carrier != null) {
      if (lines
          .any((f) => f.partner?.phone == null || f.partner?.phone == "")) {
        _dialog.showNotify(
            message: "Vui lòng cập nhật số điện thoại cho khách hàng");
        return false;
      }
      if (lines.any((f) =>
          f.partner?.addressFull == null || f.partner?.addressFull == "")) {
        _dialog.showNotify(message: "Vui lòng cập nhật địa chỉ cho khách hàng");
        return false;
      }
    }
    bool isSuccess = false;

    onStateAdd(true, message: "Đang lưu...");

    try {
      // Bỏ COD tránh lỗi
      for (final itm in _quickModel.lines) {
        itm.cOD = null;
      }

      final result =
          await _fastSaleOrderApi.createQuickFastSaleOrder(_quickModel);

      final availableModel = _resultLineModel
          .where((f) => f.status == "Chỉnh sửa" || f.status == "Lỗi")
          .toList();
      if (!result.success) {
        _dialog.showError(content: result.error);
      } else {
        _dialog.showNotify(message: "Đã tạo hóa đơn.");
        // Map kết quả vào mode
        for (int i = 0; i < result.ids.length; i++) {
          //
          availableModel[i].createdOrderId = result.ids[i];
          availableModel[i].status = "Thành công";
        }

        await _fetchAllOrderInfo();
      }

      isSuccess = true;
      if (printOrder) {
        await printOrders(availableModel);
      }

      if (printShip) {
        await printShips(availableModel);
      }
    } catch (e, s) {
      logger.error("save", e, s);
      _dialog.showError(error: e);
      isSuccess = false;
    }
    onStateAdd(false, message: "false lưu...");
    notifyListeners();
    return isSuccess;
  }

  /// Lấy thông tin hóa đơn đã tạo toàn bộ đơn hàng
  Future<void> _fetchAllOrderInfo() async {
    for (final itm in _resultLineModel) {
      if (itm.createdOrderId != null) {
        await _fetchOrderInfo(itm).catchError((e, s) {
          logger.error("", e, s);
          _dialog.showNotify(
            message: e.toString(),
            type: DialogType.NOTIFY_ERROR,
          );
        });
      }
    }
  }

  /// Lấy thông tin hóa đơn một đơn hàng
  Future<void> _fetchOrderInfo(ResultLineModel model) async {
    assert(model.createdOrderId != null);
    model.createdOrder = await _fastSaleOrderApi.getById(model.createdOrderId);
  }

  /// Lấy thông tin hóa đơn 1 đơn hàng
  Future<void> fetchOrderInfo(ResultLineModel model) async {
    try {
      await _fetchOrderInfo(model);
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
    }
  }
}

/// Chứa trạng thái của hóa đơn
/// Mã vận đơn hoặc lỗi phát sinh
class ResultLineModel extends Model {
  ResultLineModel(
      {this.status,
      this.line,
      this.trackingRef,
      this.createdOrder,
      this.message});

  String status;
  CreateQuickFastSaleOrderLineModel line;
  String trackingRef;

  /// Hóa đơn nếu tạo thành công
  FastSaleOrder createdOrder;

  /// Id hóa đơn nếu tạo thành công
  int createdOrderId;
  String message;

  bool _isBusy;
  bool get isBusy => _isBusy;

  void setState(bool isBusy) {
    _isBusy = isBusy;
    notifyListeners();
  }

  void dispose() {}
}
