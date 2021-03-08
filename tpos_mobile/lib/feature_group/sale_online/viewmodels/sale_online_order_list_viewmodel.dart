import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/extensions.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_service/odata_filter.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/services/config_service/shop_config_service.dart';
import 'package:tpos_mobile/services/data_services/data_service.dart';
import 'package:tpos_mobile/services/dialog_service/new_dialog_service.dart';
import 'package:tpos_mobile/services/log_services/log_service.dart';
import 'package:tpos_mobile/services/print_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/sale_online_status_type.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

/// prefix command sử dụng trong ViewModel mô tả rằng đó là những lệnh và nó sẽ được UI gọi để thao tác với ViewModel
class SaleOnlineOrderListViewModel extends ScopedViewModel {
  SaleOnlineOrderListViewModel({
    ISettingService settingService,
    ITposApiService tposApi,
    PrintService print,
    NewDialogService dialog,
    DataService dataService,
    LogService logService,
    ShopConfigService shopConfigService,
  }) : super(logService: logService) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _print = print ?? locator<PrintService>();
    _dialog = dialog ?? GetIt.I<NewDialogService>();
    _dataService = dataService ?? locator<DataService>();
    _setting = settingService ?? locator<ISettingService>();
    _shopConfig = shopConfigService ?? GetIt.I<ShopConfigService>();

    // Load caaus hình thời gian
    _filterDateRange = getFilterDateTemplates().firstWhere(
        (f) => f.name == _setting.saleOnlineOrderListFilterDate,
        orElse: () => getTodayDateFilter());
    _filterFromDate = _filterDateRange.fromDate;
    _filterToDate = _filterDateRange.toDate;

    _keywordController
        .debounceTime(const Duration(milliseconds: 300))
        .listen((key) {
      onSearchingOrderHandled(key);
    });

    // Listen order insert, edit or deleted

    _dataServiceSubscription = _dataService.dataSubject
        .where((f) => f.value is SaleOnlineOrder || f.value is FastSaleOrder)
        .listen((order) {
      if (order.value is SaleOnlineOrder) {
        final updateOrder = order.value as SaleOnlineOrder;
        final existsItem = _orders?.firstWhere((f) => f.id == updateOrder.id,
            orElse: () => null);

        if (existsItem != null) {
          existsItem.telephone = updateOrder.telephone;
          existsItem.address = updateOrder.address;
          existsItem.cityName = updateOrder.cityName;
          existsItem.cityCode = updateOrder.cityCode;
          existsItem.districtName = updateOrder.districtName;
          existsItem.districtCode = updateOrder.districtCode;
          updateOrder.statusText = updateOrder.statusText;
          updateOrder.status = updateOrder.status;
          updateOrder.totalQuantity = updateOrder.totalQuantity;
          updateOrder.totalAmount = updateOrder.totalAmount;
          notifyListeners();
        }
      } else if (order.value is FastSaleOrder) {
        final updateFastSaleOrder = order.value as FastSaleOrder;
        // ignore: avoid_function_literals_in_foreach_calls
        updateFastSaleOrder.saleOnlineIds?.forEach((orderId) {
          final existsItem =
              _orders?.firstWhere((f) => f.id == orderId, orElse: () => null);
          _refreshOrder(existsItem);
        });
      }
    });
  }
  static const EVENT_GOBACK = "event.goBack";
  ITposApiService _tposApi;
  PrintService _print;
  NewDialogService _dialog;
  DataService _dataService;
  ISettingService _setting;
  ShopConfigService _shopConfig;
  final SaleOnlineOrderListFilterViewModel _filterViewModel =
      SaleOnlineOrderListFilterViewModel();

  StreamSubscription _dataServiceSubscription;

  /*BỘ LỌC VÀ ĐIỀU KIỆN LỌC*/
  bool _isFilterByDate = true;
  bool _isFilterByLiveCampaign = false;
  bool _isFilterByCrmTeam = false;
  bool _isFilterByStatus = false;
  bool _isFilterByPartner = false;
  bool _isFilterByPostId = false;

  /// Biến lưu tạm cho filter
  bool _isFilterByDateCache = true;
  bool _isFilterByLiveCampaignCache = false;
  bool _isFilterByCrmTeamCache = false;
  bool _isFilterByStatusCache = false;
  bool _isFilterByPartnerCache = false;
  bool _isFilterByPostIdCache = false;

  LiveCampaign _filterLiveCampaign;
  CRMTeam _filterCrmTeam;
  DateTime _filterFromDate;
  DateTime _filterToDate;
  Partner _filterPartner;
  AppFilterDateModel _filterDateRange;
  List<SaleOnlineStatusType> _filterStatusList;
  SaleOnlineStatusType _filterStatus;

  String _postId;

  bool get isFilterByDate => _isFilterByDate;
  bool get isFilterByLiveCampaign => _isFilterByLiveCampaign;
  bool get isFilterByCrmTeam => _isFilterByCrmTeam;
  bool get isFilterByStatus => _isFilterByStatus;
  bool get isFilterByPartner => _isFilterByPartner;
  bool get isFilterByPostId => _isFilterByPostId;

  /// Biến lưu tạm cho filter
  bool get isFilterByDateCache => _isFilterByDateCache;
  bool get isFilterByLiveCampaignCache => _isFilterByLiveCampaignCache;
  bool get isFilterByCrmTeamCache => _isFilterByCrmTeamCache;
  bool get isFilterByStatusCache => _isFilterByStatusCache;
  bool get isFilterByPartnerCache => _isFilterByPartnerCache;
  bool get isFilterByPostIdCache => _isFilterByPostIdCache;

  DateTime get filterFromDate => _filterFromDate;
  DateTime get filterToDate => _filterToDate;
  AppFilterDateModel get filterDateRange => _filterDateRange;
  List<SaleOnlineStatusType> get filterStatusList => _filterStatusList;
  SaleOnlineStatusType get filterStatus => _filterStatus;
  LiveCampaign get filterLiveCampaign => _filterLiveCampaign;
  CRMTeam get filterCrmTeam => _filterCrmTeam;
  Partner get filterPartner => _filterPartner;
  String get postId => _postId;

  /// Kiểm tra liệu danh sách đang chờ để xử lý có được chọn hết hay không?
  bool get isPendingListSelectAll =>
      _selectedManyOrders.length == selectedManOrderCheckIds.length;

  int get filterCount {
    int value = 0;
    if (_isFilterByDate) {
      value += 1;
    }
    if (_isFilterByLiveCampaign) {
      value += 1;
    }
    if (_isFilterByCrmTeam) {
      value += 1;
    }
    if (_isFilterByStatus) {
      value += 1;
    }
    if (_isFilterByPartner) {
      value += 1;
    }
    if (_isFilterByPostId) {
      value += 1;
    }
    return value;
  }

  int get filterCountCache {
    int value = 0;
    if (_isFilterByDateCache) {
      value += 1;
    }
    if (_isFilterByLiveCampaignCache) {
      value += 1;
    }
    if (_isFilterByCrmTeamCache) {
      value += 1;
    }
    if (_isFilterByStatusCache) {
      value += 1;
    }
    if (_isFilterByPartnerCache) {
      value += 1;
    }
    if (_isFilterByPostIdCache) {
      value += 1;
    }
    return value;
  }

  set isFilterByDate(bool value) {
    _isFilterByDate = value;
    notifyListeners();
  }

  set isFilterByStatus(bool value) {
    _isFilterByStatus = value;
    notifyListeners();
  }

  set isFilterByLiveCampaign(bool value) {
    _isFilterByLiveCampaign = value;
    notifyListeners();
  }

  set isFilterByCrmTeam(bool value) {
    _isFilterByCrmTeam = value;
    notifyListeners();
  }

  set isFilterByPartner(bool value) {
    _isFilterByPartner = value;
    notifyListeners();
  }

  set filterCrmTeam(CRMTeam value) {
    _filterCrmTeam = value;
    notifyListeners();
  }

  set filterLiveCampaign(LiveCampaign value) {
    _filterLiveCampaign = value;
    notifyListeners();
  }

  set filterPartner(Partner value) {
    _filterPartner = value;
    notifyListeners();
  }

  set filterDateRange(AppFilterDateModel value) {
    _filterDateRange = value;
    notifyListeners();
  }

  set filterFromDate(DateTime value) {
    _filterFromDate = value;
    notifyListeners();
  }

  set filterToDate(DateTime value) {
    _filterToDate = value;
    notifyListeners();
  }

  set isFilterByPostId(bool value) {
    _isFilterByPostId = value;
    notifyListeners();
  }

  set filterPostId(String value) {
    _postId = value;
  }

  Future<void> loadFilterStatusList() async {
    try {
      _filterStatusList = await _tposApi.getSaleOnlineStatus();
      notifyListeners();
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(content: e.toString());
    }
  }

  OldOdataFilter get filter {
    final List<OldFilterBase> filterItems = <OldFilterBase>[];

    // Theo trạng thái
    if (_isFilterByStatus) {
      final selectedStatus =
          _filterStatusList?.where((f) => f.selected == true)?.toList();
      if (selectedStatus != null && selectedStatus.isNotEmpty) {
        filterItems.add(
          OldOdataFilter(
            logic: "or",
            filters: selectedStatus
                .map(
                  (f) => OldOdataFilterItem(
                      operator: "eq", field: "StatusText", value: f.text),
                )
                .toList(),
          ),
        );
      }
    }

    // Theo khách hàng
    if (_isFilterByPartner && _filterPartner != null) {
      filterItems.add(
        OldOdataFilterItem(
            field: "PartnerId", operator: "eq", value: _filterPartner?.id),
      );
    }

    // Theo ngày
    if (_isFilterByDate && _filterFromDate != null && _filterToDate != null) {
      filterItems.add(OldOdataFilterItem(
          field: "DateCreated",
          operator: "ge",
          convertDatetime: _convertDatetimeToString,
          value: filterFromDate.toUtc()));
      filterItems.add(OldOdataFilterItem(
          field: "DateCreated",
          operator: "le",
          convertDatetime: _convertDatetimeToString,
          value: filterToDate.toUtc()));
    }

    // Theo bài đăng
    if (_isFilterByPostId && _postId != null) {
      filterItems.add(
        OldOdataFilterItem(
            field: "Facebook_PostId", operator: "eq", value: _postId),
      );
    }

    // Theo kênh bán
    if (_isFilterByCrmTeam && _filterCrmTeam != null) {
      filterItems.add(OldOdataFilterItem(
          field: "CRMTeamId", operator: "eq", value: _filterCrmTeam.id));
    }

    // Theo chiến dịch
    if (_isFilterByLiveCampaign && _filterLiveCampaign != null) {
      filterItems.add(OldOdataFilterItem(
          field: "LiveCampaignId",
          operator: "eq",
          value: _filterLiveCampaign.id,
          dataType: int));
    }

    if (filterItems.isNotEmpty) {
      return OldOdataFilter(logic: "and", filters: filterItems);
    } else {
      return null;
    }
  }

  String _convertDatetimeToString(DateTime input) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss'%2B00:00'").format(input);
  }

  void resetFilter() {
    _isFilterByDate = false;
    _isFilterByLiveCampaign = false;
    _isFilterByCrmTeam = false;
    _isFilterByStatus = false;
    _isFilterByPartner = false;
    _isFilterByPostId = false;
    notifyListeners();
  }

  /// Thực hiện gán giá trị filter cho biên tạm khi áp dụng
  void updateCheckFilterApply() {
    _isFilterByDateCache = _isFilterByDate;
    _isFilterByLiveCampaignCache = _isFilterByLiveCampaign;
    _isFilterByCrmTeamCache = _isFilterByCrmTeam;
    _isFilterByStatusCache = _isFilterByStatus;
    _isFilterByPartnerCache = _isFilterByPartner;
    _isFilterByPostIdCache = _isFilterByPostId;
    notifyListeners();
  }

  /// Thực hiện gán giá trị filter cho biên tạm khi mở filter
  void updateCheckFilterOpen() {
    _isFilterByDate = _isFilterByDateCache;
    _isFilterByLiveCampaign = _isFilterByLiveCampaignCache;
    _isFilterByCrmTeam = _isFilterByCrmTeamCache;
    _isFilterByStatus = _isFilterByStatusCache;
    _isFilterByPartner = _isFilterByPartnerCache;
    _isFilterByPostId = _isFilterByPostIdCache;
    notifyListeners();
  }

  /*// HẾT BỘ LỌC*/

  SaleOnlineOrderListFilterViewModel get filterViewModel => _filterViewModel;

  /* Check all*/

  bool isSelectEnable = false;

  bool get isCheckAll {
    if (_orders != null && _orders.isNotEmpty) {
      return !_orders.any((f) => f.checked == false);
    } else
      return false;
  }

  int get selectedItemCount {
    return _orders != null ? _orders.where((f) => f.checked).length : 0;
  }

  int get itemCount => _orders?.length ?? 0;

  List<SaleOnlineOrder> get selectedOrders {
    if (_orders == null) {
      return null;
    }
    if (_orders.isEmpty) {
      return null;
    }

    return _orders.where((f) => f.checked == true).toList();
  }

// order
  List<SaleOnlineOrder> _orders = <SaleOnlineOrder>[];
  List<SaleOnlineOrder> get orders => _orders;

  final List<SaleOnlineOrder> _selectedManyOrders = <SaleOnlineOrder>[];
  List<SaleOnlineOrder> get selectedManyOrders => _selectedManyOrders;

  /// Danh sách [SaleOnlineOrder Id] được chọn trong danh sách [SelectedManyOrders]
  List<String> selectedManOrderCheckIds = <String>[];

  final BehaviorSubject<List<SaleOnlineOrder>> _ordersController =
      BehaviorSubject();
  BehaviorSubject<List<SaleOnlineOrder>> get ordersObservable =>
      _ordersController;
  void onOrderAdd(List<SaleOnlineOrder> order) {
    _orders = order;
    if (_ordersController.isClosed == false) {
      _ordersController.add(_orders);
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

  List<SaleOnlineOrder> tempOrders = <SaleOnlineOrder>[];

  bool isCancelRequest = false;
  int get currentIndex => tempOrders?.length ?? 0;
  List<SaleOnlineOrder> lastResults;
  bool isFetchingOrder = false;

  Future<void> _filterBegin() async {
    setBusy(true);
    isFetchingOrder = true;
    await _filterWithPaging();
    setBusy(false);

    while (lastResults != null && lastResults.isNotEmpty) {
      if (isCancelRequest) {
        break;
      }
      await _filterWithPaging();
    }
    isFetchingOrder = false;
    notifyListeners();
  }

  Future<void> _filterWithPaging() async {
    try {
      lastResults = await _tposApi.getSaleOnlineOrdersFilter(
        skip: currentIndex,
        take: 2000,
        filter: filter,
        sort: _filterViewModel.sort,
      );

      tempOrders?.addAll(lastResults);
      amountTotal = 0.0;
      if (tempOrders != null) {
        // ignore: avoid_function_literals_in_foreach_calls
        tempOrders?.forEach((f) {
          amountTotal = amountTotal + (f.totalAmount ?? 0);
        });
      }
      onOrderAdd(tempOrders);
      notifyListeners();
    } catch (e, s) {
      logger.error("fukterWithPagingError", e, s);
      _dialog.showError(content: e.toString());
      lastResults = null;
    }
  }

  Future<void> searchOrderCommand(String keyword) async {
    onKeywordAdd(keyword);
  }

  Future<void> onSearchingOrderHandled(String keyword) async {
    if (keyword == null && keyword == "") {
      onOrderAdd(tempOrders);
      return;
    }
    try {
      final String key = StringUtils.removeVietnameseMark(keyword);
      final orders = tempOrders
          // ignore: avoid_bool_literals_in_conditional_expressions
          .where((f) => f.name != null
              ? StringUtils.removeVietnameseMark(f.name.toLowerCase())
                      .contains(key.toLowerCase()) ||
                  f.code.toString().toLowerCase().contains(key.toLowerCase()) ||
                  f.telephone
                      .toString()
                      .toLowerCase()
                      .contains(key.toLowerCase())
              : false)
          .toList();

      onOrderAdd(orders);
    } catch (e, s) {
      _dialog.showWarning(content: e.toString());
      logger.error("", e, s);
    }
  }

  ViewSaleOnlineOrder order = ViewSaleOnlineOrder();

  Product _selectedProduct;
  double amountTotal = 0.0;

  Product get selectedProduct => _selectedProduct;

  set selectedProduct(Product value) {
    _selectedProduct = value;
    notifyListeners();
  }

  final Queue<SaleOnlineOrder> _printOrderQuene = Queue<SaleOnlineOrder>();
  bool _isPrintBusy = false;

  /// In tất cả các [SaleOnlineOrder] được chọn trong danh sách đơn hàng.
  Future<void> printAllSelect() async {
    final select = _orders?.where((f) => f.checked == true)?.toList();
    if (select != null) {
      // ignore: avoid_function_literals_in_foreach_calls
      select.forEach((f) {
        printSaleOnlineTag(f);
      });
    }
  }

  /// In tất cả các [SaleOnlineOrder] được chọn trong danh sách [Đang chờ xử lý]
  Future<void> printSelectedItemsOnPendingList() async {
    final selectedItems = _orders
        ?.where((f) => selectedManOrderCheckIds.any((b) => b == f.id))
        ?.toList();

    if (selectedItems != null && selectedItems?.isNotEmpty == true) {
      // ignore: avoid_function_literals_in_foreach_calls
      selectedItems.forEach((element) {
        printSaleOnlineTag(element);
      });
    }
  }

  /// In phiếu
  Future<void> printSaleOnlineTag(SaleOnlineOrder order) async {
    _printOrderQuene.addFirst(order);

    if (_isPrintBusy) {
      return;
    }

    setBusy(true);

    while (_printOrderQuene.isNotEmpty) {
      _isPrintBusy = true;
      await Future.delayed(const Duration(milliseconds: 100));

      try {
        final printOrder = _printOrderQuene.last;
        if (Platform.isIOS) {
          await Future.delayed(const Duration(seconds: 2));
        } else {
          await Future.delayed(const Duration(seconds: 1));
        }

        await _print.printSaleOnlineTag(
            order: printOrder,
            isPrintNode:
                _shopConfig.saleFacebookConfig.printAllOrderNoteWhenReprint);
        _printOrderQuene.remove(printOrder);

        printOrder.checked = false;
        notifyListeners();
        notifyListeners();
      } catch (e, s) {
        logger.error("", e, s);
        _dialog.showError(content: e.toString());
        _printOrderQuene.clear();
        break;
      }
    }
    setBusy(false);
    _isPrintBusy = false;
  }

  void init({Partner filterPartner, String postId}) {
    if (filterPartner != null) {
      _filterPartner = filterPartner;
      _isFilterByPartner = true;
    }

    _postId = postId;
    _isFilterByPostId = postId != null;

    if (filterPartner != null || postId != null) {
      _isFilterByDate = false;
    }
  }

  // initCommand
  Future<void> initCommand() async {
    // Tải trạng thái đơn hàng
    setBusy(true);
    await _filterViewModel.initCommand();

    try {
      await refreshOrdersCommand();
    } catch (e) {
      _dialog.showError(content: e.toString());
    }

    //Lưu cấu hình lọc
    _setting.saleOnlineOrderListFilterDate = _filterDateRange?.name;
    setBusy(false);
  }

  /// amplyFilterCommand
  Future<void> amplyFilterCommand() async {
    //save setting
    setBusy(true);
    tempOrders.clear();
    await _filterBegin();
    setBusy(false);
  }

  /// RefreshFilterCommand
  Future<void> refreshOrdersCommand() async {
    if (isFetchingOrder) {
      _dialog.showWarning(
          content: S.current.saleOnlineOrder_PleaseWaitDownload);
      return;
    }
    lastResults = null;
    tempOrders?.clear();
    await _filterBegin();
  }

  //
  Future<void> enableSelectedCommand(SaleOnlineOrder selectedOrder) async {
    selectedOrder.checked = true;
    isSelectEnable = true;
    notifyListeners();
  }

  // Chọn/Bỏ chọn item
  Future<void> selectedItemChangedCommand(SaleOnlineOrder selectedOrder) async {
    selectedOrder.checked = !selectedOrder.checked;
    notifyListeners();
  }

  // Lệnh đóng panel lựa chọn
  Future<void> closeSelectPanelCommand() async {
    isSelectEnable = false;
    notifyListeners();
  }

  Future unSelectAllCommand() async {
    // ignore: avoid_function_literals_in_foreach_calls
    orders?.forEach((f) {
      f.checked = false;
    });
    if (_ordersController.isClosed == false) {
      _ordersController.add(_orders);
    }

    notifyListeners();
  }

  Future<void> selectAllItemCommand() async {
    if (_orders.any((f) => f.checked == false)) {
      // ignore: avoid_function_literals_in_foreach_calls
      _orders?.forEach((f) {
        f.checked = true;
      });
    } else {
      // ignore: avoid_function_literals_in_foreach_calls
      _orders?.forEach((f) {
        f.checked = false;
      });
    }

    notifyListeners();
  }

  List<String> get selectedIds =>
      _orders?.where((f) => f.checked == true)?.map((ff) => ff.id)?.toList();

  // Đang thao tác . Vui lòng chờ
  Future<FastSaleOrderAddEditData> prepareFastSaleOrder() async {
    setBusy(true, message: S.current.processing);

    final selectedIds =
        _orders.where((f) => f.checked == true).map((ff) => ff.id).toList();
    if (selectedIds == null || selectedIds.isEmpty) {
      _dialog.showWarning(
          title: S.current.saleOnlineOrder_InvoiceNotSelected,
          content: S.current.saleOnlineOrder_ChooseOrderToCreate);
      setBusy(false, message: "");
      return null;
    }

    final firstSelect = selectedOrders.first;
    // khách facebook
    //Các đơn hàng phải cùng facebook
    if (selectedOrders
        .any((f) => f.facebookAsuid != firstSelect.facebookAsuid)) {
      _dialog.showWarning(
          content: S.current.saleOnlineOrder_OrderTheSameFacebook);
      setBusy(false, message: "");
      return null;
    }

    try {
      final fastSaleOrder = await _tposApi.prepareFastSaleOrder(selectedIds);
      setBusy(false, message: "");
      return fastSaleOrder;
    } catch (e, s) {
      logger.error("prepareFastSaleOrder", e, s);
      _dialog.showError(content: e.toString());
    }

    setBusy(false, message: "");
    return null;
  }

  Future<void> updateEditOrderCommand(
      SaleOnlineOrder oldOrder, SaleOnlineOrder newOrder) async {
    _updateEditOrder(oldOrder, newOrder);
    if (_ordersController != null && _ordersController.isClosed == false) {
      _ordersController.add(_orders);
    }
  }

  Future _refreshOrder(SaleOnlineOrder order) async {
    try {
      final newOrder = await _tposApi.getOrderById(order.id);
      if (newOrder != null) {
        _updateEditOrder(order, newOrder);
      }
      notifyListeners();
    } catch (e, s) {
      logger.error("", e, s);
    }
  }

  /// Cập nhật thông tin đơn hàng
  void _updateEditOrder(SaleOnlineOrder oldOrder, SaleOnlineOrder newOrder) {
    assert(newOrder != null);
    oldOrder.address = newOrder.address;
    oldOrder.telephone = newOrder.telephone;
    oldOrder.status = newOrder.status;
    oldOrder.statusText = newOrder.statusText;
    oldOrder.totalQuantity = newOrder.totalQuantity;
    oldOrder.totalAmount = newOrder.totalAmount;
    notifyListeners();
  }

  /// Cập nhật sau khi tạo hóa đơn
  Future<void> updateAfterCreateInvoiceCommand() async {
    try {
      final List<SaleOnlineOrder> updatePrintOrders = <SaleOnlineOrder>[];
      if (_selectedManyOrders != null)
        updatePrintOrders.addAll(_selectedManyOrders);
      if (selectedOrders != null) {
        updatePrintOrders.addAll(selectedOrders);
      }
      // ignore: avoid_function_literals_in_foreach_calls
      updatePrintOrders.forEach((oldOrder) async {
        final newOrder = await _tposApi.getOrderById(oldOrder.id);
        if (newOrder != null) {
          _updateEditOrder(oldOrder, newOrder);
        }
      });

      if (_ordersController != null) {
        if (_ordersController.isClosed == false) {
          _ordersController.add(_orders);
        }
      }
      notifyListeners();
    } catch (e, s) {
      logger.error("update after create invoice command", e, s);
    }
  }

  Future<bool> deleteOrder(SaleOnlineOrder order) async {
    try {
      await _tposApi.deleteSaleOnlineOrder(order.id);
      _dialog.showToast(
          message: "${S.current.saleOnlineOrder_DeletedOrder} ${order.code}");
      //remove from list
      _orders.remove(order);
      if (_ordersController.isClosed == false) {
        _ordersController?.add(_orders);
      }

      return true;
    } catch (e, s) {
      logger.error("delete sale online order", e, s);
      _dialog.showError(content: e.toString());
      return false;
    }
  }

  Future<List<SaleOnlineOrderDetail>> getProductById(
      SaleOnlineOrder order) async {
    final result = await _tposApi.getOrderById(order.id);
    return result?.details;
  }

  void changeCheckItem(SaleOnlineOrder item) {
    item.checked = !item.checked;
    notifyListeners();
  }

  void addBasketItem(SaleOnlineOrder item) {
    final SaleOnlineOrder existItem = _selectedManyOrders
        .firstWhere((f) => f.id == item.id, orElse: () => null);

    if (existItem != null) {
      _selectedManyOrders.remove(existItem);
      if (selectedManOrderCheckIds.any((f) => f == item.id)) {
        selectedManOrderCheckIds.remove(existItem.id);
      }
    } else {
      _selectedManyOrders.add(item);
      if (!selectedManOrderCheckIds.any((f) => f == item.id)) {
        selectedManOrderCheckIds.add(item.id);
      }
    }
    notifyListeners();
  }

  bool checkBasketItem(SaleOnlineOrder item) {
    return _selectedManyOrders.any((f) => f.id == item.id);
  }

  int countBasketItem() {
    return _selectedManyOrders.length;
  }

  /// Thay đổi trạng thái của đơn hàng [item] thành [status] Thay đổi được cập nhật trực tiếp
  /// tới máy chủ
  Future changeStatus(SaleOnlineOrder item, String status) async {
    setBusy(true);
    try {
      await _tposApi.saveChangeStatus(<String>[item.id], status);
      item.statusText = status;
      notifyListeners();
      _dialog.showToast(message: S.current.saleOnlineOrder_StatusOrderChanged);
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(content: e.toString());
    }
    setBusy(false);
  }

  /// Check hoặc uncheck [SaleOnlineOrder] trong danh sách [Chờ xử lý]
  /// Nếu [order] đã có trong danh sách chọn nó sẽ được xóa đi và ngược lại
  void handleCheckOnPendingList(SaleOnlineOrder order) {
    if (selectedManOrderCheckIds.any((f) => f == order.id)) {
      selectedManOrderCheckIds.remove(order.id);
    } else {
      selectedManOrderCheckIds.add(order.id);
    }
    notifyListeners();
  }

  /// Xóa 1 [SaleOnlineOrder] ra khỏi [_selectedManyOrders] và yêu cầu cập nhật giao diện
  void removeSelectedPendingItem(SaleOnlineOrder order) {
    if (_selectedManyOrders.any((f) => f.id == order.id)) {
      if (selectedManOrderCheckIds.any((element) => element == order.id)) {
        selectedManOrderCheckIds.remove(order.id);
      }
      _selectedManyOrders.remove(order);
    }
    notifyListeners();
  }

  /// Xóa tất cả các [SaleOnlineOrder] trong danh sách [SelectedManyOrder] và yêu cầu cập nhật giao diện
  void removeAllSelectedPendingItem() {
    _selectedManyOrders
        ?.removeWhere((f) => selectedManOrderCheckIds.any((b) => b == f.id));
    selectedManOrderCheckIds.clear();
    notifyListeners();
  }

  /// Check tất cả danh sách đang chờ xử lý hoặc bỏ check tất cả
  void handleCheckAllPendingList(bool isCheck) {
    if (isCheck) {
      // ignore: prefer_final_in_for_each
      for (var itm in selectedManyOrders) {
        if (!selectedManOrderCheckIds.any((f) => f == itm.id)) {
          selectedManOrderCheckIds.add(itm.id);
        }
      }
    } else {
      selectedManOrderCheckIds.clear();
    }
    notifyListeners();
  }

  /// Xuất excel danh sách được chọn hoặc toàn bộ danh sách theo điều kiện lọc nếu không có danh sách được chọn
  Future<void> exportExcel(BuildContext context) async {
    setBusy(true, message: "");

    final select = _orders?.where((f) => f.checked == true)?.toList();
    final ids = select.map((value) => value.id).toList();

    List<String> statusTexts = [];
    if (isFilterByStatus) {
      final selectedStatus =
          _filterStatusList?.where((f) => f.selected == true)?.toList();

      // ignore: avoid_function_literals_in_foreach_calls
      selectedStatus.forEach((element) {
        print(element.text);
      });
      statusTexts = selectedStatus.map((value) => value.text).toList();
    }

    try {
      if (isFilterByPartner || isFilterByPostId) {
        _dialog.showError(
            title: S.current.notification,
            content:
                "${S.current.sorry}. ${S.current.saleOnlineOrder_NoSupportExportExcel}!");
      } else {
        final String result = await _tposApi.exportInvoiceSaleOnline(
            keySearch: keyword,
            statusTexts: isFilterByStatus ? statusTexts : [],
            campaignId: isFilterByLiveCampaign ? filterLiveCampaign?.id : null,
            crmTeamId: isFilterByCrmTeam ? filterCrmTeam?.id : null,
            fromDate: isFilterByDate
                ? _filterFromDate.toStringFormat("yyyy-MM-ddTHH:mm:ss")
                : null,
            toDate: isFilterByDate
                ? _filterToDate.toStringFormat("yyyy-MM-ddTHH:mm:ss")
                : null,
            ids: ids);
        if (result != null) {
          showDialogOpenFileExcel(
              content:
                  "${S.current.fileWasSavedInFolder}: $result. ${S.current.doYouWantToOpenFile}?",
              context: context,
              path: result);
        }
      }
      setBusy(false, message: "");
    } catch (e, s) {
      setBusy(false, message: "");
      logger.error("", e, s);
      _dialog.showError(content: e);
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
                      OpenFile.open(path ?? '');
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

  @override
  void dispose() {
    _dataServiceSubscription?.cancel();
    _ordersController.close();
    _keywordController.close();
    _filterViewModel.dispose();
    isCancelRequest = true;
    super.dispose();
  }
}

class SaleOnlineOrderListFilterViewModel extends ScopedViewModel {
  OldOdataSortItem sort;
  List<OldOdataSortItem> sorts = <OldOdataSortItem>[];

  Partner selectedPartner;
  LiveCampaign selectedLiveCampaign;
  String filterLiveVideoId;

  void _initDefaultSort() {
    sorts.add(OldOdataSortItem(field: "DateCreated", dir: "desc"));
    sorts.add(OldOdataSortItem(field: "DateCreated", dir: "asc"));
    sorts.add(OldOdataSortItem(field: "SessionIndex", dir: "desc"));
    sorts.add(OldOdataSortItem(field: "SessionIndex", dir: "asc"));
    sorts.add(OldOdataSortItem(field: "Name", dir: "asc"));
    sort = sorts.first;
  }

  Future<void> initCommand() async {
    _initDefaultSort();

    notifyListeners();
  }

  Future<void> setSortCommand(String value) async {
    sort = sorts.firstWhere((f) => "${f.field}_${f.dir}" == value,
        orElse: () => null);
  }
}
