import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/fast_sale_order/viewmodels/fast_sale_order_add_edit_full_payment_info_viewmodel.dart';
import 'package:tpos_mobile/feature_group/fast_sale_order/viewmodels/fast_sale_order_add_edit_full_viewmodel.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/helpers/tmt.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';

import 'package:tpos_mobile/widgets/ModalWaitingWidget.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

class FastSaleOrderAddEditFullPaymentInfoPage extends StatefulWidget {
  const FastSaleOrderAddEditFullPaymentInfoPage({this.editVm});
  final FastSaleOrderAddEditFullViewModel editVm;

  @override
  _FastSaleOrderAddEditFullPaymentInfopageState createState() =>
      _FastSaleOrderAddEditFullPaymentInfopageState();
}

class _FastSaleOrderAddEditFullPaymentInfopageState
    extends State<FastSaleOrderAddEditFullPaymentInfoPage> {
  final _vm = FastSaleOrderAddEditFullPaymentInfoViewModel();

  @override
  void initState() {
    _vm.init(widget.editVm);
    _discountFixController.text = vietnameseCurrencyFormat(_vm.decreaseAmount);
    _discountController.text = NumberFormat("###.##").format(_vm.discount);

    _vm.addListener(() {
      if (_edittingController == _discountController) {
        _discountFixController.text =
            vietnameseCurrencyFormat(_vm.decreaseAmount);
      } else if (_edittingController == _discountFixController) {
        _discountController.text = NumberFormat("###.##").format(_vm.discount);
      }

      _rechargeAmountController.text =
          vietnameseCurrencyFormat(_vm.rechargeAmount);
      if (_edittingController != _paymentController)
        _paymentController.text = vietnameseCurrencyFormat(_vm.paymentAmount);
    });
    super.initState();
  }

  final _discountController = TextEditingController(text: "0");
  final _discountFixController = TextEditingController(text: "0");
  final _paymentController = TextEditingController(text: "0");
  final _rechargeAmountController = TextEditingController(text: "0");

  TextEditingController _edittingController;

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<FastSaleOrderAddEditFullPaymentInfoViewModel>(
      model: _vm,
      child: GestureDetector(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(S.current.paymentInformation),
          ),
          body: ModalWaitingWidget(
            isBusyStream: _vm.isBusyController,
            initBusy: false,
            child: _buildBody(),
          ),
        ),
        onTapDown: (s) {
          FocusScope.of(context)?.requestFocus(FocusNode());
        },
      ),
    );
  }

  Widget _buildBody() {
    const defaultNumberStyle =
        TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Container(
            color: Colors.grey.shade300,
            child: SingleChildScrollView(
              child: ScopedModelDescendant<
                  FastSaleOrderAddEditFullPaymentInfoViewModel>(
                builder: (ctx, _, model) {
                  return Column(
                    children: <Widget>[
                      Material(
                        color: Colors.white,
                        child: ListTile(
                          leading: Text("${S.current.paymentMethod}: "),
                          title: DropdownButton<AccountJournal>(
                            isExpanded: true,
                            hint: const Text("Chọn phương thức"),
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
                      Material(
                        color: Colors.white,
                        child: ListTile(
                          leading: const Text("Tổng tiền hàng:"),
                          trailing: SizedBox(
                            width: 200,
                            child: TextField(
                              enabled: false,
                              controller: TextEditingController(
                                  text: vietnameseCurrencyFormat(
                                      widget.editVm.subTotal ?? 0)),
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                  hintText: "", border: InputBorder.none),
                              style: defaultNumberStyle,
                            ),
                          ),
                        ),
                      ),
                      // Giảm giá %
                      const Divider(
                        height: 1,
                      ),
                      Material(
                        color: Colors.white,
                        child: ListTile(
                          leading: Text("${S.current.discount} (%):"),
                          trailing: SizedBox(
                            width: 200,
                            child: TextField(
                              style: defaultNumberStyle,
                              controller: _discountController,
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(
                                hintText: "",
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9.,]")),
                                PercentInputFormat(
                                    locate: "vi_VN", format: "###.0#"),
                              ],
                              onChanged: (text) {
                                final double value =
                                    App.convertToDouble(text, "vi_VN");
                                _vm.discount = value;
                                _edittingController = _discountController;
                              },
                              onTap: () {
                                _discountController.selection = TextSelection(
                                    baseOffset: 0,
                                    extentOffset:
                                        _discountController.text.length);
                              },
                            ),
                          ),
                        ),
                      ),
                      // Giảm giá tiền
                      const Divider(
                        height: 1,
                      ),
                      Material(
                        color: Colors.white,
                        child: ListTile(
                          leading: Text("${S.current.discount} (tiền):"),
                          trailing: SizedBox(
                            width: 200,
                            child: TextField(
                              style: defaultNumberStyle,
                              controller: _discountFixController,
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(
                                hintText: "",
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                NumberInputFormat.vietnameDong(),
                              ],
                              onChanged: (text) {
                                final double value =
                                    App.convertToDouble(text, "vi_VN");
                                _vm.decreaseAmount = value;
                                _edittingController = _discountFixController;
                              },
                              onTap: () {
                                _discountFixController.selection =
                                    TextSelection(
                                        baseOffset: 0,
                                        extentOffset:
                                            _discountFixController.text.length);
                              },
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
                          leading: Text("${S.current.total}:"),
                          trailing: SizedBox(
                            width: 200,
                            child: TextField(
                              style: defaultNumberStyle.copyWith(
                                  color: Colors.red),
                              controller: TextEditingController(
                                text: vietnameseCurrencyFormat(_vm.totalAmount),
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
                          leading: Text("${S.current.paid}:"),
                          trailing: SizedBox(
                            width: 200,
                            child: TextField(
                              style: defaultNumberStyle.copyWith(
                                  color: Colors.green),
                              controller: _paymentController,
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(
                                hintText: "",
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                              onChanged: (text) {
                                _edittingController = _paymentController;
                                final double value =
                                    App.convertToDouble(text, "vi_VN");

                                _vm.paymentAmount = value;
                              },
                              onTap: () {
                                _paymentController.selection = TextSelection(
                                    baseOffset: 0,
                                    extentOffset:
                                        _paymentController.text.length);
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
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
                          leading: const Text("Còn lại:"),
                          trailing: SizedBox(
                            width: 200,
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
        Container(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: RaisedButton.icon(
            textColor: Colors.white,
            icon: const Icon(Icons.keyboard_return),
            label: const Text("QUAY LẠI HÓA ĐƠN"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
