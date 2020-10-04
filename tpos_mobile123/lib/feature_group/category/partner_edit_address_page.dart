import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_base.dart';
import 'package:tpos_mobile/feature_group/fast_sale_order/ui/fast_sale_order_add_edit_full_ship_address_edit_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/check_address_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_select_address.dart';

import 'package:tpos_mobile/feature_group/sale_online/viewmodels/partner_add_edit_viewmodel.dart';

import 'package:tpos_mobile/src/tpos_apis/models/Address.dart';
import 'package:tpos_mobile/src/tpos_apis/models/CheckAddress.dart';

class PartnerEditAddressPage extends StatefulWidget {
  final int partnerId;
  final Partner partner;
  final bool closeAfterSaved;
  final VoidCallback onSaved;
  PartnerEditAddressPage(
      {this.partner, this.partnerId, this.closeAfterSaved, this.onSaved});
  @override
  _PartnerEditAddressPageState createState() => _PartnerEditAddressPageState();
}

class _PartnerEditAddressPageState extends State<PartnerEditAddressPage> {
  var _vm = PartnerAddEditViewModel();

  var _nameTextController = new TextEditingController();
  var _phoneTextController = new TextEditingController();
  var _streetTextController = new TextEditingController();
  var _checkKeywordTextController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scafffoldKey = new GlobalKey<ScaffoldState>();

  Future _showCheckAddress() async {
    var result = await Navigator.push(
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
      _vm.partner?.city =
          new CityAddress(code: result.cityCode, name: result.cityName);

      _vm.partner?.district = new DistrictAddress(
          code: result.districtCode, name: result.districtName);

      _vm.partner?.ward =
          new WardAddress(code: result.wardCode, name: result.wardName);

      _vm.partner?.street = result.address;
      _streetTextController.text = _vm.partner?.street;
    }
  }

  @override
  void initState() {
    _vm.partner.id = widget.partnerId;
    _vm.init(isCustomer: true);

    _vm.addListener(() {
      _nameTextController.text = _vm.partner?.name;
      _phoneTextController.text = _vm.partner?.phone;
      _streetTextController.text = _vm.partner?.street;
    });

    super.initState();
  }

  void _onSavePress() {
    _vm.save(null).then((bool result) {
      if (result) {
        Navigator.pop(context);
        if (widget.onSaved != null) widget.onSaved();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return UIViewModelBase<PartnerAddEditViewModel>(
      viewModel: _vm,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Cập nhật địa chỉ"),
          actions: <Widget>[
            FlatButton.icon(
              textColor: Colors.white,
              onPressed: () {
                _onSavePress();
              },
              icon: Icon(Icons.save),
              label: Text("LƯU"),
            )
          ],
        ),
        body: _buildBody(),
        bottomNavigationBar: Container(
          child: RaisedButton.icon(
            textColor: Colors.white,
            icon: Icon(Icons.arrow_back),
            label: Text("LƯU & ĐÓNG"),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              _onSavePress();
            },
          ),
          padding: EdgeInsets.all(8),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: ScopedModelDescendant<PartnerAddEditViewModel>(
        builder: (context, _, __) => Column(
          children: <Widget>[
            Container(
              color: Colors.grey.shade300,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 12, right: 12),
                      color: Colors.white,
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Tên khách hàng:",
                            ),
                            controller: _nameTextController,
                            onChanged: (text) {
                              _vm.partner?.name = text.trim();
                            },
                          ),
                          TextField(
                            controller: _phoneTextController,
                            autofocus: false,
                            onChanged: (text) {
                              _vm.partner?.phone = text.trim();
                            },
                            decoration: InputDecoration(
                              labelText: "Số điện thoại:",
                            ),
                          ),
                          TextField(
                              maxLines: null,
                              controller: _streetTextController,
                              onChanged: (text) {
                                _vm.partner?.street = text;
                              },
                              decoration: InputDecoration(
                                labelText: "Số nhà, tên đường:",
                                counter: SizedBox(
                                  height: 30,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      FlatButton(
                                        padding: EdgeInsets.all(0),
                                        child: Text("Copy"),
                                        textColor: Colors.blue,
                                        onPressed: () {
                                          Clipboard.setData(new ClipboardData(
                                              text: _vm.partner?.street));
                                          Scaffold.of(context).showSnackBar(
                                              new SnackBar(
                                                  content: Text(
                                                      "Đã copy ${_vm.partner?.street} vào clipboard")));
                                        },
                                      ),
                                      FlatButton(
                                        textColor: Colors.blue,
                                        padding: EdgeInsets.all(0),
                                        child: Text("Kiểm tra"),
                                        onPressed: () async {
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                          _showCheckAddress();
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 12, right: 12),
                      color: Colors.white,
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          SelectAddressWidget(
                            title: "Tỉnh thành: ",
                            currentValue:
                                _vm.partner?.city?.name ?? "Chọn tỉnh thành",
                            onTap: () async {
                              Address selectedCity = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => SelectAddressPage()));

                              if (selectedCity != null) {
                                setState(() {
                                  _vm.partner?.city = new CityAddress(
                                      code: selectedCity.code,
                                      name: selectedCity.name);

                                  _vm.partner?.district = null;
                                  _vm.partner?.ward = null;
                                });
                              }
                            },
                          ),
                          Divider(),
                          SelectAddressWidget(
                            title: "Quận/huyện",
                            currentValue: _vm.partner?.district?.name ??
                                "Chọn quận huyện",
                            valueColor: _vm.partner?.district == null
                                ? Colors.orange
                                : Colors.black,
                            onTap: () async {
                              if (_vm.partner?.city == null ||
                                  _vm.partner?.city?.code == null) {
                                return;
                              }
                              Address selectedCity = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => SelectAddressPage(
                                            cityCode: _vm.partner?.city.code,
                                          )));

                              if (selectedCity != null) {
                                setState(() {
                                  _vm.partner?.district = new DistrictAddress(
                                      code: selectedCity.code,
                                      name: selectedCity.name);

                                  _vm.partner?.ward = null;
                                });
                              }
                            },
                          ),
                          Divider(),
                          SelectAddressWidget(
                            title: "Phường/xã",
                            currentValue:
                                _vm.partner?.ward?.name ?? "Chọn phường xã",
                            valueColor: _vm.partner?.ward == null
                                ? Colors.orange
                                : Colors.black,
                            onTap: () async {
                              if (_vm.partner?.district == null ||
                                  _vm.partner?.district.code == null) {
                                return;
                              }
                              Address selectedCity = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => SelectAddressPage(
                                            cityCode: _vm.partner?.city.code,
                                            districtCode:
                                                _vm.partner?.district.code,
                                          )));

                              if (selectedCity != null) {
                                setState(() {
                                  _vm.partner?.ward = new WardAddress(
                                      code: selectedCity.code,
                                      name: selectedCity.name);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
