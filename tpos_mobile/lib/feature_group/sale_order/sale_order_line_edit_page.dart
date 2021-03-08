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
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SaleOrderLineEditPage extends StatefulWidget {
  const SaleOrderLineEditPage(this.orderLine);
  final SaleOrderLine orderLine;

  @override
  _SaleOrderLineEditPageState createState() => _SaleOrderLineEditPageState();
}

class _SaleOrderLineEditPageState extends State<SaleOrderLineEditPage> {
  _SaleOrderLineEditPageState();

  final SaleOrderLineEditViewModel _viewModel = SaleOrderLineEditViewModel();
  final _priceTextEditController = TextEditingController();
  final _discountTextEditController = TextEditingController();
  final _discountFixTextEditController = TextEditingController();

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
          /// Tùy chọn thuộc tính
          title: Text(S.current.purchaseOrder_propertyOptions),
        ),
        body: ModalWaitingWidget(
          isBusyStream: _viewModel.isBusyController,
          initBusy: false,
          child: _showBody(),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
          child: RaisedButton.icon(
            icon: const Icon(Icons.keyboard_return),

            /// QUAY LẠI ĐƠN HÀNG
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

  Widget _showBody() {
    _priceTextEditController.text = vietnameseCurrencyFormat(_viewModel.price);
    _discountTextEditController.text =
        NumberFormat("###.##", "vi_VN").format(_viewModel.discountPercent);
    _discountFixTextEditController.text =
        vietnameseCurrencyFormat(_viewModel.discountFix);

    const Divider _defaultDivider = Divider(
      height: 1,
    );
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)?.requestFocus(FocusNode());
      },
      child: ScopedModelDescendant<SaleOrderLineEditViewModel>(
        builder: (context, child, model) => Container(
          color: Colors.grey.shade300,
          child: Column(
            children: <Widget>[
              // Product Info
              _showProductInfo(),
              const SizedBox(
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
                        leading: Text("${S.current.price}:"),
                        trailing: SizedBox(
                          width: 100,
                          child: TextField(
                            controller: _priceTextEditController,
                            textAlign: TextAlign.right,
                            decoration: const InputDecoration(
                              hintText: "",
                            ),
                            onChanged: (text) {
                              _viewModel.price =
                                  App.convertToDouble(text.trim(), "vi_VN");
                            },
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true, signed: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              NumberInputFormat.vietnameDong(),
                            ],
                            onTap: () {
                              bool isFocus = false;
                              if (isFocus == false) {
                                _priceTextEditController.selection =
                                    TextSelection(
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
                        leading: Text("${S.current.discount}:"),
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
                              decoration: const InputDecoration(
                                hintText: "",
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                              inputFormatters: _viewModel.isDiscountPercent
                                  ? [
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9.,]")),
                                      PercentInputFormat(
                                          locate: "vi_VN", format: "###.0#"),
                                    ]
                                  : [
                                      FilteringTextInputFormatter.digitsOnly,
                                      NumberInputFormat.vietnameDong(),
                                    ],
                              textInputAction: TextInputAction.done,
                              keyboardAppearance: Brightness.light,
                              onChanged: (text) {
                                final double value =
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
                        leading: Text(
                            "${S.current.price} (${S.current.purchaseOrder_reduced}): "),
                        title: Text(
                          vietnameseCurrencyFormat(
                              _viewModel.orderLine.priceAfterDiscount ?? 0),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const Divider(),

                      ///Số lượng
                      ListTile(
                        leading: SizedBox(
                            width: 100,
                            child: Text(
                              "${S.current.quantity}: ",
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
                          alignment: const Alignment(1, 1),
                        ),
                      ),
                      _defaultDivider,
                      // Thành tiền
                      ListTile(
                        leading: Text("${S.current.totalAmount}: "),
                        title: Text(
                          vietnameseCurrencyFormat(_viewModel.total ?? 0),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      // Ghi chú

                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: TextEditingController(
                              text: _viewModel.orderLineNote),
                          decoration: InputDecoration(
                              labelText: S.current.note,
                              hintText: S.current.note,
                              border: const OutlineInputBorder()),
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
    if (_viewModel.product == null) {
      return const SizedBox();
    }
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
                      _viewModel.product?.nameGet ?? "",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    /// Đơn vị
                    Text(
                        "${S.current.unit}: ${_viewModel.orderLine.productUOMName ?? ""}"),
                    Text(
                      vietnameseCurrencyFormat(_viewModel.product.price ?? 0),
                      style: const TextStyle(
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
  const SwitchPercentOrCash(
      {this.isPercent = true,
      this.backgroundColor,
      this.selectedBackgroundColor = Colors.green,
      this.textColor = Colors.black,
      this.selectedTextColor = Colors.white,
      this.onChanged});

  final bool isPercent;
  final Color selectedTextColor;
  final Color textColor;
  final Color selectedBackgroundColor;
  final Color backgroundColor;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        children: <Widget>[
          SizedBox(
            child: RaisedButton(
              child: const Text("VNĐ"),
              color: isPercent ? backgroundColor : selectedBackgroundColor,
              textColor: isPercent ? textColor : selectedTextColor,
              padding: const EdgeInsets.all(0),
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
              child: const Text("%"),
              onPressed: () {
                if (onChanged != null) {
                  onChanged(true);
                }
              },
              padding: const EdgeInsets.all(0),
            ),
            width: 50,
          ),
        ],
      ),
    );
  }
}
