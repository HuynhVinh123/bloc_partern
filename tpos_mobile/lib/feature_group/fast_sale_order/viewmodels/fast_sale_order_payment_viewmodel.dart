import 'dart:async';

import 'package:logging/logging.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/helpers/helpers.dart';

import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';

class FastSaleOrderPaymentViewModel extends ViewModel {
  FastSaleOrderPaymentViewModel(
      {ITposApiService tposApi, DialogService dialogService}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _dialog = dialogService ?? locator<DialogService>();
  }

  final Logger _log = Logger("FastSaleOrderPaymentViewModel");
  ITposApiService _tposApi;

  DialogService _dialog;

  AccountPayment _payment;
  AccountPayment get payment => _payment;
  List<AccountJournal> _accountJournals;
  List<AccountJournal> get accountJournals => _accountJournals;
  AccountJournal _selectedAccountJournal;
  AccountJournal get selectedAccountJournal => _selectedAccountJournal;

  double amount;
  DateTime datePayment;
  String description;

  void init({AccountPayment defaultPayment, double amount, String content}) {
    _payment = defaultPayment ?? AccountPayment();
    this.amount = _payment.amount ?? amount ?? 0;
    datePayment = _payment.paymentDate ?? DateTime.now();
    description = _payment.communication ?? content;
  }

  Future initCommand() async {
    onIsBusyAdd(true);
    // Tải phương thức thanh toán
    await _loadPaymentJournals();
    onIsBusyAdd(false);
  }

  ///Command Lụa chọn phương thức thanh toán
  Future selectAccountJournalCommand(AccountJournal value) async {
    _selectedAccountJournal = value;
    // get new data
    onStateAdd(true);
    try {
      final onChangeResult = await _tposApi.accountPaymentOnChangeJournal(
          selectedAccountJournal.id, payment.paymentType);

      if (onChangeResult.error == null) {
        payment.paymentMethodId = onChangeResult.value.paymentMethodId;
      }
    } catch (e, s) {
      _log.severe("selectAccountCommand", e, s);
      onDialogMessageAdd(OldDialogMessage.error("", e.toString()));
    }
    onPropertyChanged("");
    onStateAdd(false);
  }

  // Submit command
  Future<bool> submitPaymentCommand() async {
    onStateAdd(true);
    try {
      payment.paymentDate = datePayment;
      payment.communication = description;
      payment.amount = amount;

      payment.currencyId = 1;
      payment.journalId = selectedAccountJournal.id;
      payment.journal = selectedAccountJournal;

      final submitResult = await _tposApi.accountPaymentCreatePost(payment);
      if (submitResult.error == false) {
        onDialogMessageAdd(
            OldDialogMessage.flashMessage("Lưu hóa đơn thành công"));
        return result(true);
      } else {
        onDialogMessageAdd(
            OldDialogMessage.error("", submitResult.message, title: "Error!"));
        return result(false);
      }
    } catch (e, s) {
      _log.severe("submit payment", e, s);
      _dialog.showError(error: e);
      return result(false);
    }
  }

  Future _loadPaymentJournals() async {
    try {
      final getResult = await _tposApi.accountJournalGetWithCompany();
      if (getResult.error == false) {
        _accountJournals = getResult.result;
        onPropertyChanged("");
      } else {
        onDialogMessageAdd(OldDialogMessage.error("", getResult.message,
            title: "Không tải được!"));
      }
    } catch (e, s) {
      _log.severe("", e, s);
      onDialogMessageAdd(OldDialogMessage.error("", e.toString(),
          title: "Lỗi không xác định!"));
    }
  }

  bool result(bool value) {
    onStateAdd(false);
    return value;
  }
}
