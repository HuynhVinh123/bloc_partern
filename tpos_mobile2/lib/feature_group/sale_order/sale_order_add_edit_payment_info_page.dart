import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_add_edit_payment_info_viewmodel.dart';
import 'package:tpos_mobile/feature_group/sale_order/viewmodels/sale_order_add_edit_viewmodel.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/helpers/tmt.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';

import 'package:tpos_mobile/widgets/ModalWaitingWidget.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SaleOrderAddEditPaymentInfoPage extends StatefulWidget {
  const SaleOrderAddEditPaymentInfoPage({this.editVm});
  final SaleOrderAddEditViewModel editVm;

  @override
  _SaleOrderAddEditPaymentInfoPageState createState() =>
      _SaleOrderAddEditPaymentInfoPageState();
}

class _SaleOrderAddEditPaymentInfoPageState
    extends State<SaleOrderAddEditPaymentInfoPage> {
  final _vm = SaleOrderAddEditPaymentInfoViewModel();

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

  final _amountDepositController = TextEditingController(text: "0");
  final _rechargeAmountController = TextEditingController(text: "0");

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
          /// Thanh toán
          title: Text(S.current.payment),
        ),
        body: ModalWaitingWidget(
          isBusyStream: _vm.isBusyController,
          initBusy: false,
          child: _buildBody(),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
          child: RaisedButton.icon(
            icon: const Icon(Icons.keyboard_return),

            ///QUAY LẠI ĐƠN HÀNG
            label: Text(S.current.backToOrder.toUpperCase()),
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
    const defaultNumberStyle = TextStyle(fontWeight: FontWeight.bold);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)?.requestFocus(FocusNode());
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
                            /// Phương thức
                            leading: Text("${S.current.paymentMethod}: "),
                            title: DropdownButton<AccountJournal>(
                              isExpanded: true,

                              /// Chọn phương thức
                              hint: Text(S.current.choosePaymentMethod),
                              value: _vm.selectedAccountJournal,
                              items: _vm.accountJournals
                                  ?.map((f) => DropdownMenuItem<AccountJournal>(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            const SizedBox(),
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
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          height: 1,
                        ),
                        Material(
                          color: Colors.white,
                          child: ListTile(
                            /// Tổng tiền
                            leading: Text("${S.current.totalAmount}:"),
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
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Colors.red,
                                  enabled: false,
                                  hintText: "",
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 1,
                        ),
                        Material(
                          color: Colors.white,
                          child: ListTile(
                            /// Tiền cọc
                            leading: Text("${S.current.depositAmount}:"),
                            trailing: SizedBox(
                              width: 100,
                              child: TextField(
                                style: defaultNumberStyle.copyWith(
                                    color: Colors.green),
                                controller: _amountDepositController,
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  hintText: "",
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(),
                                onTap: () {
                                  _amountDepositController.selection =
                                      TextSelection(
                                          baseOffset: 0,
                                          extentOffset: _amountDepositController
                                              .text.length);
                                },
                                onChanged: (text) {
                                  final double value =
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
                        const Divider(
                          height: 1,
                        ),
                        Material(
                          color: Colors.white,
                          child: ListTile(
                            /// Còn lại
                            leading: Text("${S.current.remain}:"),
                            trailing: SizedBox(
                              width: 100,
                              child: TextField(
                                enabled: false,
                                controller: _rechargeAmountController,
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
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
