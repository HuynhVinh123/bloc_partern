import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/payment.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/point_sale.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/point_sale_db.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_order.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/feature_group/pos_order/sqlite_database/database_function.dart';
import 'package:tpos_mobile/feature_group/pos_order/sqlite_database/database_helper.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/dialog_update_info_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_cart_page.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/dialog_update_info_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:path/path.dart';

import 'package:tpos_mobile/src/tpos_apis/models/tpos_user.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PosPointSaleListViewModel extends ViewModelBase {
  PosPointSaleListViewModel(
      {IPosTposApi tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<IPosTposApi>();
    _dialog = dialogService ?? locator<DialogService>();
    _dbFunction = locator<IDatabaseFunction>();
    _apiUser = locator<ITposApiService>();
  }

  DialogService _dialog;
  IPosTposApi _tposApi;
  IDatabaseFunction _dbFunction;
  ITposApiService _apiUser;

  var numberSession = "0";
  List<Session> sessions = [];
  List<PointSale> _pointSales = [];
  TposUser _tposUser = TposUser();

  TposUser get tposUser => _tposUser;
  set tposUser(TposUser value) {
    _tposUser = value;
    notifyListeners();
  }

  List<PointSale> get pointSales => _pointSales;
  set pointSales(List<PointSale> value) {
    _pointSales = value;
    notifyListeners();
  }

  Future<void> getUser() async {
    setState(true);
    try {
      final result = await _apiUser.getLoginedUserInfo();
      if (result != null) {
        tposUser = result;
      }
      setState(false);
    } catch (e) {
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> loadPointSales() async {
    setState(true);
    try {
      final result = await _tposApi.getPointSales();
      if (result != null) {
        pointSales = result;
        final List<PointSaleDB> _pointSaleDB =
            await _dbFunction.queryGetPointSale();
        // kiểm tra và lưu điểm bán hàng đang mở lên database
        for (var i = 0; i < pointSales.length; i++) {
          if (pointSales[i].currentSessionState != null &&
              pointSales[i].currentSessionState == "opened") {
            if (_pointSaleDB.isNotEmpty) {
              await _dbFunction.deletePointSale();
            }
            // Cập nhật thông tin cho pointsale database
            final PointSaleDB pointSaleDB = PointSaleDB();
            pointSaleDB.id = pointSales[i].id;
            pointSaleDB.name = pointSales[i].name;
            pointSaleDB.nameGet = pointSales[i].nameGet;
            pointSaleDB.pOSSessionUserName = pointSales[i].pOSSessionUserName;
            pointSaleDB.companyId = pointSales[i].companyId;
            pointSaleDB.vatPc = pointSales[i].vatPc;
            pointSaleDB.lastSessionClosingDate =
                pointSales[i].lastSessionClosingDate;
            await _dbFunction.insertPointSale(pointSaleDB);
          }
        }
      }
      setState(false);
    } on SocketException catch (e, s) {
      logger.error("SocketException", e, s);
      final List<PointSaleDB> _pointSaleDBs =
          await _dbFunction.queryGetPointSale();
      if (_pointSaleDBs.isNotEmpty) {
        final PointSale _pointSaleOffline = PointSale();
        _pointSaleOffline.id = _pointSaleDBs[0].id;
        _pointSaleOffline.name = _pointSaleDBs[0].name;
        _pointSaleOffline.nameGet = _pointSaleDBs[0].nameGet;
        _pointSaleOffline.pOSSessionUserName =
            _pointSaleDBs[0].pOSSessionUserName;
        _pointSaleOffline.companyId = _pointSaleDBs[0].companyId;
        _pointSaleOffline.vatPc = _pointSaleDBs[0].vatPc;
        _pointSaleOffline.lastSessionClosingDate =
            _pointSaleDBs[0].lastSessionClosingDate;
        _pointSaleOffline.currentSessionState = "opened";
        final List<PointSale> _pointSales = [];
        _pointSales.add(_pointSaleOffline);
        pointSales = _pointSales;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadPosOrders", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
    setState(false);
  }

  Future<bool> handleCreatePointSale(
      String name, int configId, int index, BuildContext context) async {
    var result = false;
    try {
      if (name == null) {
        if (_pointSales[index].lastSessionClosingCash != null) {
          final data = await _tposApi.checkCreateSessionSale(configId);

          if (data != null) {
            result = true;
          } else {
            showNotifyCannotOpenSession();
          }
        } else {
          final results = await _tposApi.checkCreateSessionSale(configId);
          if (results != null) {
            final data = await _tposApi.checkCreateSessionSale(configId);
            final numberSession = data.substring(26, data.length);

            result = await _tposApi.handleActionPosOpen(numberSession);
            if (!result) {
              showNotifyCannotOpenSession();
            }
          } else {
            showNotifyCannotOpenSession();
          }
        }
      } else {
        result = false;
        final data = await _tposApi.getPosconfigCbClose(configId);
        numberSession = data.substring(26, data.length);
      }
    } catch (e, s) {
//      _dialog.showError(error: e);
      logger.error("loadPosOrders", e, s);
      showNotifyCannotOpenSession();
    }

    return result;
  }

  Future<void> handleClosePosSession(int index) async {
    await closePosSession(index);
    await clearMemory();
  }

  Future<void> closePosSession(int index) async {
    setState(true);
    try {
      final result =
          await _tposApi.closeSession(pointSales[index].currentSessionId);
      if (result) {
        _dialog.showNotify(
            title: S.current.notification,
            message: S.current.posSession_sessionWasClosed);
        loadPointSales();
      } else {
        _dialog.showNotify(
            title: S.current.notification,
            message: S.current.posSession_sessionWasClosedFail);
      }
    } catch (e) {
      _dialog.showError(error: e);
    }
    setState(false);
  }

  Future<void> clearMemory() async {
    await _dbFunction.deletePayments();
    await _dbFunction.deletePointSaleTaxs();
    await _dbFunction.deletePosconfig();
    await _dbFunction.deleteCart();
    await _dbFunction.deleteSession();
    await _dbFunction.deleteProduct();
    await _dbFunction.deletePaymentLines();
    await _dbFunction.deletePartners();
    await _dbFunction.deletePriceList();
    await _dbFunction.deleteAccountJournal();
    await _dbFunction.deleteCompany();
    await _dbFunction.deleteStatementIds();
    await _dbFunction.deleteApplicationUser();
    await _dbFunction.deleteProductPriceList();
    await _dbFunction.deleteMoneyCart();
  }

  Future<void> checkVersion(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int oldVersion = prefs.getInt('version');
    if (oldVersion != null) {
      if (oldVersion != DatabaseHelper.databaseVersion) {
        final List<Payment> lstPayment = await _dbFunction.queryPayments();
        final int countPayment = lstPayment.length;
        if (countPayment > 0) {
          final dialogResult = await showQuestion(
              context: context,
              title: S.current.save,
              message: S.current.posOfSale_notifySaveOrder);
          if (dialogResult == DialogResultType.YES) {
            for (var i = 0; i < lstPayment.length; i++) {
              final List<Lines> _lines =
                  await _dbFunction.queryGetProductsForCart(
                      lstPayment[i].sequenceNumber.toString());
              // cập nhật và add số sản phẩm cho giỏ hàng
              for (var i = 0; i < _lines.length; i++) {
                _lines[i].productName = null;
                _lines[i].tb_cart_position = null;
                _lines[i].isPromotion = null;
                _lines[i].image = null;
                _lines[i].uomName = null;
              }
              lstPayment[i].lines = _lines;

              // update StatementIds

              final List<StatementIds> statementIds = await _dbFunction
                  .queryStatementIds(lstPayment[i].sequenceNumber.toString());
              for (var i = 0; i < statementIds.length; i++) {
                statementIds[i].position = null;
              }
              lstPayment[i].statementIds = statementIds;
            }

            await handlePayment(lstPayment);
          } else {
            await deleteDBSqLite();
          }
        } else {
          await deleteDBSqLite();
        }
      }
    }
  }

  Future<void> handlePayment(List<Payment> lstPayment) async {
    setState(true);
    try {
      if (lstPayment.isNotEmpty) {
        final result = await _tposApi.exePayment(lstPayment, false);
        if (result) {
          showNotifyPayment(S.current.posOfSale_paymentSuccessful);
          await _dbFunction.deletePayments();
          await deleteDBSqLite();
        } else {
          showNotifyPayment(S.current.posOfSale_paymentFailed);
        }
      } else {
        await deleteDBSqLite();
      }

      setState(false);
    } on SocketException catch (e, s) {
      logger.error("SocketException", e, s);
      setState(false);
    } catch (e, s) {
      logger.error("handlePaymentFail", e, s);
      _dialog.showError(error: e);
    }
  }

  Future<void> deleteDBSqLite() async {
    try {
      final Directory documentsDirectory =
          await getApplicationDocumentsDirectory();
      final String path =
          join(documentsDirectory.path, DatabaseHelper.databaseName);
      await deleteDatabase(path);
      DatabaseHelper.databaseInstance = null;
      await DatabaseHelper.instance.database;
    } catch (e, s) {
      logger.error("deleteDBSqLite", e, s);
    }
  }

  void showNotifyPayment(String message) {
    _dialog.showNotify(title: S.current.notification, message: message);
  }

  void showNotifyCannotOpenSession() {
    _dialog.showError(
        title: S.current.error, content: S.current.posOfSale_errCreateSession);
  }

  void showNotifyUpdateData(
      BuildContext contextRoute, DialogUpdateInfoViewModel _vmDialog,
      {int id, int companyId}) {
    showDialog(
      context: contextRoute,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0),
          title: Text(S.current.notification),
          content: DialogUpdateInfoPage(),
          actions: <Widget>[
            FlatButton(
              child: Text(S.current.no),
              onPressed: () {
                _vmDialog.isLoadingData = false;
                Navigator.pop(context);
                Navigator.push(
                  contextRoute,
                  MaterialPageRoute(
                      builder: (contextRoute) => PosCartPage(
                          id, companyId, tposUser.id, _vmDialog.isLoadingData)),
                ).then((value) {
                  if (value != null) {
                    loadPointSales();
                  }
                });
              },
            ),
            FlatButton(
              child: Text(S.current.confirm),
              onPressed: () {
                Navigator.pop(context);
                _vmDialog.isLoadingData = true;
                Navigator.push(
                  contextRoute,
                  MaterialPageRoute(
                      builder: (contextRoute) => PosCartPage(
                          id, companyId, tposUser.id, _vmDialog.isLoadingData)),
                ).then((value) {
                  if (value != null) {
                    loadPointSales();
                  }
                });
              },
            )
          ],
        );
      },
    );
  }
}
