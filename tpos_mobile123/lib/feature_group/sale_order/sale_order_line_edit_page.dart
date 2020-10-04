/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/16/19 5:56 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/16/19 1:26 PM
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_line.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_line_edit_viewmodel.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/helpers/tmt.dart';

import 'package:tpos_mobile/widgets/ModalWaitingWidget.dart';
import 'package:tpos_mobile/widgets/custom_widget.dart';

class SaleOrderLineEditPage extends StatefulWidget {
  final SaleOrderLine orderLine;

  SaleOrderLineEditPage(this.orderLine);
  @override
  _SaleOrderLineEditPageState createState() => _SaleOrderLineEditPageState();
}

class _SaleOrderLineEditPageState extends State<SaleOrderLineEditPage> {
  _SaleOrderLineEditPageState();

  SaleOrderLineEditViewModel _viewModel = new SaleOrderLineEditViewModel();
  final _priceTextEditController = new TextEditingController();
  final _discountTextEditController = new TextEditingController();
  final _discountFixTextEditController = new TextEditingController();

  @override
  void initState() {
    _viewModel.init(widget.orderLine);
    _viewModel.notifyPropertyChangedController.listen((f) {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SaleOrderLineEditViewModel>(
      model: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Tùy chọn thuộc tính"),
        ),
        body: ModalWaitingWidget(
          isBusyStream: _viewModel.isBusyController,
          initBusy: false,
          child: _showBody(),
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

  Widget _showBody() {
    _priceTextEditController.text = vietnameseCurrencyFormat(_viewModel.price);
    _discountTextEditController.text =
        NumberFormat("###.##", "vi_VN").format(_viewModel.discountPercent);
    _discountFixTextEditController.text =
        vietnameseCurrencyFormat(_viewModel.discountFix);

    Divider _defaultDivider = new Divider(
      height: 1,
    );
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)?.requestFocus(new FocusNode());
      },
      child: ScopedModelDescendant<SaleOrderLineEditViewModel>(
        builder: (context, child, model) => Container(
          color: Colors.grey.shade300,
          child: Column(
            children: <Widget>[
              // Product Info
              _showProductInfo(),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: ListView(
                    children: <Widget>[
                      //  Số lượng

                      // Đơn giá
                      ListTile(
                        leading: Text("Đơn giá:"),
                        trailing: SizedBox(
                          width: 100,
                          child: TextField(
                            controller: _priceTextEditController,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              hintText: "",
                            ),
                            onChanged: (text) {
                              _viewModel.price =
                                  App.convertToDouble(text.trim(), "vi_VN");
                            },
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: true, signed: true),
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              NumberInputFormat.vietnameDong(),
                            ],
                            onTap: () {
                              bool isFocus = false;
                              if (isFocus == false) {
                                _priceTextEditController.selection =
                                    new TextSelection(
                                        baseOffset: 0,
                                        extentOffset: _priceTextEditController
                                            .text.length);

                                isFocus = true;
                              }
                            },
                          ),
                        ),
                      ),
                      _defaultDivider,
                      // Giảm giá
                      ListTile(
                        leading: Text("Giảm giá:"),
                        title: SwitchPercentOrCash(
                          textColor: Colors.black,
                          selectedTextColor: Colors.white,
                          backgroundColor: Colors.grey.shade200,
                          selectedBackgroundColor: Colors.green,
                          isPercent: _viewModel.isDiscountPercent,
                          onChanged: (isPercent) {
                            _viewModel.discountType = isPercent;
                          },
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: TextField(
                              controller: _viewModel.isDiscountPercent
                                  ? _discountTextEditController
                                  : _discountFixTextEditController,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                hintText: "",
                              ),
                              keyboardType: TextInputType.numberWithOptions(),
                              inputFormatters: _viewModel.isDiscountPercent
                                  ? [
                                      WhitelistingTextInputFormatter(
                                          RegExp("[0-9.,]")),
                                      PercentInputFormat(
                                          locate: "vi_VN", format: "###.0#"),
                                    ]
                                  : [
                                      WhitelistingTextInputFormatter.digitsOnly,
                                      NumberInputFormat.vietnameDong(),
                                    ],
                              textInputAction: TextInputAction.done,
                              keyboardAppearance: Brightness.light,
                              onChanged: (text) {
                                double value =
                                    App.convertToDouble(text, "vi_VN");
                                if (_viewModel.isDiscountPercent)
                                  _viewModel.discountPercent = value;
                                else
                                  _viewModel.discountFix = value;
                              },
                              onTap: _viewModel.isDiscountPercent
                                  ? () {
                                      _discountTextEditController.selection =
                                          TextSelection(
                                              baseOffset: 0,
                                              extentOffset:
                                                  _discountTextEditController
                                                      .text.length);
                                    }
                                  : () {
                                      _discountFixTextEditController.selection =
                                          TextSelection(
                                              baseOffset: 0,
                                              extentOffset:
                                                  _discountFixTextEditController
                                                      .text.length);
                                    }),
                        ),
                      ),
                      _defaultDivider, // Giá đã giảm
                      ListTile(
                        leading: Text("Đơn giá (Đã giảm): "),
                        title: Text(
                          "${vietnameseCurrencyFormat(_viewModel.orderLine.priceAfterDiscount ?? 0)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Divider(),
                      ListTile(
                        leading: SizedBox(
                            width: 100,
                            child: Text(
                              "Số lượng: ",
                            )),
                        title: Container(
                          child: NumberInputLeftRightWidget(
                            value: widget.orderLine.productUOMQty,
                            seedValue: 1,
                            numberFormat: "###,###,###",
                            fontWeight: FontWeight.bold,
                            onChanged: (value) {
                              _viewModel.quantity = value;
                            },
                          ),
                          alignment: Alignment(1, 1),
                        ),
                      ),
                      _defaultDivider,
                      // Thành tiền
                      ListTile(
                        leading: Text("Thành tiền: "),
                        title: Text(
                          "${vietnameseCurrencyFormat(_viewModel.total)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      // Ghi chú

                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: TextEditingController(
                              text: _viewModel.orderLineNote),
                          decoration: InputDecoration(
                              labelText: "Ghi chú",
                              hintText: "Thêm ghi chú",
                              border: OutlineInputBorder()),
                          onChanged: (text) {
                            _viewModel.orderLineNote = text;
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showProductInfo() {
    if (_viewModel.product == null) return SizedBox();
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 80,
              height: 80,
              child: Builder(builder: (ctx) {
                if (_viewModel.product.imageUrl != null) {
                  return Image.network(_viewModel.product.imageUrl);
                } else {
                  return Image.asset("images/no_image.png");
                }
              }),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${_viewModel.product?.nameGet}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                        "Đơn vị: ${_viewModel.orderLine.productUOMName ?? ""}"),
                    Text(
                      "${vietnameseCurrencyFormat(_viewModel.product.price ?? 0)}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SwitchPercentOrCash extends StatelessWidget {
  final bool isPercent;
  final Color selectedTextColor;
  final Color textColor;
  final Color selectedBackgroundColor;
  final Color backgroundColor;
  final Function(bool) onChanged;
  SwitchPercentOrCash(
      {this.isPercent = true,
      this.backgroundColor,
      this.selectedBackgroundColor = Colors.green,
      this.textColor = Colors.black,
      this.selectedTextColor = Colors.white,
      this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        children: <Widget>[
          SizedBox(
            child: RaisedButton(
              child: Text("VNĐ"),
              color: isPercent ? backgroundColor : selectedBackgroundColor,
              textColor: isPercent ? textColor : selectedTextColor,
              padding: EdgeInsets.all(0),
              onPressed: () {
                if (onChanged != null) {
                  onChanged(false);
                }
              },
            ),
            width: 50,
          ),
          SizedBox(
            child: RaisedButton(
              textColor: isPercent ? selectedTextColor : textColor,
              color: isPercent ? selectedBackgroundColor : backgroundColor,
              child: Text("%"),
              onPressed: () {
                if (onChanged != null) {
                  onChanged(true);
                }
              },
              padding: EdgeInsets.all(0),
            ),
            width: 50,
          ),
        ],
      ),
    );
  }
}
