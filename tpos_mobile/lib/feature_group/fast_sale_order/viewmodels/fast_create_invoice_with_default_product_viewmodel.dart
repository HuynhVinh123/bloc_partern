import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/dialog_service/new_dialog_service.dart';
import 'package:tpos_mobile/services/log_services/log_service.dart';
import 'package:tpos_mobile/services/print_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/sale_setting.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/sale_setting_api.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

/// Tạo hóa đơn giao hàng với sản phẩm mặc định
///
class FastCreateInvoiceWithDefaultProductViewModel extends ScopedViewModel {
  FastCreateInvoiceWithDefaultProductViewModel({
    FastSaleOrderApi fastSaleOrderApi,
    LogService logService,
    PrintService printService,
    ISaleSettingApi saleSettingApi,
    NewDialogService newDialogService,
  }) : super(logService: logService) {
    _print = printService ?? locator<PrintService>();
    _saleSettingApi = saleSettingApi ?? locator<ISaleSettingApi>();
    _fastSaleOrderApi = fastSaleOrderApi ?? GetIt.I<FastSaleOrderApi>();
    _newDialog = newDialogService ?? GetIt.I<NewDialogService>();
  }
  NewDialogService _newDialog;
  List<String> _saleOnlineOrderIds;
  PrintService _print;
  FastSaleOrderApi _fastSaleOrderApi;

  /// Cấu hình bán hàng
  ISaleSettingApi _saleSettingApi;
  SaleSetting _saleSetting;

  /// Hiển thị thông tin sản phẩm
  bool isShowProduct = false;

  /// Kiểm tra load dữ liệu cho setting có bị lỗi hay ko
  bool isError = false;

  // thiết lập sản phẩm mặc định
  Product _defaultProduct = Product();
  Product get defaultProduct => _defaultProduct;

  set defaultProduct(Product value) {
    _defaultProduct = value;
    isShowProduct = true;
    _saleSetting?.productId = _defaultProduct.id;
    _saleSetting?.product = _defaultProduct;
    notifyListeners();
  }

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
    setBusy(true);
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
      _newDialog
          .showError(content: e, buttonTitle: S.current.confirm)
          .then((result) {
        if (result != null && result.type == DialogResultType.RETRY)
          initData();
        else if (result != null && result.type == DialogResultType.GOBACK) {
          onEventAdd("GO_BACK", null);
        }
      });
    }
    setBusy(false);
  }

  // Load saleSetting
  Future<bool> loadSaleSetting() async {
    setBusy(true);
    bool _isExistProduct = false;
    try {
      _saleSetting = await _saleSettingApi.getDefault();
      if (_saleSetting.product != null) {
        _isExistProduct = true;
      }
      setBusy(false);
    } catch (e) {
      isError = true;
      _newDialog
          .showError(content: e, buttonTitle: S.current.confirm)
          .then((value) {
        onEventAdd("GO_BACK", null);
      });
      setBusy(false);
    }

    return _isExistProduct;
  }

  // Lưu sản phẩm sau khi đc chọnn
  Future<void> saveSetting() async {
    setBusy(true, message: S.current.saving);
    try {
      await _saleSettingApi.updateAndExecute(_saleSetting);
    } catch (e, s) {
      logger.error("", e, s);
      _newDialog.showError(content: e);
    }
    setBusy(false, message: S.current.saving);
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
        throw Exception(S.current.saleOrderQuickCreate_InvoiceCreated);
      }

      if (!model.line.partner.isAddressValidateToShip) {
        throw Exception(S.current.saleOrderQuickCreate_DeliveryAddressInvalid);
      }
      setBusy(true, message: "${S.current.saving}...");
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
          _newDialog.showToast(
              type: AlertDialogType.error, message: e.toString());
        }

        model.status = "Thành công";

        if (printShip && model.createdOrder?.trackingRef != null) {
          // Đang in phiếu ship
          setBusy(true, message: "${S.current.printing}...");
          await _print
              .printShip(fastSaleOrderId: dataModel.id)
              .catchError((e, s) {
            logger.error("", e, s);
            _newDialog.showToast(
                type: AlertDialogType.error, message: e.toString());
          });
        }

        if (printOrder) {
          //Đang in hóa đơn
          setBusy(true, message: "${S.current.printing}...");
          await _print
              .printOrder(fastSaleOrder: model.createdOrder)
              .catchError((e, s) {
            logger.error("", e, s);
            _newDialog.showToast(
                type: AlertDialogType.error, message: e.toString());
          });
        }

        if (saveResults.error != null) {
          _newDialog.showToast(
              type: AlertDialogType.error,
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
      _newDialog.showError(content: e.toString());
    } finally {
      model.setState(false);
      setBusy(false);
      notifyListeners();
    }
  }

  Future<void> printShip(ResultLineModel model) async {
    setBusy(true, message: "${S.current.printing}...");
    try {
      await _print.printShip(fastSaleOrder: model.createdOrder);
    } catch (e, s) {
      logger.error("", e, s);
      _newDialog.showToast(type: AlertDialogType.error, message: e.toString());
    } finally {
      setBusy(false);
    }
  }

  Future<void> printOrder(ResultLineModel model) async {
    setBusy(true, message: "${S.current.printing}...");
    try {
      await _print.printOrder(
        fastSaleOrderId: model.createdOrderId,
        fastSaleOrder: model.createdOrder,
      );
    } catch (e, s) {
      logger.error("", e, s);
      _newDialog.showToast(type: AlertDialogType.error, message: e.toString());
    } finally {
      setBusy(false);
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
          _newDialog.showToast(
              type: AlertDialogType.error, message: e.toString());
        });
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  Future<void> printShips(List<ResultLineModel> models) async {
    setBusy(true, message: S.current.printing);
    try {
      for (final itm in models) {
        await _print.printShip(fastSaleOrderId: itm.createdOrderId);
        await Future.delayed(const Duration(seconds: 2));
      }
    } catch (e, s) {
      logger.error("", e, s);
      _newDialog.showToast(type: AlertDialogType.error, message: e.toString());
    }

    setBusy(false, message: S.current.printing);
  }

  /// Action Đồng ý tạo hóa đơn
  Future<bool> save({bool printOrder = false, bool printShip = false}) async {
    // validate

    if (_quickModel.carrier == null) {
      _newDialog.showToast(
        message: 'Vui lòng chọn một đối tác giao hàng',
        type: AlertDialogType.warning,
        marginBottom: 70,
      );
      return false;
    }

    // Cập nhật lại quickModelLine
    _quickModel.lines = _resultLineModel
        ?.where((f) => f.status == "Chỉnh sửa" || f.status == "Lỗi")
        ?.map((g) => g.line)
        ?.toList();
    if (carrier != null) {
      if (lines
          .any((f) => f.partner?.phone == null || f.partner?.phone == "")) {
        _newDialog.showToast(
          message: S.current.saleOrderQuickCreate_PleaseUpdatePhoneNumber,
          type: AlertDialogType.warning,
        );
        return false;
      }
      if (lines.any((f) =>
          f.partner?.addressFull == null || f.partner?.addressFull == "")) {
        // Vui lòng cập nhật địa chỉ cho khách hàng
        _newDialog.showToast(
          message: S.current.saleOrderQuickCreate_PleaseUpdateAddress,
          type: AlertDialogType.warning,
        );
        return false;
      }
    }
    bool isSuccess = false;

    setBusy(true, message: "${S.current.saving}...");

    try {
      // Bỏ COD tránh lỗi
      for (final itm in _quickModel.lines) {
        itm.cOD = null;
        itm.id = null;
      }
      _quickModel.id = null;

      final result =
          await _fastSaleOrderApi.createQuickFastSaleOrder(_quickModel);

      final availableModel = _resultLineModel
          .where((f) => f.status == "Chỉnh sửa" || f.status == "Lỗi")
          .toList();
      if (!result.success) {
        _newDialog.showError(content: result.error);
      } else {
        //Đã tạo hóa đơn
        _newDialog.showToast(
            message: "${S.current.saleOrderQuickCreate_InvoiceCreated}.");
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
      _newDialog.showError(content: e.toString());
      isSuccess = false;
    }
    setBusy(false, message: "false lưu...");
    notifyListeners();
    return isSuccess;
  }

  /// Lấy thông tin hóa đơn đã tạo toàn bộ đơn hàng
  Future<void> _fetchAllOrderInfo() async {
    for (final itm in _resultLineModel) {
      if (itm.createdOrderId != null) {
        await _fetchOrderInfo(itm).catchError((e, s) {
          logger.error("", e, s);
          _newDialog.showToast(
            message: e.toString(),
            type: AlertDialogType.error,
          );
        });
      }
    }
  }

  /// Lấy thông tin hóa đơn một đơn hàng
  Future<void> _fetchOrderInfo(ResultLineModel model) async {
    assert(model.createdOrderId != null);
    model.createdOrder = await _fastSaleOrderApi.getById(
      model.createdOrderId,
      query: GetFastSaleOrderByIdQuery.allInfo(),
    );
  }

  /// Lấy thông tin hóa đơn 1 đơn hàng
  Future<void> fetchOrderInfo(ResultLineModel model) async {
    try {
      await _fetchOrderInfo(model);
    } catch (e, s) {
      logger.error("", e, s);
      _newDialog.showError(
        content: e.toString(),
      );
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
