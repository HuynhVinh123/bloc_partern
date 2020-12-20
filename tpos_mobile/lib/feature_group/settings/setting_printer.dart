import 'package:flutter/material.dart';

import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../../resources/app_route.dart';

class SettingPrinterPage extends StatefulWidget {
  @override
  _SettingPrinterPageState createState() => _SettingPrinterPageState();
}

class _SettingPrinterPageState extends State<SettingPrinterPage> {
  final _setting = locator<ISettingService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.posOfSale_printerConfiguration),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    const divider = Divider(
      height: 1,
    );

    const icon = Icon(Icons.chevron_right);

    return ListView(
      children: <Widget>[
        //"Máy in đơn hàng (SALE ONLINE)
        ListTile(
          title: Text(S.current.setting_printerOrder),
          // subtitle: Text("${_setting.shipPrinterName ?? "Chưa chọn máy in"}"),
          trailing: icon,
          onTap: () {
            Navigator.pushNamed(context, AppRoute.saleOnlinePrinterSetting);
          },
        ),
        divider,
        // Máy in phiếu ship
        ListTile(
          title: Text(S.current.setting_printerShip),
          subtitle: Text(
              _setting.shipPrinterName ?? S.current.setting_printerNotPrinter),
          trailing: icon,
          onTap: () {
            Navigator.pushNamed(context, AppRoute.shipPrinterSetting);
          },
        ),
        divider,
        //Máy in hóa đơn
        ListTile(
          title: Text(S.current.setting_printerInvoice),
          subtitle: Text(_setting.fastSaleOrderInvoicePrinterName ??
              S.current.setting_printerNotPrinter),
          trailing: icon,
          onTap: () {
            Navigator.pushNamed(context, AppRoute.fastSaleOrderPrinterSetting);
          },
        ),
        divider,
        //Máy in điểm bán hàng
        ListTile(
          title: Text(S.current.setting_printerPointOfSale),
          subtitle: Text(_setting.posOrderPrinterName ??
              S.current.setting_printerNotPrinter),
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
