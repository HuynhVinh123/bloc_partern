import 'package:flutter/cupertino.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/account.dart';


class TypeAccountSaleAddEditViewModel extends ViewModelBase {
  DialogService _dialog;
  IPosTposApi _tposApi;
  TypeAccountSaleAddEditViewModel(
      {IPosTposApi tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<IPosTposApi>();
    _dialog = dialogService ?? locator<DialogService>();
  }

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
      var result = await _tposApi.getDetailAccountSale(id);
      if (result != null) {
        account = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("getDetailAccountFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getDefaultAccount() async {
    setState(true);
    try {
      var result = await _tposApi.getDefaultAccountSale();
      if (result != null) {
        account = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("getDefaultAccountFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> updateAccountSale(
      BuildContext context, final Function callback) async {
    setState(true);
    try {
      var result = await _tposApi.updateInfoTypeAccountSale(account);
      if (result) {
        await getDetailAccount(account.id);
        callback(account);
        Navigator.pop(context);
        showNotify("Cập nhật thông tin loại phiếu chi thành công");
      }
      setState(false);
    } catch (e, s) {
      logger.error("updateAccountFail", e, s);
      _dialog.showError(error: e);
      setState(false);
      setState(false);
    }
  }

  Future<void> addAccountSale(BuildContext context) async {
    setState(true);
    try {
      var result = await _tposApi.addInfoTypeAccountSale(account);
      if (result != null) {
        Navigator.pop(context, true);
        showNotify("Thêm loại phiếu chi thành công");
      }
      setState(false);
    } catch (e, s) {
      logger.error("addAccountFail", e, s);
      _dialog.showError(error: e);
      setState(false);
      setState(false);
    }
  }

  void updateInfoAccount(
      BuildContext context, int id, final Function callback) async {
    account.companyName = company.name;
    account.companyId = company.id;
    if (id != null) {
      await updateAccountSale(context, callback);
    } else {
      await addAccountSale(context);
    }
  }

  void showNotify(String message) {
    _dialog.showNotify(title: "Thông báo", message: "$message");
  }
}
