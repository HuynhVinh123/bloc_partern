import 'package:flutter/material.dart';

import 'package:flutter_charts/flutter_charts.dart' as chart;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/data_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/widget_helper.dart';

import 'viewmodels/report_dashboard_viewmodel.dart';

class ColumnChartPage extends StatefulWidget {
  const ColumnChartPage({Key key, this.title, this.scaffoldKey})
      : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;

  final String title;

  @override
  _ColumnChartPageState createState() => _ColumnChartPageState();
}

class _ColumnChartPageState extends State<ColumnChartPage> {
  chart.ChartOptions _verticalBarChartOptions;
  chart.LabelLayoutStrategy _xContainerLabelLayoutStrategy;
  chart.ChartData _chartData;
  final ReportDashboardViewModel _vm = locator<ReportDashboardViewModel>();

  bool isLoading = true;

  @override
  void initState() {
    _vm.currentChartColumn = _vm.chartColumnFilter[0];
    loadChart();
    super.initState();
  }

  Future loadChart() async {
    isLoading = true;
    setState(() {});

    try {
      await _vm.getDataColumnChart();
    } catch (e) {
      showCusSnackBar(
          currentState: widget.scaffoldKey.currentState,
          child: Text(convertErrorToString(e)));
    }

    initChart();
    setUpChart();

    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  void initChart() {
    _verticalBarChartOptions = chart.VerticalBarChartOptions();
    _chartData = chart.ChartData();
    _chartData.dataRows.clear();
    _chartData.xLabels.clear();
    _chartData.dataRowsColors.clear();
  }

  void setUpChart() {
    ///3

    if (_vm.dataColumns == null || _vm.dataColumns.isEmpty)
      return; //fix range error by nam

    _chartData.dataRowsLegends = _vm.dataColumns[0]?.listCompanyName;

    for (int i = 0; i <= _chartData.dataRowsLegends.length - 1; i++) {
      // ignore: avoid_function_literals_in_foreach_calls
      _vm.dataColumns.forEach((f) {
        for (int j = 0; j <= f.listValue.length - 1; j++) {
          //print("haha");
          if (i == j) {
            if (_chartData.dataRows.length - 1 < i) {
              _chartData.dataRows.add([]);
            }
            _chartData.dataRows[i].add(f.listValue[j]);
          }
        }
      });
    }

    for (final value in _vm.dataColumns) {
      //_chartData.dataRows.add(value.listValue);
      _chartData.xLabels.add(value.name);
    }
    // ignore: avoid_function_literals_in_foreach_calls
    _chartData.dataRowsLegends.forEach((_) {
      _chartData.dataRowsColors.add(const Color(0xFF28A745));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_vm.dataColumns.isEmpty) {
      initChart();
      setUpChart();
    }

    return ScopedModel<ReportDashboardViewModel>(
      model: _vm,
      child: ScopedModelDescendant<ReportDashboardViewModel>(
        builder: (context, child, model) {
          return Column(
            children: <Widget>[
              _showHeader(),
              if (isLoading)
                AspectRatio(
                  aspectRatio: 1.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: loadingScreen(),
                  ),
                )
              else
                _vm.dataColumns.isEmpty
                    ? AspectRatio(
                        aspectRatio: 1.5,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Icon(
                                FontAwesomeIcons.boxOpen,
                                color: Colors.grey,
                                size: 30,
                              ),
                              Text(
                                "Không có dữ liệu \n"
                                "${_vm.currentChartColumn.text.toLowerCase()}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _showColumnChart(),
                          _showBottom(),
                        ],
                      ),
            ],
          );
        },
      ),
    );
  }

  Widget _showColumnChart() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 1.5,
        child: chart.VerticalBarChart(
          painter: chart.VerticalBarChartPainter(),
          container: chart.VerticalBarChartContainer(
            chartData: _chartData,
            chartOptions: _verticalBarChartOptions,
            xContainerLabelLayoutStrategy: _xContainerLabelLayoutStrategy,
          ),
        ),
      ),
    );
  }

  Widget _showHeader() {
    return Column(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
              color: Color(0xFFF8F9FB),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12), topLeft: Radius.circular(12))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 12),
                child: Text(
                  "Doanh số ${_vm.currentChartColumn.text.toLowerCase()}"
                      .toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF515967),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              _showDropDown()
            ],
          ),
        ),
      ],
    );
  }

  Widget _showBottom() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "(${getBottomText(_vm.currentChartColumn.text)})",
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(
            height: 12,
          ),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                const TextSpan(
                    text: 'Tổng doanh thu:   ',
                    style: TextStyle(color: Color(0xFF929DAA), fontSize: 14)),
                TextSpan(
                    text: vietnameseCurrencyFormat(
                        _vm.dataColumnChartOverView.totalSale ?? 0),
                    style: const TextStyle(
                        color: Color(0xFF2395FF), fontSize: 14)),
              ],
            ),
          )
        ],
      ),
    );
  }

  String getBottomText(String a) {
    switch (a.toLowerCase()) {
      case "tuần này":
        return "Ngày trong tuần";
      case "tháng này":
        return "Ngày trong tháng";
      case "tháng trước":
        return "Ngày trong tháng";
    }
    return "";
  }

  String dropdownValue;

  Widget _showDropDown() {
    return DropdownButton(
      iconEnabledColor: Colors.lightBlue,
      underline: const SizedBox(),
      value: _vm.currentChartColumn,
      onChanged: (value) {
        setState(() {
          _vm.currentChartColumn = value;
        });
        _vm.setCurrentChartColumn(value);
        loadChart();
      },
      items: _vm.chartColumnFilter
          .map(
            (f) => DropdownMenuItem(
              value: f,
              child: Text(
                "${f.text.toUpperCase()[0]}${f.text.substring(1).toLowerCase()}",
                style: TextStyle(
                    color: f == _vm.currentChartColumn
                        ? Colors.lightBlue
                        : Colors.black),
              ),
            ),
          )
          .toList(),
    );
  }
}
