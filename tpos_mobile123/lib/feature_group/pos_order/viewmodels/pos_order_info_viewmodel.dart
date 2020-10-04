import 'package:rxdart/rxdart.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_make_payment.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_order.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class PosOrderInfoViewModel extends ViewModelBase {
  PosOrderInfoViewModel(
      {ITposApiService tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<ITposApiService>();
    _dialog = dialogService ?? locator<DialogService>();
  }

  ITposApiService _tposApi;
  DialogService _dialog;

  PosOrder posOrder;

  List<PosOrderLine> _posOrderLines;

  List<PosOrderLine> get posOrderLines => _posOrderLines;

  set posOrderLines(List<PosOrderLine> value) {
    _posOrderLines = value;
    notifyListeners();
  }

  List<PosAccountBankStatement> _posAccount;

  List<PosAccountBankStatement> get posAccount => _posAccount;

  set posAccount(List<PosAccountBankStatement> value) {
    _posAccount = value;
    notifyListeners();
  }

  Future<void> loadPosOrderInfo(int id) async {
    setState(true, message: "Đang tải..");
    try {
      final result = await _tposApi.getPosOrderInfo(id);
      if (result != null) {
        posOrder = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
    }
    setState(false);
  }

  Future<void> loadPosOrderLine(int id) async {
    setState(true, message: "Đang tải..");
    try {
      final result = await _tposApi.getPosOrderLines(id);
      if (result != null) {
        posOrderLines = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
    }
    setState(false);
  }

  Future<void> loadPosAccountBankStatement(int id) async {
    setState(true, message: "Đang tải..");
    try {
      final result = await _tposApi.getPosAccountBankStatement(id);
      if (result != null) {
        _posAccount = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
    }
  }

  int newPosOrderId;
  Future<String> refundPosOrder(int id) async {
    try {
      final result = await _tposApi.refundPosOrder(id);
      if (!result.error) {
        _dialog.showNotify(message: "Đã trả hàng", title: "Thông báo");
      } else {
        _dialog.showError(
          title: "Lỗi",
          content: result.message,
        );
      }
      return result.result;
    } catch (e) {
      _dialog.showError(title: "Lỗi", content: "$e");
    }
    return ''; //TODO(namnv) Chỗ này lỗi thì return cái gì để catch ở ui
  }

  PosMakePayment posMakePayment;

  final BehaviorSubject<PosMakePayment> _posMakePaymentController =
      BehaviorSubject();
  Stream<PosMakePayment> get posMakePaymenStream =>
      _posMakePaymentController.stream;

  Future<void> loadPosMakePayment(int id) async {
    setState(true);
    try {
      final result = await _tposApi.getPosMakePayment(id);
      if (result != null) {
        posMakePayment = result.result;
      }
      _selectedJournal = posMakePayment.journal;
      _posMakePaymentController.add(posMakePayment);
      setState(false);
    } catch (e, s) {
      logger.error("loadPosMakePayment", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> posPayment(int id) async {
    setState(true, message: "Đang thanh toán");
    posMakePayment.journalId = 1;
    try {
      final result = await _tposApi.posMakePayment(posMakePayment, id);
      if (result.result) {
        _dialog.showNotify(message: "Đã thanh toán", title: "Thông báo");
      } else {
        _dialog.showError(
          title: "Lỗi",
          content: result.message,
        );
      }
      setState(false);
    } catch (e) {
      setState(false);
      _dialog.showError(title: "Lỗi", content: "$e");
    }
  }

  /// Phương thức thanh toán
  Journal _selectedJournal;
  Journal get selectedJournal => _selectedJournal;

  Future<void> selectJournalCommand(Journal item) async {
    _selectedJournal = item;
    notifyListeners();
  }

  Future<void> initCommand(int id) async {
    await loadPosOrderInfo(id);
    await loadPosOrderLine(id);
    await loadPosAccountBankStatement(id);
  }
}
