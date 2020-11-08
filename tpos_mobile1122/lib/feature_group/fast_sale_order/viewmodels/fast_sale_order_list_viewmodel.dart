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
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/helpers/helpers.dart';

import 'package:tpos_mobile/services/data_services/data_service.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/navigation_service.dart';
import 'package:tpos_mobile/services/print_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/date_filter_template.dart';

import 'package:tpos_mobile/src/tpos_apis/models/fast_sale_order_sort.dart';
import 'package:tpos_mobile/src/tpos_apis/models/sale_setting.dart';
import 'package:tpos_mobile/src/tpos_apis/models/status_report.dart';

import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/fast_sale_order_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/sale_setting_api.dart';

import 'package:tpos_mobile/src/tpos_apis/services/tpos_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class FastSaleOrderListViewModel extends ViewModel {
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
    _fastSaleOrderApi = fastSaleOrderApi ?? locator<FastSaleOrderApi>();
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
  DateTime _filterFromDate;
  DateTime _filterToDate;
  AppFilterDateModel _filterDateRange;
  final List<String> _filterStatus = <String>[];

  bool get isFilterByDate => _isFilterByDate;
  bool get isFilterByStatus => _isFilterByStatus;
  AppFilterDateModel get initFilterDate => _filterDateRange;
  DateTime get filterFromDate => _filterFromDate;
  DateTime get filterToDate => _filterToDate;
  List<String> get filterStatus => _filterStatus;

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

  void addFilterStatus(String value) {
    if (_filterStatus.any((f) => f == value)) {
      _filterStatus.remove(value);
    } else {
      _filterStatus.add(value);
    }
    notifyListeners();
  }

  set filterDateRange(AppFilterDateModel value) {
    if (value == _filterDateRange) {
      return;
    }
    _filterDateRange = value;
    _filterFromDate = value.fromDate;
    _filterToDate = value.toDate;
    notifyListeners();
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
        return "${selectedStatus.first.name} + ${selectedStatus.length - 1} khác";
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
  List<StatusReport> get statusReports => _statusReports;

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
      _fastSaleOrders = tempFastSaleOrders
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
        tempFastSaleOrders.isNotEmpty) {
      //Get status report
      final DateTime minDate = tempFastSaleOrders
          ?.map((f) => f.dateInvoice)
          ?.reduce((a, b) => a.isBefore(b) ? a : b);

      fromDate = minDate;
    }

    if (!_isFilterByDate &&
        _filterToDate == null &&
        tempFastSaleOrders.isNotEmpty) {
      final DateTime maxDate = tempFastSaleOrders
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
  final _pageSize = 1000;

  /// Số lượng hóa đơn server
  int _listCount = 0;

  var sort = <Map>[];
  Map filter;

  int get listCount => _listCount;
  Future _loadFastSaleOrder() async {
    sort = [
      {"field": fastSaleOrderSort.orderBy, "dir": fastSaleOrderSort.value},
    ];

    // Tất cả điều kiện lọc
    final filterList = <Map>[];
    filterList.add({"field": "Type", "operator": "eq", "value": "invoice"});

    if (_isFilterByDate && filterFromDate != null) {
      filterList.add({
        "field": "DateInvoice",
        "operator": "gte",
        "value": DateFormat("yyyy-MM-ddTHH:mm:ss").format(filterFromDate),
      });
    }

    if (_isFilterByStatus && filterToDate != null) {
      filterList.add({
        "field": "DateInvoice",
        "operator": "lte",
        "value": DateFormat("yyyy-MM-ddTHH:mm:ss").format(filterToDate),
      });
    }

    // Điều kiện lọc trạng thái
    final filterStatusListMap = <Map>[];
    final selectedStatusReports = _statusReports
        ?.where((f) => _filterStatus.any((a) => a == f.value))
        ?.toList();

    if (_isFilterByStatus &&
        selectedStatusReports != null &&
        selectedStatusReports.isNotEmpty) {
      selectedStatusReports.forEach(
        (item) {
          filterStatusListMap.add(
            {
              "field": "State",
              "operator": "eq",
              "value": item.value,
            },
          );
        },
      );

      filterList.add({
        "logic": "or",
        "filters": filterStatusListMap,
      });
    }

    // Lọc Partner
    if (_partnerId != null) {
      filterList.add({
        "field": "PartnerId",
        "operator": "eq",
        "value": _partnerId,
      });
    }
    // Điều kiện lọc
    filter = {
      "logic": "and",
      "filters": filterList,
    };

    final result = await _fastSaleOrderApi.getInvoices(
      filter: filter,
      sort: sort,
      take: _take,
      skip: _skip,
      pageSize: _pageSize,
    );

    _listCount = result.count;

    if (_skip == 0) {
      tempFastSaleOrders = result.data;
    } else {
      tempFastSaleOrders.addAll(result.data);
    }
    _skip = invoiceCount;
    _fastSaleOrders = tempFastSaleOrders;
    notifyListeners();
  }

  // Đếm số điều kiện lọc
  int get filterCount {
    const int dem = 1;
    return dem;
  }

  // Đếm hóa đơn hiển thị
  int get invoiceCount => tempFastSaleOrders?.length ?? 0;
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

    _filterDateRange = AppFilterDateModel.thisMonth();
    _filterFromDate = _filterDateRange.fromDate;
    _filterToDate = _filterDateRange.toDate;
    onStateAdd(false);
  }

  /// Khởi tạo dữ liệu ban đâu
  /// Lấy tình trạng theo ngày lọc
  /// Lấy danh sách hóa đơn theo điều kiện lọc
  Future<void> initData() async {
    onStateAdd(true, message: "Đang tải");
    resetPaging();
    try {
      _saleSetting = await _saleSettingApi.getDefault();
      await _fetchAllOrders();
      await _refreshStatusReport();
      notifyListeners();
    } catch (e, s) {
      logger.error("initData", e, s);
      final dialogResult = await _dialog.showError(
        title: "Đã xảy ra lỗi!",
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
    onStateAdd(false);
  }

  /// Áp dụng lọc
  /// Lấy danh sách đơn hàng theo điều kiện lọc
  /// Tải lại danh sách trạng thái
  Future<void> applyFilter() async {
    resetPaging();
    onStateAdd(true, message: "Đang tải dữ liệu...");
    try {
      await _fetchAllOrders();
      await _refreshStatusReport();
    } catch (e, s) {
      logger.error("applyFilter", e, s);
      _dialog.showError(title: "Lỗi tải dữ liệu", error: e);
    }
    notifyListeners();
    onStateAdd(false);
  }

  /// Tải toàn bộ đơn hàng dựa trên phân trang
  Future<void> _fetchAllOrders() async {
    await _loadFastSaleOrder();
    while (invoiceCount < _listCount) {
      print(invoiceCount);
      print(listCount);
      await _loadFastSaleOrder();
    }
  }

  Future printShipOrderCommand(FastSaleOrder order, [int carrierId]) async {
    try {
      if (_saleSetting.statusDenyPrintShip.isNotEmpty) {
        final bool isExist = _saleSetting.statusDenyPrintShip
            .any((item) => item["Value"] == order.state);
        if (isExist) {
          _dialog.showNotify(
              title: "Thông báo",
              message:
                  "Bạn không thể in phiếu ship ở trạng thái '${order.showState}'. Vui lòng vào cấu hình bán hàng để cài đặt lại.");
        } else {
          if (_saleSetting.groupDenyPrintNoShippingConnection) {
            if (order.carrierId != null) {
              await handlePrint(order.id);
            } else {
              _dialog.showNotify(
                  title: "Thông báo",
                  message:
                      "Bạn không thể in phiếu ship khi chưa có kết nối vận chuyển. Vui lòng vào cấu hình bán hàng để cài đặt lại.");
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
                title: "Thông báo",
                message:
                    "Bạn không thể in phiếu ship khi chưa có kết nối vận chuyển. Vui lòng vào cấu hình bán hàng để cài đặt lại.");
          }
        } else {
          await handlePrint(order.id);
        }
      }
    } catch (e, s) {
      onDialogMessageAdd(OldDialogMessage.error("", e.toString()));
      logger.error("", e, s);
    }
    onStateAdd(false);
  }

  Future<void> handlePrint(int orderId) async {
    onStateAdd(true, message: "Đang in...");
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
              title: "Thông báo",
              message:
                  "Bạn không thể in hóa đơn ở trạng thái '${order.showState}'. Vui lòng vào cấu hình bán hàng để cài đặt lại.");
        } else {
          onStateAdd(true, message: "Đang in...");
          await _print.printOrder(
            fastSaleOrderId: order.id,
          );
        }
      } else {
        onStateAdd(true, message: "Đang in...");
        await _print.printOrder(
          fastSaleOrderId: order.id,
        );
      }
    } catch (e, s) {
      onDialogMessageAdd(OldDialogMessage.error("", e.toString()));
      logger.error("", e, s);
    }
    onStateAdd(false);
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
    _statusReports?.forEach((f) {
      f.isChecked = false;
    });

    notifyListeners();
  }

  ///Xóa đơn hàng
  Future<void> deleteOrder(FastSaleOrder order) async {
    try {
      await _tposApi.deleteFastSaleOrder(order.id);
      _dialog.showNotify(message: "Đã xóa đơn hàng ${order.number}");
      _fastSaleOrders?.remove(order);
      notifyListeners();
    } catch (e, s) {
      logger.error("delete order", e, s);
      _dialog.showError(title: "Không xóa được đơn hàng", error: e);
    }
  }

  void resetPaging() {
    _skip = 0;
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
