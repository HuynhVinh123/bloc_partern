import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

import 'package:tpos_mobile/feature_group/fast_sale_order/viewmodels/fast_sale_order_add_edit_full_viewmodel.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/check_address_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_select_address.dart';

import 'package:tpos_mobile/src/tpos_apis/models/CheckAddress.dart';
import 'package:tpos_mobile/src/tpos_apis/models/Address.dart';
import 'package:tpos_mobile/src/tpos_apis/models/ship_receiver.dart';


import 'package:tpos_mobile/widgets/ModalWaitingWidget.dart';

class FastSaleOrderAddEditFullShipAddressEditPage extends StatefulWidget {
  const FastSaleOrderAddEditFullShipAddressEditPage({@required this.vm});
  final FastSaleOrderAddEditFullViewModel vm;

  @override
  _FastSaleOrderAddEditFullShipAddressEditPageState createState() =>
      _FastSaleOrderAddEditFullShipAddressEditPageState();
}

class _FastSaleOrderAddEditFullShipAddressEditPageState
    extends State<FastSaleOrderAddEditFullShipAddressEditPage> {
  final _nameTextController = TextEditingController();
  final _phoneTextController = TextEditingController();
  final _streetTextController = TextEditingController();
  final GlobalKey<ScaffoldState> _scafffoldKey = GlobalKey<ScaffoldState>();

  final bool _isKeyboardVisible = false;

  Future _check() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckAddressPage(
          keyword: _streetTextController.text.trim(),
        ),
      ),
    );
//
//
    if (result != null && result is CheckAddress) {
      widget.vm.shipReceiver?.city =
          CityAddress(code: result.cityCode, name: result.cityName);

      widget.vm.shipReceiver?.district =
          DistrictAddress(code: result.districtCode, name: result.districtName);

      widget.vm.shipReceiver?.ward =
          WardAddress(code: result.wardCode, name: result.wardName);

      widget.vm.shipReceiver?.street = result.address;
      _streetTextController.text = widget.vm.shipReceiver?.street;
    }
  }

  @override
  void initState() {
//    KeyboardVisibilityNotification().addNewListener(onChange: (value) {
//      if (mounted)
//        setState(() {
//          _isKeyboardVisible = value;
//        });
//    });
    if (widget.vm.shipReceiver == null) {
      widget.vm.order.shipReceiver = ShipReceiver();
    }

    _nameTextController.text = widget.vm.shipReceiver?.name;
    _phoneTextController.text = widget.vm.shipReceiver?.phone;
    _streetTextController.text = widget.vm.shipReceiver?.street;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<FastSaleOrderAddEditFullViewModel>(
      model: widget.vm,
      child: GestureDetector(
        child: Scaffold(
          key: _scafffoldKey,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text("Sửa địa chỉ giao hàng"),
          ),
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(child: _buildBody()),
                if (!_isKeyboardVisible)
                  Container(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: RaisedButton.icon(
                      textColor: Colors.white,
                      icon: Icon(Icons.keyboard_return),
                      label: const Text("ĐÃ XONG"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                if (_isKeyboardVisible)
                  Container(
                    child: RaisedButton(
                      textColor: Colors.white,
                      child: const Text("XONG"),
                      color: Colors.grey.shade500,
                      onPressed: () {
                        FocusScope.of(context)?.requestFocus(FocusNode());
                      },
                    ),
                  ),
              ]),
        ),
        onTapDown: (tap) {
          FocusScope.of(context)?.requestFocus(FocusNode());
        },
      ),
    );
  }

  Widget _buildBody() {
    return ScopedModelDescendant<FastSaleOrderAddEditFullViewModel>(
      rebuildOnChange: true,
      builder: (ctx, _, model) {
        return ModalWaitingWidget(
          isBusyStream: model.isBusyController,
          initBusy: false,
          child: Container(
            color: Colors.grey.shade300,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    color: Colors.white,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        TextField(
                          decoration: const InputDecoration(
                            labelText: "Tên người nhận:",
                          ),
                          controller: _nameTextController,
                          onChanged: (text) {
                            model.shipReceiver?.name = text.trim();
                          },
                        ),
                        TextField(
                          controller: _phoneTextController,
                          autofocus: false,
                          onChanged: (text) {
                            model.shipReceiver?.phone = text.trim();
                          },
                          decoration: const InputDecoration(
                            labelText: "Số điện thoại:",
                          ),
                        ),
                        TextField(
                            maxLines: null,
                            controller: _streetTextController,
                            onChanged: (text) {
                              model.shipReceiver?.street = text;
                            },
                            decoration: InputDecoration(
                              labelText: "Địa chỉ:",
                              counter: SizedBox(
                                height: 30,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    FlatButton(
                                      padding: const EdgeInsets.all(0),
                                      child: const Text("Copy"),
                                      textColor: Colors.blue,
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(
                                            text: model.shipReceiver.street));
                                        Scaffold.of(ctx).showSnackBar(SnackBar(
                                            content: Text(
                                                "Đã copy ${model.shipReceiver.street} vào clipboard")));
                                      },
                                    ),
                                    FlatButton(
                                      textColor: Colors.blue,
                                      padding: const EdgeInsets.all(0),
                                      child: const Text("Kiểm tra"),
                                      onPressed: () async {
                                        _check();
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      },
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    color: Colors.white,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        SelectAddressWidget(
                          title: "Tỉnh thành: ",
                          currentValue: model.shipReceiver?.city?.name ??
                              "Chọn tỉnh thành",
                          onTap: () async {
                            final Address selectedCity = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) =>
                                        const SelectAddressPage()));

                            if (selectedCity != null) {
                              setState(() {
                                if (model.shipReceiver?.city?.code !=
                                    selectedCity.code) {
                                  model.shipReceiver?.city = CityAddress(
                                      code: selectedCity.code,
                                      name: selectedCity.name);
                                  model.shipReceiver?.district = null;
                                  model.shipReceiver?.ward = null;
                                }
                              });
                            }
                          },
                        ),
                        const Divider(),
                        SelectAddressWidget(
                          title: "Quận/huyện",
                          currentValue: model.shipReceiver?.district?.name ??
                              "Chọn quận huyện",
                          valueColor: model.shipReceiver?.district == null
                              ? Colors.orange
                              : Colors.black,
                          onTap: () async {
                            if (model.shipReceiver.city == null ||
                                model.shipReceiver.city.code == null) {
                              return;
                            }
                            final Address selectedCity = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => SelectAddressPage(
                                          cityCode:
                                              model.shipReceiver.city.code,
                                        )));

                            if (selectedCity != null) {
                              setState(() {
                                if (selectedCity.code !=
                                    model.shipReceiver?.district?.code) {
                                  model.shipReceiver?.district =
                                      DistrictAddress(
                                          code: selectedCity.code,
                                          name: selectedCity.name);

                                  model.shipReceiver?.ward = null;
                                }
                              });
                            }
                          },
                        ),
                        const Divider(),
                        SelectAddressWidget(
                          title: "Phường/xã",
                          currentValue: model.shipReceiver?.ward?.name ??
                              "Chọn phường xã",
                          valueColor: model.shipReceiver?.ward == null
                              ? Colors.orange
                              : Colors.black,
                          onTap: () async {
                            if (model.shipReceiver.district == null ||
                                model.shipReceiver.district.code == null) {
                              return;
                            }
                            final Address selectedCity = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => SelectAddressPage(
                                          cityCode:
                                              model.shipReceiver.city.code,
                                          districtCode:
                                              model.shipReceiver.district.code,
                                        )));

                            if (selectedCity != null) {
                              setState(() {
                                model.shipReceiver?.ward = WardAddress(
                                    code: selectedCity.code,
                                    name: selectedCity.name);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
//                  Container(
//                    padding: EdgeInsets.only(left: 12, right: 12),
//                    color: Colors.white,
//                    child: TextField(
//                      onChanged: (text) {
//                        // model.checkKeyword = text.trim();
//                      },
//                      controller: _checkKeywordTextController,
//                      decoration: InputDecoration(
//                          suffix: OutlineButton(
//                            onPressed: () async {
//                              _check();
//
//                              FocusScope.of(context)
//                                  .requestFocus(new FocusNode());
//                            },
//                            child: Text(
//                              "Kiểm tra",
//                              style: TextStyle(color: Colors.blue),
//                            ),
//                          ),
//                          labelText: "Nhập đc viết tắt để tìm địa chỉ nhanh",
//                          hintText: "VD: 54 dmc, tsn, tp, hcm "),
//                    ),
//                  ),
//                  SizedBox(
//                    height: 10,
//                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SelectAddressWidget extends StatelessWidget {
  const SelectAddressWidget(
      {this.title,
      this.currentValue,
      this.onTap,
      this.valueColor = Colors.black,
      this.contentPadding =
          const EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 2)});
  final String title;
  final String currentValue;
  final EdgeInsetsGeometry contentPadding;
  final Function onTap;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Padding(
        padding: contentPadding,
        child: Row(
          children: <Widget>[
            Text(title ?? ""),
            Expanded(
              child: Text(
                currentValue ?? "",
                textAlign: TextAlign.right,
                style: TextStyle(color: valueColor),
              ),
            ),
            Icon(Icons.chevron_right)
          ],
        ),
      ),
    );
  }
}
