import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';
import 'package:tpos_mobile/services/config_service/shop_config_service.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SettingHomePage extends StatefulWidget {
  @override
  _SettingHomePageState createState() => _SettingHomePageState();
}

class _SettingHomePageState extends State<SettingHomePage> {
  final _config = GetIt.instance<ConfigService>();
  final _shopConfig = GetIt.instance<ShopConfigService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Cài đặt trang chủ
        title: Text("${S.current.setting} ${S.current.homePage.toLowerCase()}"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView(
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        //Danh sách tính năng trên trang chủ khi ứng dụng được mở
        // ListTile(
        //   title: Text(S.current.setting_homePageFeatureWhenOpenApp),
        //   subtitle: Column(
        //     children: <Widget>[
        //       RadioListTile<bool>(
        //         title: Text(S.current.setting_homePageFeature),
        //         value: false,
        //         groupValue: _config.showAllMenuOnStart,
        //         onChanged: (value) {
        //           setState(
        //             () {
        //               _config.setShowAllMenuOnStart(false);
        //             },
        //           );
        //         },
        //       ),
        //       RadioListTile<bool>(
        //         // Toàn bộ chức năng
        //         title: Text(S.current.menu_allFeature),
        //         value: true,
        //         groupValue: _config.showAllMenuOnStart,
        //         onChanged: (value) {
        //           setState(() {
        //             _config.setShowAllMenuOnStart(true);
        //           });
        //         },
        //       ),
        //     ],
        //   ),
        // ),
//        Divider(),
//        ListTile(
//          title: Text("Sắp xếp chức năng tùy chọn ở trang chủ"),
//          trailing: Icon(Icons.chevron_right),
//        ),
        const Divider(),
        ListTile(
          title: const Text("Giao diện màn hình chủ"),
          subtitle: Column(
            children: <Widget>[
              RadioListTile<String>(
                title: const Text("Phong cách 1 (Mặc định)"),
                value: 'style1',
                groupValue: _shopConfig.homePageStyle,
                onChanged: (value) {
                  setState(
                    () {
                      _shopConfig.setHomePageStyle("style1");
                    },
                  );
                },
              ),
              RadioListTile<String>(
                // Toàn bộ chức năng
                title: const Text("Phong cách 2"),
                value: "style2",
                groupValue: _shopConfig.homePageStyle,
                onChanged: (value) {
                  setState(() {
                    _shopConfig.setHomePageStyle("style2");
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
