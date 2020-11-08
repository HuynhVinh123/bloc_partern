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
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/category/product_search_page.dart';
import 'package:tpos_mobile/feature_group/settings/viewmodels/setting_fast_sale_viewmodel.dart';

import 'package:tpos_mobile/services/app_setting_service.dart';

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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        Text("Không cho in ship nếu chưa kết nối vận chuyển"),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Text(
                      "Không cho in bán hàng theo trạng thái",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildStatePrintOrder(),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 10, bottom: 6),
                    child: Text(
                      "Không cho in Ship theo trạng thái",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
          padding: EdgeInsets.all(8),
          child: RaisedButton(
            child: Text("LƯU VÀ ĐÓNG"),
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
            label: const Text(
              "Thêm",
              style: TextStyle(color: Colors.green),
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
            label: const Text(
              "Thêm",
              style: TextStyle(color: Colors.green),
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
                  Divider(
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
                  Divider(
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

  void _onSelectDefaultProduct() async {
    final Product product = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProductSearchPage()));

    if (product != null) {
      _vm.setProduct(product);
    }
  }
}
