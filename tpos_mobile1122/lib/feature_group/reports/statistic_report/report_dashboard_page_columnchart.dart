import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_charts/flutter_charts.dart' as chart;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:random_color/random_color.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/data_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/widget_helper.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

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
  final ReportDashboardViewModel _vm = locator<ReportDashboardViewModel>();

  double maxY = 0;
  double minY = 0;
  double maxValue = 0;
  double minValue = 0;
  double unit = 1;

  final List<Color> _colors = [];
  List<BarChartGroupData> _barChartGroup = [];
  List<BarChartRodStackItem> _chartRodStacks;
  bool isLoading = true;
  String lastCharacter = "";

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

    setUpChart();

    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  void setUpChart() {
    maxY = 0;
    minY = 0;
    maxValue = 0;
    minValue = 0;

    ///
//    _barChartGroup = List(_vm.dataColumns.length);
    if (_vm.dataColumns.isNotEmpty) {
      for (final value in _vm.dataColumns[0].listCompanyName) {
        final Color randomColor = RandomColor().randomColor();
        final existColor = _colors.any((element) => element == randomColor);
        if (!existColor) {
          _colors.add(randomColor);
        }
      }
    }

    // ignore: avoid_function_literals_in_foreach_calls
    _vm.dataColumns.forEach((value) {
      // ignore: avoid_function_literals_in_foreach_calls
      value.listValue.forEach((element) {
        maxValue = element > maxValue ? element : maxValue;
        minValue = element < minValue ? element : minValue;
      });
    });

    if (maxValue / 1000000000 >= 1) {
      if (mounted) {
        lastCharacter = "b";
        unit = 1000000000;
      } //billion
    } else if (maxValue / 1000000 >= 1) {
      if (mounted) {
        lastCharacter = "m";
      } //million
      unit = 1000000;
    } else if (maxValue / 1000 >= 1) {
      if (mounted) {
        lastCharacter = "k";
      } //thousand
      unit = 1000;
    } else {
      if (mounted) {
        lastCharacter = "";
      }
    }
    maxY = maxValue / unit != 0 ? (maxValue / unit) + 1 : 0;
    minY = (minValue / unit) != 0 ? (minValue / unit) - 1 : 0;
    int positionX = 1;
    for (final value in _vm.dataColumns) {
      _chartRodStacks = [];
      double y = 0;
      double positionY = 0;
      int index = 0;

      // ignore: avoid_function_literals_in_foreach_calls
      value.listValue.forEach((element) {
        element = element / unit;

        y = y + element;

        final BarChartRodStackItem item = BarChartRodStackItem(
            positionY, element + positionY, _colors[index]);
        index++;

        positionY = positionY + element;
        _chartRodStacks.add(item);
      });

      final BarChartRodData rodData = BarChartRodData(
          y: y,
          width: MediaQuery.of(context).size.width /
                      2 /
                      _vm.dataColumns.length >
                  17
              ? 17
              : MediaQuery.of(context).size.width / 2 / _vm.dataColumns.length,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(0), topRight: Radius.circular(0)),
          rodStackItems: _chartRodStacks);

      final BarChartGroupData groupData =
          BarChartGroupData(x: positionX, barRods: [rodData]);
      positionX++;
      _barChartGroup.add(groupData);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_vm.dataColumns.isEmpty) {
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
                                "${S.current.noData} \n"
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
                          _buildNameCompany(),
                          _showBarchart(),
                          _showBottom(),
                        ],
                      ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNameCompany() {
    return Wrap(
        children:
            List.generate(_vm.dataColumns[0].listCompanyName.length, (index) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 12),
              width: 25,
              height: 15,
              color: _colors[index],
            ),
            Text(_vm.dataColumns[0].listCompanyName[index])
          ],
        ),
      );
    }));
  }

  Widget _showBarchart() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 18),
      child: AspectRatio(
        aspectRatio: 1.5,
        child: BarChart(
          BarChartData(
              maxY: maxY,
              minY: minY.floorToDouble(),
              groupsSpace: 5,
              barTouchData: BarTouchData(
                enabled: false,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  reservedSize: 30,
                  showTitles: true,
                  textStyle: const TextStyle(color: Colors.black, fontSize: 10),
                  margin: 10,
                  rotateAngle: 0,
                  getTitles: (double value) {
                    if (value > 0) {
                      return _vm.dataColumns[value.toInt() - 1].name;
                    }
                    return "";
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  textStyle: const TextStyle(
                    color: Color(0xff75729e),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  getTitles: (double value) {
                    if (value.toInt() % 2 == 0) {
                      /*count++;*/
                      return '${value.toInt()} $lastCharacter';
                    } else if (value.toInt() == maxY.toInt()) {
                      return '${maxY.toInt()} $lastCharacter';
                    }
                    return '';
//                    if (value == 0) {
//                      return '0';
//                    }
//                    return "${value.toInt()} $lastCharacter";
                  },
                  margin: 8,
                  reservedSize: 30,
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                drawVerticalLine: true,
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
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      y: 0,
                      width: 5,
                      rodStackItems: [BarChartRodStackItem(0, 0, Colors.white)],
                    ),
                  ],
                ),
                ..._barChartGroup
              ]),
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
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 12),
                  child: Text(
                    "${S.current.reportDashboard_salesChart} ${_vm.currentChartColumn.text.toLowerCase()}"
                        .toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF515967),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              _showDropDown(),
              const SizedBox(
                width: 12,
              )
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
//          Text(
//            "(${getBottomText(_vm.currentChartColumn.text)})",
//            style: const TextStyle(color: Colors.grey),
//          ),
          const SizedBox(
            height: 12,
          ),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: '${S.current.totalRevenue}:   ',
                    style: const TextStyle(
                        color: Color(0xFF929DAA), fontSize: 14)),
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
        _barChartGroup = [];
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
