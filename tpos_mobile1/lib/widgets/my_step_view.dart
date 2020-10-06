import 'package:flutter/material.dart';

class MyStepView extends StatelessWidget {
  final List<MyStepItem> items;
  final int currentIndex;
  final Color lineColor;
  MyStepView(
      {this.items, this.currentIndex = 0, this.lineColor = Colors.green});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: items
                .map(
                  (f) => Expanded(
                    child: f.title,
                  ),
                )
                .toList(),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: items
                .map(
                  (f) => Expanded(
                      child: Row(
                    children: <Widget>[
                      Expanded(
                        child: items.indexOf(f) > 0
                            ? Container(
                                height: 2,
                                color: f.isCompleted ? lineColor : Colors.grey,
                              )
                            : SizedBox(),
                      ),
                      Expanded(
                        child: f.isCompleted ? f.icon : f.iconUncomplete,
                      ),
                      Expanded(
                        child: items.indexOf(f) < items.length - 1
                            ? Container(
                                height: 2,
                                color: f.isCompleted ? lineColor : Colors.grey,
                              )
                            : SizedBox(),
                      ),
                    ],
                  )),
                )
                .toList(),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: items
                .map(
                  (f) => Expanded(
                    child: f.customContent ?? f.content != null
                        ? Text(
                            "${f.content}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10),
                          )
                        : SizedBox(),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class MyStepItem {
  final int index;
  final Widget icon;
  final Widget iconUncomplete;
  final Widget title;
  final String titleString;
  final Color lineColor;
  final iconCompleteColor;
  final bool isCompleted;
  final String content;
  final Widget customContent;

  MyStepItem(
      {this.icon = const Icon(Icons.check_circle),
      this.title,
      this.index,
      this.lineColor,
      this.isCompleted = false,
      this.iconCompleteColor = Colors.blue,
      this.titleString = "",
      this.content,
      this.customContent,
      this.iconUncomplete = const Icon(Icons.radio_button_unchecked)});
}
