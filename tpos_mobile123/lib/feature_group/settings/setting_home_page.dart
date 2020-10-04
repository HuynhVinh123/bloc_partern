import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';

class SettingHomePage extends StatefulWidget {
  @override
  _SettingHomePageState createState() => _SettingHomePageState();
}

class _SettingHomePageState extends State<SettingHomePage> {
  var _config = GetIt.instance<ConfigService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cài đặt trang chủ"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        ListTile(
          title:
              Text("Danh sách tính năng trên trang chủ khi ứng dụng được mở"),
          subtitle: Column(
            children: <Widget>[
              RadioListTile<bool>(
                title: Text("Tính năng tùy chọn của bạn"),
                value: false,
                groupValue: _config.showAllMenuOnStart,
                onChanged: (value) {
                  setState(
                    () {
                      _config.setShowAllMenuOnStart(false);
                    },
                  );
                },
              ),
              RadioListTile<bool>(
                title: Text("Toàn bộ chức năng"),
                value: true,
                groupValue: _config.showAllMenuOnStart,
                onChanged: (value) {
                  setState(() {
                    _config.setShowAllMenuOnStart(true);
                  });
                },
              ),
            ],
          ),
        ),
//        Divider(),
//        ListTile(
//          title: Text("Sắp xếp chức năng tùy chọn ở trang chủ"),
//          trailing: Icon(Icons.chevron_right),
//        ),
        Divider(),
      ],
    );
  }
}
