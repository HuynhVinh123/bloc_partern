/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/5/19 4:54 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/5/19 9:51 AM
 *
 */

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_base.dart';
import 'package:tpos_mobile/feature_group/category/product_search_page.dart';
import 'package:tpos_mobile/feature_group/settings/viewmodels/setting_fast_sale_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SettingFastSaleOrderAddEditFullPage extends StatefulWidget {
  @override
  _SettingFastSaleOrderAddEditFullPageState createState() =>
      _SettingFastSaleOrderAddEditFullPageState();
}

class _SettingFastSaleOrderAddEditFullPageState
    extends State<SettingFastSaleOrderAddEditFullPage> {
  final _vm = SettingFastSaleViewModel();
  final _setting = locator<ISettingService>();
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
          // Cấu hình bán hàng nhanh
          title: Text(S.current.setting_settingFastSale),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SwitchListTile.adaptive(
                    value: _setting.isHideDeliveryAddressInFastSaleOrder,
                    onChanged: (value) {
                      setState(() {
                        _setting.isHideDeliveryAddressInFastSaleOrder = value;
                      });
                    },
                    // Ẩn địa chỉ giao hàng khi tạo hóa đơn
                    title: Text(S.current.setting_settingFastSaleHideAddress),
                  ),
                  SwitchListTile.adaptive(
                    value: _setting.isHideDeliveryCarrierInFastSaleOrder,
                    onChanged: (value) {
                      setState(() {
                        _setting.isHideDeliveryCarrierInFastSaleOrder = value;
                      });
                    },
                    // "Ẩn chọn đối tác giao hàng khi tạo hóa đơ
                    title: Text(S.current.setting_settingFastSaleHidePartner),
                  ),
                  const Divider(),
                  SwitchListTile.adaptive(
                    value: _setting.isAutoInputPaymentAmountInFastSaleOrder,
                    onChanged: (value) {
                      setState(() {
                        _setting.isAutoInputPaymentAmountInFastSaleOrder =
                            value;
                      });
                    },
                    // "Tự động điền số tiền thanh toán"
                    title: Text(S.current.setting_settingFastSaleAutoFill),
                    subtitle:
                        Text(S.current.setting_settingFastSalePaymentDefault),
                  ),
                  SwitchListTile.adaptive(
                    value: _setting.settingFastSaleOrderPrintShipAfterConfirm,
                    onChanged: (value) {
                      setState(() {
                        _setting.settingFastSaleOrderPrintShipAfterConfirm =
                            value;
                      });
                    },
                    // /In phiếu ship sau khi xác nhận"
                    title: Text(
                        S.current.setting_settingFastSalePrintAfterConfirm),
                    subtitle: Text(
                        S.current.setting_settingFastSalePrintAfterConfirm),
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
                    //Chuyển qua thông tin hóa đơn sau khi lưu /xác nhận"
                    title:
                        Text(S.current.setting_settingFastSaleMoveInvoiceInfo),
                    subtitle: Text(S.current
                        .setting_settingFastSaleConfirmAndMoveInvoiceInfo),
                  ),
                  SwitchListTile.adaptive(
                    value: _vm.saleSetting?.groupAmountPaid ?? false,
                    onChanged: (value) {
                      setState(() {
                        _vm.saleSetting?.groupAmountPaid = value;
                      });
                    },
                    //ắt tự động số tiền thanh toán = Tổng tiền hóa đơn
                    title: Text(S.current.setting_settingFastSaleTurnOffFill),
                  ),
                  const Divider(),
                  //Sản phẩm mặc định"
                  // "Sản phẩm sẽ được dùng trong tạo nhanh hóa đơn giao hàng với sản phẩm mặc định"
                  ListTile(
                    title:
                        Text(S.current.setting_settingFastSaleProductDefault),
                    subtitle: Text(
                      S.current
                          .setting_settingFastSaleProductAppToCreateFastInvoice,
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: _onSelectDefaultProduct,
                  ),
                  ListTile(
                    title: Text(
                      _vm.saleSetting?.product?.nameGet ??
                          "<${S.current.setting_settingFastSaleSelect1Product.toUpperCase()}>",
                      style: const TextStyle(color: Colors.blue),
                    ),
                    onTap: _onSelectDefaultProduct,
                  ),
                  const Divider(),
                  SwitchListTile.adaptive(
                    value:
                        _vm.saleSetting?.groupDenyPrintNoShippingConnection ??
                            false,
                    onChanged: (value) {
                      setState(() {
                        _vm.saleSetting?.groupDenyPrintNoShippingConnection =
                            value;
                      });
                    },
                    title:
                        //"Không cho in ship nếu chưa kết nối vận chuyển
                        Text(S.current.setting_settingFastSaleCannotPrintShip),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    //"Không cho in bán hàng theo trạng thái
                    child: Text(
                      S.current.setting_settingFastSaleCannotPrintSaleByStatus,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildStatePrintOrder(),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 10, bottom: 6),
                    //Không cho in Ship theo trạng thái"
                    child: Text(
                      S.current.setting_settingFastSaleCannotPrintShipByStatus,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildStatePrintShip(),
                  const Divider(),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: RaisedButton(
            child: Text(
                "${S.current.save.toUpperCase()} &  ${S.current.close.toUpperCase()}"),
            onPressed: () async {
              _vm.saleSetting?.statusDenyPrintSale = _vm.statePrintOrders;
              _vm.saleSetting?.statusDenyPrintShip = _vm.statePrintShips;
              if (await _vm.save()) {
                Navigator.pop(context);
                _vm.showNotify();
              }
            },
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
          ),
        )
      ],
    );
  }

  /// UI hiển thị danh sách trạng thái đã chọn cho in hóa đơn (In hóa đơn)
  Widget _buildStatePrintOrder() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        children: [
          ...List.generate(
              _vm.statePrintOrders.length,
              (index) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Chip(
                      label: Text(_vm.statePrintOrders[index]["Text"]),
                      deleteIcon: const Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onDeleted: () {
                        _vm.removeState(
                            _vm.statePrintOrders[index], index, false);
                      },
                    ),
                  )),
          RawChip(
            label: Text(
              S.current.add,
              style: const TextStyle(color: Colors.green),
            ),
            selected: false,
            onSelected: (value) {
              _showBottomSheet(isPrintShip: false);
            },
            avatar: const Icon(
              Icons.add,
              size: 20,
              color: Colors.green,
            ),
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }

  /// UI hiển thị danh sách trạng thái đã chọn cho in hóa đơn (In ship)
  Widget _buildStatePrintShip() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        children: [
          ...List.generate(
              _vm.statePrintShips.length,
              (index) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Chip(
                      label: Text(_vm.statePrintShips[index]["Text"]),
                      deleteIcon: const Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onDeleted: () {
                        _vm.removeState(
                            _vm.statePrintShips[index], index, true);
                      },
                    ),
                  )),
          RawChip(
            label: Text(
              S.current.add,
              style: const TextStyle(color: Colors.green),
            ),
            selected: false,
            onSelected: (value) {
              _showBottomSheet(isPrintShip: true);
            },
            avatar: const Icon(
              Icons.add,
              size: 20,
              color: Colors.green,
            ),
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }

  /// Hiển thị trạng thái
  void _showBottomSheet({bool isPrintShip}) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      topLeft: Radius.circular(12))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text(_vm.states[0]["Text"]),
                    leading: const Icon(
                      Icons.confirmation_num,
                      color: Color(0xFF929DAA),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _vm.addState(_vm.states[0], 0, isPrintShip);
                    },
                    trailing: Visibility(
                        visible: isPrintShip
                            ? _vm.checkedStatePrintShips[0]
                            : _vm.statesChecked[0],
                        child: const Icon(
                          Icons.check,
                          color: Colors.green,
                        )),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  ListTile(
                    title: Text(_vm.states[1]["Text"]),
                    leading: const Icon(
                      Icons.payment,
                      color: Color(0xFF929DAA),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _vm.addState(_vm.states[1], 1, isPrintShip);
                    },
                    trailing: Visibility(
                        visible: isPrintShip
                            ? _vm.checkedStatePrintShips[1]
                            : _vm.statesChecked[1],
                        child: const Icon(
                          Icons.check,
                          color: Colors.green,
                        )),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  ListTile(
                    title: Text(_vm.states[2]["Text"]),
                    leading: const Icon(
                      Icons.drafts,
                      color: Color(0xFF929DAA),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _vm.addState(_vm.states[2], 2, isPrintShip);
                    },
                    trailing: Visibility(
                        visible: isPrintShip
                            ? _vm.checkedStatePrintShips[2]
                            : _vm.statesChecked[2],
                        child: const Icon(
                          Icons.check,
                          color: Colors.green,
                        )),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  ListTile(
                    title: Text(_vm.states[3]["Text"]),
                    leading: const Icon(
                      Icons.cancel,
                      color: Color(0xFF929DAA),
                    ),
                    onTap: () {
                      print(json.encode(_vm.states[3]));
                      print(json
                          .decode("{\"Text\":\"Hủy\",\"Value\":\"cancel\"}"));
                      Navigator.pop(context);
                      _vm.addState(_vm.states[3], 3, isPrintShip);
                    },
                    trailing: Visibility(
                        visible: isPrintShip
                            ? _vm.checkedStatePrintShips[3]
                            : _vm.statesChecked[3],
                        child: const Icon(
                          Icons.check,
                          color: Colors.green,
                        )),
                  ),
                ],
              ));
        });
  }

  Future<void> _onSelectDefaultProduct() async {
    final Product product = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ProductSearchPage()));

    if (product != null) {
      _vm.setProduct(product);
    }
  }
}
