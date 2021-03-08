/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/16/19 5:56 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/16/19 1:26 PM
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/fast_sale_order/viewmodels/fast_sale_order_line_edit_viewmodel.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/helpers/tmt.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/widgets/ModalWaitingWidget.dart';
import 'package:tpos_mobile/widgets/custom_widget.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class FastSaleOrderLineEditPage extends StatefulWidget {
  const FastSaleOrderLineEditPage(this.orderLine);
  final FastSaleOrderLine orderLine;
  @override
  _FastSaleOrderLineEditPageState createState() =>
      _FastSaleOrderLineEditPageState();
}

class _FastSaleOrderLineEditPageState extends State<FastSaleOrderLineEditPage> {
  _FastSaleOrderLineEditPageState();

  final _viewModel = locator<FastSaleOrderLineEditViewModel>();
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
    return Scaffold(
      appBar: AppBar(
        // Tùy chọn thuộc tính
        title: Text(S.current.propertyOptions),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            child: Text(S.current.save.toUpperCase()),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: ModalWaitingWidget(
        isBusyStream: _viewModel.isBusyController,
        initBusy: false,
        child: _showBody(),
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
    return Container(
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
                            _priceTextEditController.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset:
                                    _priceTextEditController.text.length);

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
                        _viewModel.isDiscountPercent = isPercent;
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
                          keyboardType: const TextInputType.numberWithOptions(),
                          inputFormatters: _viewModel.isDiscountPercent
                              ? [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(
                                      "[0-9.,]",
                                    ),
                                  ),
                                  PercentInputFormat(
                                    locate: "vi_VN",
                                    format: "###.0#",
                                  ),
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

                            if (_viewModel.isDiscountPercent) {
                              _viewModel.discountPercent = value;
                            } else {
                              _viewModel.discountFix = value;
                            }
                          },
                          onTap: _viewModel.isDiscountPercent
                              ? () {
                                  _discountTextEditController.selection =
                                      TextSelection(
                                    baseOffset: 0,
                                    extentOffset:
                                        _discountTextEditController.text.length,
                                  );
                                }
                              : () {
                                  _discountFixTextEditController.selection =
                                      TextSelection(
                                    baseOffset: 0,
                                    extentOffset: _discountFixTextEditController
                                        .text.length,
                                  );
                                }),
                    ),
                  ),
                  _defaultDivider, // Giá đã giảm
                  // Đơn giá (Đã giảm)
                  ListTile(
                    leading:
                        Text("${S.current.price} (${S.current.reduced}): "),
                    title: StreamBuilder<double>(
                        stream: _viewModel.priceDiscountStream,
                        initialData: _viewModel.priceDiscount,
                        builder: (context, snapshot) {
                          return Text(
                            vietnameseCurrencyFormat(snapshot.data ?? 0),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                            textAlign: TextAlign.right,
                          );
                        }),
                  ),
                  const Divider(),
                  // Số lượng
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
                    title: StreamBuilder<double>(
                        stream: _viewModel.totalStream,
                        initialData: _viewModel.total,
                        builder: (context, snapshot) {
                          return Text(
                            // ignore: unnecessary_string_interpolations
                            "${vietnameseCurrencyFormat(
                              _viewModel.total,
                            )}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                            textAlign: TextAlign.right,
                          );
                        }),
                  ),
                  // Ghi chú

                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller:
                          TextEditingController(text: _viewModel.orderLineNote),
                      decoration: InputDecoration(
                          labelText: S.current.note,
                          hintText: S.current.addNote,
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
    );
  }

  Widget _showProductInfo() {
    if (_viewModel.product == null) return const SizedBox();
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
                    // Đơn vị
                    Text(
                        "${S.current.unit}: ${_viewModel.orderLine.productUomName ?? ""}"),
                    Text(
                      vietnameseCurrencyFormat(_viewModel.product.price ?? 0),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Tồn kho
                    SizedBox(
                      height: 35,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _viewModel.inventories?.length ?? 0,
                        itemBuilder: (context, index) => DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.grey.shade300,
                            border: Border.all(color: Colors.grey, width: 0.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "${S.current.menu_inventoryReport}: ${vietnameseCurrencyFormat(_viewModel.inventories[index].quantity)}"),
                          ),
                        ),
                      ),
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
