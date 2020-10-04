import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/data_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/widget_helper.dart';

import 'viewmodels/report_dashboard_viewmodel.dart';

class LineChartPage extends StatefulWidget {
  const LineChartPage({@required this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<StatefulWidget> createState() => LineChartPageState();
}

class LineChartPageState extends State<LineChartPage> {
  final _vm = locator<ReportDashboardViewModel>();
  StreamController<LineTouchResponse> controller;

  String dropdownValue;
  List<FlSpot> listCurrent = <FlSpot>[];
  List<FlSpot> listLast = <FlSpot>[];
  double maxValue = 0;
  double maxX = 1;
  double maxY = 0;
  int count = 1;
  String lastCharacter = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _vm.currentChartLine = _vm.chartLineFilter[0];
    loadChart();

    controller = StreamController();
    controller.stream.distinct().listen((LineTouchResponse response) {
      print('response: ${response.touchInput}');
    });
  }

  Future loadChart() async {
    setState(() {
      isLoading = true;
    });
    listCurrent = <FlSpot>[];
    listLast = <FlSpot>[];
    maxValue = 0;
    maxX = 1;
    maxY = 0;
    count = 1;
    try {
      await _vm.getDataLinesChart();
    } catch (e) {
      isLoading = false;
      showCusSnackBar(
        currentState: widget.scaffoldKey.currentState,
        child: Text(
          convertErrorToString(e),
        ),
      );
      setState(() {});
    }

    ///lấy giá trị lớn nhất
    // ignore: avoid_function_literals_in_foreach_calls
    _vm.dataLines.forEach((f) {
      maxValue = maxValue < f.current ? f.current : maxValue;
      maxValue = maxValue < f.last ? f.last : maxValue;
    });
    if (maxValue / 1000000000 >= 1) {
      if (mounted) {
        lastCharacter = "b";
      } //billion
    } else if (maxValue / 1000000 >= 1) {
      if (mounted) {
        lastCharacter = "m";
      } //million
    } else if (maxValue / 1000 >= 1) {
      if (mounted) {
        lastCharacter = "k";
      } //thousand
    } else {
      if (mounted) {
        lastCharacter = "";
      }
    }

    double divideValue = 1;
    for (int i = 0; i <= maxValue.toInt().toString().length; i++) {
      divideValue = divideValue * 10;
    }
    divideValue = divideValue / 1000;
    print(divideValue);
    maxY = maxValue / divideValue;
    // ignore: avoid_function_literals_in_foreach_calls
    _vm.dataLines.forEach((f) {
      if (mounted)
        setState(() {
          print("${f.name} - ${f.current} - ${f.last}");
          listCurrent.add(FlSpot(maxX, f.current / divideValue));
          listLast.add(FlSpot(maxX, f.last / divideValue));
          maxX++;
        });
    });

    if (mounted)
      setState(() {
        isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ReportDashboardViewModel>(
      model: _vm,
      child: AspectRatio(
        aspectRatio: 1,
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _showHeader(),
            _showInfo(),
            Expanded(
              child: isLoading
                  ? loadingScreen()
                  : _vm.dataLines.isEmpty
                      ? Container(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.boxOpen,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                                Text(
                                  "Không có dữ liệu \n"
                                  "${_vm.currentChartLine.text.toLowerCase()} ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            _showLineChart(),
                            _showBottom(),
                          ],
                        ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.close();
  }

  Widget _showHeader() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Doanh thu ${_vm.currentChartLine.text.toLowerCase()}",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showInfo() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 6,
                      width: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xff27b6fc),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  Text(
                      "${_vm.currentChartLine.text.replaceAll(" NÀY", "")[0].toUpperCase()}${_vm.currentChartLine.text.replaceAll(" NÀY", "").substring(1).toLowerCase()} này"),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 6,
                      width: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xffaa4cfc),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  Text(
                      "${_vm.currentChartLine.text.replaceAll(" NÀY", "")[0].toUpperCase()}${_vm.currentChartLine.text.replaceAll(" NÀY", "").substring(1).toLowerCase()} trước")
                ],
              ),
            ],
          ),
        ),
        DropdownButton(
          iconEnabledColor: Colors.lightBlue,
          underline: DropdownButtonHideUnderline(
              child: Text(
            _vm.currentChartLine != null
                ? "".padLeft(_vm.currentChartLine.text.length + 1, "_")
                : "",
            style: TextStyle(color: Colors.lightBlue),
          )),
          value: _vm.currentChartLine,
          onChanged: (value) {
            setState(() {
              _vm.currentChartLine = value;
            });
            _vm.setCurrentChartLine(value);
            loadChart();
          },
          items: _vm.chartLineFilter
              .map(
                (f) => DropdownMenuItem(
                  value: f,
                  child: Text(
                    "${f.text.toUpperCase()[0]}${f.text.substring(1).toLowerCase()}",
                    style: TextStyle(
                        color: f == _vm.currentChartLine
                            ? Colors.lightBlue
                            : Colors.black),
                  ),
                ),
              )
              .toList(),
        )
      ],
    );
  }

  Widget _showLineChart() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 6.0, bottom: 10),
        child: ScopedModelDescendant<ReportDashboardViewModel>(
          builder: (context, child, model) {
            return Container(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: true,
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      textStyle: const TextStyle(
                        color: Color(0xff72719b),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      margin: 10,
                      getTitles: (value) {
                        if (listCurrent.length >= 26) {
                          if (value.toInt() % 5 == 0)
                            return value.toInt().toString();
                        } else if (listCurrent.length == 7) {
                          switch (value.toInt()) {
                            case 1:
                              return 'T2';
                            case 2:
                              return 'T3';
                            case 3:
                              return 'T4';
                            case 4:
                              return 'T5';
                            case 5:
                              return 'T6';
                            case 6:
                              return 'T7';
                            case 7:
                              return 'CN';
                          }
                        } else if (listCurrent.length == 4) {
                          switch (value.toInt()) {
                            case 1:
                              return 'Quý 1';
                            case 2:
                              return 'Quý 2';
                            case 3:
                              return 'Quý 3';
                            case 4:
                              return 'Quý 4';
                          }
                        } else if (listCurrent.length == 12 &&
                            value.toInt() % 2 == 0) {
                          return "T${value.toInt()}";
                        }

                        return '';
                      },
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      textStyle: const TextStyle(
                        color: Color(0xff75729e),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      getTitles: (value) {
                        if (value % 2 == 0) {
                          /*count++;*/
                          return '${value.toInt()}$lastCharacter';
                        } else if (value == maxY.toInt()) {
                          return '${maxY.toInt()}$lastCharacter';
                        }
                        return '';
                      },
                      margin: 8,
                      reservedSize: 30,
                    ),
                  ),
                  borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        bottom: BorderSide(
                          color: Color(0xff4e4965),
                          width: 2,
                        ),
                        left: BorderSide(
                          color: Colors.transparent,
                        ),
                        right: BorderSide(
                          color: Colors.transparent,
                        ),
                        top: BorderSide(
                          color: Colors.transparent,
                        ),
                      )),
                  minX: 0,
                  maxX: maxX,
                  maxY: maxY == 0 ? 1 : maxY,
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: listLast,
                      isCurved: true,
                      colors: [
                        const Color(0xffaa4cfc),
                      ],
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                      ),
                      belowBarData: BarAreaData(
                        show: false,
                      ),
                      preventCurveOverShooting: true,
                    ),
                    LineChartBarData(
                      spots: listCurrent,
                      isCurved: true,
                      colors: [
                        const Color(0xff27b6fc),
                      ],
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                      ),
                      belowBarData: BarAreaData(
                        show: false,
                      ),
                      preventCurveOverShooting: true,
                    ),
                  ],
                ),
                swapAnimationDuration: const Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _showBottom() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "(${getBottomText(_vm.currentChartLine.text)})",
            style: TextStyle(color: Colors.grey),
          ),
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
      case "quý của năm này":
        return "Quý trong năm";
      case "năm này":
        return "Tháng trong năm";
    }
    return "";
  }
}
