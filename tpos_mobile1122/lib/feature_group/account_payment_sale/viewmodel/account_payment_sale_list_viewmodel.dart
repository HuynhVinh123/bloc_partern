import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/account_payment/account_payment_state.dart';
import 'package:tpos_mobile/feature_group/account_payment_sale/models/base_model.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class AccountPaymentSaleListViewModel extends ViewModelBase {
  AccountPaymentSaleListViewModel(
      {IPosTposApi tposApiService,
      DialogService dialogService,
      AccountPaymentApi accountPaymentApi}) {
    _tposApi = tposApiService ?? locator<IPosTposApi>();
    _dialog = dialogService ?? locator<DialogService>();
    _apiClient = accountPaymentApi ?? GetIt.instance<AccountPaymentApi>();

    filterToDate = _filterDateRange.toDate;
    filterFromDate = _filterDateRange.fromDate;

    // handled search
    _keywordController
        .debounceTime(
      const Duration(milliseconds: 400), //TODO Check debounceTime dispable
    )
        .listen((key) {
      getAccountPaymentSales();
    });
  }

  DialogService _dialog;
  IPosTposApi _tposApi;

  AccountPaymentApi _apiClient;

  List<AccountPayment> _accountPayments = [];
  Account _account = Account();
  bool _isFilterByStatus = false;
  bool _isFilterByTypeAccountPaymentSale = false;
  bool _isSearch = false;
  static const int limit = 100;
  int skip = 0;
  int max = 0;

  bool isLoadMore = false;

  List<AccountPayment> get accountPayments => _accountPayments;

  set accountPayments(List<AccountPayment> value) {
    _accountPayments = value;
    notifyListeners();
  }

  Account get account => _account;

  set account(Account value) {
    _account = value;
    notifyListeners();
  }

  bool get isSearch => _isSearch;

  set isSearch(bool value) {
    _isSearch = value;
    notifyListeners();
  }

  Future<void> exportExcel(BuildContext context) async {
    setState(true);
    try {
      if (isFilterByDate) {
        final result = await _tposApi.exportExcelAccountPaymentSale(
            fromDate: _filterFromDate.toUtc().toIso8601String(),
            toDate: _filterToDate.toUtc().toIso8601String(),
            keySearch: keyword,
            filterStatus: _isFilterByStatus ? filterByStatusString : []);
        if (result != null) {
          showDialogOpenFileExcel(
              content:
                  "${S.current.fileWasSavedInFolder}: $result. ${S.current.doYouWantToOpenFile}",
              context: context,
              path: result);
        }
      } else {
        showNotify(S.current.paymentReceipt_pleaseEnterTheDate);
      }

      setState(false);
    } catch (e, s) {
      logger.error("exportExcel", e, s);
      setState(false);
    }
  }

  Future<void> getAccountPaymentSales() async {
    setState(true);
    skip = 0;
    try {
      final result = await _apiClient.getAccountPaymentSales(
          take: limit,
          skip: skip,
          keySearch: _keyword,
          accountId: _isFilterByTypeAccountPaymentSale ? _account.id : null,
          filterStatus: _isFilterByStatus ? filterByStatusString : [],
          fromDate: _isFilterByDate
              ? DateFormat("yyyy-MM-ddThh:mm:ss+00:00").format(_filterFromDate)
              : "",
          toDate: _isFilterByDate
              ? DateFormat("yyyy-MM-ddThh:mm:ss+00:00").format(_filterToDate)
              : "");
      if (result != null) {
        accountPayments = result.result;
        max = result.totalItems;
        if (accountPayments.length > 99) {
          _showLoadingIndicator();
        }
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadAccountPaymentsFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  // Load more
  List<AccountPayment> _accountPaymentsMore;

  Future<List<AccountPayment>> loadMoreAccountPayments() async {
    AccountPaymentBaseModel result;
    try {
      skip += limit;
      result = await _apiClient.getAccountPaymentSales(
          take: limit,
          skip: skip,
          keySearch: _keyword,
          accountId: _isFilterByTypeAccountPaymentSale ? _account.id : null,
          filterStatus: _isFilterByStatus ? filterByStatusString : [],
          fromDate: _isFilterByDate
              ? DateFormat("yyyy-MM-ddThh:mm:ss+00:00").format(_filterFromDate)
              : "",
          toDate: _isFilterByDate
              ? DateFormat("yyyy-MM-ddThh:mm:ss+00:00").format(_filterToDate)
              : "");
      _accountPaymentsMore = result.result;
    } catch (e, s) {
      logger.error("loadAccountPaymentsFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
    return _accountPaymentsMore;
  }

  Future handleItemCreated(int index) async {
    if (skip + limit < max && isLoadMore) {
      final newFetchedItems = await loadMoreAccountPayments();
      _accountPayments.addAll(newFetchedItems);
      _removeLoadingIndicator();
      _showLoadingIndicator();
    } else {
      _removeLoadingIndicator();
    }
    isLoadMore = false;
  }

  void _showLoadingIndicator() {
    _accountPayments.add(tempAccountPayment);
    notifyListeners();
  }

  void _removeLoadingIndicator() {
    _accountPayments.remove(tempAccountPayment);
    notifyListeners();
  }

  Future<void> deleteAccountPayment(
      int id, AccountPayment accountPayment) async {
    try {
      await _apiClient.deleteAccountPayment(id);
      accountPayments.remove(accountPayment);
//      showNotify("Xóa dữ liệu thành công!");
    } catch (e, s) {
      logger.error("deleteAccountPaymentFail", e, s);
      _dialog.showError(error: e);
    }
  }

  // XỬ LÝ LỌC

  bool _isFilterByDate = false;

  bool get isFilterByStatus => _isFilterByStatus;

  bool get isFilterByTypeAccountPaymentSale =>
      _isFilterByTypeAccountPaymentSale;

  set isFilterByTypeAccountPaymentSale(bool value) {
    _isFilterByTypeAccountPaymentSale = value;
    notifyListeners();
  }

  set isFilterByStatus(bool value) {
    _isFilterByStatus = value;
    notifyListeners();
  }

  AppFilterDateModel _filterDateRange = getTodayDateFilter();

  AppFilterDateModel get filterDateRange => _filterDateRange;

  set filterDateRange(AppFilterDateModel value) {
    _filterDateRange = value;
    notifyListeners();
  }

  // Lọc theo ngày
  bool get isFilterByDate => _isFilterByDate;

  set isFilterByDate(bool value) {
    _isFilterByDate = value;
    notifyListeners();
  }

  DateTime _filterFromDate;
  DateTime _filterToDate;

  DateTime get filterFromDate => _filterFromDate;

  DateTime get filterToDate => _filterToDate;

  set filterToDate(DateTime value) {
    _filterToDate = value;
    notifyListeners();
  }

  set filterFromDate(DateTime value) {
    _filterFromDate = value;
    notifyListeners();
  }

  List<AccountPaymentStateOption> _filterStatusList =
      AccountPaymentStateOption.options;

  List<AccountPaymentStateOption> get filterStatusList => _filterStatusList;

  set filterStatusList(List<AccountPaymentStateOption> value) {
    _filterStatusList = value;
    notifyListeners();
  }

  int get filterCount {
    int value = 0;
    if (_isFilterByDate) {
      value += 1;
    }
    if (_isFilterByStatus) {
      value += 1;
    }
    return value;
  }

  List<String> get filterByStatusString {
    final selectedStatus =
        _filterStatusList.where((f) => f.isSelected).toList();
    if (selectedStatus != null && selectedStatus.isNotEmpty) {
      if (selectedStatus.length == 1)
        return [selectedStatus.first.state];
      else {
        return selectedStatus.map((value) => value.state).toList();
      }
    }
    return [];
  }

  // Reset filter
  void resetFilter() {
    account = Account();
    _isFilterByDate = false;
    _isFilterByStatus = false;
    _isFilterByTypeAccountPaymentSale = false;
    notifyListeners();
  }

  Future<void> handleFilter() async {
    await getAccountPaymentSales();
  }

  //searchKeyword
  String _keyword = "";

  String get keyword => _keyword;
  final BehaviorSubject<String> _keywordController = BehaviorSubject();

  void onKeywordAdd(String value) {
    _keyword = value;
    if (_keywordController.isClosed == false) {
      _keywordController.add(_keyword);
    }
  }

  int countFilter() {
    int count = 0;
    if (_isFilterByDate) {
      count++;
    }
    if (_isFilterByStatus) {
      count++;
    }
    if (_isFilterByTypeAccountPaymentSale) {
      count++;
    }
    return count;
  }

  // Search
  Future<void> searchOrderCommand(String keyword) async {
    onKeywordAdd(keyword);
  }

  void showNotify(String message) {
    _dialog.showNotify(title: S.current.notification, message: message);
  }

  void showError(String content) {
    _dialog.showError(title: S.current.error, content: content);
  }

  void showDialogOpenFileExcel(
      {String content, BuildContext context, String path}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(S.current.notification),
          content: Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                S.current.openFolder,
                style: const TextStyle(fontSize: 16),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                if (Platform.isAndroid) {
                  OpenFile.open('/sdcard/download');
                } else {
                  final String dirloc =
                      (await getApplicationDocumentsDirectory()).path;
                  OpenFile.open(dirloc);
                }
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    S.current.close,
                    style: const TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    S.current.open,
                    style: const TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (path != null) {
                      OpenFile.open(path);
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

var tempAccountPayment = AccountPayment(name: "temp");
