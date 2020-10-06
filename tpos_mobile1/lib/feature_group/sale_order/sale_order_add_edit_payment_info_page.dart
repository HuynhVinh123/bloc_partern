import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_add_edit_payment_info_viewmodel.dart';
import 'package:tpos_mobile/feature_group/sale_order/viewmodels/sale_order_add_edit_viewmodel.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/helpers/tmt.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';

import 'package:tpos_mobile/widgets/ModalWaitingWidget.dart';

class SaleOrderAddEditPaymentInfoPage extends StatefulWidget {
  final SaleOrderAddEditViewModel editVm;
  SaleOrderAddEditPaymentInfoPage({this.editVm});
  @override
  _SaleOrderAddEditPaymentInfoPageState createState() =>
      _SaleOrderAddEditPaymentInfoPageState();
}

class _SaleOrderAddEditPaymentInfoPageState
    extends State<SaleOrderAddEditPaymentInfoPage> {
  var _vm = new SaleOrderAddEditPaymentInfoViewModel();

  @override
  void initState() {
    _vm.init(widget.editVm);

    _vm.addListener(() {
      _rechargeAmountController.text =
          vietnameseCurrencyFormat(_vm.rechargeAmount);
      if (_edittingController != _amountDepositController)
        _amountDepositController.text =
            vietnameseCurrencyFormat(_vm.amountDeposit);
    });
    super.initState();
  }

  var _amountDepositController = new TextEditingController(text: "0");
  var _rechargeAmountController = new TextEditingController(text: "0");

  TextEditingController _edittingController;

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SaleOrderAddEditPaymentInfoViewModel>(
      model: _vm,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Thanh toán"),
        ),
        body: ModalWaitingWidget(
          isBusyStream: _vm.isBusyController,
          initBusy: false,
          child: _buildBody(),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
          child: RaisedButton.icon(
            icon: Icon(Icons.keyboard_return),
            label: Text("QUAY LẠI ĐƠN HÀNG"),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    var defaultNumberStyle = TextStyle(fontWeight: FontWeight.bold);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)?.requestFocus(new FocusNode());
      },
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.grey.shade300,
              child: SingleChildScrollView(
                child:
                    ScopedModelDescendant<SaleOrderAddEditPaymentInfoViewModel>(
                  builder: (ctx, _, model) {
                    return Column(
                      children: <Widget>[
                        Material(
                          color: Colors.white,
                          child: ListTile(
                            leading: Text("Phương thức: "),
                            title: DropdownButton<AccountJournal>(
                              isExpanded: true,
                              hint: Text("Chọn phương thức"),
                              value: _vm.selectedAccountJournal,
                              items: _vm.accountJournals
                                  ?.map((f) => DropdownMenuItem<AccountJournal>(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            SizedBox(),
                                            Text(
                                              f.name,
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                        value: f,
                                      ))
                                  ?.toList(),
                              onChanged: (value) {
                                _vm.selectAccountJournalCommand(value);
                              },
                            ),
                            onTap: () {},
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          height: 1,
                        ),
                        Material(
                          color: Colors.white,
                          child: ListTile(
                            leading: Text("Tổng tiền:"),
                            trailing: SizedBox(
                              width: 100,
                              child: TextField(
                                style: defaultNumberStyle.copyWith(
                                    color: Colors.red),
                                controller: TextEditingController(
                                  text:
                                      vietnameseCurrencyFormat(_vm.totalAmount),
                                ),
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Colors.red,
                                  enabled: false,
                                  hintText: "",
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                        ),
                        Material(
                          color: Colors.white,
                          child: ListTile(
                            leading: Text("Tiền cọc:"),
                            trailing: SizedBox(
                              width: 100,
                              child: TextField(
                                style: defaultNumberStyle.copyWith(
                                    color: Colors.green),
                                controller: _amountDepositController,
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                  hintText: "",
                                ),
                                keyboardType: TextInputType.numberWithOptions(),
                                onTap: () {
                                  _amountDepositController.selection =
                                      new TextSelection(
                                          baseOffset: 0,
                                          extentOffset: _amountDepositController
                                              .text.length);
                                },
                                onChanged: (text) {
                                  double value =
                                      App.convertToDouble(text, "vi_VN");
                                  _vm.amountDeposit = value;
                                  _edittingController =
                                      _amountDepositController;
                                },
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly,
                                  NumberInputFormat.vietnameDong(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                        ),
                        Material(
                          color: Colors.white,
                          child: ListTile(
                            leading: Text("Còn lại:"),
                            trailing: SizedBox(
                              width: 100,
                              child: TextField(
                                enabled: false,
                                controller: _rechargeAmountController,
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                    hintText: "", border: InputBorder.none),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
