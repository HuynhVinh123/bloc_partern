/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/5/19 4:54 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/5/19 9:51 AM
 *
 */

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/category/product_search_page.dart';
import 'package:tpos_mobile/feature_group/settings/viewmodels/setting_fast_sale_viewmodel.dart';

import 'package:tpos_mobile/services/app_setting_service.dart';

import 'package:tpos_mobile/src/tpos_apis/models/product.dart';

class SettingFastSaleOrderAddEditFullPage extends StatefulWidget {
  @override
  _SettingFastSaleOrderAddEditFullPageState createState() =>
      _SettingFastSaleOrderAddEditFullPageState();
}

class _SettingFastSaleOrderAddEditFullPageState
    extends State<SettingFastSaleOrderAddEditFullPage> {
  var _vm = SettingFastSaleViewModel();
  var _setting = locator<ISettingService>();
  @override
  void initState() {
    _vm.init();
    _vm.initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UIViewModelBase<SettingFastSaleViewModel>(
      viewModel: _vm,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Cấu hình bán hàng nhanh"),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ScopedModelDescendant<SettingFastSaleViewModel>(
            builder: (context, _, ___) => SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SwitchListTile.adaptive(
                    value: _setting.isHideDeliveryAddressInFastSaleOrder,
                    onChanged: (value) {
                      setState(() {
                        _setting.isHideDeliveryAddressInFastSaleOrder = value;
                      });
                    },
                    title: Text("Ẩn địa chỉ giao hàng khi tạo hóa đơn"),
                  ),
                  SwitchListTile.adaptive(
                    value: _setting.isHideDeliveryCarrierInFastSaleOrder,
                    onChanged: (value) {
                      setState(() {
                        _setting.isHideDeliveryCarrierInFastSaleOrder = value;
                      });
                    },
                    title: Text("Ẩn chọn đối tác giao hàng khi tạo hóa đơn"),
                  ),
                  Divider(),
                  SwitchListTile.adaptive(
                    value: _setting.isAutoInputPaymentAmountInFastSaleOrder,
                    onChanged: (value) {
                      setState(() {
                        _setting.isAutoInputPaymentAmountInFastSaleOrder =
                            value;
                      });
                    },
                    title: Text("Tự động điền số tiền thanh toán"),
                    subtitle:
                        Text("Số tiền thanh toán mặc định = tổng tiền hóa đơn"),
                  ),
                  SwitchListTile.adaptive(
                    value: _setting.settingFastSaleOrderPrintShipAfterConfirm,
                    onChanged: (value) {
                      setState(() {
                        _setting.settingFastSaleOrderPrintShipAfterConfirm =
                            value;
                      });
                    },
                    title: Text("In phiếu ship sau khi xác nhận"),
                    subtitle: Text("In phiếu ship sau khi xác nhận"),
                  ),
                  const Divider(),
                  SwitchListTile.adaptive(
                    value: _setting.isShowInfoInvoiceAfterSaveFastSaleOrder,
                    onChanged: (value) {
                      setState(() {
                        _setting.isShowInfoInvoiceAfterSaveFastSaleOrder =
                            value;
                      });
                    },
                    title: Text(
                        "Chuyển qua thông tin hóa đơn sau khi lưu /xác nhận"),
                    subtitle: Text(
                        "Xác nhận và chuyển qua trang thông tin hóa đơn vừa tạo"),
                  ),
                  SwitchListTile.adaptive(
                    value: _vm.saleSetting?.groupAmountPaid ?? false,
                    onChanged: (value) {
                      setState(() {
                        _vm.saleSetting?.groupAmountPaid = value;
                      });
                    },
                    title: Text(
                        "Tắt tự động số tiền thanh toán = Tổng tiền hóa đơn"),
                  ),
                  const Divider(),
                  ListTile(
                    title: Text("Sản phẩm mặc định"),
                    subtitle: Text(
                      "Sản phẩm sẽ được dùng trong tạo nhanh hóa đơn giao hàng với sản phẩm mặc định",
                    ),
                    trailing: (Icon(Icons.keyboard_arrow_right)),
                    onTap: _onSelectDefaultProduct,
                  ),
                  ListTile(
                    title: Text(
                      "${_vm.saleSetting?.product?.nameGet ?? "<CHỌN MỘT SẢN PHẨM>"}",
                      style: const TextStyle(color: Colors.blue),
                    ),
                    onTap: _onSelectDefaultProduct,
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(8),
          child: RaisedButton(
            child: Text("LƯU VÀ ĐÓNG"),
            onPressed: () async {
              if (await _vm.save()) {
                Navigator.pop(context);
              }
            },
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
          ),
        )
      ],
    );
  }

  void _onSelectDefaultProduct() async {
    Product product = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProductSearchPage()));

    if (product != null) {
      _vm.setProduct(product);
    }
  }
}
