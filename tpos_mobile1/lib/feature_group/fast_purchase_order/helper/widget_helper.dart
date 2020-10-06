import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/screen_helper.dart';

import 'custom_shape.dart';
import 'data_helper.dart';

Widget loadingScreen({String text}) {
  return Stack(
    children: <Widget>[
      Scaffold(
        backgroundColor: Colors.black26,
        body: text != null
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: ListTile(
                          leading: loadingIcon(),
                          title: Text("$text..."),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Center(
                child: loadingIcon(),
              ),
      )
    ],
  );
}

Widget loadingIcon() {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
    child: CircularProgressIndicator(),
  );
}

Widget showCustomContainer({Widget child}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
    child: Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 1,
            )
          ]),
      child: child,
    ),
  );
}

Widget stateBar(String currentState) {
  List<String> stateBarListState = ["draft", "open", "paid", "cancel"];
  Color backgroundColor = Colors.grey.shade200;
  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: stateBarListState.map((state) {
            return Expanded(
              child: AutoSizeText(
                "${getStateVietnamese(state)}",
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black87),
              ),
            );
          }).toList(),
        ),
        Row(
          children: stateBarListState.map((state) {
            bool isFirst = stateBarListState.indexOf(state) == 0;
            bool isLast = stateBarListState.indexOf(state) ==
                stateBarListState.length - 1;
            bool isHighlight = stateBarListState.indexOf(state) <=
                stateBarListState.indexOf(currentState ?? "");
            return Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                color: isFirst
                                    ? backgroundColor
                                    : isHighlight ? Colors.green : Colors.grey,
                                height: 2,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                color: isLast
                                    ? backgroundColor
                                    : isHighlight ? Colors.green : Colors.grey,
                                height: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: backgroundColor, shape: BoxShape.circle),
                          child: Icon(
                            isHighlight
                                ? FontAwesomeIcons.checkCircle
                                : FontAwesomeIcons.circle,
                            color: isHighlight ? Colors.green : Colors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}

Future myErrorDialog({
  String title = "Thất bại",
  String content,
  BuildContext context,
  Widget actionBtn,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("$title"),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.cancel,
              color: Colors.grey,
            ),
          )
        ],
      ),
      content: Text("${content.replaceAll("Exception:", "")}"),
      actions: <Widget>[
        actionBtn == null ? SizedBox() : actionBtn,
      ],
    ),
  );
}

class MyCustomerAlerCard extends StatefulWidget {
  final String text;

  @override
  _MyCustomerAlerCardState createState() => _MyCustomerAlerCardState();

  MyCustomerAlerCard({this.text});
}

class _MyCustomerAlerCardState extends State<MyCustomerAlerCard> {
  bool isShow = true;
  Color myWhite = Colors.white.withOpacity(0.75);
  Color myRed = Colors.red.withOpacity(0.8);
  @override
  Widget build(BuildContext context) {
    return isShow ? _showMyCard() : SizedBox();
  }

  Widget _showMyCard() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 5),
            )
          ]),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(),
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: Container(
                  decoration: BoxDecoration(
                    color: myRed,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                    ),
                  ),
                  child: Icon(
                    Icons.cancel,
                    color: myWhite,
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.text,
                    style: prefix0.TextStyle(color: myRed),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isShow = false;
                  });
                },
                icon: Icon(
                  Icons.clear,
                  color: myRed,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

Widget clipShape(BuildContext context) {
  double _height;
  _height = getScreenHeight(context);
  return Stack(
    children: <Widget>[
      ClipPath(
        clipper: MyClipper(),
        child: Container(
          height: 220,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF035A1A),
                Color(0xFF1CAC3E),
              ],
            ),
          ),
        ),
      ),

//      ClipPath(
//        clipper: CustomShapeClipper2(),
//        child: Container(
//          height: 200,
//          decoration: const BoxDecoration(
//            gradient: LinearGradient(
//              colors: [
//                Color(0xFF1CAC3E),
//                Color(0xFF7AC461),
//              ],
//            ),
//          ),
//        ),
//      ),

//      Opacity(
//        opacity: 0.25,
//        child: ClipPath(
//          clipper: CustomShapeClipper3(),
//          child: Container(
//            height: _height / 3,
//            decoration: BoxDecoration(
//              gradient: LinearGradient(
//                colors: [
//                  Color(0xFF165F42),
//                  Color(0xFF8FC751),
//                ],
//              ),
//            ),
//          ),
//        ),
//      ),
      /*Container(
        margin: EdgeInsets.only(left: 40, right: 40, top: _height / 3.75),
        child: Material(
          borderRadius: BorderRadius.circular(30.0),
          elevation: 8,
          child: Container(
            child: TextFormField(
              cursorColor: Colors.orange[200],
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                prefixIcon:
                    Icon(Icons.search, color: Colors.orange[200], size: 30),
                hintText: "What're you looking for?",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
      ),*/
    ],
  );
}

void showCusSnackBar({
  @required ScaffoldState currentState,
  @required Widget child,
}) {
  try {
    currentState?.removeCurrentSnackBar();
  } catch (e, s) {}

  currentState?.showSnackBar(
    SnackBar(
      content: child,
    ),
  );
}
