import 'dart:async';

import 'package:logging/logging.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/feature_group/sale_order/viewmodels/sale_order_add_edit_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class SaleOrderAddEditPaymentInfoViewModel extends ScopedViewModel {
  SaleOrderAddEditPaymentInfoViewModel({this.editVm});
  ITposApiService _tposApi;
  final Logger _log = Logger("SaleOrderAddEditPaymentInfoViewModel");

  void init(SaleOrderAddEditViewModel editVm) {
    this.editVm = editVm;
    _tposApi = _tposApi ?? locator<ITposApiService>();
    _calTotal();
    initCommand();
  }

  List<AccountJournal> _accountJournals;
  AccountJournal _selectedAccountJournal;
  double _rechargeAmount = 0;

  SaleOrderAddEditViewModel editVm;
  bool get isPercent => editVm.isDiscountPercent;

  /// Tiền  thanh toán
  double get amountDeposit => editVm.order.amountDeposit ?? 0;

  set amountDeposit(double value) {
    editVm.order.amountDeposit = value;
    _calTotal();
    notifyListeners();
  }

  /// Tổng tiền hàng hóa
  double get subTotal => editVm.subTotal ?? 0;

  /// Tổng tiền hóa đơn
  double get totalAmount => editVm.total ?? 0;

  ///  Tiền thối lại
  double get rechargeAmount => _rechargeAmount;

  /// Phương thức thanh toán
  AccountJournal _paymentJournal;
  List<AccountJournal> get accountJournals => _accountJournals;
  AccountJournal get paymentJournal => _paymentJournal;

  /// Phương thức thanh toán
  AccountJournal get selectedAccountJournal => _selectedAccountJournal;

  void _calTotal() {
    _rechargeAmount = totalAmount - amountDeposit;
  }

  Future<void> initCommand() async {
    setBusy(true);
    try {
      await _loadAccountJournals();
      if (editVm.paymentJournal != null) {
        _selectedAccountJournal = _accountJournals.firstWhere(
            (f) => f.id == editVm.paymentJournal.id,
            orElse: () => null);
      }
    } catch (e, s) {
      _log.severe("initCommand", e, s);
    }
    setBusy(false);
    notifyListeners();
  }

  Future<void> selectAccountJournalCommand(AccountJournal item) async {
    _selectedAccountJournal = item;
    editVm.paymentJournal = item;
    notifyListeners();
  }

  Future<void> _loadAccountJournals() async {
    final getResult = await _tposApi.accountJournalGetWithCompany();
    if (getResult.error == true) {
      throw Exception(getResult.error);
    } else {
      _accountJournals = getResult.result;
    }
  }
}
