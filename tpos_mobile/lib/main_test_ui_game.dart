import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/game_helper.dart';
import 'feature_group/sale_online/game/lucky_wheel/lucky_wheel_setting_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LuckyWheelSettingPage(),
    );
  }
}

class ShowTutorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Container(
        child: Center(
          child: RaisedButton(
            onPressed: () {
              showTutorial(context);
            },
            child: const Text('Show Tutorial Game'),
          ),
        ),
      ),
    );
  }
}
