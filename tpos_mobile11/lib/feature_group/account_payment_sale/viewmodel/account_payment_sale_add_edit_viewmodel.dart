import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

import 'package:tpos_mobile/src/tpos_apis/models/account_payment.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class AccountPaymentSaleAddEditViewModel extends ViewModelBase {
  AccountPaymentSaleAddEditViewModel(
      {IPosTposApi tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<IPosTposApi>();
    _dialog = dialogService ?? locator<DialogService>();
  }

  DialogService _dialog;
  IPosTposApi _tposApi;

  int _selectTypePayment = -1;
  DateTime _selectTime = DateTime.now();
  AccountPayment accountPayment = AccountPayment();
  AccountJournal accountJournal = AccountJournal();
  bool isShowReceiver = true;

  Partner _partner;

  Partner get partner => _partner;

  set partner(Partner value) {
    _partner = value;
    notifyListeners();
  }

  Partner _partnerContact;

  Partner get partnerContact => _partnerContact;

  set partnerContact(Partner value) {
    _partnerContact = value;
    notifyListeners();
  }

  Account _account;

  Account get account => _account;

  set account(Account value) {
    _account = value;
    notifyListeners();
  }

  List<AccountJournal> _accountJournals = [];

  List<AccountJournal> get accountJournals => _accountJournals;

  set accountJournals(List<AccountJournal> value) {
    _accountJournals = value;
    notifyListeners();
  }

  int get selectTypePayment => _selectTypePayment;

  set selectTypePayment(int value) {
    _selectTypePayment = value;
    notifyListeners();
  }

  DateTime get selectTime => _selectTime;

  set selectTime(DateTime value) {
    _selectTime = value;
    notifyListeners();
  }

  Future<void> getAccountJournals() async {
    try {
      setState(true);
      final result = await _tposApi.getAccountJournalWithAccountPayments();
      if (result != null) {
        accountJournals = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadAccountJournalsFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getDefaultAccountPaymentSale() async {
    try {
      setState(true);
      final result = await _tposApi.getDefaultAccountPaymentSale();
      if (result != null) {
        accountPayment = result;
        selectTypePayment = accountPayment.journal?.id;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadDefaultAccountPaymentSaleFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> updateAccountPayment(BuildContext context) async {
    try {
      setState(true);
      await _tposApi.updateAccountPayment(accountPayment);
//      await confirmAccountPayment();
      showNotify(S.current.updateSuccessful);
      setState(false);
    } catch (e, s) {
      logger.error("updateAccountPaymentFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> addAccountPayment(bool isConfirm) async {
    try {
      setState(true);
      final result = await _tposApi.addAccountPayment(accountPayment);
      if (result != null) {
        accountPayment = result;
        if (!isConfirm) {
          showNotify(S.current.addSuccessful);
        }
      }
      setState(false);
    } catch (e, s) {
      logger.error("addAccountPaymentFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> updateInfoAccountPayment(
      AccountPayment accountPayment, BuildContext context,
      {bool isConfirm}) async {
    this.accountPayment.account = account;
    this.accountPayment.accountId = account.id;
    this.accountPayment.accountName = account.name;

    this.accountPayment.paymentDate = _selectTime;
//    this.accountPayment.partner = _partner;
    this.accountPayment.partner?.partnerCategories = [];
    this.accountPayment.partnerId = _partner?.id;
//    this.accountPayment.partnerDisplayName = _partner?.displayName;
    if (!isShowReceiver) {
      this.accountPayment.senderReceiver = _partner?.name;
      this.accountPayment.phone = _partner?.phone;
      this.accountPayment.address = _partner?.street;
    }
    this.accountPayment.contact = partnerContact;
    this.accountPayment.contactId = partnerContact?.id;

    // ignore: avoid_function_literals_in_foreach_calls
    accountJournals.forEach((value) {
      if (value.id == selectTypePayment) {
        this.accountPayment.journal = value;
        this.accountPayment.journalName = value.name;
        this.accountPayment.journalId = value.id;
      }
    });
    if (accountPayment != null) {
      await updateAccountPayment(context);
      if (isConfirm) {
        await confirmAccountPayment();
      }
    } else {
      await addAccountPayment(isConfirm);
      if (isConfirm) {
        await confirmAccountPayment();
      }
    }
    Navigator.pop(context, true);
  }

  void setInfoAccountPayment(AccountPayment accountPayment) {
    account = accountPayment.account;
    selectTypePayment = accountPayment.journal.id;
    selectTime = accountPayment.paymentDate;
    partner = accountPayment.partner;
    partnerContact = accountPayment.contact;
    accountJournal = accountPayment.journal;
  }

  void showNotify(String message) {
    _dialog.showNotify(title: S.current.notification, message: message ?? "");
  }

  Future<void> cancelAccountPayment(BuildContext context) async {
    try {
      setState(true);
      await _tposApi.cancelAccountPayment(accountPayment.id);
      await getAccountPayment();
      Navigator.pop(context, true);
      setState(false);
    } catch (e, s) {
      logger.error("cancelAccountPaymentFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> confirmAccountPayment() async {
    try {
      setState(true);
      await _tposApi.confirmAccountPayment(accountPayment.id);
      await getAccountPayment();
      setState(false);
    } catch (e, s) {
      logger.error("confirmAccountPaymentFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getAccountPayment() async {
    setState(true);
    try {
      final result = await _tposApi.getInfoAccountPayment(accountPayment.id);
      if (result != null) {
        accountPayment = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadAccountPaymentsFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  /// Thay đổi phương thức chọn tiền nếu trùng tên khác id
  Future<void> changeAccountJournal() {
    bool isExist = true;
    bool isInsert = true;
    // ignore: avoid_function_literals_in_foreach_calls
    _accountJournals.forEach((element) {
      if (element.id != accountJournal.id &&
          element.name == accountJournal.name) {
        selectTypePayment = element.id;
        isInsert = false;
      }

      if (element.id == accountJournal.id &&
          element.name == accountJournal.name) {
        isExist = false;
      }
    });

    if (isExist && isInsert) {
      _accountJournals.add(accountJournal);
      selectTypePayment = accountJournal.id;
    }

    notifyListeners();
  }

  void removeAccountJournal() {
    _accountJournals.remove(accountJournal);
  }
}
