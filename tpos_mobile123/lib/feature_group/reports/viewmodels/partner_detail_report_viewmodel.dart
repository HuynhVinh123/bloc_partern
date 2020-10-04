import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner_detail_report.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class PartnerDetailReportViewModel extends ViewModelBase {
  ITposApiService _tposApi;
  DialogService _dialog;
  PartnerDetailReportViewModel({
    ITposApiService tposApi,
    DialogService dialogService,
  }) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _dialog = dialogService ?? locator<DialogService>();
  }

  int limit = 10;
  int skip = 0;
  int max = 0;
  int _currentPage = 0;

  List<PartnerDetailReport> _partnerDetailReports = [];
  List<PartnerDetailReport> get partnerDetailReports => _partnerDetailReports;
  set partnerDetailReports(List<PartnerDetailReport> value) {
    _partnerDetailReports = value;
    notifyListeners();
  }

  Future<void> getPartnerDetailReports({
    String dataFrom,
    String dateTo,
    String resultSelection,
    String companyId,
    String partnerId,
    String userId,
    String categId,
  }) async {
    limit = 10;
    skip = 0;
    max = 0;
    _currentPage = 0;
    setState(true);
    try {
      var result = await _tposApi.getPartnerDetailReports(
        pageSize: 10,
        page: _currentPage + 1,
        skip: skip,
        take: limit,
        dataFrom: dataFrom,
        dateTo: dateTo,
        resultSelection: resultSelection,
        companyId: companyId,
        partnerId: partnerId,
      );
      if (result != null) {
        partnerDetailReports = result;
      }
      if (partnerDetailReports.isNotEmpty) {
        max = partnerDetailReports[0].totalItem;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadPartnerDetailReportsFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  // XỬ LÝ LOADMORE
  List<PartnerDetailReport> _partnerDetailReportsMore;

  Future<List<PartnerDetailReport>> getPartnerDetailReportsMore({
    String dataFrom,
    String dateTo,
    String resultSelection,
    String companyId,
    String partnerId,
    String userId,
    String categId,
  }) async {
    try {
      skip += limit;
      var result = await _tposApi.getPartnerDetailReports(
        pageSize: 10,
        page: _currentPage + 1,
        skip: skip,
        take: limit,
        dataFrom: dataFrom,
        dateTo: dateTo,
        resultSelection: resultSelection,
        companyId: companyId,
        partnerId: partnerId,
      );
      if (result != null) {
        _partnerDetailReportsMore = result;
      }
    } catch (e, s) {
      logger.error("loadPartnerDetailReportsFail", e, s);
      _dialog.showError(error: e);
    }
    return _partnerDetailReportsMore;
  }

  Future handleItemCreated(
    int index, {
    String dataFrom,
    String dateTo,
    String resultSelection,
    String companyId,
    String partnerId,
    String userId,
    String categId,
  }) async {
    var itemPosition = index + 1;
    var requestMoreData = itemPosition % limit == 0 && itemPosition != 0;
    var pageToRequest = itemPosition ~/ limit;

    if (requestMoreData && pageToRequest > _currentPage) {
      print('handleItemCreated | pageToRequest: $pageToRequest');
      _currentPage = pageToRequest;
      _showLoadingIndicator();
      if (skip + limit < max) {
        var newFetchedItems = await getPartnerDetailReportsMore(
            dataFrom: dataFrom,
            dateTo: dateTo,
            resultSelection: resultSelection,
            companyId: companyId,
            partnerId: partnerId,
            userId: userId,
            categId: categId);
        await Future.delayed(Duration(seconds: 1));
        partnerDetailReports.addAll(newFetchedItems);
      }
      _removeLoadingIndicator();
    }
  }

  void _showLoadingIndicator() {
    _partnerDetailReports.add(temp);
    notifyListeners();
  }

  void _removeLoadingIndicator() {
    _partnerDetailReports.remove(temp);
    notifyListeners();
  }
}

var temp = new PartnerDetailReport(name: "temp");
