import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner_staff_detail_report.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class PartnerStaffDetailReportViewModel extends ViewModelBase {
  ITposApiService _tposApi;
  DialogService _dialog;
  PartnerStaffDetailReportViewModel({
    ITposApiService tposApi,
    DialogService dialogService,
  }) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _dialog = dialogService ?? locator<DialogService>();
  }

  int limit = 20;
  int skip = 0;
  int max = 0;
  int _currentPage = 0;

  List<PartnerStaffDetailReport> _partnerStaffDetailReports = [];
  List<PartnerStaffDetailReport> get partnerStaffDetailReports =>
      _partnerStaffDetailReports;
  set partnerStaffDetailReports(List<PartnerStaffDetailReport> value) {
    _partnerStaffDetailReports = value;
    notifyListeners();
  }

  Future<void> getPartnerStaffDetailReports(
      {String dataFrom,
      String dateTo,
      String resultSelection,
      String partnerId}) async {
    limit = 10;
    skip = 0;
    max = 0;
    _currentPage = 0;

    setState(true);
    try {
      var result = await _tposApi.getPartnerStaffDetailReports(
        pageSize: 10,
        page: _currentPage + 1,
        skip: skip,
        take: limit,
        dataFrom: dataFrom,
        dateTo: dateTo,
        resultSelection: resultSelection,
        partnerId: partnerId,
      );
      if (result != null) {
        partnerStaffDetailReports = result;
      }
      if (partnerStaffDetailReports.isNotEmpty) {
        max = partnerStaffDetailReports[0].totalItem;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadPartnerDetailReportsFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  // XỬ LÝ LOADMORE

  List<PartnerStaffDetailReport> _partnerStaffDetailReportsMore;

  Future<List<PartnerStaffDetailReport>> getPartnerStaffDetailReportsMore(
      {String dataFrom,
      String dateTo,
      String resultSelection,
      String partnerId}) async {
    try {
      skip += limit;
      var result = await _tposApi.getPartnerStaffDetailReports(
        pageSize: 10,
        page: _currentPage + 1,
        skip: skip,
        take: limit,
        dataFrom: dataFrom,
        dateTo: dateTo,
        resultSelection: resultSelection,
        partnerId: partnerId,
      );
      if (result != null) {
        _partnerStaffDetailReportsMore = result;
      }
    } catch (e, s) {
      logger.error("loadPartnerDetailReportsFail", e, s);
      _dialog.showError(error: e);
    }
    return _partnerStaffDetailReportsMore;
  }

  Future handleItemCreated(
    int index, {
    String dataFrom,
    String dateTo,
    String resultSelection,
    String partnerId,
  }) async {
    var itemPosition = index + 1;
    var requestMoreData = itemPosition % limit == 0 && itemPosition != 0;
    var pageToRequest = itemPosition ~/ limit;

    if (requestMoreData && pageToRequest > _currentPage) {
      print('handleItemCreated | pageToRequest: $pageToRequest');
      _currentPage = pageToRequest;
      _showLoadingIndicator();
      if (skip + limit < max) {
        var newFetchedItems = await getPartnerStaffDetailReportsMore(
            dataFrom: dataFrom,
            dateTo: dateTo,
            resultSelection: resultSelection,
            partnerId: partnerId);
        await Future.delayed(Duration(seconds: 1));
        partnerStaffDetailReports.addAll(newFetchedItems);
      }
      _removeLoadingIndicator();
    }
  }

  void _showLoadingIndicator() {
    _partnerStaffDetailReports.add(temp);
    notifyListeners();
  }

  void _removeLoadingIndicator() {
    _partnerStaffDetailReports.remove(temp);
    notifyListeners();
  }
}

var temp = new PartnerStaffDetailReport(name: "temp");
