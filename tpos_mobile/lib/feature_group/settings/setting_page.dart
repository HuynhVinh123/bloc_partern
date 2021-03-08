import 'package:flutter/material.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/resources/app_route.dart';
import 'package:tpos_mobile/services/print_service.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    locator<PrintService>().clearCache();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.setting),
      ),
      body: _showBody(),
    );
  }

  Widget _showBody() {
    const divider = Divider(
      height: 1,
    );
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text(S.current.homePage),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, AppRoute.homeSetting);
          },
        ),
        divider,
        ListTile(
          title: Text(S.current.config_SaleOnlineSetting),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, AppRoute.saleOnlineSetting);
          },
        ),
        divider,
        ListTile(
          title: Text(S.current.config_SaleSettings),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, AppRoute.fastSaleOrderSetting);
          },
        ),
        divider,
        ListTile(
          title: Text(S.current.config_printers),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, AppRoute.printersSetting);
          },
        ),
        divider,
        ListTile(
          title: Text(S.current.printConfiguration),
          subtitle: Text(S.current.setting_description),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, AppRoute.printSetting);
          },
        ),
        divider,
        ListTile(
          title: Text(S.current.configurationSynchronized),
          subtitle: Text(S.current.configurationSyncDescription),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, AppRoute.configurationSync);
          },
        ),
        divider,
      ],
    );
  }
}
