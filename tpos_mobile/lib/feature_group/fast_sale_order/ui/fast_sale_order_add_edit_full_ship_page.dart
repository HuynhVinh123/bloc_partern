import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

import 'package:tpos_mobile/feature_group/fast_sale_order/viewmodels/fast_sale_order_add_edit_full_viewmodel.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_service/calculate_fee_result.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/delivery_carrier_search_page.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/helpers/tmt.dart';
import 'package:tpos_mobile/helpers/ui_help.dart';

import 'package:tpos_mobile/widgets/ModalWaitingWidget.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

class FastSaleOrderAddEditFullShipInfoPage extends StatefulWidget {
  final FastSaleOrderAddEditFullViewModel editVm;
  FastSaleOrderAddEditFullShipInfoPage({@required this.editVm});
  @override
  _FastSaleOrderAddEditFullShipInfoPageState createState() =>
      _FastSaleOrderAddEditFullShipInfoPageState();
}

class _FastSaleOrderAddEditFullShipInfoPageState
    extends State<FastSaleOrderAddEditFullShipInfoPage> {
  FastSaleOrderAddEditFullViewModel _vm;
  final _weightController = new TextEditingController();
  final _feeController = new TextEditingController();
  final _depositController = new TextEditingController();
  final _cashOnDeliveryController = new TextEditingController();
  final _deliverNoteController = new TextEditingController();
  final _insuranceFeeController = new TextEditingController();
  TextEditingController _edittingController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isEditInsuranceFee = false;

  @override
  void initState() {
    _vm = widget.editVm;
    _weightController.text = NumberFormat("###,###,###").format(_vm.shipWeight);
    _feeController.text = vietnameseCurrencyFormat(_vm.deliveryPrice);
    _depositController.text = vietnameseCurrencyFormat(_vm.depositAmount);
    _insuranceFeeController.text =
        vietnameseCurrencyFormat(_vm.shipInsuranceFee);
    _cashOnDeliveryController.text =
        vietnameseCurrencyFormat(_vm.cashOnDelivery);
    _deliverNoteController.text = _vm.deliveryNote;

    if (_vm.carrier != null) {
      _vm.setDeliveryCarrier(_vm.carrier);
    }

    _vm.addListener(() {
      if (_edittingController != _weightController)
        _weightController.text =
            NumberFormat("###,###,###").format(_vm.shipWeight);
      if (_edittingController != _feeController)
        _feeController.text = vietnameseCurrencyFormat(_vm.deliveryPrice);
      if (_edittingController != _depositController)
        _depositController.text = vietnameseCurrencyFormat(_vm.depositAmount);
      _cashOnDeliveryController.text =
          vietnameseCurrencyFormat(_vm.cashOnDelivery);
      if (_edittingController != _deliverNoteController)
        _deliverNoteController.text = _vm.deliveryNote;
      _insuranceFeeController.text =
          vietnameseCurrencyFormat(_vm.shipInsuranceFee);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<FastSaleOrderAddEditFullViewModel>(
      model: widget.editVm,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(S.current.deliveryCarrierAndFee),
        ),
        body: _buildBody(),
        bottomNavigationBar: BottomBackButton(
          content: S.of(context).backToInvoice.toUpperCase(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    Divider defaultDivider = new Divider(
      height: 1,
    );

    TextStyle defaultNumberStyle = new TextStyle(fontWeight: FontWeight.bold);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)?.requestFocus(new FocusNode());
        _edittingController = null;
      },
      child: ModalWaitingWidget(
        isBusyStream: widget.editVm.isBusyController,
        initBusy: false,
        child: ScopedModelDescendant<FastSaleOrderAddEditFullViewModel>(
          builder: (context, _, vm) {
            return Container(
              color: Colors.grey.shade300,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _CarrierSelectPanel(),
                    defaultDivider,
                    //Ca lấy hàng\

                    if (_vm.shipExtra != null &&
                        _vm.shipExtra.hasSetting &&
                        _vm.shipExtra.pickWorkShift != null)
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text("Ca lấy hàng:"),
                              trailing: SizedBox(
                                width: 200,
                                child: DropdownButton<String>(
                                    hint: Text("Chọn ca lấy hàng"),
                                    isExpanded: true,
                                    value: widget
                                            .editVm.shipExtra?.pickWorkShift ??
                                        null,
                                    items: widget.editVm.shifts.keys.map((key) {
                                      return DropdownMenuItem<String>(
                                        value: key,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            SizedBox(),
                                            Text(
                                              widget.editVm.shifts[key],
                                              style: defaultNumberStyle,
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      widget.editVm
                                          .selectShipExtraCommand(value);
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),

                    //Dịch vụ của đối tác
                    if ((_vm.deliveryCarrierServices?.length ?? 0) > 0)
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text("Dịch vụ:"),
                              trailing: SizedBox(
                                width: 250,
                                child: DropdownButton<
                                        CalculateFeeResultDataService>(
                                    isExpanded: true,
                                    value: widget.editVm.deliveryCarrierServices
                                        .firstWhere(
                                            (element) =>
                                                element.serviceId ==
                                                widget.editVm.carrierService
                                                    ?.serviceId,
                                            orElse: () => null),
                                    items: widget.editVm.deliveryCarrierServices
                                        ?.map((f) => DropdownMenuItem<
                                                CalculateFeeResultDataService>(
                                              value: f,
                                              child: Text(
                                                "${f.serviceName} | ${vietnameseCurrencyFormat(f.totalFee)}",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ))
                                        ?.toList(),
                                    onChanged: (value) {
                                      widget.editVm
                                          .setDeliveryCarrierService(value);
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                    defaultDivider,
                    // Tùy chọn thêm dịch vụ
                    Container(
                      color: Colors.white,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _vm.carrierServiceExtras?.length ?? 0,
                        itemBuilder: (context, index) {
                          // Checkbox.
                          var itemWidget = CheckboxListTile(
                            title: Text(
                                "${_vm.carrierServiceExtras[index].serviceName} | (${vietnameseCurrencyFormat(_vm.carrierServiceExtras[index].fee)})"),
                            dense: true,
                            value: _vm.shipServiceExtras.any(
                              (f) =>
                                  f.id ==
                                  _vm.carrierServiceExtras[index].serviceId
                                      .toString(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _vm.setDeliverCarrierServiceExtra(
                                    _vm.carrierServiceExtras[index], value);
                              });
                            },
                          );

                          if (_vm.carrierServiceExtras[index].serviceName
                                  .toLowerCase()
                                  .contains("khai giá") &&
                              widget.editVm.isInsuranceFeeEnable) {
                            return Column(
                              children: [
                                itemWidget,
                                _NumberInputField(
                                  title: "Giá trị hàng hóa",
                                  controller: _insuranceFeeController,
                                  onValueChange: (value) =>
                                      _vm.shipInsuranceFee = value,
                                  onFocusController: (value) =>
                                      _edittingController = value,
                                ),
                              ],
                            );
                          } else {
                            return itemWidget;
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 1),

                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green.shade200,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 7, bottom: 7),
                          child: Row(
                            children: <Widget>[
                              Text("${S.current.deliveryCarrierFee}: "),
                              Expanded(
                                child: Text(
                                  "${vietnameseCurrencyFormat(_vm.customerDeliveryPrice) ?? "N/A"}",
                                  style: defaultNumberStyle.copyWith(
                                      color: Colors.red),
                                ),
                              ),
                              if (_vm.carrier != null)
                                SizedBox(
                                  height: 25,
                                  child: FlatButton(
                                    padding: EdgeInsets.all(0),
                                    textColor: Colors.blue,
                                    onPressed: () {
                                      _vm.calculateDeliveryFee(
                                          isReCalculate: true);
                                    },
                                    child: const Text("Tính lại"),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Khối lượng, phí giao hàng, tiền cọc, tiền thu hộ
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          _NumberInputField(
                            title: "${S.current.weight} (gram):",
                            controller: _weightController,
                            onFocusController: (controller) =>
                                _edittingController = controller,
                            onValueChange: (double value) =>
                                _vm.shipWeight = value,
                          ),
                          defaultDivider,
                          _NumberInputField(
                            title: S.current.shippingFee,
                            controller: _feeController,
                            onFocusController: (controller) =>
                                _edittingController = controller,
                            onValueChange: (double value) =>
                                _vm.deliveryPrice = value,
                          ),
                          defaultDivider,
                          _NumberInputField(
                            title: "${S.current.depositAmount}:",
                            controller: _depositController,
                            onFocusController: (controller) =>
                                _edittingController = controller,
                            onValueChange: (double value) =>
                                _vm.depositAmount = value,
                          ),
                          defaultDivider,
                          _NumberInputField(
                            title: "${S.current.cashOnDelivery}:",
                            controller: _cashOnDeliveryController,
                            onFocusController: (controller) =>
                                _edittingController = controller,
                            onValueChange: (double value) =>
                                _vm.cashOnDelivery = value,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 17, right: 8, top: 5, bottom: 10),
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.note),
                              SizedBox(
                                width: 10,
                              ),
                              Text(S.current.deliveryNote),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: _deliverNoteController,
                            onChanged: (text) {
                              _vm.deliveryNote = text;
                            },
                            maxLines: null,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  gapPadding: 10,
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey,
                                      style: BorderStyle.solid),
                                ),
                                hintText: S
                                    .current.addFastSaleOrder_deliveryNoteHint),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CarrierSelectPanel extends StatelessWidget {
  // Mở giao diện chọn hoặc sửa đối tác giao hàng
  Future<DeliveryCarrier> _selectDeliveryCarrier(
      BuildContext context, DeliveryCarrier currentCarrier) async {
    final selectedCarrier = await Navigator.push(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => DeliveryCarrierSearchPage(
          closeWhenDone: true,
          isSearch: true,
          selectedDeliveryCarrier: currentCarrier,
        ),
      ),
    );

    if (selectedCarrier != null) {
      return selectedCarrier;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var _vm = ScopedModel.of<FastSaleOrderAddEditFullViewModel>(context);
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.directions_car,
              color: Theme.of(context).iconTheme.color,
            ),
            SizedBox(
              width: 10,
            ),
            Text("${S.current.deliveryCarrier}:")
          ],
        ),
        title: Text(
          "${_vm.carrier?.name ?? S.current.tapToSelect}",
          textAlign: TextAlign.end,
          style: TextStyle(color: Colors.black),
        ),
        trailing: Icon(Icons.chevron_right),
        onTap: () async {
          if (_vm.carrier != null) {
            // Thong bao chon lai
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Text("${_vm.carrier?.name}"),
                actions: <Widget>[
                  OutlineButton.icon(
                    label: Text("Bỏ chọn"),
                    icon: Icon(Icons.remove_circle),
                    textColor: Colors.red,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                      _vm.setDeliveryCarrier(null);
                    },
                  ),
                  RaisedButton.icon(
                    label: Text("Thay đổi"),
                    icon: Icon(Icons.cached),
                    textColor: Colors.white,
                    onPressed: () async {
                      Navigator.pop(context);
                      var selectedCarrier =
                          await _selectDeliveryCarrier(context, _vm.carrier);
                      if (selectedCarrier != null) {
                        _vm.setDeliveryCarrier(selectedCarrier);
                      }
                    },
                  ),
                ],
              ),
            );

            return;
          }

          _selectDeliveryCarrier(context, _vm.carrier).then((value) {
            if (value != null) {
              _vm.setDeliveryCarrier(value);
            }
          });
        },
      ),
    );
  }
}

class _NumberInputField extends StatelessWidget {
  _NumberInputField(
      {this.controller,
      this.onValueChange,
      this.onFocusController,
      this.title});
  final TextEditingController controller;
  final ValueChanged<double> onValueChange;
  final ValueChanged<TextEditingController> onFocusController;
  final String title;
  final TextStyle defaultNumberStyle =
      new TextStyle(fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("$title"),
      trailing: SizedBox(
          width: 150,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.right,
            style: defaultNumberStyle,
            keyboardType: TextInputType.numberWithOptions(),
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              NumberInputFormat.vietnameDong(),
            ],
            onTap: () {
              controller.selection = TextSelection(
                  baseOffset: 0, extentOffset: controller.text.length);
              if (onFocusController != null) {
                onFocusController(controller);
              }
            },
            onChanged: (text) {
              double value = App.convertToDouble(text, "vi_VN");

              if (onValueChange != null) {
                onValueChange(value);
              }
            },
          )),
    );
  }
}
