import 'package:intl/intl.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_partner.dart';
import 'package:tpos_mobile/src/tpos_apis/models/supplier_report.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class SupplierReportViewModel extends ViewModelBase {
  SupplierReportViewModel({
    ITposApiService tposApi,
    DialogService dialogService,
  }) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _dialog = dialogService ?? locator<DialogService>();

    filterToDate = _filterDateRange.toDate;
    filterFromDate = _filterDateRange.fromDate;
  }
  ITposApiService _tposApi;
  DialogService _dialog;

  int limit = 20;
  int skip = 0;
  int max = 0;
  int _currentPage = 0;
  int display = 0;

  PartnerFPO _supplier;
  CompanyOfUser _companyOfUser;

  List<SupplierReport> _supplierReports = [];

  CompanyOfUser get companyOfUser => _companyOfUser;
  set companyOfUser(CompanyOfUser value) {
    _companyOfUser = value;
    notifyListeners();
  }

  PartnerFPO get supplier => _supplier;
  set supplier(PartnerFPO value) {
    _supplier = value;
    notifyListeners();
  }

  List<SupplierReport> get supplierReports => _supplierReports;
  set supplierReports(List<SupplierReport> value) {
    _supplierReports = value;
    notifyListeners();
  }

  Future<void> getSupplierReports() async {
    limit = 20;
    skip = 0;
    max = 0;
    _currentPage = 0;
    setState(true);
    try {
      supplierReports = await _tposApi.getSupplierReports(
          display: display == 0 ? "all" : "not_zero",
          dateFrom: DateFormat("dd/MM/yyyy").format(filterFromDate),
          dateTo: DateFormat("dd/MM/yyyy").format(filterToDate),
          take: limit,
          skip: skip,
          page: _currentPage + 1,
          pageSize: 20,
          resultSelection: "supplier",
          partnerId: _supplier == null ? null : _supplier.id.toString(),
          companyId: _companyOfUser == null ? null : _companyOfUser.value,
          userId: null,
          categId: null);
      if (supplierReports.isNotEmpty) {
        max = supplierReports[0].totalItem;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadSupplierReportFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  void changeDisplay(int value) {
    display = value;
    notifyListeners();
  }

  // FILTER

  AppFilterDateModel _filterDateRange = getDateFilterThisMonth();

  AppFilterDateModel get filterDateRange => _filterDateRange;

  set filterDateRange(AppFilterDateModel value) {
    _filterDateRange = value;
    notifyListeners();
  }

  DateTime _filterFromDate;
  DateTime _filterToDate;
  bool _isFilterByDate = true;
  bool get isFilterByDate => _isFilterByDate;

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

  set isFilterByDate(bool value) {
    _isFilterByDate = value;
    notifyListeners();
  }

  int countFilter() {
    int filter = 2;
    if (_companyOfUser != null) {
      filter++;
    }
    if (_supplier != null) {
      filter++;
    }
    return filter;
  }

  // Reset filter
  void resetFilter() {
//    _isFilterByDate = false;
    _companyOfUser = null;
    _supplier = null;
    display = 0;
    notifyListeners();
  }

  // XỬ LÝ LOADMORE
  List<SupplierReport> _supplierReportsMore;
  Future<List<SupplierReport>> getSupplierReportsMore() async {
    try {
      skip += limit;
      _supplierReportsMore = await _tposApi.getSupplierReports(
          display: display == 0 ? "all" : "not_zero",
          dateFrom: DateFormat("dd/MM/yyyy").format(filterFromDate),
          dateTo: DateFormat("dd/MM/yyyy").format(filterToDate),
          take: limit,
          skip: skip,
          page: _currentPage + 1,
          pageSize: 20,
          resultSelection: "supplier",
          partnerId: _supplier == null ? null : _supplier.id.toString(),
          companyId: _companyOfUser == null ? null : _companyOfUser.value,
          userId: null,
          categId: null);
    } catch (e, s) {
      logger.error("loadSupplierReportFail", e, s);
      _dialog.showError(error: e);
    }
    return _supplierReportsMore;
  }

  Future handleItemCreated(int index) async {
    final itemPosition = index + 1;
    final requestMoreData = itemPosition % limit == 0 && itemPosition != 0;
    final pageToRequest = itemPosition ~/ limit;

    if (requestMoreData && pageToRequest > _currentPage) {
      print('handleItemCreated | pageToRequest: $pageToRequest');
      _currentPage = pageToRequest;
      _showLoadingIndicator();
      if (skip + limit < max) {
        final newFetchedItems = await getSupplierReportsMore();
        await Future.delayed(const Duration(seconds: 1));
        supplierReports.addAll(newFetchedItems);
      }
      _removeLoadingIndicator();
    }
  }

  void _showLoadingIndicator() {
    _supplierReports.add(temp);
    notifyListeners();
  }

  void _removeLoadingIndicator() {
    _supplierReports.remove(temp);
    notifyListeners();
  }
}

var temp = SupplierReport(partnerName: "temp");
