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
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tmt_flutter_untils/tmt_flutter_utils.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service/new_dialog_service.dart';
import 'package:tpos_mobile/services/print_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_sale_order_sort.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/sale_setting_api.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class FastSaleDeliveryInvoiceViewModel extends ScopedViewModel
    implements ViewModelBase {
  FastSaleDeliveryInvoiceViewModel(
      {ITposApiService tposApi,
      PrintService print,
      ISaleSettingApi saleSettingApi,
      NewDialogService newDialog,
      FastSaleOrderApi fastSaleOrderApi}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _print = print ?? locator<PrintService>();
    //_dialog = dialog ?? locator<DialogService>();
    _fastSaleOrderApi = fastSaleOrderApi ?? GetIt.I<FastSaleOrderApi>();
    _saleSettingApi = saleSettingApi ?? locator<ISaleSettingApi>();
    _newDialog = newDialog ?? GetIt.I<NewDialogService>();
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

  // DialogService _dialog;

  NewDialogService _newDialog;
  ISaleSettingApi _saleSettingApi;
  SaleSetting _saleSetting;

  /// Có đang cho phép chọn nhiều hóa đơn hay không
  bool _isSelectEnable = false;
  int _totalCount = 0;
  bool _isLoadingMore = false;
  String _lastFilterDescription = "";

  /// BỘ lọc
  final OdataFilter _filter = OdataFilter(
    logic: 'and',
    filters: <OdataFilterItem>[],
  );

  // Sắp xếp
  final List<OdataSortItem> _sorts = <OdataSortItem>[];

  bool get isSelectEnable => _isSelectEnable;

  bool get isSelectAll {
    return !_fastSaleDeliveryInvoices.any((f) => f.isSelected == false);
  }

  bool get isLoadingMore => _isLoadingMore;

  int get totalCount => _totalCount;

  int get filterCount {
    int count = 0;
    if (_isFilterByDateTemp) {
      count += 1;
    }
    if (_isFilterByStatusTemp) {
      count += 1;
    }
    if (_isFilterByDeliveryCarrierTemp) {
      count += 1;
    }
    return count;
  }

  String get dataNotifyString {
    String filterString = "";

    if (filterCount > 0 && orderCount == 0 ||
        (_keyword != null && _keyword != "")) {
      filterString +=
          "\n${S.current.fastSaleOrder_noResultsWhenFilter} \n$_lastFilterDescription";
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

  bool get canLoadMore => orderCount < _totalCount;

  /* FILTER - ĐIỀU KIỆN LỌC */
  DeliveryCarrier _deliveryCarrier;
  DeliveryCarrier _deliveryCarrierTemp;
  bool _isFilterDeliveryCarrier = false;
  bool _isFilterByDate = true;
  bool _isFilterByStatus = false;

  /// Có lọc theo ngày hay không. Áp dụng trước khi nhấn nút lọc. Sẽ gắn lại = IsFilteryByDate nếu không áp dụng điều kiện lọc.
  bool _isFilterByDateTemp = true;

  /// Có lọc theo trạng thái hay không. Áp dụng trước khi nhấn nút lọc. Sẽ gắn lại = IsFilterByStatus nếu không áp dụng lọc
  bool _isFilterByStatusTemp = false;

  /// Có lọc theo đối tác giao hàng hay không. Áp dụng trước khi nhấn nút lọc. Sẽ gán lại = IsFilterByDeliveryCarrier nếu không áp dụng lọc
  bool _isFilterByDeliveryCarrierTemp = false;

  bool get isFilterByDateTemp => _isFilterByDateTemp;

  bool get isFilterByStatusTemp => _isFilterByStatusTemp;

  bool get isFilterByDeliveryCarrierTemp => _isFilterByDeliveryCarrierTemp;

  DateTime _filterFromDate;
  DateTime _filterToDate;
  DeliveryStatusReport _filterStatus; // Trạng thái
  DeliveryStatusReport _filterStatusTemp;
  AppFilterDateModel _filterDateRange; // Khoảng thời gian
  AppFilterDateModel filterDateRangeTemp;

  DateTime get filterFromDate => _filterFromDate;

  DateTime get filterToDate => _filterToDate;

  DeliveryStatusReport get filterStatus => _filterStatus;
  DeliveryStatusReport get filterStatusTemp => _filterStatusTemp;

  AppFilterDateModel get filterDateRange => _filterDateRange;

  set isFilterByDeliveryCarrierTemp(bool value) {
    _isFilterByDeliveryCarrierTemp = value;
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

  set fromDate(DateTime value) {
    _filterFromDate = value;
    notifyListeners();
  }

  set toDate(DateTime value) {
    _filterToDate = value;
    notifyListeners();
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
  DeliveryCarrier get deliveryCarrierTemp => _deliveryCarrierTemp;

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

    _isFilterByDateTemp = true;
    _isFilterByStatusTemp = false;
    _isFilterByDeliveryCarrierTemp = false;
    _filterStatus = null;
    _deliveryCarrier = null;
    init();
    initData();
    notifyListeners();
  }

  /// Khôi phục điều kiện trạng thái lọc nếu không nhấn Áp dụng.
  /// Điều kiện lọc sẽ về lúc nhấn áp dụng gần nhất
  void undoFilter() {
    filterDateRange = filterDateRangeTemp;
    isFilterByDateTemp = _isFilterByDate;
    isFilterByDeliveryCarrierTemp = _isFilterDeliveryCarrier;
    isFilterByStatusTemp = _isFilterByStatus;
    _filterStatus = filterStatusTemp;
    _deliveryCarrier = _deliveryCarrierTemp;
    notifyListeners();
  }

  /// Validate dữ liệu cho điều kiện lọc
  bool validateFilter() {
    String errorString = "";
    // Validate
    if (_isFilterByDeliveryCarrierTemp && _deliveryCarrier == null) {
      errorString = errorString + S.current.filter_ErrorSelectPartner + "\n";
    }
    if (filterStatus == null && isFilterByStatusTemp) {
      errorString = errorString + S.current.filter_ErrorSelectStatus;
    }

    if (errorString != "") {
      _newDialog.showDialog(
        content: errorString,
        type: AlertDialogType.warning,
      );
    } else {
      return true;
    }
  }

  /// Chấp nhận điều kiện lọc và tải lại dữ liệu mới theo điều kiện lọc
  Future<void> applyFilter() async {
    try {
      // Đang tải
      setBusy(true, message: "${S.current.loading}...");
      _isFilterByDate = isFilterByDateTemp;
      _isFilterByStatus = isFilterByStatusTemp;
      _isFilterDeliveryCarrier = isFilterByDeliveryCarrierTemp;

      _resetPaging();
      filterDateRangeTemp = filterDateRange;
      _filterStatusTemp = filterStatus;
      _deliveryCarrierTemp = deliveryCarrier;
      await _loadFastSaleOrder();
      notifyListeners();
    } catch (e, s) {
      logger.error("", e, s);
      _newDialog.showError(content: e.toString());
    }
    setBusy(false, message: "${S.current.loading}...");
  }

  Future<void> loadMoreItem() async {
    try {
      _isLoadingMore = true;
      notifyListeners();
      await _loadFastSaleOrder();
      notifyListeners();
    } catch (e, s) {
      _log.severe("", e, s);
      _newDialog.showToast(message: e.toString(), type: AlertDialogType.error);
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
  final _take = 1000;

  int get take => _take;
  int _skip = 0;
  final _pageSize = 1000;

  /// Lấy danh sách hóa đơn
  Future _loadFastSaleOrder({bool resetPaging = false}) async {
    _sorts.clear();
    _filter.filters.clear();

    if (resetPaging) {
      _resetPaging();
    }

    _sorts.add(
      OdataSortItem(
          field: fastSaleDeliveryInvoiceSort.orderBy,
          dir: fastSaleDeliveryInvoiceSort.value),
    );

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

    if (_isFilterByStatus && _filterStatus != null) {
      _filter.filters.add(
        OdataFilterItem(
          field: 'ShipPaymentStatus',
          operator: 'eq',
          value: _filterStatus.value,
        ),
      );
    }

    if (deliveryCarrier != null && _isFilterDeliveryCarrier) {
      _filter.filters.add(
        OdataFilterItem(
          field: 'CarrierId',
          operator: 'eq',
          value: deliveryCarrier?.id,
        ),
      );
    }

    /// Lọc theo từ khóa
    if (keyword != null && keyword.isNotEmpty) {
      _filter.filters.add(
        OdataFilter(logic: 'or', filters: <OdataFilterItem>[
          // Tìm theo tên hiển thị
          OdataFilterItem(
            field: 'PartnerDisplayName',
            operator: 'contains',
            value: _keyword,
          ),
          // Tìm theo tên
          OdataFilterItem(
            field: 'PartnerNameNoSign',
            operator: 'contains',
            value: _keyword.removeVietnameseMark(toLower: true),
          ),
          OdataFilterItem(
            field: 'TrackingRef',
            operator: 'contains',
            value: _keyword,
          ),
          OdataFilterItem(
            field: 'Phone',
            operator: 'contains',
            value: _keyword,
          ),
          OdataFilterItem(
            field: 'Number',
            operator: 'contains',
            value: _keyword,
          ),
        ]),
        // Tìm theo trackingRef
      );
    }

    _lastFilterDescription = "";
    // build filter note
    if (_keyword != null && _keyword != "") {
      // "Theo tìm kiếm từ khóa
      _lastFilterDescription =
          "- ${S.current.accordingToKeywordSearch}: $_keyword";
    }

    if (_isFilterByDate && _filterFromDate != null && _filterToDate != null) {
      // Theo thời gian từ
      _lastFilterDescription +=
          "\n- ${S.current.accordingToTime} ${DateFormat("dd/MM/yyyy  HH:mm").format(_filterFromDate)} ${S.current.to} ${DateFormat("dd/MM/yyyy HH:mm").format(_filterToDate)}";
    }
    if (_isFilterByStatus) {
      _lastFilterDescription += "\n";
      // Theo trạng thái đơn hàng
      _lastFilterDescription +=
          "- ${S.current.accordingToTheOrderStatus}: ${_filterStatus?.name}";
    }

    try {
      final result =
          await _fastSaleOrderApi.getDeliveryInvoices(GetFastSaleOrderQuery(
        sort: _sorts,
        filter: _filter,
        take: _take,
        skip: _skip,
        page: _pageSize,
      ));

      if (_skip == 0) {
        _fastSaleDeliveryInvoices = result.value;
      } else {
        _fastSaleDeliveryInvoices.addAll(result.value);
      }
      _totalCount = result.count ?? 0;
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
    } catch (e, s) {
      setBusy(false);
      _newDialog.showError(
        title: 'Không tải được dữ liệu!',
        content: e.toString(),
      );
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
    _filterStatusTemp = filterStatus;
    _deliveryCarrierTemp = deliveryCarrier;
  }

  /// Lấy các giá trị và dữ liệu khi view được mở
  Future initData() async {
    _resetPaging();
    filterDateRangeTemp = filterDateRange;
    setBusy(true, message: "${S.current.loading}...");
    try {
      _saleSetting = await _saleSettingApi.getDefault();
      await _loadFastSaleOrder();
    } catch (e) {
      _newDialog.showError(title: 'Đã xảy ra lỗi!', content: e.toString());
    }

    setBusy(false);
    notifyListeners();
  }

  Future printShipOrderCommand(FastSaleOrder order,
      {bool isDownloadOkiela = false, int carrierId}) async {
    try {
      if (_saleSetting.statusDenyPrintShip.isNotEmpty) {
        final bool isExist = _saleSetting.statusDenyPrintShip
            .any((item) => item["Value"] == order.state);
        if (isExist) {
          _newDialog.showToast(
              title: S.current.notification,
              message:
                  "${S.current.notifyPrintInvoice} '${order.showState}'. ${S.current.notifyPrintPleaseAccess}.",
              type: AlertDialogType.warning);
        } else {
          if (_saleSetting.groupDenyPrintNoShippingConnection) {
            if (order.carrierId != null) {
              await handlePrint(order.id, isDownloadOkiela);
            } else {
              _newDialog.showToast(
                  title: S.current.notification,
                  message:
                      "${S.current.notifyPrintShipWithPartner} ${S.current.notifyPrintPleaseAccess}.");
            }
          } else {
            await handlePrint(order.id, isDownloadOkiela);
          }
        }
      } else {
        if (_saleSetting.groupDenyPrintNoShippingConnection) {
          if (order.carrierId != null) {
            await handlePrint(order.id, isDownloadOkiela);
          } else {
            _newDialog.showToast(
                title: S.current.notification,
                message:
                    "${S.current.notifyPrintShipWithPartner}. ${S.current.notifyPrintPleaseAccess}.");
          }
        } else {
          await handlePrint(order.id, isDownloadOkiela);
        }
      }

      // onStateAdd(true);
      // await _print.printShip(
      //   fastSaleOrderId: orderId,
      //   download: isDownloadOkiela,
      // );
    } catch (e, s) {
      _log.severe("Print ship", e, s);
      // Không in được phiếu
      _newDialog.showError(content: e.toString());
    }
    setBusy(false);
  }

  Future<void> handlePrint(int orderId, bool isDownloadOkiela) async {
    setBusy(true, message: "${S.current.printing}...");
    await _print.printShip(
        fastSaleOrderId: orderId, download: isDownloadOkiela);
  }

  Future printInvoiceCommand(FastSaleOrder order) async {
    try {
      setBusy(true, message: "${S.current.printing}...");
      if (_saleSetting.statusDenyPrintSale.isNotEmpty) {
        final bool isExist = _saleSetting.statusDenyPrintSale
            .any((item) => item["Value"] == order.state);
        if (isExist) {
          _newDialog.showDialog(
            title: S.current.notification,
            content:
                "${S.current.notifyPrintInvoice} '${order.showState}'. ${S.current.notifyPrintPleaseAccess}.",
            type: AlertDialogType.warning,
          );
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
      // await _print.printOrder(
      //   fastSaleOrderId: orderId,
      // );
    } catch (e, s) {
      _newDialog.showError(content: e.toString());
      _log.severe("", e, s);
    }
    setBusy(false);
  }

  /// Cập nhật trạng thái giao hàng tất cả hóa đơn
  Future<void> updateDeliveryState() async {
    try {
      // Đang cập nhật
      setBusy(true, message: "${S.current.updating}...");
      await _tposApi.refreshFastSaleOnlineOrderDeliveryState();
    } catch (e, s) {
      _log.severe("", e, s);
      _newDialog.showError(content: e.toString());
    }
    setBusy(false, message: "${S.current.updating}...");
  }

  /// Hủy bỏ một hoặc nhiều phiếu ship
  Future<void> cancelShips(List<FastSaleOrder> items) async {
    final selectedItem =
        _fastSaleDeliveryInvoices.where((f) => f.isSelected).toList();

    if (selectedItem == null && selectedItem.isEmpty) {
      // Vui lòng chọn một hoặc nhiều hóa đơn
      _newDialog.showToast(
          message: S.current.fastSaleOrder_selectOneOrMoreInvoices);
    }

    for (final itm in selectedItem) {
      try {
        //Đang hủy
        setBusy(true,
            message: "${S.current.canceling} ${itm.trackingRef ?? "N/A"}");
        await _tposApi.fastSaleOrderCancelShip(itm.id);
        _loadFastSaleOrder();
      } catch (e, s) {
        // Hủy vận đơn
        _log.severe(S.current.cancelBillOfLading, e, s);
        _newDialog.showToast(message: e.toString());
      }
    }

    setBusy(false);
    notifyListeners();
  }

  /// Hủy bỏ một hoặc nhiều hóa đơn
  Future<void> canncelInvoices(List<FastSaleOrder> items) async {
    final selectedItem =
        _fastSaleDeliveryInvoices.where((f) => f.isSelected).toList();

    if (selectedItem == null && selectedItem.isEmpty) {
      // Vui lòng chọn một hoặc nhiều hóa đơn
      _newDialog.showToast(
          message: S.current.fastSaleOrder_selectOneOrMoreInvoices);
      return;
    }

    try {
      // Đang hủy
      setBusy(true, message: "${S.current.canceling}...");
      await _tposApi
          .fastSaleOrderCancelOrder(selectedItem.map((f) => f.id).toList());
      await _loadFastSaleOrder(resetPaging: true);
      _newDialog.showToast(
        message: S.current.invoiceCanceled,
      );
    } catch (e, s) {
      // "Hủy vận đơn
      _log.severe(S.current.cancelBillOfLading, e, s);
      _newDialog.showToast(message: e.toString());
    }

    setBusy(false);
    notifyListeners();
  }

  /// Hủy bỏ một hoặc nhiều hóa đơn
  Future<void> updateDeliveryInfo(List<FastSaleOrder> items) async {
    setBusy(true);
    final selectedItem =
        _fastSaleDeliveryInvoices.where((f) => f.isSelected).toList();

    if (selectedItem == null && selectedItem.isEmpty) {
      // Vui lòng chọn một hoặc nhiều hóa đơn
      _newDialog.showToast(
          message: S.current.fastSaleOrder_selectOneOrMoreInvoices);
      return;
    }

    try {
      await _tposApi.refreshFastSaleOrderDeliveryState(
          selectedItem.map((f) => f.id).toList());
      _loadFastSaleOrder();
    } catch (e, s) {
      _log.severe(S.current.cancelBillOfLading, e, s);
      _newDialog.showToast(message: e.toString());
    }

    setBusy(false);
  }

  Future<void> printOrders() async {
    final selectedItem =
        _fastSaleDeliveryInvoices.where((f) => f.isSelected).toList();

    if (selectedItem == null && selectedItem.isEmpty) {
      _newDialog.showToast(
          message: S.current.fastSaleOrder_selectOneOrMoreInvoices);
      return;
    }

    for (final itm in selectedItem) {
      try {
        // "Đang in
        setBusy(true, message: "${S.current.printing} ${itm.number ?? "N/A"}");
        await _print.printOrder(fastSaleOrderId: itm.id);
        Future.delayed(const Duration(seconds: 1));
      } catch (e, s) {
        // Hủy vận đơn
        _log.severe(S.current.cancelBillOfLading, e, s);
        _newDialog.showToast(message: e.toString());
      }
    }

    setBusy(false);
  }

  Future<void> printShips({bool isDownloadOkiela = false}) async {
    final selectedItem =
        _fastSaleDeliveryInvoices.where((f) => f.isSelected).toList();

    if (selectedItem == null && selectedItem.isEmpty) {
      _newDialog.showToast(
          message: S.current.fastSaleOrder_selectOneOrMoreInvoices);
      return;
    }

    for (final itm in selectedItem) {
      try {
        //Đang in
        setBusy(true, message: "${S.current.printing} ${itm.number ?? "N/A"}");
        await _print.printShip(
            fastSaleOrderId: itm.id, download: isDownloadOkiela);
        await Future.delayed(const Duration(seconds: 1));
      } catch (e, s) {
        _log.severe(S.current.cancelBillOfLading, e, s);
        _newDialog.showToast(message: e.toString());
      }
    }

    setBusy(false);
  }

  Future<void> exportExcel(BuildContext context) async {
    setBusy(true);
    final selectedItem =
        _fastSaleDeliveryInvoices.where((f) => f.isSelected).toList();

    final ids = selectedItem.map((value) => value.id).toList();

    try {
      final result = await _tposApi.exportExcelDeliveryInvoice(
          keySearch: keyword,
          fromDate: _isFilterByDate
              ? DateFormat("yyyy-MM-ddTHH:mm:ss").format(_filterFromDate)
              : null,
          toDate: _isFilterByDate
              ? DateFormat('yyyy-MM-ddTHH:mm:ss').format(filterToDate)
              : null,
          statusTexts: _isFilterByStatus && _filterStatus != null
              ? _filterStatus.value
              : null,
          ids: ids,
          deliveryType:
              _isFilterDeliveryCarrier ? deliveryCarrier?.deliveryType : null,
          isFilterStatus: _isFilterByStatus && _filterStatus != null);

      if (result != null) {
        showDialogOpenFileExcel(
            content:
                "${S.current.fileWasSavedInFolder}: $result. ${S.current.doYouWantToOpenFile}",
            context: context,
            path: result);
      }

      setBusy(false);
    } catch (e) {
      _newDialog.showError(content: e.toString());
      setBusy(false);
    }
  }

  Future<void> exportExcelDetail(BuildContext context) async {
    setBusy(true);
    final selectedItem =
        _fastSaleDeliveryInvoices.where((f) => f.isSelected).toList();

    final ids = selectedItem.map((value) => value.id).toList();
    try {
      final result = await _tposApi.exportExcelDeliveryInvoiceDetail(
          keySearch: keyword,
          fromDate: _isFilterByDate
              ? _filterFromDate.toStringFormat('yyyy-MM-ddTHH:mm:ss')
              : null,
          toDate: _isFilterByDate
              ? _filterToDate.toStringFormat('yyyy-MM-ddTHH:mm:ss')
              : null,
          statusTexts: _isFilterByStatus && _filterStatus != null
              ? _filterStatus.value
              : null,
          ids: ids,
          deliveryType:
              _isFilterDeliveryCarrier ? deliveryCarrier?.deliveryType : null,
          isFilterStatus: _isFilterByStatus && _filterStatus != null);
      if (result != null) {
        showDialogOpenFileExcel(
            content:
                "${S.current.fileWasSavedInFolder}: $result.  ${S.current.doYouWantToOpenFile}",
            context: context,
            path: result);
      }

      setBusy(false);
    } catch (e) {
      _newDialog.showError(content: e.toString());
      setBusy(false);
    }
  }

  void showDialogOpenFileExcel(
      {String content, BuildContext context, String path}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(S.current.notification),
          content: Text(content ?? ''),
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
