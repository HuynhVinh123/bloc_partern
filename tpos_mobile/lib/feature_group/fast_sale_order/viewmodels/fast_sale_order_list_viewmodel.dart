/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/4/19 6:25 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/4/19 5:50 PM
 *
 */

import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/data_services/data_service.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/navigation_service.dart';
import 'package:tpos_mobile/services/print_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/date_filter_template.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_sale_order_sort.dart';
import 'package:tpos_mobile/src/tpos_apis/models/sale_setting.dart';
import 'package:tpos_mobile/src/tpos_apis/models/status_report.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/sale_setting_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class FastSaleOrderListViewModel extends ScopedViewModel {
  FastSaleOrderListViewModel({
    NavigationService navigationService,
    PrintService printService,
    ITposApiService tposApi,
    ISaleSettingApi saleSettingApi,
    FastSaleOrderApi fastSaleOrderApi,
    DataService dataService,
    DialogService dialogService,
  }) {
    _navigation = navigationService ?? GetIt.I<NavigationService>();
    _print = printService ?? locator<PrintService>();
    _tposApi = tposApi ?? locator<ITposApiService>();
    _fastSaleOrderApi = fastSaleOrderApi ?? GetIt.I<FastSaleOrderApi>();
    _dialog = dialogService ?? locator<DialogService>();
    _dataService = dataService ?? locator<DataService>();
    _saleSettingApi = saleSettingApi ?? locator<ISaleSettingApi>();

    // handled search
    _keywordController
        .debounceTime(
      const Duration(milliseconds: 300),
    )
        .listen((key) {
      onSearchingOrderHandled(key);
    });

    // Nghe thông báo thay đổi
    _dataSubscription = _dataService.dataSubject
        .where((f) =>
            f.value is FastSaleOrder || f.valueTargetType is FastSaleOrder)
        .listen((dataMessage) {
      if (dataMessage.value is FastSaleOrder) {
        _onInsertOrUpdateOrder(order: dataMessage.value);
      } else if (dataMessage.value is int) {
        _onInsertOrUpdateOrder(orderId: dataMessage.value);
      }
    });

    // Phân quyền
  }

  PrintService _print;
  TposApiService _tposApi;
  FastSaleOrderApi _fastSaleOrderApi;
  DialogService _dialog;
  NavigationService _navigation;
  DataService _dataService;
  ISaleSettingApi _saleSettingApi;
  SaleSetting _saleSetting;

  //Permission

  final bool permissionAdd = true;
  final bool permissionEdit = true;

  StreamSubscription _dataSubscription;

  bool isSearchEnable = false;

  // Partner
  int _partnerId;

  /* FILTER */
  bool _isFilterByDate = true;
  bool _isFilterByStatus = false;

  /// Tạo biến lưu tạm cho filter
  bool _isFilterByDateTemp = true;
  bool get isFilterByDateTemp => _isFilterByDateTemp;
  bool _isFilterByStatusTemp = false;

  bool isApply = false;

  DateTime _filterFromDate;
  DateTime _filterToDate;
  AppFilterDateModel _filterDateRange;
  AppFilterDateModel filterDateRangeTemp;
  List<String> _filterStatus = <String>[];
  List<String> _filterStatusTemp = <String>[];

  /// Lưu giá trị xác định có đang load thêm các phần tử khác hay không
  bool _isLoadingMore = false;

  /// Lấy giá trị xác định có đang tải thêm các phần tử khác hay không. dùng cho view
  bool get isLoadingMore => _isLoadingMore;

  int get listCount => _fastSaleOrders.length;

  bool get canLoadMore => !_isLoadingMore && _totalCount > listCount;

  bool get isFilterByDate => _isFilterByDate;

  bool get isFilterByStatus => _isFilterByStatus;
  bool get isFilterByStatusTemp => _isFilterByStatusTemp;

  AppFilterDateModel get filterDateRange => _filterDateRange;

  DateTime get filterFromDate => _filterFromDate;

  DateTime get filterToDate => _filterToDate;

  List<String> get filterStatus => _filterStatus;

  List<String> get filterStatusTemp => _filterStatusTemp;

  String get filterByDateString {
    return "${DateFormat("dd/MM/yyyy").format(_filterFromDate ?? DateTime.now())} -> ${DateFormat("dd/MM/yyyy").format(_filterToDate ?? DateTime.now())}";
  }

  set filterFromDate(DateTime value) {
    _filterFromDate = value;
    notifyListeners();
  }

  set filterToDate(DateTime value) {
    _filterToDate = value;
    notifyListeners();
  }

  set isFilterByDate(bool value) {
    _isFilterByDate = value;
    notifyListeners();
  }

  set isFilterByStatus(bool value) {
    _isFilterByStatus = value;
    notifyListeners();
  }

  set isFilterByDateTemp(bool value) {
    _isFilterByDateTemp = value;
    notifyListeners();
  }

  set isFilterByStatusTemp(bool value) {
    _isFilterByStatusTemp = value;
    notifyListeners();
  }

  void addFilterStatus(String value) {
    if (_filterStatus.any((f) => f == value)) {
      _filterStatus.remove(value);
    } else {
      _filterStatus.add(value);
    }
    notifyListeners();
  }

  set filterDateRange(AppFilterDateModel value) {
    if (value != _filterDateRange) {
      _filterDateRange = value;
      _filterFromDate = value.fromDate;
      _filterToDate = value.toDate;
      notifyListeners();
    }
  }

  final BehaviorSubject<List<DateFilterTemplate>>
      _dateFilterTemplateController = BehaviorSubject();

  Stream<List<DateFilterTemplate>> get dateFilterTemplateStream =>
      _dateFilterTemplateController.stream;

  String get filterByStatusString {
    final selectedStatus = _statusReports.where((f) => f.isChecked).toList();
    if (selectedStatus != null && selectedStatus.isNotEmpty) {
      if (selectedStatus.length == 1)
        return selectedStatus.first.name;
      else {
        // khác
        return "${selectedStatus.first.name} + ${selectedStatus.length - 1} ${S.current.other}";
      }
    }
    return null;
  }

  /* END FILTER */

  List<FastSaleOrder> tempFastSaleOrders = <FastSaleOrder>[];

  //FastSaleOrder
  List<FastSaleOrder> _fastSaleOrders;

  List<FastSaleOrder> get fastSaleOrders => _fastSaleOrders;

  List<StatusReport> _statusReports = <StatusReport>[];

  // ignore: unnecessary_getters_setters
  List<StatusReport> get statusReports => _statusReports;

  // ignore: unnecessary_getters_setters
  set statusReports(List<StatusReport> value) {
    _statusReports = value;
  }

  Future<void> onSearchingOrderHandled(String keyword) async {
    if (keyword == null && keyword == "") {
      notifyListeners();
      return;
    }
    try {
      final String key = StringUtils.removeVietnameseMark(keyword);
      _fastSaleOrders = _fastSaleOrders
          // ignore: avoid_bool_literals_in_conditional_expressions
          .where((f) => f.partnerNameNoSign != null
              ? StringUtils.removeVietnameseMark(
                          f.partnerNameNoSign.toLowerCase())
                      .contains(key.toLowerCase()) ||
                  f.number
                      .toString()
                      .toLowerCase()
                      .contains(key.toLowerCase()) ||
                  f.phone.toString().toLowerCase().contains(key.toLowerCase())
              : false)
          .toList();
      notifyListeners();
    } catch (ex) {
      onDialogMessageAdd(OldDialogMessage.error("", ex.toString()));
    }
  }

  // Get status report
  Future<void> _refreshStatusReport() async {
    DateTime fromDate = _filterFromDate;
    DateTime toDate = _filterToDate;
    if (!_isFilterByDate &&
        _filterFromDate == null &&
        _fastSaleOrders.isNotEmpty) {
      //Get status report
      final DateTime minDate = _fastSaleOrders
          ?.map((f) => f.dateInvoice)
          ?.reduce((a, b) => a.isBefore(b) ? a : b);

      fromDate = minDate;
    }

    if (!_isFilterByDate &&
        _filterToDate == null &&
        _fastSaleOrders.isNotEmpty) {
      final DateTime maxDate = _fastSaleOrders
          ?.map((f) => f.dateInvoice)
          ?.reduce((a, b) => a.isAfter(b) ? a : b);
      toDate = maxDate;
    }

    if (_filterFromDate != null && _filterToDate != null) {
      final results = await _tposApi.getStatusReport(
        DateFormat("yyyy-MM-ddTHH:mm:ss").format(fromDate),
        DateFormat("yyyy-MM-ddTHH:mm:ss").format(toDate),
      );

      _statusReports = results;
    }
  }

  //Load more Fast Sale Order
  bool _isLoadingMoreFastSaleOrder = false;

  bool get isLoadingMoreFastSaleOrder => _isLoadingMoreFastSaleOrder;
  final BehaviorSubject<bool> _isLoadingMoreFastSaleOrderController =
      BehaviorSubject();

  Stream<bool> get isLoadingMoreFastSaleOrderStream =>
      _isLoadingMoreFastSaleOrderController.stream;

  set isLoadingMoreFastSaleOrder(bool value) {
    _isLoadingMoreFastSaleOrder = value;
    if (!_isLoadingMoreFastSaleOrderController.isClosed)
      _isLoadingMoreFastSaleOrderController.add(_isLoadingMoreFastSaleOrder);
  }

//Load fast sale order
  FastSaleOrderSort fastSaleOrderSort =
      FastSaleOrderSort(1, "", "desc", "DateInvoice");

  void selectSoftCommand(String orderBy) {
    if (fastSaleOrderSort.orderBy != orderBy) {
      fastSaleOrderSort.orderBy = orderBy;
      fastSaleOrderSort.value = "desc";
    } else {
      fastSaleOrderSort.value =
          fastSaleOrderSort.value == "desc" ? "asc" : "desc";
    }
    initData();
  }

  final _take = 1000;
  int _skip = 0;
  int page = 1;
  final _pageSize = 1000;

  /// Số lượng hóa đơn server
  int _totalCount = 0;

  int get totalCount => _totalCount;

  final OdataFilter _filter = OdataFilter(
    logic: 'and',
    filters: <FilterBase>[],
  );

  final List<OdataSortItem> _sorts = <OdataSortItem>[];

  Future _loadFastSaleOrder() async {
    _filter.filters.clear();
    _sorts.clear();

    _sorts.add(OdataSortItem(
        field: fastSaleOrderSort.orderBy, dir: fastSaleOrderSort.value));

    // Lọc theo loại là hóa đơn
    _filter.filters
        .add(OdataFilterItem(field: 'Type', operator: 'eq', value: 'invoice'));

    // Lọc theo từ ngày
    if (_isFilterByDate && filterFromDate != null) {
      _filter.filters.add(
        OdataFilterItem(
          field: 'DateInvoice',
          operator: 'gte',
          value: _filterFromDate.toStringFormat('yyyy-MM-ddTHH:mm:ss'),
        ),
      );
    }

    // Lọc theo đến ngày
    if (_isFilterByDate && filterToDate != null) {
      _filter.filters.add(
        OdataFilterItem(
          field: 'DateInvoice',
          operator: 'lte',
          value: _filterToDate.toStringFormat('yyyy-MM-ddTHH:mm:ss'),
        ),
      );
    }

    // Điều kiện lọc trạng thái
    final OdataFilter filterByStatus = OdataFilter(
      logic: 'or',
      filters: <OdataFilterItem>[],
    );
    final selectedStatusReports = _statusReports
        ?.where((f) => _filterStatus.any((a) => a == f.value))
        ?.toList();

    if (_isFilterByStatus &&
        selectedStatusReports != null &&
        selectedStatusReports.isNotEmpty) {
      // ignore: avoid_function_literals_in_foreach_calls
      selectedStatusReports.forEach(
        (item) {
          filterByStatus.filters.add(
            OdataFilterItem(field: 'State', operator: 'eq', value: item.value),
          );
        },
      );

      _filter.filters.add(filterByStatus);
    }

    // Lọc Partner
    if (_partnerId != null) {
      _filter.filters.add(
        OdataFilterItem(field: 'PartnerId', operator: 'eq', value: _partnerId),
      );
    }

    final OdataListResult<FastSaleOrder> result = await _fastSaleOrderApi.gets(
      GetFastSaleOrderQuery(
        pageSize: _pageSize,
        skip: _skip,
        take: _take,
        page: page,
        filter: _filter,
        sort: _sorts,
      ),
    );

    // Nếu trang 1 thì gắn lại danh sách
    if (_skip == 0) {
      _fastSaleOrders = result.value;
    } else {
      // Nếu load more thì thêm vào list
      _fastSaleOrders.addAll(result.value);
    }
    _totalCount = result.count;
    _skip += result.value.length;
    notifyListeners();
  }

  // Đếm số điều kiện lọc
  int get filterCount {
    int count = 0;
    if (_isFilterByDateTemp) {
      count += 1;
    }
    if (_isFilterByStatusTemp) {
      count += 1;
    }
    return count;
  }

  // Đếm điều kiện lọc sau khi ứng dụng filter
  int get filterCountCache {
    int countCache = 0;
    if (isFilterByDateTemp) {
      countCache += 1;
    }
    if (isFilterByStatusTemp) {
      countCache += 1;
    }
    return countCache;
  }

  // Đếm hóa đơn hiển thị
  int get invoiceCount => _fastSaleOrders?.length ?? 0;

  int get invoiceTotal {
    if (_fastSaleOrders == null || _fastSaleOrders.isEmpty) {
      return 0;
    }
    return _fastSaleOrders
        .map((f) => f.amountTotal)
        .reduce((a, b) => a + b)
        .toInt();
  }

  //searchKeyword
  String _keyword;

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

  /// Param
  /// Type: Delivery: Giao hàng, Order: Bán hàng
  /// PartnerId: Id khách hàng
  Future init({String type, int partnerId}) async {
    _partnerId = partnerId;
    filterDateRange = AppFilterDateModel.thisMonth();
    filterFromDate = filterDateRange.fromDate;
    filterToDate = filterDateRange.toDate;
    _filterStatusTemp.clear();
    _filterStatusTemp.addAll(filterStatus);
    setBusy(false);
  }

  /// Khởi tạo dữ liệu ban đâu
  /// Lấy tình trạng theo ngày lọc
  /// Lấy danh sách hóa đơn theo điều kiện lọc
  Future<void> initData() async {
    // Đang tải
    setBusy(true, message: S.current.loading);
    resetPaging();
    filterDateRangeTemp = filterDateRange;
    try {
      _saleSetting = await _saleSettingApi.getDefault();
      await _loadFastSaleOrder();
      await _refreshStatusReport();
      notifyListeners();
    } catch (e, s) {
      logger.error("initData", e, s);
      final dialogResult = await _dialog.showError(
        title: "${S.current.dialog_errorTitle}!",
        content: e.toString(),
        error: e,
        isRetry: true,
      );

      if (dialogResult.type == DialogResultType.RETRY) {
        initData();
      } else if (dialogResult.type == DialogResultType.GOBACK) {
        _navigation.pop();
      }
    }
    setBusy(false);
  }

  /// Áp dụng lọc
  /// Lấy danh sách đơn hàng theo điều kiện lọc
  /// Tải lại danh sách trạng thái
  Future<void> applyFilter() async {
    isApply = true;
    resetPaging();
    //Đang tải dữ liệu
    setBusy(true, message: "${S.current.loading}...");
    _isFilterByDate = isFilterByDateTemp;
    _isFilterByStatus = isFilterByStatusTemp;
    _filterStatusTemp.clear();
    _filterStatusTemp.addAll(_filterStatus);
    filterDateRangeTemp = filterDateRange;
    try {
      await _loadFastSaleOrder();
      await _refreshStatusReport();
    } catch (e, s) {
      logger.error("applyFilter", e, s);
      _dialog.showError(title: S.current.dialog_errorTitle, error: e);
    }
    notifyListeners();
    setBusy(false);
  }

  void undoFilter() {
    filterDateRange = filterDateRangeTemp;
    isFilterByDateTemp = _isFilterByDate;
    isFilterByStatusTemp = _isFilterByStatus;
    _filterStatus.clear();
    _filterStatus.addAll(filterStatusTemp);
    notifyListeners();
  }

  /// Tải toàn bộ đơn hàng dựa trên phân trang
  Future<void> loadMore() async {
    _isLoadingMore = true;
    notifyListeners();
    await _loadFastSaleOrder();
    _isLoadingMore = false;
    page += 1;
    notifyListeners();
  }

  Future printShipOrderCommand(FastSaleOrder order, [int carrierId]) async {
    try {
      if (_saleSetting.statusDenyPrintShip.isNotEmpty) {
        final bool isExist = _saleSetting.statusDenyPrintShip
            .any((item) => item["Value"] == order.state);
        if (isExist) {
          _dialog.showNotify(
              title: S.current.notification,
              message:
                  "${S.current.notifyPrintShip} '${order.showState}'. ${S.current.notifyPrintPleaseAccess}.");
        } else {
          if (_saleSetting.groupDenyPrintNoShippingConnection) {
            if (order.carrierId != null) {
              await handlePrint(order.id);
            } else {
              _dialog.showNotify(
                  title: S.current.notification,
                  message:
                      "${S.current.notifyPrintShipWithPartner}. ${S.current.notifyPrintPleaseAccess}.");
            }
          } else {
            await handlePrint(order.id);
          }
        }
      } else {
        if (_saleSetting.groupDenyPrintNoShippingConnection) {
          if (order.carrierId != null) {
            await handlePrint(order.id);
          } else {
            _dialog.showNotify(
                title: S.current.notification,
                message:
                    "${S.current.notifyPrintShipWithPartner}. ${S.current.notifyPrintPleaseAccess}.");
          }
        } else {
          await handlePrint(order.id);
        }
      }
    } catch (e, s) {
      onDialogMessageAdd(OldDialogMessage.error("", e.toString()));
      logger.error("", e, s);
    }
    setBusy(false);
  }

  Future<void> handlePrint(int orderId) async {
    // Đang in
    setBusy(true, message: "${S.current.printing}...");
    await _print.printShip(
      fastSaleOrderId: orderId,
    );
  }

  Future printInvoiceCommand(FastSaleOrder order) async {
    try {
      if (_saleSetting.statusDenyPrintSale.isNotEmpty) {
        final bool isExist = _saleSetting.statusDenyPrintSale
            .any((item) => item["Value"] == order.state);
        if (isExist) {
          _dialog.showNotify(
              title: S.current.notification,
              message:
                  "${S.current.notifyPrintInvoice} '${order.showState}'. ${S.current.notifyPrintPleaseAccess}.");
        } else {
          setBusy(true, message: "${S.current.printing}...");
          await _print.printOrder(
            fastSaleOrderId: order.id,
          );
        }
      } else {
        setBusy(true, message: "${S.current.printing}...");
        await _print.printOrder(
          fastSaleOrderId: order.id,
        );
      }
    } catch (e, s) {
      onDialogMessageAdd(OldDialogMessage.error("", e.toString()));
      logger.error("", e, s);
    }
    setBusy(false);
  }

  void _onInsertOrUpdateOrder({FastSaleOrder order, int orderId}) {
    if (order != null) {
      final item = _fastSaleOrders?.firstWhere((f) => f.id == order.id,
          orElse: () => null);
      if (item != null) {
        //update
        item.amountTotal = order.amountTotal;
        item.state = order.state;
        item.showState = order.showState;
      } else {
        // insert
        initData();
      }
    } else {
      final item = _fastSaleOrders?.firstWhere((f) => f.id == orderId,
          orElse: () => null);

      if (item != null) {
        // update
        initData();
      } else {
        // refresh
        initData();
      }
    }
  }

  /// Xóa bộ lọc
  void resetFilter() {
    _isFilterByDate = true;
    _isFilterByStatus = false;
    _isFilterByDateTemp = true;
    _isFilterByStatusTemp = false;
    init();
    initData();
    notifyListeners();
  }

  ///Xóa đơn hàng
  Future<void> deleteOrder(FastSaleOrder order) async {
    try {
      await _tposApi.deleteFastSaleOrder(order.id);
      _dialog.showNotify(
          message: "${S.current.saleOnlineOrder_DeletedOrder} ${order.number}");
      _fastSaleOrders?.remove(order);
      notifyListeners();
    } catch (e, s) {
      logger.error("delete order", e, s);
      _dialog.showError(
          title: S.current.fastSaleOrder_deleteOrderFailed, error: e);
    }
  }

  void resetPaging() {
    _skip = 0;
    _keyword = null;
  }

  @override
  void dispose() {
    _dataSubscription?.cancel();
    _dateFilterTemplateController.close();
    _isLoadingMoreFastSaleOrderController.close();
    _keywordController.close();
    super.dispose();
  }
}
