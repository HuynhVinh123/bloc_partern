import 'dart:async';

import 'package:logging/logging.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';

import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';

import 'fast_sale_order_add_edit_full_viewmodel.dart';

class FastSaleOrderAddEditFullPaymentInfoViewModel extends ViewModel {
  FastSaleOrderAddEditFullPaymentInfoViewModel({this.editVm});
  ITposApiService _tposApi;
  final Logger _log = Logger("FastSaleOrderAddEditFullPaymentInfoViewModel");

  void init(FastSaleOrderAddEditFullViewModel editVm) {
    this.editVm = editVm;
    _tposApi = _tposApi ?? locator<ITposApiService>();
    _calTotal();
    initCommand();
  }

  List<AccountJournal> _accountJournals;
  AccountJournal _selectedAccountJournal;
  double _rechargeAmount = 0;

  FastSaleOrderAddEditFullViewModel editVm;
  bool get isPercent => editVm.isDiscountPercent;

  /// Giảm giá %
  double get discount => editVm.order.discount ?? 0;

  /// số tiền giảm giá (%)
  double get discountAmount => editVm.order.discountAmount ?? 0;

  /// Tiền giảm
  double get decreaseAmount => editVm.order.decreaseAmount ?? 0;

  /// Tiền  thanh toán
  double get paymentAmount => editVm.order.paymentAmount ?? 0;

  /// Tổng tiền hàng hóa
  double get subTotal => editVm.subTotal ?? 0;

  /// Tổng tiền hóa đơn
  double get totalAmount => editVm.total ?? 0;

  ///  Tiền thối lại
  double get rechargeAmount => _rechargeAmount;

  List<AccountJournal> get accountJournals => _accountJournals;

  /// Phương thức thanh toán
  AccountJournal get selectedAccountJournal => _selectedAccountJournal;

  set discount(double value) {
    editVm.order.discount = value;
    editVm.calculatePaymentAmount();
    _calTotal();

    notifyListeners();
  }

  set discountAmount(double value) {
    editVm.order.discountAmount = value;
    _calTotal();
    notifyListeners();
  }

  set paymentAmount(double value) {
    editVm?.order?.paymentAmount = value;
    _calTotal();
    notifyListeners();
  }

  set decreaseAmount(double value) {
    editVm?.order?.decreaseAmount = value;
    _calTotal();
    editVm.calculateCashOnDelivery();
    editVm.calculatePaymentAmount();
    notifyListeners();
  }

  void _calTotal() {
    editVm.order.discountAmount = subTotal * (discount / 100);
    _rechargeAmount = totalAmount - paymentAmount;
    notifyListeners();
  }

  Future<void> initCommand() async {
    onStateAdd(true);
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
    onStateAdd(false);
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
