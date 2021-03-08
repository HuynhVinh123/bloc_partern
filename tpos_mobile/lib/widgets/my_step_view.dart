import 'package:flutter/material.dart';

class MyStepView extends StatelessWidget {
  const MyStepView(
      {this.items, this.currentIndex = 0, this.lineColor = Colors.green});
  final List<MyStepItem> items;
  final int currentIndex;
  final Color lineColor;

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
          const SizedBox(
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
                            : const SizedBox(),
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
                            : const SizedBox(),
                      ),
                    ],
                  )),
                )
                .toList(),
          ),
          const SizedBox(
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
                            style: const TextStyle(fontSize: 10),
                          )
                        : const SizedBox(),
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
  final int index;
  final Widget icon;
  final Widget iconUncomplete;
  final Widget title;
  final String titleString;
  final Color lineColor;
  final Color iconCompleteColor;
  final bool isCompleted;
  final String content;
  final Widget customContent;
}
