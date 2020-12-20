import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/reports/business_result.dart';

import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class BusinessResultViewModel extends ViewModelBase implements DataTableSource {
  BusinessResultViewModel(
      {ITposApiService tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<ITposApiService>();
    _dialog = dialogService ?? locator<DialogService>();

    filterToDate = _filterDateRange.toDate;
    filterFromDate = _filterDateRange.fromDate;
  }
  ITposApiService _tposApi;
  DialogService _dialog;

  int positionFilter = 2;
  BusinessResult businessResult;
  List<Datas> datas;
  CompanyOfUser _companyOfUser;
  CompanyOfUser get companyOfUser => _companyOfUser;
  set companyOfUser(CompanyOfUser value) {
    _companyOfUser = value;
    notifyListeners();
  }

  final AppFilterDateModel _filterDateRange = getTodayDateFilter();
//Báo cáo theo tháng
  //Báo cáo theo năm
  double sum = 0;
  List<Map<String, dynamic>> typeReport = [
    {"name": S.current.businessReport_monthlyReports, "value": "month"},
    {"name": S.current.businessReport_reportedByYear, "value": "year"},
  ];

  DateTime _filterFromDate;
  DateTime _filterToDate;

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

  int selectedTypeReport;

  void setCommandTypeReport(int value) {
    selectedTypeReport = value;
    notifyListeners();
  }

  void setDateFilter(DateTime dateTime, {DateTime fromDate, DateTime toDate}) {
    if (fromDate != null) {
      if (selectedTypeReport == 0)
        filterFromDate =
            DateTime(dateTime.year, dateTime.month, DateTime.now().day);
      else
        filterFromDate =
            DateTime(dateTime.year, DateTime.now().month, DateTime.now().day);
    }

    if (toDate != null) {
      if (selectedTypeReport == 1)
        filterToDate =
            DateTime(dateTime.year, dateTime.month, DateTime.now().day);
      else
        filterToDate =
            DateTime(dateTime.year, dateTime.month, DateTime.now().day);
    }
  }

  Future loadBusinessResult() async {
    sum = 0;
    setState(true, message: "${S.current.loading}...");
    try {
      businessResult = await _tposApi.getBusinessResult(
          filterFromDate, filterToDate, _companyOfUser?.value, positionFilter);
      datas = businessResult.datas;
      for (final f in datas) {
        if (f.sign == 1)
          sum = sum + f.value;
        else if (f.sign == -1) sum = sum - f.value;
      }
      setState(false);
    } catch (e, s) {
      setState(false);
      logger.error("loadBusinessResult", e, s);
      _dialog.showError(title: S.current.error, content: "$e");
    }
  }

  int sortColumnIndex;
  bool sortAscending = true;

  void sortDetail<T>(
      Comparable<T> getField(Datas d), int columnIndex, bool ascending) {
    businessResult.datas.sort((Datas a, Datas b) {
      if (!ascending) {
        final Datas c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    sortColumnIndex = columnIndex;
    sortAscending = ascending;
    notifyListeners();
  }

  final int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= businessResult.datas.length) return null;
    final Datas datas = businessResult.datas[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text(datas.name ?? '')),
        DataCell(Text(vietnameseCurrencyFormat(datas.value) ?? '0')),
      ],
    );
  }

  @override
  int get rowCount => datas.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  @override
  // TODO: implement hasListeners
  bool get hasListeners => null;

  Future initCommand() async {
    selectedTypeReport = 0;
    await loadBusinessResult();
  }
}
