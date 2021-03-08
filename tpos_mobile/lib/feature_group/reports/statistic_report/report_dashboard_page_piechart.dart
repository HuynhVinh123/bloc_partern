import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:random_color/random_color.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/data_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/widget_helper.dart';
import 'package:tpos_mobile/feature_group/reports/statistic_report/color_position.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import 'viewmodels/report_dashboard_viewmodel.dart';

class PieChartPage extends StatefulWidget {
  const PieChartPage({@required this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _PieChartPageState createState() => _PieChartPageState();
}

class _PieChartPageState extends State<PieChartPage> {
  List<PieChartSectionData> pieChartRawSections;
  List<PieChartSectionData> showingSections;
  final RandomColor _randomColor = RandomColor();
  StreamController<PieTouchResponse> pieTouchedResultStreamController;
  int touchedIndex;
  bool isLoading = true;
  int count;
  final ReportDashboardViewModel _vm = locator<ReportDashboardViewModel>();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _showHeader(),
        _showDropDown(),
        _showPieChart(),
        _showListProduct(),
      ],
    );
  }

  @override
  void dispose() {
    pieTouchedResultStreamController?.close();
    super.dispose();
  }

  Future loadData() async {
    isLoading = true;
    setState(() {});

    _vm.dataPieChart = <DataPieChart>[];
    try {
      await _vm.getDataPieChart();
      setupChart(_vm.dataPieChart);
      isLoading = false;
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print(e);
      isLoading = false;
      if (mounted) {
        setState(() {});
      }
      showCusSnackBar(
          currentState: widget.scaffoldKey.currentState,
          child: Text(convertErrorToString(e)));
    }
  }

  void setupChart(List<DataPieChart> value) {
    var tong = 0;
    final List<PieChartSectionData> items = [];
    final List<DataPieChart> myListPieChart = [];
    for (final DataPieChart data in value) {
      tong = tong + int.parse(data.quantity.toString().split(".")[0]);
      final Color color =
          _randomColor.randomColor(colorBrightness: ColorBrightness.dark);
      data.colors = color;
      myListPieChart.add(data);
    }
    //Color(Random().nextInt(0xffffffff))
    for (final data in myListPieChart) {
      final double value = (data.quantity / tong * 100).toDouble();

      items.add(
        PieChartSectionData(
          color: data.colors,
          value: value,
          title: "${value.toInt()}%",
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xffffffff),
          ),
        ),
      );
    }
    pieChartRawSections = items;

    showingSections = pieChartRawSections;

    // pieTouchedResultStreamController = StreamController();
//    pieTouchedResultStreamController.stream.distinct().listen((details) {
//      if (details == null) {
//        return;
//      }
//
//      touchedIndex = -1;
//      if (details.sectionData != null) {
//        touchedIndex = showingSections.indexOf(details.sectionData);
//      }
//
//      setState(() {
//        if (details.touchInput is FlLongPressEnd) {
//          touchedIndex = -1;
//          showingSections = List.of(pieChartRawSections);
//        } else {
//          showingSections = List.of(pieChartRawSections);
//
//          if (touchedIndex != -1) {
//            final TextStyle style = showingSections[touchedIndex].titleStyle;
//            showingSections[touchedIndex] =
//                showingSections[touchedIndex].copyWith(
//              titleStyle: style.copyWith(
//                fontSize: 24,
//              ),
//              radius: 60,
//            );
//          }
//        }
//      });
//    });
  }

  Widget _showDropDown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        DropdownButton(
          iconEnabledColor: Colors.lightBlue,
          underline: const SizedBox(),
          value: _vm.currentDataPieChartOrderOption,
          onChanged: (value) {
            setState(() {
              _vm.currentDataPieChartOrderOption = value;
            });
            _vm.setCurrentDataPieChartOrderOption(value);
            loadData();
          },
          items: _vm.chartPieOrderFilter
              .map(
                (f) => DropdownMenuItem(
                  value: f,
                  child: Text(
                    "${f.text.toUpperCase()[0]}${f.text.substring(1).toLowerCase()}",
                    style: TextStyle(
                        color: f == _vm.currentDataPieChartOrderOption
                            ? Colors.lightBlue
                            : Colors.black),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(
          width: 6,
        )
      ],
    );
  }

  Widget _showPieChart() {
    return ScopedModel<ReportDashboardViewModel>(
      model: _vm,
      child: ScopedModelDescendant<ReportDashboardViewModel>(
        builder: (context, child, model) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: pieTouchedResultStreamController == null
                ? const SizedBox()
                : AspectRatio(
                    aspectRatio: 1.5,
                    child: isLoading
                        ? loadingScreen()
                        : model.dataPieChart.isEmpty
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
                                        "${_vm.currentPieChartOption.text.toLowerCase()} "
                                        "${_vm.currentDataPieChartOrderOption.text.toLowerCase()} !",
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
                            : PieChart(
                                PieChartData(
                                  pieTouchData: PieTouchData(),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 40,
                                  sections: showingSections,
                                ),
                              ),
                  ),
          );
        },
      ),
    );
  }

  /// #${_vm.dataPieChart.indexOf(item) + 1}

  Widget _showListProduct() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._vm.dataPieChart
            .map(
              (item) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Indicator(
                  position: _vm.dataPieChart.indexOf(item) + 1,
                  color: item.colors,
                  textColor: const Color(0xFF2C333A),
                  fontWeight: FontWeight.w300,
                  text: item.nameProduct ?? "",
                  isSquare: true,
                  value: item.quantity.toStringFormat("###,###,###,###"),
                ),
              ),
            )
            .toList(),
        const SizedBox(
          height: 6,
        )
      ],
    );
  }

  Column _showHeader() {
    return Column(
      children: <Widget>[
        Container(
          //color: Colors.grey.shade200,
          decoration: const BoxDecoration(
              color: Color(0xFFF8F9FB),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12), topLeft: Radius.circular(12))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Text(
                  S.current.reportDashboard_topSales.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF515967),
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              DropdownButton(
                iconEnabledColor: Colors.lightBlue,
                underline: const SizedBox(),
                value: _vm.currentPieChartOption,
                onChanged: (value) {
                  setState(() {
                    _vm.currentPieChartOption = value;
                  });
                  _vm.setCurrentPieChartOption(value);
                  loadData();
                },
                items: _vm.chartPieFilter
                    .map(
                      (f) => DropdownMenuItem(
                        value: f,
                        child: Text(
                          "${f.text.toUpperCase()[0]}${f.text.substring(1).toLowerCase()}",
                          style: TextStyle(
                              color: f == _vm.currentPieChartOption
                                  ? Colors.lightBlue
                                  : Colors.black),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(
                width: 6,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator(
      {Key key,
      this.color,
      this.text,
      this.isSquare,
      this.size = 24,
      this.textColor = const Color(0xffffffff),
      this.value,
      this.fontWeight = FontWeight.w300,
      this.position})
      : super(key: key);
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;
  final String value;
  final FontWeight fontWeight;
  final int position;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: getColor(position),
          ),
          child: Center(
            child: Text(
              position.toString(),
              style: TextStyle(
                  color: position < 4 ? Colors.white : const Color(0xFF6B7280)),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: 16, fontWeight: fontWeight, color: textColor),
                ),
              ),
              Text(
                value,
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: fontWeight,
                    color: const Color(0xFF2C333A)),
              )
            ],
          ),
        ),
      ],
    );
  }
}
