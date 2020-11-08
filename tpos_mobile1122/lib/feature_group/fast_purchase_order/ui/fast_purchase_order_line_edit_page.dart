import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';

import 'package:tpos_mobile/feature_group/fast_purchase_order/view_model/fast_purchase_order_addedit_viewmodel.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order.dart';
import 'package:tpos_mobile/widgets/number_input_left_right_widget.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class FastPurchaseOrderLineEditPage extends StatefulWidget {
  const FastPurchaseOrderLineEditPage({this.viewModel, this.orderLine});
  final FastPurchaseOrderAddEditViewModel viewModel;
  final OrderLine orderLine;
  @override
  _FastPurchaseOrderLineEditPageState createState() =>
      _FastPurchaseOrderLineEditPageState();
}

class _FastPurchaseOrderLineEditPageState
    extends State<FastPurchaseOrderLineEditPage> {
  final _priceTextEditController = TextEditingController();
  final _discountTextEditController = TextEditingController();

  @override
  void initState() {
    widget.viewModel.qtyLines = widget.orderLine.productQty.toDouble();
    super.initState();
  }

  @override
  void dispose() {
//    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<FastPurchaseOrderAddEditViewModel>(
        model: widget.viewModel,
        child: Scaffold(
          appBar: AppBar(
            //Tùy chọn thuộc tính
            title: Text(S.current.fastPurchase_propertyOptions),
            actions: <Widget>[
              FlatButton(
                textColor: Colors.white,
                //LƯU
                child: Text(S.current.save.toUpperCase()),
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
//    _priceTextEditController.text = vietnameseCurrencyFormat(_viewModel.price);
    _priceTextEditController.text =
        vietnameseCurrencyFormat(widget.orderLine.priceUnit);
    _discountTextEditController.text =
        NumberFormat("###.##", "vi_VN").format(widget.orderLine.discount);

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
                    leading: Text("${S.current.unit}:"),
                    trailing: SizedBox(
                      width: 100,
                      child: TextField(
                        controller: _priceTextEditController,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          hintText: "",
                        ),
                        onChanged: (text) {
                          widget.viewModel.updateOrderLinesInfo({
                            "productQty": widget.viewModel.qtyLines,
                            "priceUnit": double.parse(text.replaceAll(".", "")),
                            "discount": double.parse(_discountTextEditController
                                .text
                                .replaceAll(".", "")),
                          }, widget.orderLine);
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
                  //Chiết khấu

                  ListTile(
                    leading: Text("${S.current.fastPurchase_discount}(%):"),
                    trailing: SizedBox(
                      width: 100,
                      child: TextField(
                        controller: _discountTextEditController,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          hintText: "",
                        ),
                        onChanged: (text) {
                          widget.viewModel.updateOrderLinesInfo({
                            "productQty": widget.viewModel.qtyLines,
                            "priceUnit": double.parse(_priceTextEditController
                                .text
                                .replaceAll(".", "")),
                            "discount": double.parse(text.replaceAll(".", "")),
                          }, widget.orderLine);
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
                            _discountTextEditController.selection =
                                TextSelection(
                                    baseOffset: 0,
                                    extentOffset: _discountTextEditController
                                        .text.length);

                            isFocus = true;
                          }
                        },
                      ),
                    ),
                  ),
                  _defaultDivider,
                  // Giảm giá
                  // Giá đã giảm
                  ScopedModelDescendant<FastPurchaseOrderAddEditViewModel>(
                      builder: (context, child, model) {
                    // Đơn giá (Đã giảm)
                    return ListTile(
                      leading: Text(
                          "${S.current.unit} (${S.current.purchaseOrder_reduced}): "),
                      title: Text(
                        vietnameseCurrencyFormat(widget.viewModel
                            .priceDiscountProduct(_priceTextEditController.text,
                                _discountTextEditController.text)),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                        textAlign: TextAlign.right,
                      ),
                    );
                  }),
                  const Divider(),
                  //      Số lượng            //
                  ListTile(
                    leading: SizedBox(
                        width: 100,
                        child: Text(
                          "${S.current.quantity}: ",
                        )),
                    title: Container(
                      child: NumberInputLeftRightWidget(
                        value: widget.viewModel.qtyLines,
                        seedValue: 1,
                        numberFormat: "###,###,###",
                        fontWeight: FontWeight.bold,
                        onChanged: (value) {
                          setState(() {
                            widget.viewModel.qtyLines = value;
                          });

                          widget.viewModel.updateOrderLinesInfo({
                            "productQty": widget.viewModel.qtyLines,
                            "priceUnit": double.parse(_priceTextEditController
                                .text
                                .replaceAll(".", "")),
                            "discount": double.parse(_discountTextEditController
                                .text
                                .replaceAll(".", "")),
                          }, widget.orderLine);
//                          _viewModel.quantity = value;
                        },
                      ),
                      alignment: const Alignment(1, 1),
                    ),
                  ),
                  _defaultDivider,
                  // Thành tiền
                  ScopedModelDescendant<FastPurchaseOrderAddEditViewModel>(
                      builder: (context, child, model) {
                    return ListTile(
                      leading: Text("${S.current.totalAmount}: "),
                      title: Text(
                        vietnameseCurrencyFormat(widget
                            .viewModel
                            .defaultFPO
                            .orderLines[widget.viewModel.defaultFPO.orderLines
                                .indexOf(widget.orderLine)]
                            .priceSubTotal),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                        textAlign: TextAlign.right,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showProductInfo() {
    print(widget.orderLine.product.imageUrl);
//    if (_viewModel.product == null) return SizedBox();
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
                if (widget.orderLine.product.imageUrl != null &&
                    widget.orderLine.product.imageUrl != "") {
                  return Image.network(widget.orderLine.product.imageUrl);
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
//                      "${_viewModel.product?.nameGet}",
                      widget.orderLine.name ?? "",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    // Đơn vị
                    Text(
                        "${S.current.unit}: ${widget.orderLine.productUom.name} "),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      vietnameseCurrencyFormat(widget.orderLine.priceUnit ?? 0),
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
