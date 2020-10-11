import 'package:flutter/material.dart';

import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';

import '../../resources/app_route.dart';

class SettingPrinterPage extends StatefulWidget {
  @override
  _SettingPrinterPageState createState() => _SettingPrinterPageState();
}

class _SettingPrinterPageState extends State<SettingPrinterPage> {
  var _setting = locator<ISettingService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cấu hình máy in"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    var divider = new Divider(
      height: 1,
    );

    var icon = new Icon(Icons.chevron_right);

    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("Máy in đơn hàng (SALE ONLINE)"),
          // subtitle: Text("${_setting.shipPrinterName ?? "Chưa chọn máy in"}"),
          trailing: icon,
          onTap: () {
            Navigator.pushNamed(context, AppRoute.saleOnlinePrinterSetting);
          },
        ),
        divider,
        ListTile(
          title: Text("Máy in phiếu ship"),
          subtitle: Text("${_setting.shipPrinterName ?? "Chưa chọn máy in"}"),
          trailing: icon,
          onTap: () {
            Navigator.pushNamed(context, AppRoute.shipPrinterSetting);
          },
        ),
        divider,
        ListTile(
          title: Text("Máy in hóa đơn"),
          subtitle: Text(
              "${_setting.fastSaleOrderInvoicePrinterName ?? "Chưa chọn máy in"}"),
          trailing: icon,
          onTap: () {
            Navigator.pushNamed(context, AppRoute.fastSaleOrderPrinterSetting);
          },
        ),
        divider,
        ListTile(
          title: Text("Máy in điểm bán hàng"),
          subtitle:
              Text("${_setting.posOrderPrinterName ?? "Chưa chọn máy in"}"),
          trailing: icon,
          onTap: () {
            Navigator.pushNamed(context, AppRoute.posOrderPrinterSetting);
          },
        ),
        divider,
      ],
    );
  }
}
