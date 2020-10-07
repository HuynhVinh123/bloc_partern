import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';

import 'package:tpos_mobile/feature_group/fast_purchase_order/view_model/fast_purchase_order_addedit_viewmodel.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order.dart';
import 'package:tpos_mobile/widgets/ModalWaitingWidget.dart';
import 'package:tpos_mobile/widgets/number_input_left_right_widget.dart';

class FastPurchaseOrderLineEditPage extends StatefulWidget {
  FastPurchaseOrderLineEditPage({this.viewModel, this.orderLine});
  final FastPurchaseOrderAddEditViewModel viewModel;
  final OrderLine orderLine;
  @override
  _FastPurchaseOrderLineEditPageState createState() =>
      _FastPurchaseOrderLineEditPageState();
}

class _FastPurchaseOrderLineEditPageState
    extends State<FastPurchaseOrderLineEditPage> {
  final _priceTextEditController = new TextEditingController();
  final _discountTextEditController = new TextEditingController();

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
            title: Text("Tùy chọn thuộc tính"),
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
//    _priceTextEditController.text = vietnameseCurrencyFormat(_viewModel.price);
    _priceTextEditController.text =
        vietnameseCurrencyFormat(widget.orderLine.priceUnit);
    _discountTextEditController.text =
        NumberFormat("###.##", "vi_VN").format(widget.orderLine.discount);

    Divider _defaultDivider = new Divider(
      height: 1,
    );
    return Container(
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
                          widget.viewModel.updateOrderLinesInfo({
                            "productQty": widget.viewModel.qtyLines,
                            "priceUnit": double.parse(text.replaceAll(".", "")),
                            "discount": double.parse(_discountTextEditController
                                .text
                                .replaceAll(".", "")),
                          }, widget.orderLine);
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
                            _priceTextEditController.selection =
                                new TextSelection(
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
                  ListTile(
                    leading: Text("Chiết khấu(%):"),
                    trailing: SizedBox(
                      width: 100,
                      child: TextField(
                        controller: _discountTextEditController,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
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
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        inputFormatters: [
                          // FilteringTextInputFormatter.digitsOnly,
                          NumberInputFormat.vietnameDong(),
                        ],
                        onTap: () {
                          bool isFocus = false;
                          if (isFocus == false) {
                            _discountTextEditController.selection =
                                new TextSelection(
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
                    return ListTile(
                      leading: Text("Đơn giá (Đã giảm): "),
                      title: Text(
                        "${vietnameseCurrencyFormat(widget.viewModel.priceDiscountProduct(_priceTextEditController.text, _discountTextEditController.text))}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                        textAlign: TextAlign.right,
                      ),
                    );
                  }),
                  Divider(),
                  ListTile(
                    leading: SizedBox(
                        width: 100,
                        child: Text(
                          "Số lượng: ",
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
                      alignment: Alignment(1, 1),
                    ),
                  ),
                  _defaultDivider,
                  // Thành tiền
                  ScopedModelDescendant<FastPurchaseOrderAddEditViewModel>(
                      builder: (context, child, model) {
                    return ListTile(
                      leading: Text("Thành tiền: "),
                      title: Text(
                        "${vietnameseCurrencyFormat(widget.viewModel.defaultFPO.orderLines[widget.viewModel.defaultFPO.orderLines.indexOf(widget.orderLine)].priceSubTotal)}",
                        style: TextStyle(
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
                      "${widget.orderLine.name}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text("Đơn vị: ${widget.orderLine.productUom.name} "),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${vietnameseCurrencyFormat(widget.orderLine.priceUnit)}",
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
