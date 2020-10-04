import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/account_bank.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_order.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/feature_group/pos_order/sqlite_database/database_function.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/dialog_update_info_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_cart_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/dialog_update_info_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/services/dialog_service.dart';

class PosClosePointSaleViewModel extends ViewModelBase {
  PosClosePointSaleViewModel(
      {IPosTposApi tposApiService, DialogService dialogService}) {
    _dialog = dialogService ?? locator<DialogService>();
    _dbFuction = locator<IDatabaseFunction>();
    _tposApi = tposApiService ?? locator<IPosTposApi>();
  }

  DialogService _dialog;
  IDatabaseFunction _dbFuction;
  IPosTposApi _tposApi;

  Session _session = Session();
  Session get session => _session;
  set session(Session value) {
    _session = value;
    notifyListeners();
  }

  List<AccountBank> _accountBanks = [];
  List<AccountBank> get accountBanks => _accountBanks;
  set accountBanks(List<AccountBank> value) {
    _accountBanks = value;
    notifyListeners();
  }

  Future<void> getPosSessionById(int id) async {
    setState(true);
    try {
      final result = await _tposApi.getSessionById(id);
      if (result != null) {
        session = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadPosSessionFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getAccountBank(int id) async {
    setState(true);
    try {
      final result = await _tposApi.getAccountBank(id);
      if (result != null) {
        accountBanks = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadAccountBankFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> closePosSession(BuildContext context, int id) async {
    setState(true);
    try {
      final result = await _tposApi.closeSession(id);
      if (result) {
        _dialog.showNotify(
            title: "Thông báo", message: "Đóng phiên thành công");
      } else {
        _dialog.showNotify(title: "Thông báo", message: "Đóng phiên thất bại");
      }
    } catch (e) {
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> clearMemory() async {
    await _dbFuction.deletePayments();
    await _dbFuction.deletePointSaleTaxs();
    await _dbFuction.deletePosconfig();
    await _dbFuction.deleteCart();
    await _dbFuction.deleteSession();
    await _dbFuction.deleteProduct();
    await _dbFuction.deletePaymentLines();
    await _dbFuction.deletePartners();
    await _dbFuction.deletePriceList();
    await _dbFuction.deleteAccountJournal();
    await _dbFuction.deleteCompany();
    await _dbFuction.deleteStatementIds();
    await _dbFuction.deleteApplicationUser();
    await _dbFuction.deleteProductPriceList();
    await _dbFuction.deleteMoneyCart();
  }

  Future<void> handleClosePosSession(BuildContext context, int id) async {
    await closePosSession(context, id);
    await clearMemory();
    Navigator.pop(context, true);
  }

  void showNotifyUpdateData(
      BuildContext contextRoute, DialogUpdateInfoViewModel _vmDialog,
      {int pointSaleId, int companyId, String userId, int id}) {
    showDialog(
      context: contextRoute,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 0),
          contentPadding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0),
          title: const Text("Thông báo"),
          content: DialogUpdateInfoPage(),
          actions: <Widget>[
            FlatButton(
              child: const Text("Không"),
              onPressed: () {
                _vmDialog.isLoadingData = false;
                Navigator.pop(context);
                Navigator.push(
                  contextRoute,
                  MaterialPageRoute(
                      builder: (contextRoute) => PosCartPage(pointSaleId,
                          companyId, userId, _vmDialog.isLoadingData)),
                ).then((value) async {
                  await getAccountBank(id);
                  await getPosSessionById(id);
                });
              },
            ),
            FlatButton(
              child: const Text("Xác nhận"),
              onPressed: () {
                Navigator.pop(context);
                _vmDialog.isLoadingData = true;
                Navigator.push(
                  contextRoute,
                  MaterialPageRoute(
                      builder: (contextRoute) => PosCartPage(pointSaleId,
                          companyId, userId, _vmDialog.isLoadingData)),
                ).then((value) async {
                  await getAccountBank(id);
                  await getPosSessionById(id);
                });
              },
            )
          ],
        );
      },
    );
  }
}
