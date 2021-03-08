import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/services/dialog_service/new_dialog_service.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class TypeAccountAddEditViewModel extends ViewModelBase {
  TypeAccountAddEditViewModel(
      {AccountPaymentTypeApi accountPaymentTypeApi,
      NewDialogService newDialog}) {
    _apiClient =
        accountPaymentTypeApi ?? GetIt.instance<AccountPaymentTypeApi>();
    _newDialog = newDialog ?? GetIt.I<NewDialogService>();
  }

  NewDialogService _newDialog;
  AccountPaymentTypeApi _apiClient;

  Account _account = Account();
  Company _company;

  Company get company => _company;
  set company(Company value) {
    _company = value;
    notifyListeners();
  }

  Account get account => _account;
  set account(Account value) {
    _account = value;
    notifyListeners();
  }

  Future<void> getDetailAccount(int id) async {
    setState(true);
    try {
      final result = await _apiClient.getDetailAccountSale(id);
      if (result != null) {
        account = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("getDetailAccountFail", e, s);
      // _dialog.showError(error: e);
      _newDialog.showError(content: e.toString());
      setState(false);
    }
  }

  Future<void> getDefaultAccount() async {
    setState(true);
    try {
      final result = await _apiClient.getDefaultAccount();
      if (result != null) {
        account = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("getDefaultAccountFail", e, s);
      // _dialog.showError(error: e);
      _newDialog.showError(content: e.toString());
      setState(false);
    }
  }

  Future<void> updateAccountSale(
      BuildContext context, final Function callback) async {
    setState(true);
    try {
      final result = await _apiClient.updateInfoTypeAccountSale(account);
      if (result) {
        await getDetailAccount(account.id);
        callback(account);
        Navigator.pop(context);
        showNotify(S.current.receiptType_receiptTypeWasUpdatedSuccessful);
      }
      setState(false);
    } catch (e, s) {
      logger.error("updateAccountFail", e, s);
      // _dialog.showError(error: e);
      _newDialog.showError(content: e.toString());
      setState(false);
      setState(false);
    }
  }

  Future<void> addAccountSale(BuildContext context) async {
    setState(true);
    try {
      final Account result = await _apiClient.addInfoTypeAccountSale(account);
      if (result != null) {
        Navigator.pop(context, result);
        showNotify(S.current.receiptType_receiptTypeWasAddedSuccessful);
      }
      setState(false);
    } catch (e, s) {
      logger.error("addAccountFail", e, s);
      // _dialog.showError(error: e);
      _newDialog.showError(content: e.toString());
      setState(false);
      setState(false);
    }
  }

  Future<void> updateInfoAccount(
      BuildContext context, int id, final Function callback) async {
    account.companyName = company.name;
    account.companyId = company.id;
    if (company != null) {
      account.company = company;
    }

    if (id != null) {
      await updateAccountSale(context, callback);
    } else {
      await addAccountSale(context);
    }
  }

  void showNotify(String message) {
    // _dialog.showNotify(title: S.current.notification, message: message ?? "");
    _newDialog.showToast(message: message ?? "");
  }
}
