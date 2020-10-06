/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/5/19 4:54 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/5/19 8:41 AM
 *
 */

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';

import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/print_service.dart';

import 'package:tpos_mobile/src/tpos_apis/models/fast_sale_order.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_sale_order_sort.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/fast_sale_order_api.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';
import 'package:tpos_mobile/extensions/extensions.dart';

class FastSaleDeliveryInvoiceViewModel extends ViewModel
    implements ViewModelBase {
  FastSaleDeliveryInvoiceViewModel(
      {ITposApiService tposApi,
      PrintService print,
      DialogService dialog,
      FastSaleOrderApi fastSaleOrderApi}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _print = print ?? locator<PrintService>();
    _dialog = dialog ?? locator<DialogService>();
    _fastSaleOrderApi = fastSaleOrderApi ?? locator<FastSaleOrderApi>();
    // handled search
    _keywordController
        .debounceTime(const Duration(milliseconds: 300))
        .listen((key) {
      onSearchingOrderHandled(key);
    });
  }
  //log
  final _log = Logger("FastSaleDeliveryInvoiceViewModel");
  ITposApiService _tposApi;
  FastSaleOrderApi _fastSaleOrderApi;
  PrintService _print;
  DialogService _dialog;

  /// Có đang cho phép chọn nhiều hóa đơn hay không
  bool _isSelectEnable = false;
  int _listCount = 0;
  bool _isLoadingMore = false;
  String _lastFilterDescription = "";

  bool get isSelectEnable => _isSelectEnable;
  bool get isSelectAll {
    return !_fastSaleDeliveryInvoices.any((f) => f.isSelected == false);
  }

  bool get isLoadingMore => _isLoadingMore;
  int get listCount => _listCount;
  int get filterCount {
    int count = 0;
    if (_isFilterByDate) {
      count += 1;
    }
    if (_isFilterByStatus) {
      count += 1;
    }
    if (_isFilterDeliveryCarrier) {
      count += 1;
    }
    return count;
  }

  String get dataNotifyString {
    String filterString = "";

    if (filterCount > 0 && orderCount == 0 ||
        (_keyword != null && _keyword != "")) {
      filterString +=
          "\nKhông có kết quả nào phù hợp với điều kiện lọc \n$_lastFilterDescription";
    }
    return filterString;
  }

  set isSelectEnable(bool value) {
    _isSelectEnable = value;
    notifyListeners();
  }

  set isSelectAll(bool value) {
    if (value) {
      for (final value in _fastSaleDeliveryInvoices) {
        value.isSelected = true;
      }
    } else {
      for (final value in _fastSaleDeliveryInvoices) {
        value.isSelected = false;
      }
    }
    notifyListeners();
  }

  int get selectedCount =>
      _fastSaleDeliveryInvoices?.where((f) => f.isSelected)?.length ?? 0;
  int get orderCount => _fastSaleDeliveryInvoices?.length ?? 0;
  bool get canLoadMore => orderCount < _listCount;

  /* FILTER - ĐIỀU KIỆN LỌC */
  DeliveryCarrier _deliveryCarrier;
  bool _isFilterDeliveryCarrier = false;
  bool _isFilterByDate = true;
  bool _isFilterByStatus = false;
  DateTime _filterFromDate;
  DateTime _filterToDate;
  DeliveryStatusReport _filterStatus; // Trạng thái
  AppFilterDateModel _filterDateRange; // Khoảng thời gian

  bool get isFilterDeliveryCarrier => _isFilterDeliveryCarrier;
  bool get isFilterByDate => _isFilterByDate;
  bool get isFilterByStatus => _isFilterByStatus;
  DateTime get filterFromDate => _filterFromDate;
  DateTime get filterToDate => _filterToDate;
  DeliveryStatusReport get filterStatus => _filterStatus;
  AppFilterDateModel get filterDateRange => _filterDateRange;

  set isFilterDeliveryCarrier(bool value) {
    _isFilterDeliveryCarrier = value;
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

  set fromDate(DateTime value) {
    _filterFromDate = value;
    onPropertyChanged("");
  }

  set toDate(DateTime value) {
    _filterToDate = value;
    onPropertyChanged("");
  }

  set status(DeliveryStatusReport value) {
    _filterStatus = value;
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

  DeliveryCarrier get deliveryCarrier => _deliveryCarrier;
  set deliveryCarrier(DeliveryCarrier value) {
    _deliveryCarrier = value;
    notifyListeners();
  }

  /// Reset phân trang
  void _resetPaging() {
    _skip = 0;
  }

  ///Reset điều kiện lọc
  void resetFilter() {
    _isFilterByDate = true;
    _isFilterByStatus = false;
    _isFilterDeliveryCarrier = false;
    notifyListeners();
  }

  /// Chấp nhận điều kiện lọc
  Future<void> applyFilter() async {
    try {
      onStateAdd(true, message: "Đang tải...");

      _resetPaging();
      await _loadFastSaleOrder();
      notifyListeners();
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
    }
    onStateAdd(false, message: "Đang tải...");
  }

  Future<void> loadMoreItem() async {
    try {
      _isLoadingMore = true;
      notifyListeners();
      await _loadFastSaleOrder();
      notifyListeners();
    } catch (e, s) {
      _log.severe("", e, s);
      _dialog.showNotify(
          message: e.toString(),
          showOnTop: true,
          type: DialogType.NOTIFY_ERROR);
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> loadAllMoreItem() async {
    while (canLoadMore) {
      await loadMoreItem();
    }
  }

  /* END FILTER */

  //FastSaleOrder
  List<FastSaleOrder> _fastSaleDeliveryInvoices;
  List<FastSaleOrder> get fastSaleDeliveryInvoices => _fastSaleDeliveryInvoices;

  List<DeliveryStatusReport> _deliveryStatus;

  List<DeliveryStatusReport> get deliveryStatus => _deliveryStatus;

  Future<void> onSearchingOrderHandled(String keyword) async {
    _keyword = keyword;

    await _loadFastSaleOrder(resetPaging: true);
    notifyListeners();
  }

//Load fast sale order
  FastSaleOrderSort fastSaleDeliveryInvoiceSort =
      FastSaleOrderSort(1, "", "desc", "DateInvoice");

  void selectSoftCommand(String orderBy) {
    if (fastSaleDeliveryInvoiceSort.orderBy != orderBy) {
      fastSaleDeliveryInvoiceSort.orderBy = orderBy;
      fastSaleDeliveryInvoiceSort.value = "desc";
    } else {
      fastSaleDeliveryInvoiceSort.value =
          fastSaleDeliveryInvoiceSort.value == "desc" ? "asc" : "desc";
    }

    initData();
  }

  double totalAmount = 0.0;
  final _take = 100;
  int get take => _take;
  int _skip = 0;
  final _pageSize = 100;
  var _sort = <Map>[];
  Map _filter;

  /// Lấy danh sách hóa đơn
  Future _loadFastSaleOrder({bool resetPaging = false}) async {
    if (resetPaging) {
      _resetPaging();
    }
    _sort = [
      {
        "field": fastSaleDeliveryInvoiceSort.orderBy,
        "dir": fastSaleDeliveryInvoiceSort.value
      },
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

    if (_isFilterByDate && filterToDate != null) {
      filterList.add({
        "field": "DateInvoice",
        "operator": "lte",
        "value": DateFormat("yyyy-MM-ddTHH:mm:ss").format(filterToDate),
      });
    }

    if (_isFilterByStatus && _filterStatus != null) {
      filterList.add({
        "field": "ShipPaymentStatus",
        "operator": "eq",
        "value": _filterStatus.value,
      });
    }

    if (deliveryCarrier != null && _isFilterDeliveryCarrier) {
      filterList.add({
        "field": "CarrierId",
        "operator": "eq",
        "value": deliveryCarrier?.id
      });
    }

    if (keyword != null && keyword.isNotEmpty) {
      filterList.add(
        {
          "logic": "or",
          "filters": [
            {
              "field": "PartnerDisplayName",
              "operator": "contains",
              "value": _keyword
            },
            {
              "field": "PartnerNameNoSign",
              "operator": "contains",
              "value": StringUtils.removeVietnameseMark(_keyword.toLowerCase())
            },
            {"field": "TrackingRef", "operator": "contains", "value": _keyword},
            {"field": "Phone", "operator": "contains", "value": _keyword},
            {"field": "Number", "operator": "contains", "value": _keyword},
          ]
        },
      );
    }

    // Điều kiện lọc
    _filter = {
      "logic": "and",
      "filters": filterList,
    };

    _lastFilterDescription = "";
    // build filter note
    if (_keyword != null && _keyword != "") {
      _lastFilterDescription = "- Theo tìm kiếm từ khóa: $_keyword";
    }

    if (_isFilterByDate && _filterFromDate != null && _filterToDate != null) {
      _lastFilterDescription +=
          "\n- Theo thời gian từ ${DateFormat("dd/MM/yyyy  HH:mm").format(_filterFromDate)} tới ${DateFormat("dd/MM/yyyy HH:mm").format(_filterToDate)}";
    }
    if (_isFilterByStatus) {
      _lastFilterDescription += "\n";
      _lastFilterDescription +=
          "- Theo trạng thái đơn hàng: ${_filterStatus?.name}";
    }

    try {
      final result = await _fastSaleOrderApi.getDeliveryInvoices(
        sort: _sort,
        filter: _filter,
        take: _take,
        skip: _skip,
        page: _pageSize,
      );

      if (_skip == 0) {
        _fastSaleDeliveryInvoices = result.data;
      } else {
        _fastSaleDeliveryInvoices.addAll(result.data);
      }
      _listCount = result.count ?? 0;
      _skip = orderCount;

      DateTime statusFromDate = _filterFromDate;
      DateTime statusToDate = _filterToDate;

      if (!_isFilterByDate ||
          _filterFromDate == null && _fastSaleDeliveryInvoices.isNotEmpty) {
        statusFromDate = DateTime(2017, 1, 1);
      }

      if (!_isFilterByDate ||
          _filterToDate == null && _fastSaleDeliveryInvoices.isNotEmpty) {
        statusToDate = DateTime.now();
      }

      _deliveryStatus = await _tposApi.getFastSaleOrderDeliveryStatusReports(
          startDate: statusFromDate, endDate: statusToDate);

      // Get total amount
      if (_deliveryStatus != null && _deliveryStatus.isNotEmpty) {
        totalAmount = (_deliveryStatus
            .map((f) => f.totalAmount)
            .reduce((a, b) => a + b)).toDouble();
      }
    } on SocketException catch (e, s) {
      _log.severe("", e, s);
      onDialogMessageAdd(OldDialogMessage.error("", "Không có kết nối mạng"));
    } catch (e, s) {
      onIsBusyAdd(false);
      _dialog.showError(error: e, isRetry: true).then((result) {
        if (result.type == DialogResultType.RETRY)
          initData();
        else if (result.type == DialogResultType.GOBACK)
          onEventAdd("GO_BACK", null);
      });
      _log.severe("", e, s);
    }
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

  /// Khởi tạo giá trị và nhận param khi view được tạo
  void init() {
    filterDateRange = AppFilterDateModel.thisMonth();
  }

  /// Lấy các giá trị và dữ liệu khi view được mở
  Future initData() async {
    _resetPaging();
    onStateAdd(true, message: "Đang tải...");
    await _loadFastSaleOrder();
    onStateAdd(false);
    notifyListeners();
  }

  Future printShipOrderCommand(int orderId,
      {bool isDownloadOkiela = false, int carrierId}) async {
    try {
      onStateAdd(true);
      await _print.printShip(
        fastSaleOrderId: orderId,
        download: isDownloadOkiela,
      );
    } catch (e, s) {
      _log.severe("Print ship", e, s);
      onDialogMessageAdd(OldDialogMessage.error(
          "Không in được phiếu ", e.toString(),
          error: e));
    }
    onStateAdd(false);
  }

  Future printInvoiceCommand(int orderId) async {
    try {
      onStateAdd(true, message: "Đang in...");
      await _print.printOrder(
        fastSaleOrderId: orderId,
      );
    } catch (e, s) {
      onDialogMessageAdd(OldDialogMessage.error("", e.toString()));
      _log.severe("", e, s);
    }
    onStateAdd(false);
  }

  /// Cập nhật trạng thái giao hàng tất cả hóa đơn
  Future<void> updateDeliveryState() async {
    try {
      onStateAdd(true, message: "Đang cập nhật...");
      await _tposApi.refreshFastSaleOnlineOrderDeliveryState();
    } catch (e, s) {
      _log.severe("", e, s);
      _dialog.showError(error: e);
    }
    onStateAdd(false, message: "Đang cập nhật...");
  }

  /// Hủy bỏ một hoặc nhiều phiếu ship
  Future<void> cancelShips(List<FastSaleOrder> items) async {
    final selectedItem =
        _fastSaleDeliveryInvoices.where((f) => f.isSelected).toList();

    if (selectedItem == null && selectedItem.isEmpty) {
      _dialog.showNotify(message: "Vui lòng chọn một hoặc nhiều hóa đơn");
    }

    for (final itm in selectedItem) {
      try {
        onStateAdd(true, message: "Đang hủy ${itm.trackingRef ?? "N/A"}");
        await _tposApi.fastSaleOrderCancelShip(itm.id);
        _loadFastSaleOrder();
      } catch (e, s) {
        _log.severe("Hủy vận đơn", e, s);
        _dialog.showNotify(message: e.toString());
      }
    }

    onStateAdd(false);
    notifyListeners();
  }

  /// Hủy bỏ một hoặc nhiều hóa đơn
  Future<void> canncelInvoices(List<FastSaleOrder> items) async {
    final selectedItem =
        _fastSaleDeliveryInvoices.where((f) => f.isSelected).toList();

    if (selectedItem == null && selectedItem.isEmpty) {
      _dialog.showNotify(message: "Vui lòng chọn một hoặc nhiều hóa đơn");
      return;
    }

    try {
      onStateAdd(true, message: "Đang hủy...");
      await _tposApi
          .fastSaleOrderCancelOrder(selectedItem.map((f) => f.id).toList());
      await _loadFastSaleOrder(resetPaging: true);
      _dialog.showNotify(
        message: "Đã hủy hóa đơn",
      );
    } catch (e, s) {
      _log.severe("Hủy vận đơn", e, s);
      _dialog.showNotify(message: e.toString());
    }

    onStateAdd(false);
    notifyListeners();
  }

  /// Hủy bỏ một hoặc nhiều hóa đơn
  Future<void> updateDeliveryInfo(List<FastSaleOrder> items) async {
    onStateAdd(true);
    final selectedItem =
        _fastSaleDeliveryInvoices.where((f) => f.isSelected).toList();

    if (selectedItem == null && selectedItem.isEmpty) {
      _dialog.showNotify(message: "Vui lòng chọn một hoặc nhiều hóa đơn");
      return;
    }

    try {
      await _tposApi.refreshFastSaleOrderDeliveryState(
          selectedItem.map((f) => f.id).toList());
      _loadFastSaleOrder();
    } catch (e, s) {
      _log.severe("Hủy vận đơn", e, s);
      _dialog.showNotify(message: e.toString());
    }

    onStateAdd(false);
  }

  Future<void> printOrders() async {
    final selectedItem =
        _fastSaleDeliveryInvoices.where((f) => f.isSelected).toList();

    if (selectedItem == null && selectedItem.isEmpty) {
      _dialog.showNotify(message: "Vui lòng chọn một hoặc nhiều hóa đơn");
      return;
    }

    for (final itm in selectedItem) {
      try {
        onStateAdd(true, message: "Đang in ${itm.number ?? "N/A"}");
        await _print.printOrder(fastSaleOrderId: itm.id);
        Future.delayed(const Duration(seconds: 1));
      } catch (e, s) {
        _log.severe("Hủy vận đơn", e, s);
        _dialog.showNotify(message: e.toString());
      }
    }

    onStateAdd(false);
  }

  Future<void> printShips({bool isDownloadOkiela = false}) async {
    final selectedItem =
        _fastSaleDeliveryInvoices.where((f) => f.isSelected).toList();

    if (selectedItem == null && selectedItem.isEmpty) {
      _dialog.showNotify(message: "Vui lòng chọn một hoặc nhiều hóa đơn");
      return;
    }

    for (final itm in selectedItem) {
      try {
        onStateAdd(true, message: "Đang in ${itm.number ?? "N/A"}");
        await _print.printShip(
            fastSaleOrderId: itm.id, download: isDownloadOkiela);
        await Future.delayed(const Duration(seconds: 1));
      } catch (e, s) {
        _log.severe("Hủy vận đơn", e, s);
        _dialog.showNotify(message: e.toString());
      }
    }

    onStateAdd(false);
  }

  Future<void> exportExcel(BuildContext context) async {
    onStateAdd(true);
    final selectedItem =
        _fastSaleDeliveryInvoices.where((f) => f.isSelected).toList();

    final ids = selectedItem.map((value) => value.id).toList();

    try {
      final result = await _tposApi.exportExcelDeliveryInvoice(
          keySearch: keyword,
          fromDate: isFilterByDate
              ? DateFormat("yyyy-MM-ddTHH:mm:ss").format(_filterFromDate)
              : null,
          toDate: isFilterByDate
              ? DateFormat('yyyy-MM-ddTHH:mm:ss').format(filterToDate)
              : null,
          statusTexts: _isFilterByStatus && _filterStatus != null
              ? _filterStatus.value
              : null,
          ids: ids,
          deliveryType:
              isFilterDeliveryCarrier ? deliveryCarrier?.deliveryType : null,
          isFilterStatus: _isFilterByStatus && _filterStatus != null);

      if (result != null) {
        showDialogOpenFileExcel(
            content:
                "File của bạn đã được lưu ở thư  mục: $result. Bạn có muốn mở file?",
            context: context,
            path: result);
      }

      onStateAdd(false);
    } catch (e) {
      _dialog.showError(content: e.toString());
      onStateAdd(false);
    }
  }

  Future<void> exportExcelDetail(BuildContext context) async {
    onStateAdd(true);
    final selectedItem =
        _fastSaleDeliveryInvoices.where((f) => f.isSelected).toList();

    final ids = selectedItem.map((value) => value.id).toList();
    try {
      final result = await _tposApi.exportExcelDeliveryInvoiceDetail(
          keySearch: keyword,
          fromDate: isFilterByDate
              ? _filterFromDate.toStringFormat('yyyy-MM-ddTHH:mm:ss')
              : null,
          toDate: isFilterByDate
              ? _filterToDate.toStringFormat('yyyy-MM-ddTHH:mm:ss')
              : null,
          statusTexts: _isFilterByStatus && _filterStatus != null
              ? _filterStatus.value
              : null,
          ids: ids,
          deliveryType:
              isFilterDeliveryCarrier ? deliveryCarrier?.deliveryType : null,
          isFilterStatus: _isFilterByStatus && _filterStatus != null);
      if (result != null) {
        showDialogOpenFileExcel(
            content:
                "File của bạn đã được lưu ở thư  mục: $result. Bạn có muốn mở file?",
            context: context,
            path: result);
      }

      onStateAdd(false);
    } catch (e) {
      _dialog.showError(content: e.toString());
      onStateAdd(false);
    }
  }

  void showDialogOpenFileExcel(
      {String content, BuildContext context, String path}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text("Thông báo"),
          content: Text(content ?? ''),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: const Text(
                "Mở thư mục lưu",
                style: TextStyle(fontSize: 16),
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
                  child: const Text(
                    "Đóng",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: const Text(
                    "Mở",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (path != null) {
                      OpenFile.open(path);
                    }
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _keywordController.close();
    super.dispose();
  }
}
