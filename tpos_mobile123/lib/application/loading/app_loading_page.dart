import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeLoadingScreen extends StatefulWidget {
  const HomeLoadingScreen();
  @override
  _FlashScreenPageState createState() => _FlashScreenPageState();
}

class _FlashScreenPageState extends State<HomeLoadingScreen> {
  double loading = 0;
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 5), (timer) {
      if (loading < 99) {
        setState(() {
          loading++;
        });
      }
      //if (!widget.applicationVM.isLoadPage) {
      setState(() {
        loading = 100;
      });
    });
    //});
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  /// Hiển thị body cho page flash screen
  Widget _buildBody() {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 1,
                  child: Lottie.asset('assets/lottie/ic_screen_loading.json',
                      fit: BoxFit.fill),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
              ],
            ),
            const SizedBox(
              height: 28,
            ),
            Row(
              children: <Widget>[
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                    flex: 3,
                    child: ProgressBar(
                      backgroundColor: const Color(0xFFD0DDEC),
                      padding: 5,
                      barColor: Colors.green,
                      barHeight: 4,
                      barWidth: MediaQuery.of(context).size.width * 3 / 5,
                      numerator: loading,
                      denominator: 100,
                      dialogTextStyle: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      titleStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff3c6e71)),
                      boarderColor: Colors.transparent,
                      title: '',
                    )),
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              'Đang tải dữ liệu (${loading.floor()}%)',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// HIỂN THỊ PROGRESSBAR CHO FLASH sCEEN
class ProgressBar extends StatelessWidget {
  const ProgressBar(
      {@required this.title,
      @required this.numerator,
      @required this.denominator,
      @required this.barWidth,
      @required this.barHeight,
      @required this.barColor,
      @required this.titleStyle,
      @required this.dialogTextStyle,
      this.padding = 0.0,
      this.backgroundColor = Colors.white,
      this.boarderColor = Colors.grey,
      this.showRemainder = true});
  final String title;
  final double numerator;
  final double denominator;
  final double barWidth;
  final double barHeight;
  final Color barColor;
  final TextStyle titleStyle;
  final TextStyle dialogTextStyle;
  final double padding;
  final Color backgroundColor;
  final Color boarderColor;
  final bool showRemainder;

  @override
  Widget build(BuildContext context) {
    double barWithoutPadding = barWidth - padding;

    double percentageWidth = (numerator / denominator) * barWithoutPadding;
    double displayPercentage = (numerator / denominator) * 100;
    double precentageBarWithoutPadding = percentageWidth - padding;
    if (percentageWidth.isNaN) {
      percentageWidth = 0.0;
    }
    if (displayPercentage.isNaN) {
      displayPercentage = 0.0;
    }

    if (precentageBarWithoutPadding.isNaN) {
      precentageBarWithoutPadding = 0.0;
    }

    if (barWithoutPadding.isNaN) {
      barWithoutPadding = 0.0;
    }
    return Padding(
        padding: EdgeInsets.all(padding),
        child: Container(
          width: barWithoutPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  //full bar
                  Container(
                    height: barHeight,
                    width: barWithoutPadding,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: backgroundColor,
                      border: Border.all(
                        color: boarderColor,
                        width: 0.3,
                      ),
                    ),
                  ),
                  // percentage
                  Container(
                    height: barHeight,
                    width: precentageBarWithoutPadding < 0
                        ? percentageWidth
                        : precentageBarWithoutPadding,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: barColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 0.1,
              ),
            ],
          ),
        ));
  }
}
