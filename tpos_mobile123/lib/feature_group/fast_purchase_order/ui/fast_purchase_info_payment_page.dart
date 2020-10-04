import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';

import 'package:tpos_mobile/feature_group/fast_purchase_order/view_model/fast_purchase_order_addedit_viewmodel.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order.dart';

class FastPurchaseInfoPaymentPage extends StatefulWidget {
  FastPurchaseInfoPaymentPage({this.viewModel});
  final FastPurchaseOrderAddEditViewModel viewModel;
  @override
  _FastPurchaseInfoPaymentPageState createState() =>
      _FastPurchaseInfoPaymentPageState();
}

class _FastPurchaseInfoPaymentPageState
    extends State<FastPurchaseInfoPaymentPage> {
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
//    widget.viewModel.qtyLines = widget.orderLine.productQty.toDouble();
    _viewModel = widget.viewModel;
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
  void dispose() {
//    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _viewModel.notifyListeners(); /**/
    return ScopedModel<FastPurchaseOrderAddEditViewModel>(
        model: widget.viewModel,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Thông tin thanh toán"),
            actions: <Widget>[
              FlatButton(
                textColor: Colors.white,
                child: Text("LƯU"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
          body: _showBody(),
        ));
  }

  Widget _showBody() {
    Divider _defaultDivider = new Divider(
      height: 1,
    );
    return Container(
      color: Colors.grey.shade300,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: Text("Tổng: "),
                    title: Text(
                      "${vietnameseCurrencyFormat(item.amount ?? 0)}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 21),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  _defaultDivider,
                  // Đơn giá
                  ListTile(
                    leading: Text("Chiết khấu % :"),
                    trailing: SizedBox(
                      width: 100,
                      child: TextField(
                        controller: discountController,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: "",
                        ),
                        onChanged: (text) {
                          if (text == "") {
                            setState(() {
                              item.discount = 0;
                              item.discountAmount = 0;
                            });
                          } else {
                            setState(() {
                              item.discount =
                                  double.parse(text.replaceAll(".", ""));
                              item.discountAmount =
                                  item.amount * item.discount / 100;
                            });
                          }
                          updateTotal();
                        },
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        inputFormatters: [
                          // FilteringTextInputFormatter.digitsOnly,
                          NumberInputFormat.vietnameDong(),
                        ],
                        onTap: () {
                          bool isFocus = false;
                          if (isFocus == false) {
                            discountController.selection = new TextSelection(
                                baseOffset: 0,
                                extentOffset: discountController.text.length);

                            isFocus = true;
                          }
                        },
                      ),
                    ),
                  ),
                  _defaultDivider,
                  ScopedModelDescendant<FastPurchaseOrderAddEditViewModel>(
                      builder: (context, child, model) {
                    return ListTile(
                      leading: Text("Tiền chiết khấu: "),
                      title: Text(
                        "${vietnameseCurrencyFormat(item.discountAmount)}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                        textAlign: TextAlign.right,
                      ),
                    );
                  }),
                  _defaultDivider,
                  ListTile(
                    leading: Text("Giảm tiền:"),
                    trailing: SizedBox(
                      width: 100,
                      child: TextField(
                        controller: decreaseController,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: "",
                        ),
                        onChanged: (text) {
                          if (text == "") {
                            setState(() {
                              item.decreaseAmount = 0;
                            });
                          } else {
                            setState(() {
                              item.decreaseAmount =
                                  double.parse(text.replaceAll(".", ""));
                            });
                          }

                          updateTotal();
                        },
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        inputFormatters: [
                          // FilteringTextInputFormatter.digitsOnly,
                          NumberInputFormat.vietnameDong(),
                        ],
                        onTap: () {
                          bool isFocus = false;
                          if (isFocus == false) {
                            decreaseController.selection = new TextSelection(
                                baseOffset: 0,
                                extentOffset: decreaseController.text.length);

                            isFocus = true;
                          }
                        },
                      ),
                    ),
                  ),
                  _defaultDivider,
                  ListTile(
                    leading: Text("Thuế "),
                    trailing: _myDropDown(),
                  ),
                  _defaultDivider,
                  // Giảm giá
                  // Giá đã giảm
                  ScopedModelDescendant<FastPurchaseOrderAddEditViewModel>(
                      builder: (context, child, model) {
                    return ListTile(
                      leading: Text("Tiền thuế "),
                      title: Text(
                        "${vietnameseCurrencyFormat(item.amountTax ?? 0)}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                        textAlign: TextAlign.right,
                      ),
                    );
                  }),
                  Divider(),

                  // Thành tiền
                  ScopedModelDescendant<FastPurchaseOrderAddEditViewModel>(
                      builder: (context, child, model) {
                    return ListTile(
                      leading: Text("Tổng tiền: "),
                      title: Text(
                        "${vietnameseCurrencyFormat(item.amountTotal ?? 0)}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                        textAlign: TextAlign.right,
                      ),
                    );
                  }),
                  _defaultDivider,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _myDropDown() {
    return ScopedModelDescendant<FastPurchaseOrderAddEditViewModel>(
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
                        taxController.text = item.amountTax.toInt().toString();
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
}
