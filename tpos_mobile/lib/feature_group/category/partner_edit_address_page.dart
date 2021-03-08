import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/blocs/partner_edit_address/partner_edit_address_bloc.dart';
import 'package:tpos_mobile/feature_group/fast_sale_order/ui/fast_sale_order_add_edit_full_ship_address_edit_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/check_address_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_select_address.dart';
import 'package:tpos_mobile/src/tpos_apis/models/Address.dart';
import 'package:tpos_mobile/src/tpos_apis/models/CheckAddress.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/page_state/page_state.dart';
import 'package:tpos_mobile/widgets/page_state/page_state_type.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../../app.dart';
import 'blocs/partner_edit_address/partner_edit_address_event.dart';
import 'blocs/partner_edit_address/partner_edit_address_state.dart';

class PartnerEditAddressPage extends StatefulWidget {
  const PartnerEditAddressPage(
      {this.partner, this.partnerId, this.closeAfterSaved, this.onSaved});
  final int partnerId;
  final Partner partner;
  final bool closeAfterSaved;
  final VoidCallback onSaved;

  @override
  _PartnerEditAddressPageState createState() => _PartnerEditAddressPageState();
}

class _PartnerEditAddressPageState extends State<PartnerEditAddressPage> {
  // var _vm = PartnerAddEditViewModel();

  final PartnerEditAddressBloc _bloc = PartnerEditAddressBloc();

  final _nameTextController = TextEditingController();
  final _phoneTextController = TextEditingController();
  final _streetTextController = TextEditingController();

  bool _isFirstLoad = true;
  Partner _partner = Partner();

  Future _showCheckAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckAddressPage(
          keyword: _streetTextController.text.trim(),
        ),
      ),
    );

    if (result != null && result is CheckAddress) {
      _partner?.city =
          CityAddress(code: result.cityCode, name: result.cityName);

      _partner?.district =
          DistrictAddress(code: result.districtCode, name: result.districtName);

      _partner?.ward =
          WardAddress(code: result.wardCode, name: result.wardName);

      _partner?.street = result.address;
      _streetTextController.text = _partner?.street;
    }
  }

  @override
  void initState() {
    _bloc.add(PartnerEditAddressLoaded(partnerId: widget.partnerId));
    super.initState();
  }

  void _onSavePress() {
    _partner.name = _nameTextController.text;
    _partner.phone = _phoneTextController.text;
    _partner.street = _streetTextController.text;
    _bloc.add(PartnerEditAddressSaved(partner: _partner));
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<PartnerEditAddressBloc>(
      bloc: _bloc,
      listen: (state) {
        if (state is PartnerEditAddressLoadFailure) {
          App.showDefaultDialog(
              title: state.title,
              content: state.content,
              type: AlertDialogType.error,
              context: context);
        } else if (state is PartnerEditAddActionFailure) {
          App.showDefaultDialog(
              title: state.title,
              content: state.content,
              type: AlertDialogType.error,
              context: context);
        } else if (state is PartnerEditAddActionSuccess) {
          Navigator.pop(context);
          if (widget.onSaved != null) widget.onSaved();
          App.showToast(
              title: state.title,
              message: state.content,
              type: AlertDialogType.info,
              context: context);
        }
      },
      child: Scaffold(
        // backgroundColor: Colors.grey,
        appBar: AppBar(
          title: const Text("Cập nhật địa chỉ"),
          actions: <Widget>[
            FlatButton.icon(
              textColor: Colors.white,
              onPressed: () {
                if (_isFirstLoad) {
                  Navigator.pop(context);
                } else {
                  _onSavePress();
                }
              },
              icon: const Icon(Icons.save),
              label: const Text("LƯU"),
            ),
          ],
        ),
        body: BlocLoadingScreen<PartnerEditAddressBloc>(
            busyStates: const [PartnerEditAddressLoading],
            child: BlocBuilder<PartnerEditAddressBloc, PartnerEditAddressState>(
                buildWhen: (prevState, currState) =>
                    currState is PartnerEditAddressLoadSuccess ||
                    currState is PartnerEditAddressLoadFailure,
                builder: (context, state) {
                  if (state is PartnerEditAddressLoadSuccess) {
                    return _buildBody(state, context);
                  } else if (state is PartnerEditAddressLoadFailure) {
                    return AppPageState(
                      type: PageStateType.dataError,
                      actions: [
                        Container(
                          width: 110,
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          child: FlatButton(
                              color: Colors.green,
                              onPressed: () async {
                                _bloc.add(PartnerEditAddressLoaded(
                                    partnerId: widget.partnerId));
                              },
                              child: Text(
                                S.current.reload,
                                style: const TextStyle(color: Colors.white),
                              )),
                        )
                      ],
                    );
                  }
                  return const SizedBox();
                })),
        bottomNavigationBar: Container(
          child: RaisedButton.icon(
            textColor: Colors.white,
            icon: const Icon(Icons.arrow_back),
            label: const Text("LƯU & ĐÓNG"),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              if (_isFirstLoad) {
                Navigator.pop(context);
              } else {
                _onSavePress();
              }
            },
          ),
          padding: const EdgeInsets.all(8),
        ),
      ),
    );
  }

  Widget _buildBody(
      PartnerEditAddressLoadSuccess state, BuildContext buildContext) {
    _partner = state.partner;
    if (_isFirstLoad) {
      _nameTextController.text = state.partner.name ?? '';
      _phoneTextController.text = state.partner.phone ?? '';
      _streetTextController.text = state.partner.street ?? '';
      _isFirstLoad = false;
    }
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Container(
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
                          labelText: "Tên khách hàng:",
                        ),
                        controller: _nameTextController,
                        onChanged: (text) {
                          // _vm.partner?.name = text.trim();
                        },
                      ),
                      TextField(
                        controller: _phoneTextController,
                        autofocus: false,
                        onChanged: (text) {
                          // _vm.partner?.phone = text.trim();
                        },
                        decoration: const InputDecoration(
                          labelText: "Số điện thoại:",
                        ),
                      ),
                      TextField(
                          maxLines: null,
                          controller: _streetTextController,
                          onChanged: (text) {
                            // _vm.partner?.street = text;
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
                                    padding: const EdgeInsets.all(0),
                                    child: const Text("Copy"),
                                    textColor: Colors.blue,
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                          text: _streetTextController.text));
                                      Scaffold.of(buildContext).showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "Đã copy ${_streetTextController.text} vào clipboard")));
                                    },
                                  ),
                                  FlatButton(
                                    textColor: Colors.blue,
                                    padding: const EdgeInsets.all(0),
                                    child: const Text("Kiểm tra"),
                                    onPressed: () async {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
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
                        currentValue:
                            state.partner.city?.name ?? "Chọn tỉnh thành",
                        onTap: () async {
                          final Address selectedCity = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => const SelectAddressPage()));

                          if (selectedCity != null) {
                            state.partner?.city = CityAddress(
                                code: selectedCity.code,
                                name: selectedCity.name);

                            state.partner?.district = null;
                            state.partner?.ward = null;
                            _bloc.add(PartnerEditAddressSelectAddress(
                                partner: state.partner));
                          }
                        },
                      ),
                      const Divider(),
                      SelectAddressWidget(
                        title: "Quận/huyện",
                        currentValue:
                            state.partner.district?.name ?? "Chọn quận huyện",
                        valueColor: state.partner.district?.name == null
                            ? Colors.orange
                            : Colors.black,
                        onTap: () async {
                          if (state.partner?.city == null ||
                              state.partner?.city?.code == null) {
                            return;
                          }
                          final Address selectedCity = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => SelectAddressPage(
                                        cityCode: state.partner.city.code,
                                      )));

                          if (selectedCity != null) {
                            state.partner?.district = DistrictAddress(
                                code: selectedCity.code,
                                name: selectedCity.name);

                            state.partner?.ward = null;
                            _bloc.add(PartnerEditAddressSelectAddress(
                                partner: state.partner));
                          }
                        },
                      ),
                      const Divider(),
                      SelectAddressWidget(
                        title: "Phường/xã",
                        currentValue:
                            state.partner.ward?.name ?? "Chọn phường xã",
                        valueColor: state.partner.ward?.name == null
                            ? Colors.orange
                            : Colors.black,
                        onTap: () async {
                          if (state.partner?.district == null ||
                              state.partner?.district?.code == null) {
                            return;
                          }
                          final Address selectedCity = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => SelectAddressPage(
                                        cityCode: state.partner?.city?.code,
                                        districtCode:
                                            state.partner?.district?.code,
                                      )));

                          if (selectedCity != null) {
                            state.partner?.ward = WardAddress(
                                code: selectedCity.code,
                                name: selectedCity.name);
                            _bloc.add(PartnerEditAddressSelectAddress(
                                partner: state.partner));
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
