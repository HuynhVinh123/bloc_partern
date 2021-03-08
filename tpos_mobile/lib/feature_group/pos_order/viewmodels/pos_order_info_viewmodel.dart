import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_make_payment.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_order.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service/new_dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PosOrderInfoViewModel extends ViewModelBase {
  PosOrderInfoViewModel(
      {ITposApiService tposApiService, NewDialogService newDialog}) {
    _tposApi = tposApiService ?? locator<ITposApiService>();
    _newDialog = newDialog ?? GetIt.I<NewDialogService>();
  }

  ITposApiService _tposApi;
  NewDialogService _newDialog;

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
    final result = await _tposApi.getPosOrderInfo(id);
    if (result != null) {
      posOrder = result;
    }
  }

  Future<void> loadPosOrderLine(int id) async {
    final result = await _tposApi.getPosOrderLines(id);
    if (result != null) {
      posOrderLines = result;
    }
  }

  Future<void> loadPosAccountBankStatement(int id) async {
    final result = await _tposApi.getPosAccountBankStatement(id);
    if (result != null) {
      _posAccount = result;
    }
  }

  int newPosOrderId;
  Future<String> refundPosOrder(int id) async {
    try {
      final result = await _tposApi.refundPosOrder(id);
      if (!result.error) {
        _newDialog.showInfo(
            title: S.current.notification, content: "Đã trả hàng");
      } else {
        _newDialog.showError(
          content: result.message,
        );
      }
      return result.result;
    } catch (e) {
      _newDialog.showError(content: e.toString());
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
      _newDialog.showError(content: e.toString());
      setState(false);
    }
  }

  Future<void> posPayment(int id) async {
    setState(true, message: "Đang thanh toán");
    posMakePayment.journalId = 1;
    try {
      final result = await _tposApi.posMakePayment(posMakePayment, id);
      if (result.result) {
        _newDialog.showInfo(
            title: S.current.notification, content: "Đã thanh toán");
      } else {
        _newDialog.showError(
          content: result.message,
        );
      }
      setState(false);
    } catch (e) {
      setState(false);
      _newDialog.showError(content: e.toString());
    }
  }

  /// Phương thức thanh toán
  PosMakePaymentJournal _selectedJournal;
  PosMakePaymentJournal get selectedJournal => _selectedJournal;

  Future<void> selectJournalCommand(PosMakePaymentJournal item) async {
    _selectedJournal = item;
    notifyListeners();
  }

  Future<void> initCommand(int id) async {
    try {
      setState(true, message: "Đang tải..");
      await loadPosOrderInfo(id);
      await loadPosOrderLine(id);
      await loadPosAccountBankStatement(id);
    } catch (e) {
      setState(false);
      _newDialog.showError(content: e.toString());
    }
    setState(false);
  }
}
