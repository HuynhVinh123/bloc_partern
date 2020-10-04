import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/log_services/log_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/product_category.dart';
import 'package:tpos_mobile/src/tpos_apis/models/stock_report_result.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';

class InventoryReportViewModel extends ViewModel {
  ITposApiService _tposApi;
  DialogService _dialog;

  InventoryReportViewModel(
      {ITposApiService tposApi,
      DialogService dialogService,
      LogService logService})
      : super(logService: logService) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _dialog = dialogService ?? locator<DialogService>();

    //set giá trị mặc định
    isFilterByDate = true;
    var now = DateTime.now();
    _fromDate = new DateTime(now.year, now.month, 1);
    _toDate = new DateTime(_fromDate.year, _fromDate.month + 1, 1)
        .add(Duration(days: -1));

    _keywordSubject.debounceTime(Duration(microseconds: 500)).listen((key) {
      _onSearchOnList(key);
    });
  }

  StockReport _stockReport;
  List<StockReportData> _stockRepotDatasResult;

  // Bộ lọc
  bool isFilterByDate = false;
  bool _isFilterByStock = false;
  bool _isFilterByProductGroup = false;
  bool _isIncludeCancel = false;
  bool _isIncludeRefund = false;
  String _keyword;

  DateTime _fromDate;
  DateTime _toDate;
  String _dateTimeStringValue;
  ProductCategory _productCategory;
  StockWareHouse _selectedWareHouse;
  AppFilterDateModel _filterDateRange = AppFilterDateModel.thisMonth();

  var _keywordSubject = BehaviorSubject<String>();

  DateTime get fromDate => _fromDate;
  DateTime get toDate => _toDate;
  String get filterByDateString {
    if (_dateTimeStringValue == null && _fromDate != null && _toDate != null)
      return "${DateFormat("dd/MM/yyyy").format(_fromDate)} -> ${DateFormat("dd/MM/yyyy").format(_toDate)}";
    else {
      return _dateTimeStringValue;
    }
  }

  bool get isFilterByStock => _isFilterByStock;
  bool get isFilterByProductGroup => _isFilterByProductGroup;
  bool get isIncludeCancel => _isIncludeCancel;
  bool get isIncludeRefund => _isIncludeRefund;

  AppFilterDateModel get filterDateRange => _filterDateRange;

  StockReport get stockReport => _stockReport;
  StockWareHouse get selectedWareHouse => _selectedWareHouse;
  ProductCategory get selectedProductCategory => _productCategory;
  List<StockReportData> get stockReportDatas => _stockReport?.data;
  List<StockReportData> get stockRepotDatasResult => _stockRepotDatasResult;
  double get beginQuantity => _stockReport?.aggregates?.begin?.sum;
  double get endQuantity => _stockReport?.aggregates?.end?.sum;
  double get importQuantity => _stockReport?.aggregates?.import?.sum;
  double get exportQuantity => _stockReport?.aggregates?.export?.sum;

  Sink<String> get keywordSink => _keywordSubject.sink;
  set isFilterByStock(bool value) {
    _isFilterByStock = value;
    notifyListeners();
  }

  void setIsIncludeCancel(bool value) {
    _isIncludeCancel = value;
    notifyListeners();
  }

  void setIsIncludeRefund(bool value) {
    _isIncludeRefund = value;
    notifyListeners();
  }

  void setIsFilterByProductGroup(bool value) {
    _isFilterByProductGroup = value;
    notifyListeners();
  }

  set fromDate(DateTime value) {
    _fromDate = value;
    notifyListeners();
  }

  set toDate(DateTime value) {
    _toDate = value;
    notifyListeners();
  }

  set selectedWareHouse(StockWareHouse value) {
    _selectedWareHouse = value;
    notifyListeners();
  }

  set selectedProductCategory(ProductCategory value) {
    _productCategory = value;
    notifyListeners();
  }

  set filterDateRange(AppFilterDateModel value) {
    _filterDateRange = value;
    notifyListeners();
  }

  /// Lấy dữ liệu và tải report
  Future<void> initData() async {
    onStateAdd(true, message: "Đang tải...");
    try {
      _stockReport = await _tposApi.getStockReport(
        fromDate: isFilterByDate ? _fromDate : null,
        toDate: isFilterByDate ? _toDate : null,
        isIncludeCanceled: _isIncludeCancel,
        isIncludeReturned: _isIncludeRefund,
        productCategoryId:
            _isFilterByProductGroup ? _productCategory?.id : null,
        wareHouseId: _isFilterByStock ? _selectedWareHouse?.id : null,
      );

      _stockRepotDatasResult = this.stockReportDatas;
      notifyListeners();
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
    }
    onStateAdd(false);
  }

  void _onSearchOnList(String keyword) async {
    if (keyword == null || keyword.isEmpty) {
      _stockRepotDatasResult = stockReportDatas;
      notifyListeners();
      return;
    }
    var keywordNoSign = keyword?.toLowerCase();
    keywordNoSign = StringUtils.removeVietnameseMark(keywordNoSign);
    _stockRepotDatasResult =
        await compute(_searchOnThread, [stockReportDatas, keywordNoSign]);
    notifyListeners();
  }

  static List<StockReportData> _searchOnThread(param) {
    List<StockReportData> _source = param[0];
    String keyword = param[1];
    return param[0]
        ?.where(
          (f) =>
              StringUtils.removeVietnameseMark(f.productName.toLowerCase())
                  .contains(keyword) ||
              StringUtils.removeVietnameseMark(f.productCode?.toLowerCase() ?? "")
                  .contains(keyword),
        )
        ?.toList();
  }

  void resetFilter() {
    _isFilterByProductGroup = false;
    _isFilterByStock = false;
    isFilterByDate = false;
    _productCategory = null;
    _isIncludeRefund = false;
    _isIncludeCancel = false;
    notifyListeners();
  }

  void applyFilter() {
    initData();
  }

  @override
  void dispose() {
    _keywordSubject?.close();
    super.dispose();
  }
}
