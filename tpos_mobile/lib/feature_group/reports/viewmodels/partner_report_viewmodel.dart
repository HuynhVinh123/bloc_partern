import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_application_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_partner.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner_category.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner_report.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class PartnerReportViewModel extends ViewModelBase {
  ITposApiService _tposApi;
  DialogService _dialog;
  PartnerReportViewModel({
    ITposApiService tposApi,
    DialogService dialogService,
  }) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _dialog = dialogService ?? locator<DialogService>();

    filterToDate = _filterDateRange.toDate;
    filterFromDate = _filterDateRange.fromDate;
  }

  int limit = 20;
  int skip = 0;
  int max = 0;
  int _currentPage = 0;
  int display = 0;
  String positionReport = "1";
  PartnerCategory _partnerCategory;
  ApplicationUserFPO _applicationUserFPO;
  PartnerFPO _partnerFPO;
  CompanyOfUser _companyOfUser;

  List<PartnerReport> _partnerReports = [];

  PartnerFPO get partnerFPO => _partnerFPO;
  set partnerFPO(PartnerFPO value) {
    _partnerFPO = value;
    notifyListeners();
  }

  ApplicationUserFPO get applicationUserFPO => _applicationUserFPO;
  set applicationUserFPO(ApplicationUserFPO value) {
    _applicationUserFPO = value;
    notifyListeners();
  }

  PartnerCategory get partnerCategory => _partnerCategory;
  set partnerCategory(PartnerCategory value) {
    _partnerCategory = value;
    notifyListeners();
  }

  CompanyOfUser get companyOfUser => _companyOfUser;
  set companyOfUser(CompanyOfUser value) {
    _companyOfUser = value;
    notifyListeners();
  }

  List<PartnerReport> get partnerReports => _partnerReports;
  set partnerReports(List<PartnerReport> value) {
    _partnerReports = value;
    notifyListeners();
  }

  Future<void> getPartnerReports() async {
    limit = 20;
    skip = 0;
    max = 0;
    _currentPage = 0;
    setState(true);
    try {
      partnerReports = await _tposApi.getPartnerReports(
          display: display == 0 ? "all" : "not_zero",
          dataFrom: DateFormat("dd/MM/yyyy").format(filterFromDate),
          dateTo: DateFormat("dd/MM/yyyy").format(filterToDate),
          take: limit,
          skip: skip,
          page: _currentPage + 1,
          pageSize: 20,
          resultSelection: "customer",
          partnerId: _partnerFPO == null ? null : _partnerFPO.id.toString(),
          companyId: _companyOfUser == null ? null : _companyOfUser.value,
          userId: _applicationUserFPO == null ? null : _applicationUserFPO.id,
          categid:
              _partnerCategory == null ? null : _partnerCategory.id.toString(),
          typeReport: positionReport);
      if (partnerReports.isNotEmpty) {
        max = partnerReports[0].totalItem;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadPartnerReportFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  void changeDisplay(int value) {
    display = value;
    notifyListeners();
  }

  void changePosition(String value) async {
    positionReport = value;
    resetFilter();
    await getPartnerReports();
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
    if (_partnerCategory != null) {
      filter++;
    }
    if (_partnerFPO != null) {
      filter++;
    }
    if (_applicationUserFPO != null) {
      filter++;
    }
    return filter;
  }

  // Reset filter
  void resetFilter() {
//    _isFilterByDate = false;
    _companyOfUser = null;
    _partnerCategory = null;
    _partnerFPO = null;
    _applicationUserFPO = null;
    display = 0;
    notifyListeners();
  }

  // XỬ LÝ LOADMORE

  List<PartnerReport> _partnerReportsMore;

  Future<List<PartnerReport>> getPartnerReportsMore() async {
    try {
      skip += limit;
      _partnerReportsMore = await _tposApi.getPartnerReports(
          display: display == 0 ? "all" : "not_zero",
          dataFrom: DateFormat("dd/MM/yyyy").format(filterFromDate),
          dateTo: DateFormat("dd/MM/yyyy").format(filterToDate),
          take: limit,
          skip: skip,
          page: _currentPage + 1,
          pageSize: 20,
          resultSelection: "customer",
          partnerId: _partnerFPO == null ? null : _partnerFPO.id.toString(),
          companyId: _companyOfUser == null ? null : _companyOfUser.value,
          userId: _applicationUserFPO == null ? null : _applicationUserFPO.id,
          categid:
              _partnerCategory == null ? null : _partnerCategory.id.toString(),
          typeReport: positionReport);
    } catch (e, s) {
      logger.error("loadPartnerReportFail", e, s);
      _dialog.showError(error: e);
    }
    return _partnerReportsMore;
  }

  Future handleItemCreated(int index) async {
    var itemPosition = index + 1;
    var requestMoreData = itemPosition % limit == 0 && itemPosition != 0;
    var pageToRequest = itemPosition ~/ limit;

    if (requestMoreData && pageToRequest > _currentPage) {
      print('handleItemCreated | pageToRequest: $pageToRequest');
      _currentPage = pageToRequest;
      _showLoadingIndicator();
      if (skip + limit < max) {
        var newFetchedItems = await getPartnerReportsMore();
        await Future.delayed(Duration(seconds: 1));
        partnerReports.addAll(newFetchedItems);
      }
      _removeLoadingIndicator();
    }
  }

  void _showLoadingIndicator() {
    _partnerReports.add(temp);
    notifyListeners();
  }

  void _removeLoadingIndicator() {
    _partnerReports.remove(temp);
    notifyListeners();
  }
}

var temp = new PartnerReport(partnerName: "temp");
