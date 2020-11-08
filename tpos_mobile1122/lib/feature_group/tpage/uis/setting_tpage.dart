import 'package:flutter/material.dart';
import 'package:tpos_mobile/feature_group/tpage/uis/item_setting_page.dart';

class SettingTPagePage extends StatefulWidget {
  @override
  _SettingTPagePageState createState() => _SettingTPagePageState();
}

class _SettingTPagePageState extends State<SettingTPagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ItemSettingPage(),
            ItemSettingPage(),
            ItemSettingPage(),
            ItemSettingPage(),
          ],
        ),
      ),
    );
  }
}
