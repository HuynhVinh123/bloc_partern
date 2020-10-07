import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/view_model/fast_purchase_order_addedit_viewmodel.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order.dart';

class PaymentInfoFPO extends StatefulWidget {
  final FastPurchaseOrderAddEditViewModel vm;
  PaymentInfoFPO({@required this.vm});

  @override
  _PaymentInfoFPOState createState() => _PaymentInfoFPOState();
}

class _PaymentInfoFPOState extends State<PaymentInfoFPO> {
  FastPurchaseOrderAddEditViewModel _viewModel;
  FastPurchaseOrder item;

  TextEditingController amountController =
      MoneyMaskedTextController(decimalSeparator: "", precision: 0);
  TextEditingController discountController =
      MoneyMaskedTextController(decimalSeparator: "", precision: 0);
  TextEditingController decreaseController =
      MoneyMaskedTextController(decimalSeparator: "", precision: 0);
  TextEditingController taxController =
      MoneyMaskedTextController(decimalSeparator: "", precision: 0);
  TextEditingController amountTotalController =
      MoneyMaskedTextController(decimalSeparator: "", precision: 0);

  @override
  void initState() {
    _viewModel = widget.vm;
    item = _viewModel.defaultFPO;
    amountController.text = (item.amount ?? 0).toInt().toString();
    discountController.text = (item.discount ?? 0).toInt().toString();
    decreaseController.text = (item.decreaseAmount ?? 0).toInt().toString();
    taxController.text = (item.amountTax ?? 0).toInt().toString();
    amountTotalController.text = (item.amountTotal ?? 0).toInt().toString();
    _viewModel.getTax();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _viewModel.notifyListeners();
    return AlertDialog(
      title: Text("Thông tin thanh toán"),
      content: Stack(
        children: <Widget>[
          Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: <Widget>[
                    _showPaymentInfo(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        _showBottomAction(),
      ],
    );
  }

  Widget _showPaymentInfo() {
    Widget myDivider = SizedBox(
      height: 10,
    );
    return Column(
      children: <Widget>[
        TextField(
          enabled: false,
          controller: amountController,
          keyboardType: TextInputType.number,
          textDirection: TextDirection.rtl,
          style: TextStyle(color: Colors.grey),
          decoration: InputDecoration(
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            labelText: "Tổng",
            labelStyle: TextStyle(fontSize: 20),
          ),
        ),
        myDivider,
        TextField(
          autofocus: true,
          controller: discountController,
          keyboardType: TextInputType.number,
          textDirection: TextDirection.rtl,
          onChanged: (text) {
            if (text == "") {
              setState(() {
                item.discount = 0;
                item.discountAmount = 0;
              });
            } else {
              setState(() {
                item.discount = double.parse(text.replaceAll(".", ""));
                item.discountAmount = item.amount * item.discount / 100;
              });
            }
            updateTotal();
          },
          decoration: InputDecoration(
            prefixText: "(${vietnameseCurrencyFormat(item.discountAmount)})",
            labelText: "Chiết khấu %",
            labelStyle: TextStyle(fontSize: 20),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
          ),
        ),
        myDivider,
        TextField(
          controller: decreaseController,
          keyboardType: TextInputType.number,
          textDirection: TextDirection.rtl,
          onChanged: (text) {
            if (text == "") {
              setState(() {
                item.decreaseAmount = 0;
              });
            } else {
              setState(() {
                item.decreaseAmount = double.parse(text.replaceAll(".", ""));
              });
            }

            updateTotal();
          },
          decoration: InputDecoration(
            labelText: "Giảm tiền",
            labelStyle: TextStyle(fontSize: 20),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
          ),
        ),
        myDivider,
        Stack(
          children: <Widget>[
            TextField(
              enabled: false,
              controller: taxController,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.rtl,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  labelText: "Thuế",
                  labelStyle: TextStyle(fontSize: 20),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  prefixText: "(${taxController.text})"),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _myDropDown(),
            ),
          ],
        ),
        myDivider,
        TextField(
          enabled: false,
          controller: amountTotalController,
          keyboardType: TextInputType.number,
          textDirection: TextDirection.rtl,
          style: TextStyle(color: Colors.red),
          decoration: InputDecoration(
            labelText: "Tổng tiền",
            labelStyle: TextStyle(fontSize: 20),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }

  void updateTotal() {
    setState(() {
      item.amountUntaxed = item.amount -
          (item.amount * item.discount / 100) -
          item.decreaseAmount; //

      item.amountTax = item.amountUntaxed *
          (item.tax != null ? item.tax.amount : 0) /
          100; //132500

      item.amountTotal = item.amountUntaxed - item.amountTax;

      taxController.text = item.amountTax.toInt().toString();
      amountTotalController.text = item.amountTotal.toInt().toString();
    });
  }

  void updateText() {}

  Widget _showBottomAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        RaisedButton(
          child: Text(
            "Đóng",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  Widget _myDropDown() {
    return ScopedModel<FastPurchaseOrderAddEditViewModel>(
      model: _viewModel,
      child: ScopedModelDescendant<FastPurchaseOrderAddEditViewModel>(
        builder: (context, child, model) {
          return model.taxs.isEmpty
              ? SizedBox()
              : DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: item.tax != null
                        ? model.taxs.firstWhere((f) => f.name == item.tax.name)
                        : null,
                    hint: Text("Không thuế"),
                    onChanged: (value) {
                      setState(
                        () {
                          item.tax = value;
                          updateTotal();
                          taxController.text =
                              item.amountTax.toInt().toString();
                          updateTotal();
                        },
                      );
                    },
                    items: model.taxs
                        .map(
                          (f) => DropdownMenuItem(
                            value: f,
                            child: Text(
                              "${f.name}",
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
        },
      ),
    );
  }
}
