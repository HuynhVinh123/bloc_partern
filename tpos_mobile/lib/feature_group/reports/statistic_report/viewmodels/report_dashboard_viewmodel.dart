import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/data_helper.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/models/DashboardReport.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class ReportDashboardViewModel extends ScopedViewModel {
  ReportDashboardViewModel({ITposApiService tposApi, AlertApi alertApi}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    setBusy(false);

    _selectedOverviewOption = _overviewFilter.first;
    currentPieChartOption = chartPieFilter[2];
    currentDataPieChartOrderOption = chartPieOrderFilter[2];
    _apiClient = alertApi ?? GetIt.instance<AlertApi>();
  }
  ITposApiService _tposApi;
  AlertApi _apiClient;
  final Logger _log = Logger("ReportDashboardViewModel");

  List<DataLineChart> dataLines = <DataLineChart>[];
  List<DataPieChart> dataPieChart = <DataPieChart>[];
  List<StockWarehouseProduct> reportProductMin = <StockWarehouseProduct>[];
  List<StockWarehouseProduct> reportProductMax = <StockWarehouseProduct>[];

  DashboardReport report;
  AppFilterDateModel filterDateInvoice = getTodayDateFilter();
  Alert alert = Alert();
  bool _isInit = false;

  final List<DashboardReportDataOverviewOption> _overviewFilter = [
    DashboardReportDataOverviewOption(
        value: "T", text: S.current.today.toUpperCase()),
    DashboardReportDataOverviewOption(
        value: "Yesterday", text: S.current.yesterday.toUpperCase()),
    DashboardReportDataOverviewOption(
        value: "M", text: S.current.thisMonth.toUpperCase()),
    DashboardReportDataOverviewOption(
        value: "Y", text: S.current.thisYear.toUpperCase()),
  ];
  List<DataLineOption> chartLineFilter = [
    DataLineOption(value: "WNWP", text: S.current.thisWeek.toUpperCase()),
    DataLineOption(value: "MNMP", text: S.current.thisMonth.toUpperCase()),
    DataLineOption(
        value: "YQNYQP", text: S.current.thisYearQuarter.toUpperCase()),
    DataLineOption(value: "YNYP", text: S.current.thisYear.toUpperCase()),
    //DataDataLineOption(value: "O", text: "KHÁC"),
  ];
  DataLineOption currentChartLine =
      DataLineOption(value: "WNWP", text: S.current.thisWeek.toUpperCase());
  void setCurrentChartLine(DataLineOption option) {
    currentChartLine = option;
  }

  List<DataColumnOption> chartColumnFilter = [
    DataColumnOption(value: "W", text: S.current.thisWeek.toUpperCase()),
    DataColumnOption(value: "CM", text: S.current.thisMonth.toUpperCase()),
    DataColumnOption(value: "PM", text: S.current.monthsAgo.toUpperCase()),
  ];
  DataColumnOption currentChartColumn =
      DataColumnOption(value: "W", text: S.current.thisWeek.toUpperCase());
  void setCurrentChartColumn(DataColumnOption option) {
    currentChartColumn = option;
    notifyListeners();
  }

  ///PIE CHART
  List<DataPieChartOption> chartPieFilter = [
    DataPieChartOption(value: "W", text: S.current.thisWeek.toUpperCase()),
    DataPieChartOption(value: "CM", text: S.current.thisMonth.toUpperCase()),
    DataPieChartOption(value: "PM", text: S.current.monthsAgo.toUpperCase()),
  ];
  DataPieChartOption currentPieChartOption;
  void setCurrentPieChartOption(DataPieChartOption option) {
    currentPieChartOption = option;
  }

  List<DataPieChartOrderOption> chartPieOrderFilter = [
    DataPieChartOrderOption(
        value: 1, text: S.current.reportDashboard_sales.toUpperCase()),
    DataPieChartOrderOption(
        value: 2, text: S.current.reportDashboard_revenue.toUpperCase()),
    DataPieChartOrderOption(
        value: 3, text: S.current.reportDashboard_quantity.toUpperCase()),
  ];
  DataPieChartOrderOption currentDataPieChartOrderOption;
  void setCurrentDataPieChartOrderOption(DataPieChartOrderOption option) {
    currentDataPieChartOrderOption = option;
  }

  DashboardReportDataOverviewOption _selectedOverviewOption;
  List<DashboardReportDataOverviewOption> get overviewFilter => _overviewFilter;
  DashboardReportDataOverviewOption get selectedOverviewOption =>
      _selectedOverviewOption;
  set selectedOverviewOption(DashboardReportDataOverviewOption value) {
    _selectedOverviewOption = value;
    notifyListeners();
  }

  Future<void> initCommand() async {
    if (_isInit) {
      return;
    }
    try {
      await getAlert();
      await _getDashboardReport();
      await reportInventory();
      notifyListeners();
      _isInit = true;
    } catch (e, s) {
      _log.severe("", e, s);
    }
  }

  Future<void> getAlert() async {
    try {
      alert = await _apiClient.getAlert();
      notifyListeners();
    } catch (e, s) {
      _log.severe("", e, s);
    }
  }

  Future<void> reportInventory() async {
    try {
      reportProductMin = await _apiClient.reportInventoryMin();
      reportProductMax = await _apiClient.reportInventoryMax();
      notifyListeners();
    } catch (e, s) {
      _log.severe("", e, s);
    }
  }

  Future<void> refreshReportCommand() async {
    try {
      _getDashboardReport();
      notifyListeners();
    } catch (e, s) {
      _log.severe("", e, s);
    }
  }

  Future<void> reloadOverviewCommand() async {
    setBusy(true);
    try {
      final overview = await _tposApi.getDashboardReportOverview(
          overViewValue: _selectedOverviewOption?.value,
          overViewText: _selectedOverviewOption?.text);

      if (overview != null) {
        report.overview = overview;
      }
      notifyListeners();
    } catch (e, s) {
      _log.severe("", e, s);
    }
    setBusy(false);
  }

  Future<void> _getDashboardReport() async {
    report = await _tposApi.getDashboardReport(
        overViewText: _selectedOverviewOption?.text,
        overViewValue: _selectedOverviewOption?.value);
    notifyListeners();
  }

  Future getDataLinesChart() async {
    dataLines = <DataLineChart>[];
    try {
      dataLines = await _tposApi.getDashBoardChart(
        chartType: "GetDataLine",
        lineChartText: currentChartLine.text,
        lineChartValue: currentChartLine.value,
      );
    } catch (e) {
      onDialogMessageAdd(OldDialogMessage.flashMessage(
        convertErrorToString(e),
      ));
    }
    notifyListeners();
  }

  List<DataColumnChart> dataColumns = <DataColumnChart>[];
  DataColumnChartOverView dataColumnChartOverView;

  Future getDataColumnChart() async {
    dataColumnChartOverView = await _tposApi.getDashBoardChart(
      chartType: "GetSales",
      columnCharText: currentChartColumn.text,
      columnChartValue: currentChartColumn.value,
    );

    dataColumns = dataColumnChartOverView.dataColumnsCharts;
    notifyListeners();
  }

  Future getDataPieChart() async {
    dataPieChart = <DataPieChart>[];
    notifyListeners();
    try {
      final values = await _tposApi.getDashBoardChart(
        chartType: "GetSales2",
        barChartValue: currentPieChartOption.value,
        barChartText: currentPieChartOption.text,
        barChartOrderValue: currentDataPieChartOrderOption.value,
        barChartOrderText: currentDataPieChartOrderOption.text,
      );
      dataPieChart = [...values];
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> readAlert(String alertId, var context) async {
    try {
      await _apiClient.readWarning(alertId);
    } catch (e) {
      showError(
          title: S.current.error, message: e.toString(), context: context);
    }
  }
  //
  // DashboardReportDataOverviewOption(value: "T", text: "HÔM NAY"),
  // DashboardReportDataOverviewOption(value: "Yesterday", text: "HÔM QUA"),
  // DashboardReportDataOverviewOption(value: "M", text: "THÁNG NÀY"),
  // DashboardReportDataOverviewOption(value: "Y", text: "NĂM NÀY"),

}

///LINE CHART
class DataLineChart {
  DataLineChart({this.name, this.current, this.last});
  DataLineChart.fromJson(List<dynamic> json) {
    name = json[0];
    current = double.parse(json[1].toString().replaceAll(",", "."));
    last = double.parse(json[2].toString().replaceAll(",", "."));
  }
  String name;
  double current;
  double last;
}

class DataLineOption {
  DataLineOption({this.text, this.value});
  String text;
  String value;
}

///COLUMN CHART
class DataColumnChartOverView {
  DataColumnChartOverView({this.totalSale, this.dataColumnsCharts});
  DataColumnChartOverView.fromJson(Map<String, dynamic> json) {
    totalSale = double.parse(json["TotalSaleCC"].toString());
    dataColumnsCharts = (json["DataDate"] as List)
        .map(
          (f) => DataColumnChart.fromJson(f, json["ListHeader"]),
        )
        .toList();
  }

  double totalSale;
  List<DataColumnChart> dataColumnsCharts;
}

class DataColumnChart {
  DataColumnChart({this.name, this.listValue, this.listCompanyName});
  DataColumnChart.fromJson(List<dynamic> json, List<dynamic> listCompanyName) {
    name = json[0];
    json.length;
    for (int i = 0; i <= listCompanyName.length - 1; i++) {
      this.listCompanyName.add(listCompanyName[i]["CompanyName"].toString());
    }
    for (int i = 1; i <= json.length - 1; i++) {
      listValue.add(double.parse(json[i].toString().replaceAll(",", ".")));
    }
  }
  String name;
  List<double> listValue = <double>[];
  List<String> listCompanyName = <String>[];
}

class DataColumnOption {
  DataColumnOption({this.text, this.value});
  String text;
  String value;
}

///PIE CHART
class DataPieChart {
  DataPieChart({this.nameProduct, this.quantity, this.type, this.colors});
  factory DataPieChart.fromJson(Map<String, dynamic> json) => DataPieChart(
        nameProduct: json["NameProduct"],
        quantity: json["Quantity"]?.toDouble(),
        type: json["Type"],
      );
  String nameProduct;
  double quantity;
  dynamic type;
  Color colors;

  Map<String, dynamic> toJson() => {
        "NameProduct": nameProduct,
        "Quantity": quantity,
        "Type": type,
      };
}

class DataPieChartOption {
  DataPieChartOption({
    this.value,
    this.text,
  });
  String value;
  String text;
}

class DataPieChartOrderOption {
  DataPieChartOrderOption({this.value, this.text});
  int value;
  String text;
}
