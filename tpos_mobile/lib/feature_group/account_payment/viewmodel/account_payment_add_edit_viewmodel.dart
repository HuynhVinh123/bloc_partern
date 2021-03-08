import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/services/dialog_service/new_dialog_service.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class AccountPaymentAddEditViewModel extends ViewModelBase {
  AccountPaymentAddEditViewModel(
      {AccountPaymentApi accountPaymentApi, NewDialogService newDialog}) {
    _apiClient = accountPaymentApi ?? GetIt.instance<AccountPaymentApi>();
    _newDialog = newDialog ?? GetIt.I<NewDialogService>();
  }

  // DialogService _dialog;

  AccountPaymentApi _apiClient;
  NewDialogService _newDialog;

  /// Dùng để kiểm tra nếu có sửa đổi thông tin thì khi back về sẽ xác nhận thoát
  bool isEdit = false;
  bool isConfirmFailed = false;

  int _selectTypePayment = -1;
  DateTime _selectTime = DateTime.now();
  AccountPayment accountPayment = AccountPayment();
  AccountJournal accountJournal = AccountJournal();
  bool isShowReceiver = true;
  bool isUpdate = false;

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
      final result = await _apiClient.getAccountJournalWithAccountPayments();
      if (result != null) {
        accountJournals = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadAccountJournalsFail", e, s);
      _newDialog.showError(content: e.toString());
      setState(false);
    }
  }

  Future<void> getDefaultAccountPayment() async {
    try {
      setState(true);
      final result = await _apiClient.getDefaultAccountPayment();
      if (result != null) {
        accountPayment = result;
        selectTypePayment = accountPayment.journal?.id;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadDefaultAccountPaymentFail", e, s);
      _newDialog.showError(content: e.toString());
      setState(false);
    }
  }

  Future<bool> updateAccountPayment(BuildContext context) async {
    try {
      setState(true);
      await _apiClient.updateAccountPayment(accountPayment);
//      await confirmAccountPayment();

      setState(false);
      return true;
    } catch (e, s) {
      logger.error("updateAccountPaymentFail", e, s);
      _newDialog.showError(content: e.toString());
      setState(false);
    }
    return false;
  }

  Future<bool> addAccountPayment(bool isConfirm) async {
    try {
      setState(true);
      final result = await _apiClient.addAccountPayment(accountPayment);
      if (result != null) {
        accountPayment = result;
      }
      setState(false);
      return true;
    } catch (e, s) {
      logger.error("addAccountPaymentFail", e, s);
      _newDialog.showError(content: e.toString());
      setState(false);
    }
    return false;
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
//    this.accountPayment.partnerId = _partner?.id;
//    this.accountPayment.partnerDisplayName = _partner?.displayName;
    if (!isShowReceiver) {
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
      final bool result = await updateAccountPayment(context);
      if (isConfirm) {
        // showNotify("Cập nhật thành công!");
        showNotify(S.current.receiptType_receiptTypeWasSaved);
        final bool resultConfirm = await confirmAccountPayment();
        if (resultConfirm) {
          _popPage(context, accountPayment, handle: 'confirm');
        }
      } else {
        if (result) {
          _popPage(context, accountPayment);
        }
      }
    } else {
      final bool result = await addAccountPayment(isConfirm);
      if (isConfirm) {
        showNotify(S.current.receiptType_receiptTypeWasSaved);
        // showNotify(S.current.paymentReceipt_paymentReceiptWasSaved);
        final bool resultConfirm = await confirmAccountPayment();
        if (resultConfirm) {
          _popPage(context, accountPayment);
        }
      } else {
        if (result) {
          _popPage(context, accountPayment);
        }
      }
    }
  }

  void _popPage(BuildContext context, AccountPayment accountPayment,
      {String handle = ""}) {
    Navigator.pop(context, handle);
    if (accountPayment != null) {
      showNotify(S.current.updateSuccessful);
    } else {
      showNotify(S.current.addSuccessful);
    }
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
    App.showToast(title: S.current.notification, message: message);
  }

  Future<void> cancelAccountPayment(BuildContext context) async {
    try {
      setState(true);
      await _apiClient.cancelAccountPayment(accountPayment.id);
      await getAccountPayment();
      Navigator.pop(context, true);
      setState(false);
    } catch (e, s) {
      logger.error("cancelAccountPaymentFail", e, s);
      _newDialog.showError(content: e.toString());
      setState(false);
    }
  }

  Future<bool> confirmAccountPayment() async {
    try {
      setState(true);
      await _apiClient.confirmAccountPayment(accountPayment.id);
      await getAccountPayment();
      setState(false);
      return true;
    } catch (e, s) {
      logger.error("confirmAccountPaymentFail", e, s);
      _newDialog.showError(content: e.toString());
      setState(false);
    }
    return false;
  }

  Future<void> getAccountPayment() async {
    setState(true);
    try {
      final result = await _apiClient.getInfoAccountPayment(accountPayment.id);
      if (result != null) {
        accountPayment = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadAccountPaymentsFail", e, s);
      _newDialog.showError(content: e.toString());
      setState(false);
    }
  }

  /// Thay đổi phương thức chọn tiền nếu trùng tên khác id
  Future<void> changeAccountJournal() async {
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
      selectTypePayment = accountJournal?.id;
    }

    notifyListeners();
  }

  void removeAccountJournal() {
    _accountJournals.remove(accountJournal);
  }
}
