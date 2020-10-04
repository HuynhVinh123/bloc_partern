import 'package:rxdart/rxdart.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/pos_order.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_service/odata_filter.dart';

import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';

import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

import '../pos_order_state.dart';

class PosOrderListViewModel extends ViewModelBase {
  PosOrderListViewModel(
      {ITposApiService tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<ITposApiService>();
    _dialog = dialogService ?? locator<DialogService>();

    filterToDate = _filterDateRange.toDate;
    filterFromDate = _filterDateRange.fromDate;

    _keywordController
        .debounceTime(const Duration(milliseconds: 500))
        .switchMap((keyword) async* {
      yield await loadPosOrders();
    }).listen((posOrders) {
      notifyListeners();
    });
  }

  ITposApiService _tposApi;
  DialogService _dialog;

  List<PosOrder> _posOrders;

  List<PosOrder> get posOrders => _posOrders;

  set posOrders(List<PosOrder> value) {
    _posOrders = value;
    notifyListeners();
  }

  String _keyword = "";

  String get keyword => _keyword;
  final BehaviorSubject<String> _keywordController = BehaviorSubject();

  Future<void> setKeyword(String value) async {
    _keyword = value;
    _keywordController.add(value);
  }

  static const int take = 1000;
  int skip = 0;
  int max = 0;
  int _currentPage = 0;

  // XỬ LÝ LỌC

  bool _isFilterByDate = true;
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

  List<PosOrderSateOption> _filterStatusList = PosOrderSateOption.options;

  List<PosOrderSateOption> get filterStatusList => _filterStatusList;

  set filterStatusList(List<PosOrderSateOption> value) {
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

  // Reset filter
  void resetFilter() {
    _isFilterByDate = false;
    _isFilterByStatus = false;
    notifyListeners();
  }

  String get filterByStatusString {
    final selectedStatus =
        _filterStatusList.where((f) => f.isSelected).toList();
    if (selectedStatus != null && selectedStatus.isNotEmpty) {
      if (selectedStatus.length == 1)
        return selectedStatus.first.description;
      else {
        return "${selectedStatus.first.description} + ${selectedStatus.length - 1} khác";
      }
    }
    return null;
  }

  OdataFilter get filter {
    final List<FilterBase> filterItems = <FilterBase>[];

    // Theo trạng thái
    if (_isFilterByStatus) {
      final selectedStatus =
          _filterStatusList?.where((f) => f.isSelected == true)?.toList();
      if (selectedStatus != null && selectedStatus.isNotEmpty) {
        filterItems.add(
          OdataFilter(
            logic: "or",
            filters: selectedStatus
                .map(
                  (f) => OdataFilterItem(
                      operator: "eq", field: "State", value: f.state),
                )
                .toList(),
          ),
        );
      }
    }

    // Theo ngày
    if (_isFilterByDate && _filterFromDate != null && _filterToDate != null) {
      filterItems.add(OdataFilterItem(
          field: "DateCreated",
          operator: "gte",
          value: filterFromDate.toUtc()));
      filterItems.add(OdataFilterItem(
          field: "DateCreated", operator: "lte", value: filterToDate.toUtc()));
    }

//    String keywordNoSign = StringUtils.removeVietnameseMark(keyword?.toLowerCase() ?? "");
    if (keyword != null && keyword != "") {
      filterItems.add(OdataFilter(logic: "or", filters: <OdataFilterItem>[
        OdataFilterItem(field: "Name", operator: "contains", value: keyword),
        OdataFilterItem(
            field: "POSReference", operator: "contains", value: keyword),
        OdataFilterItem(
            field: "PartnerName", operator: "contains", value: keyword),
        OdataFilterItem(
            field: "UserName", operator: "contains", value: keyword),
        OdataFilterItem(
            field: "SessionName", operator: "contains", value: keyword),
      ]));
    }

    if (filterItems.isNotEmpty) {
      return OdataFilter(logic: "and", filters: filterItems);
    } else {
      return null;
    }
  }

//  OdataSortItem sort = new OdataSortItem(field: "Name", dir: "ASC");
  List<OdataSortItem> sorts = <OdataSortItem>[];
  PosOrderSort posOrderSort = PosOrderSort(1, "", "desc", "DateOrder");

  void selectSoftCommand(String orderBy) {
    if (posOrderSort.orderBy != orderBy) {
      posOrderSort.orderBy = orderBy;
      posOrderSort.value = "desc";
    } else {
      posOrderSort.value = posOrderSort.value == "desc" ? "asc" : "desc";
    }
    notifyListeners();
    applyFilter();
  }

  Future<List<PosOrder>> loadPosOrders() async {
    sorts = [
      (OdataSortItem(
          field: posOrderSort.orderBy ?? "", dir: posOrderSort.value ?? ""))
    ];

    setState(true, message: "Đang tải..");
    // Gọi request
    try {
      final result = await _tposApi.getPosOrders(
          page: take,
          filter: filter,
          sorts: sorts,
          pageSize: take,
          take: take,
          skip: skip);

      if (result != null) {
        posOrders = result.data;
        max = result.total ?? 0;
      }
    } catch (e, s) {
      logger.error("loadPosOrders", e, s);
      _dialog.showError(error: e);
    }
    setState(false);
    return posOrders;
  }

  Future<void> applyFilter() async {
    skip = 0;
    _currentPage = 0;
    posOrders = [];
    loadPosOrders();
  }

  Future handleItemCreated(int index) async {
    final itemPosition = index + 1;
    final requestMoreData = itemPosition % take == 0 && itemPosition != 0;
    final pageToRequest = itemPosition ~/ take;

    if (requestMoreData && pageToRequest > _currentPage) {
      print('handleItemCreated | pageToRequest: $pageToRequest');
      _currentPage = pageToRequest;
      _showLoadingIndicator();
      if (skip + take < max) {
        final newFetchedItems = await loadMorePosOrders();
        posOrders.addAll(newFetchedItems);
      }
      _removeLoadingIndicator();
    }
  }

  void _showLoadingIndicator() {
    posOrders.add(temp);
    notifyListeners();
  }

  void _removeLoadingIndicator() {
    posOrders.remove(temp);
    notifyListeners();
  }

  Future<List<PosOrder>> loadMorePosOrders() async {
    PosOrderResult result;
    skip += take;
    try {
      result = await _tposApi.getPosOrders(
          page: take,
          filter: filter,
          sorts: sorts,
          pageSize: take,
          take: take,
          skip: skip);

      if (result != null) {
        max = result.total ?? 0;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadMorePosOrders", e, s);
      _dialog.showError(error: e);
    }
    return result.data;
  }

  void removePosOrder(int index) {
    posOrders.removeAt(index);
    notifyListeners();
  }

  Future<bool> deleteInvoice(int id) async {
    try {
      final result = await _tposApi.deletePosOrder(id);
      if (result.result) {
        _dialog.showNotify(message: "Đã xóa đơn hàng Pos", title: "Thông báo");
        return true;
      } else {
        _dialog.showError(
          title: "Lỗi",
          content: result.message,
        );
        return false;
      }
    } catch (e, s) {
      logger.error("deleteInvoice", e, s);
      _dialog.showError(title: "Lỗi", content: "$e");
      return false;
    }
  }
}

var temp = PosOrder(name: "temp");
