import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/feature_group/reports/statistic_report/internal_chart.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/data_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/widget_helper.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

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
  List<String> listDate = <String>[];
  double maxValue = 0;
  double maxX = 0;
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
    maxX = 0;
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
    double divideValue = 1;

    ///lấy giá trị lớn nhất
    // ignore: avoid_function_literals_in_foreach_calls
    _vm.dataLines.forEach((f) {
      maxValue = maxValue < f.current ? f.current : maxValue;
      maxValue = maxValue < f.last ? f.last : maxValue;
    });
    if (maxValue / 1000000000 >= 1) {
      if (mounted) {
        lastCharacter = S.current.billion; //"b";
        divideValue = 1000000000;
      } //billion
    } else if (maxValue / 1000000 >= 1) {
      if (mounted) {
        lastCharacter = S.current.million; //"m";
        divideValue = 1000000;
      } //million
    } else if (maxValue / 1000 >= 1) {
      if (mounted) {
        lastCharacter = "k";
        divideValue = 1000;
      } //thousand
    } else {
      if (mounted) {
        lastCharacter = "";
        divideValue = 1;
      }
    }

    // for (int i = 0; i <= maxValue.toInt().toString().length; i++) {
    //   divideValue = divideValue * 10;
    // }
    // divideValue = divideValue / 1000;
    // print(divideValue);
    maxY = maxValue / divideValue;
    // ignore: avoid_function_literals_in_foreach_calls
    _vm.dataLines.forEach((f) {
      if (mounted)
        setState(() {
          print("${f.name} - ${f.current} - ${f.last}");
          listDate.add(f.name);
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
                                const Icon(
                                  FontAwesomeIcons.boxOpen,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                                Text(
                                  "${S.current.noData} \n"
                                  "${_vm.currentChartLine.text.toLowerCase()} ",
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
      decoration: const BoxDecoration(
          color: Color(0xFFF8F9FB),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8, left: 12),
              child: Text(
                "${S.current.revenue} ${_vm.currentChartLine.text.toLowerCase()}"
                    .toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFF515967),
                  fontSize: 15,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          DropdownButton(
            iconEnabledColor: Colors.lightBlue,
            underline: const SizedBox(),
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
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "${f.text.toUpperCase()[0]}${f.text.substring(1).toLowerCase()}",
                        style: TextStyle(
                          color: f == _vm.currentChartLine
                              ? Colors.lightBlue
                              : Colors.black,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(
            width: 8,
          )
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 4,
                      width: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xff27b6fc),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                        "${_vm.currentChartLine.text.replaceAll(" NÀY", "")[0].toUpperCase()}${_vm.currentChartLine.text.replaceAll(" NÀY", "").substring(1).toLowerCase()} ${S.current.reportDashboard_this}"),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8, left: 8),
                    child: const Center(
                        child: Icon(
                      Icons.more_horiz,
                      color: Color(0xFF2395FF),
                    )),
                  ),
                  Flexible(
                    child: Text(
                        "${_vm.currentChartLine.text.replaceAll(" NÀY", "")[0].toUpperCase()}${_vm.currentChartLine.text.replaceAll(" NÀY", "").substring(1).toLowerCase()} ${S.current.reportDashboard_ago}"),
                  ),
                  const SizedBox(
                    width: 16,
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _showLineChart() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0, left: 12.0, bottom: 10),
        child: ScopedModelDescendant<ReportDashboardViewModel>(
          builder: (context, child, model) {
            return Container(
              child: LineChart(
                LineChartData(
//                  lineTouchData: LineTouchData(
//                      getTouchedSpotIndicator:
//                          (LineChartBarData barData, List<int> spotIndexes) {
//                        return spotIndexes.map((spotIndex) {
//                          final FlSpot spot = barData.spots[spotIndex];
//                          if (spot.x == 0 || spot.x == 6) {
//                            return null;
//                          }
//                          return TouchedSpotIndicatorData(
//                            FlLine(color: Colors.blue, strokeWidth: 4),
//                            FlDotData(
//                              getDotPainter: (spot, percent, barData, index) {
//                                return FlDotCirclePainter(
//                                    radius: 8,
//                                    color: Colors.white,
//                                    strokeWidth: 5,
//                                    strokeColor: Colors.deepOrange);
//                              },
//                            ),
//                          );
//                        }).toList();
//                      },
//                      touchTooltipData: LineTouchTooltipData(
//                          tooltipBgColor: Colors.blueAccent,
//                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
//                            return touchedBarSpots.map((barSpot) {
//                              final flSpot = barSpot;
//                              if (flSpot.x == 6) {
//                                return null;
//                              }
//
//                              return LineTooltipItem(
//                                'k calories \n 26/06',
//                                const TextStyle(color: Colors.white),
//                              );
//                            }).toList();
//                          })),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: true,
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      // textStyle: const TextStyle(
                      //   color: Color(0xff6B7280),
                      //   fontSize: 14,
                      // ), // TODO Xem xét
                      margin: 10,
                      getTitles: (value) {
                        if (listCurrent.length >= 26) {
                          if (value.toInt() % 5 == 0)
                            return value.toInt().toString();
                        } else if (listCurrent.length == 7) {
                          switch (value.toInt()) {
                            case 0:
                              return listDate[0];
                            case 1:
                              return listDate[1];
                            case 2:
                              return listDate[2];
                            case 3:
                              return listDate[3];
                            case 4:
                              return listDate[4];
                            case 5:
                              return listDate[5];
                            case 6:
                              return listDate[6];
                          }
                        } else if (listCurrent.length == 4) {
                          switch (value.toInt()) {
                            case 0:
                              return 'Quý 1';
                            case 1:
                              return 'Quý 2';
                            case 2:
                              return 'Quý 3';
                            case 3:
                              return 'Quý 4';
                          }
                        } else if (listCurrent.length == 12 &&
                                value.toInt() % 2 != 0 ||
                            value.toInt() == 0) {
                          return "T${value.toInt() + 1}";
                        }

                        return '';
                      },
                    ),
                    leftTitles: SideTitles(
                        showTitles: true,
                        // textStyle: const TextStyle(
                        //   color: Color(0xff75729e),
                        //   fontWeight: FontWeight.bold,
                        //   fontSize: 14,
                        // ), //Text style
                        getTitles: (value) {
                          // if (value % 2 == 0) {
                          /*count++;*/
                          return '${value.toInt()}$lastCharacter';
                          // } else if (value == maxY.toInt()) {
                          //   return '${maxY.toInt()}$lastCharacter';
                          // }
                          // return '';
                        },
                        margin: 8,
                        reservedSize: 30,
                        interval: getInterval(maxY)),
                  ),
                  borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        bottom: BorderSide(
                          color: Color(0xffDFE5E9),
                          width: 2,
                        ),
                        left: BorderSide(
                          color: Color(0xffDFE5E9),
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
                  maxY: maxY == 0 ? 1 : maxY + getInterval(maxY),
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: listLast,
                      isCurved: true,
                      colors: [
                        const Color(0xffA8D3FC),
                      ],
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData:
                          FlDotData(show: true, getDotPainter: _getDotPainter),
                      belowBarData: BarAreaData(
                        show: false,
                      ),
                      preventCurveOverShooting: true,
                      dashArray: [2, 3],
                    ),
                    LineChartBarData(
                      spots: listCurrent,
                      isCurved: true,
                      colors: [
                        const Color(0xff27b6fc),
                      ],
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData:
                          FlDotData(show: true, getDotPainter: _getDotPainter),
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
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  String getBottomText(String a) {
    switch (a.toLowerCase()) {
      case "tuần này":
        return S.current.reportDashboard_dayOfTheWeek;
      case "tháng này":
        return S.current.reportDashboard_dayInMonth;
      case "quý của năm này":
        return S.current.reportDashboard_quarterOfTheYear;
      case "năm này":
        return S.current.reportDashboard_theMonthOfTheYear;
    }
    return "";
  }
}

FlDotPainter _getDotPainter(
    FlSpot spot, double xPercentage, LineChartBarData bar, int index,
    {double size}) {
  return FlDotCirclePainter(
      radius: size,
      color: _defaultGetDotColor(spot, xPercentage, bar),
      strokeWidth: 0);
}

Color _defaultGetDotColor(FlSpot _, double xPercentage, LineChartBarData bar) {
  if (bar.colors == null || bar.colors.isEmpty) {
    return Colors.green;
  } else {
    return bar.colors[0];
  }
}
