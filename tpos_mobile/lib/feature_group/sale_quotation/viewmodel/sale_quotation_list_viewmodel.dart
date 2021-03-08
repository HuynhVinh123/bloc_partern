import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/sale_quotation/models/base_model_sale_quotation.dart';
import 'package:tpos_mobile/feature_group/sale_quotation/sale_quotation_state.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/sale_quotation.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SaleQuotationListViewModel extends ViewModelBase {
  SaleQuotationListViewModel(
      {ITposApiService tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<ITposApiService>();
    _dialog = dialogService ?? locator<DialogService>();

    filterToDate = _filterDateRange.toDate;
    filterFromDate = _filterDateRange.fromDate;

    // handled search
    _keywordController
        .debounceTime(
      const Duration(milliseconds: 400), //TODO Check debounceTime dispable
    )
        .listen((key) {
      getSaleQuotations();
    });
  }

  DialogService _dialog;
  ITposApiService _tposApi;

  bool isLoadMore = false;
  static const int limit = 100;
  int skip = 0;
  int max = 0;
  int _currentPage = 1;

  bool _isSearch = false;
  bool get isSearch => _isSearch;
  bool isUnselect = false;

  set isSearch(bool value) {
    _isSearch = value;
    notifyListeners();
  }

  List<int> saleQuotationsSelected = [];
  List<SaleQuotation> _saleQuotations = [];
  List<SaleQuotation> get saleQuotations => _saleQuotations;
  set saleQuotations(List<SaleQuotation> value) {
    _saleQuotations = value;
    notifyListeners();
  }

  void setUnselected(bool select) {
    isUnselect = select;
    notifyListeners();
  }

  Future<void> getSaleQuotations() async {
    saleQuotationsSelected.clear();
    setState(true);
    skip = 0;
    _currentPage = 1;
    try {
      final result = await _tposApi.getSaleQuotations(
          skip: skip,
          page: _currentPage,
          pageSize: limit,
          take: limit,
          keySearch: keyword,
          fromDate: isFilterByDate
              ? DateFormat("yyyy-MM-ddTHH:mm:ss").format(filterFromDate)
              : null,
          toDate: isFilterByDate
              ? DateFormat("yyyy-MM-ddTHH:mm:ss").format(filterToDate)
              : null,
          states: _isFilterByStatus ? filterByStatusString : []);
      if (result != null) {
        saleQuotations = result.result;
        if (saleQuotations.length > 99) {
          _showLoadingIndicator();
        }
        max = result.totalItems;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadSaleQuotationsFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> deleteSaleQuotation(int id, SaleQuotation item) async {
    setState(true);
    try {
      await _tposApi.deleteSaleQuotation(id);
      saleQuotations.remove(item);
      showNotify(S.current.quotation_quotationWasDeletedSuccessful);
      setState(false);
    } catch (e, s) {
      logger.error("deleteSaleQuotationsFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> exportExcel(String id, BuildContext context) async {
    try {
      setState(true);
      final result = await _tposApi.exportExcelSaleQuotation(id);
      if (result != null) {
        showDialogOpenFileExcel(
            content:
                "${S.current.fileWasSavedInFolder}: $result. ${S.current.doYouWantToOpenFile}",
            context: context,
            path: result);
      } else {
        _dialog.showError(
            title: S.current.error, content: S.current.permission);
      }
      setState(false);
    } catch (e) {
      _dialog.showError(title: S.current.error, content: e.toString());
      setState(false);
    }
  }

  Future<void> exportPDF(String id, BuildContext context) async {
    try {
      setState(true);
      final result = await _tposApi.exportPDFSaleQuotation(id);
      if (result != null) {
        showDialogOpenFileExcel(
            content:
                "${S.current.fileWasSavedInFolder}: $result. ${S.current.doYouWantToOpenFile}",
            context: context,
            path: result);
      } else {
        _dialog.showError(
            title: S.current.error, content: S.current.permission);
      }
      setState(false);
    } catch (e) {
      _dialog.showError(title: S.current.error, content: e.toString());
      setState(false);
    }
  }

  Future<void> deleteMultiSaleQuotation() async {
    setState(true);
    try {
      await _tposApi.deleteMultiSaleQuotation(saleQuotationsSelected);
      await getSaleQuotations();

      /// Xóa phiếu báo giá thành công
      showNotify(S.current.quotation_quotationWasDeletedSuccessful);
      setState(false);
    } catch (e, s) {
      logger.error("deleteSaleQuotationsFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
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

  void selectQuotation({SaleQuotation saleQuotation, int index, bool value}) {
    _saleQuotations[index].isSelect = value;
    if (value) {
      saleQuotationsSelected.add(saleQuotation.id);
    } else {
      saleQuotationsSelected.remove(saleQuotation.id);
    }
    isUnselect = false;
    notifyListeners();
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

  // Search
  Future<void> searchOrderCommand(String keyword) async {
    onKeywordAdd(keyword);
  }

  // XỬ LÝ LỌC

  bool _isFilterByDate = false;

  /// Lọc theo trạng thái
  bool _isFilterByStatus = false;

  bool get isFilterByStatus => _isFilterByStatus;

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

  List<SaleQuotationStateOption> _filterStatusList =
      SaleQuotationStateOption.options;

  List<SaleQuotationStateOption> get filterStatusList => _filterStatusList;

  set filterStatusList(List<SaleQuotationStateOption> value) {
    _filterStatusList = value;
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

  // Reset filter
  void resetFilter() {
    _isFilterByDate = false;
    _isFilterByStatus = false;
    notifyListeners();
  }

  Future<void> handleFilter() async {
    await getSaleQuotations();
  }

  int countFilter() {
    int count = 0;
    if (_isFilterByDate) {
      count++;
    }
    if (_isFilterByStatus) {
      count++;
    }
    return count;
  }

  /// LOADMORE
  List<SaleQuotation> _saleQuotationsMore;

  Future<List<SaleQuotation>> loadMoreSaleQuotations() async {
    BaseModelSaleQuotation result;
    try {
      skip += limit;
      result = await _tposApi.getSaleQuotations(
          take: limit,
          skip: skip,
          page: _currentPage,
          pageSize: limit,
          keySearch: _keyword,
          fromDate: isFilterByDate
              ? DateFormat("yyyy-MM-ddTHH:mm:ss").format(filterFromDate)
              : null,
          toDate: isFilterByDate
              ? DateFormat("yyyy-MM-ddTHH:mm:ss").format(filterToDate)
              : null,
          states: _isFilterByStatus ? filterByStatusString : []);
      _saleQuotationsMore = result.result;
    } catch (e, s) {
      logger.error("loadAccountPaymentsFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
    return _saleQuotationsMore;
  }

  Future handleItemCreated(int index) async {
    final itemPosition = index + 1;
    final pageToRequest = itemPosition ~/ limit;
    _currentPage = pageToRequest == 0 ? 1 : pageToRequest;

    if (skip + limit < max && isLoadMore) {
      final newFetchedItems = await loadMoreSaleQuotations();
      _saleQuotations.addAll(newFetchedItems);
      _removeLoadingIndicator();
      _showLoadingIndicator();
    } else {
      _removeLoadingIndicator();
    }
    isLoadMore = false;
  }

  void _showLoadingIndicator() {
    _saleQuotations.add(tempSaleQuotation);
    notifyListeners();
  }

  void _removeLoadingIndicator() {
    _saleQuotations.remove(tempSaleQuotation);
    notifyListeners();
  }

  void showNotify(String message) {
    _dialog.showNotify(title: S.current.notification, message: message);
  }

  void showDialogOpenFileExcel(
      {String content, BuildContext context, String path}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(S.current.notification),
          content: Text(content ?? ""),
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
                  OpenFile.open(dirloc ?? "");
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
                      OpenFile.open(path ?? "");
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

var tempSaleQuotation = SaleQuotation(name: "temp");
