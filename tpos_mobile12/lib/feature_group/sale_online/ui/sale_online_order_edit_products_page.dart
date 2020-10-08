/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/16/19 5:56 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/16/19 2:59 PM
 *
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/helpers/tmt.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/category/product_search_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_order_line_edit_page.dart';

import 'package:tpos_mobile/feature_group/sale_online/viewmodels/sale_online_order_edit_products_viewmodel.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';

import 'package:tpos_mobile/widgets/number_input_left_right_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';

class SaleOnlineOrderEditProductsPage extends StatefulWidget {
  const SaleOnlineOrderEditProductsPage(this.orderLines);
  final List<SaleOnlineOrderDetail> orderLines;

  @override
  _SaleOnlineOrderEditProductsPageState createState() =>
      _SaleOnlineOrderEditProductsPageState(orderLines);
}

class _SaleOnlineOrderEditProductsPageState
    extends State<SaleOnlineOrderEditProductsPage> {
  _SaleOnlineOrderEditProductsPageState(this.orderLines);
  List<SaleOnlineOrderDetail> orderLines;
  final _viewModel = locator<SaleOnlineOrderEditProductsViewModel>();
  StreamSubscription _notifyPropertyChangedSubcription;
  String barcode = "";
  @override
  void initState() {
    _viewModel.init(orderLines);
    _viewModel.initCommand();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _notifyPropertyChangedSubcription =
        _viewModel.notifyPropertyChangedController.listen((propertyName) {
      setState(() {});
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _notifyPropertyChangedSubcription?.cancel();
    _viewModel.dispose();
    super.dispose();
  }

  Future _findProduct({String keyword}) async {
    final product = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductSearchPage(),
      ),
    );

    if (product != null) {
      _viewModel.addItemFromProductCommand(product);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Container(
            width: double.infinity,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.grey.shade100,
            ),
            child: InkWell(
              onTap: () {
                _findProduct();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.add,
                    color: Colors.green,
                  ),
                  Text(
                    "Thêm sản phẩm",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: SvgPicture.asset(
                      "images/barcode_scan.svg",
                      width: 25,
                      height: 25,
                      color: Colors.blue,
                    ),
                    onPressed: () async {
                      final result = await scanBarcode();
                      if (result.isError) {}
                      _findProduct(keyword: result.result);
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: _showBody(),
    );
  }

  Widget _showBody() {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: _showListItems(_viewModel.orderLines),
        ),
        SafeArea(
          child: Container(
            height: 62,
            color: Colors.green.shade100,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 3, top: 3, bottom: 3),
                  child: RaisedButton.icon(
                    textColor: Colors.white,
                    color: Colors.deepPurple,
                    icon: Icon(Icons.keyboard_return),
                    label: const Padding(
                      padding: EdgeInsets.only(right: 10, left: 10),
                      child: Text("Quay lại"),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Số lượng: ${(_viewModel.getQuantity() ?? 0).toStringFormat('###,###,###.##', locate: App.locate)} \nTổng tiền: ${vietnameseCurrencyFormat(_viewModel.getSubtotal())}",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.right,
                  ),
                ))
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _showListItems(List<SaleOnlineOrderDetail> items) {
    return Material(
        color: Colors.white,
        child: Scrollbar(
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (ctx, index) {
              return Dismissible(
                direction: DismissDirection.endToStart,
                key: Key(
                    "${items[index].productId.toString()}${items[index].uomId}"),
                child: _showItem(items[index], index),
                background: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Expanded(
                        child: Text("Xóa sản phẩm: "),
                      ),
                      RaisedButton(
                        child: const Text("Xóa"),
                        color: Colors.white,
                        onPressed: () {},
                      )
                    ],
                  ),
                ),
                onDismissed: (direction) {
                  setState(() {
                    if (items.contains(items[index])) {
                      items.remove(items[index]);
                    }
                  });
                },
              );
            },
            separatorBuilder: (ctx, index) {
              return Divider(
                height: 5,
                indent: 10,
                color: Colors.black45,
              );
            },
            itemCount: items.length,
          ),
        ));
  }

  Widget _showItem(SaleOnlineOrderDetail item, int index) {
    final TextStyle itemTextStyle = TextStyle(color: Colors.black);
    return ListTile(
      contentPadding:
          const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
      title: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              child: Text("${index + 1}"),
              radius: 10,
            ),
          ),
          RichText(
            text: TextSpan(
              style: itemTextStyle,
              children: [
                TextSpan(
                  text: item.productName ?? "",
                  style: itemTextStyle.copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: " (${item.uomName})",
                  style: itemTextStyle.copyWith(color: Colors.blue),
                )
              ],
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Text(
                vietnameseCurrencyFormat(item.price ?? 0),
                style: itemTextStyle.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
            Expanded(
                child: Text(
              "x",
              style: itemTextStyle.copyWith(color: Colors.green),
              textAlign: TextAlign.left,
            )),
            Expanded(
              flex: 2,
              child: SizedBox(
                child: NumberInputLeftRightWidget(
                  key: Key(item.productId.toString()),
                  value: item.quantity,
                  fontWeight: FontWeight.bold,
                  onChanged: (value) {
                    _viewModel.updateQuantityCommand(item, value);
                  },
                ),
                height: 35,
              ),
            )
          ],
        ),
      ),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => SaleOnlineOrderLineEditPage(item),
          ),
        );

        setState(() {});
      },
    );
  }
}

//class SaleOnlineOrderLineItemWidget extends StatelessWidget {
//  SaleOnlineOrderDetail orderLine;
//  Function(void) onDeletePress;
//  Function(void) onEditPress;
//  Function(SaleOnlineOrderDetail) onChanged;
//  SaleOnlineOrderLineItemWidget(SaleOnlineOrderDetail orderLine,
//      {this.onDeletePress, this.onEditPress}) {
//    this.orderLine = orderLine;
//  }
//  @override
//  Widget build(BuildContext context) {
//    return Material(
//      child: new Row(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        mainAxisSize: MainAxisSize.min,
//        children: <Widget>[
//          new Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              new SizedBox(
//                height: 50,
//                width: 60,
//                child: Image.asset("images/no_image.png"),
//              ),
//              new SizedBox(
//                width: 60,
//                child: FlatButton(
//                  textColor: ColorResource.hyperlinkColor,
//                  child: Text(
//                    "Sửa",
//                    textAlign: TextAlign.left,
//                  ),
//                  onPressed: () {
////                    Navigator.push(
////                        context,
////                        MaterialPageRoute(
////                            builder: (ctx) => FastSaleOrderLineEditPage(line)));
//                  },
//                ),
//              )
//            ],
//          ),
//          new Expanded(
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.stretch,
//              mainAxisSize: MainAxisSize.max,
//              children: <Widget>[
//                new Row(
//                  children: <Widget>[
//                    Expanded(
//                      child: Text(
//                        "${orderLine.productName}",
//                        style: TextStyle(
//                            fontSize: 15,
//                            color: Colors.black,
//                            fontWeight: FontWeight.bold),
//                      ),
//                    ),
//                    SizedBox(
//                      width: 60,
//                      height: 30,
//                      child: FlatButton(
//                        textColor: Colors.red,
//                        child: Text("Xóa"),
//                        onPressed: () async {
//                          if (await showQuestion(
//                                  context: context,
//                                  title: "Xác nhận",
//                                  message: "Xác nhận xóa sản phẩm ") ==
//                              DialogResult.Yes) {
//                            if (this.onDeletePress != null) onDeletePress(null);
//                          }
//                        },
//                      ),
//                    )
//                  ],
//                ),
//                new SizedBox(
//                  height: 5,
//                ),
//                // Số lượng
//                new Row(
//                  children: <Widget>[
//                    new Container(
//                      padding: EdgeInsets.all(5),
//                      height: 35,
//                      child: Row(
//                        mainAxisSize: MainAxisSize.min,
//                        children: <Widget>[
//                          SizedBox(
//                            width: 30,
//                            child: OutlineButton(
//                              child: Icon(
//                                Icons.remove,
//                                size: 12,
//                              ),
//                              onPressed: () {
//                                _viewModel.changeQuantityOfProductCommand(
//                                    line, false);
//                              },
//                              padding: EdgeInsets.all(0),
//                            ),
//                          ),
//                          new SizedBox(
//                            width: 5,
//                          ),
//                          SizedBox(
//                            width: 120,
//                            child: OutlineButton(
//                              child: Text("${line.productUOMQty}"),
//                              onPressed: () async {
//                                var value = await showDialog(
//                                    context: context,
//                                    builder: (ctx) {
//                                      return new NumberInputDialogWidget(
//                                        currentValue: line.productUOMQty,
//                                      );
//                                    });
//
//                                if (value != null) {
//                                  _viewModel.updateOrderLineQuantityCommand(
//                                      line, value);
//                                }
//                              },
//                            ),
//                          ),
//                          new SizedBox(
//                            width: 5,
//                          ),
//                          new SizedBox(
//                            width: 30,
//                            child: OutlineButton(
//                              child: Icon(
//                                Icons.add,
//                                size: 12,
//                              ),
//                              padding: EdgeInsets.all(0),
//                              onPressed: () {
//                                _viewModel.changeQuantityOfProductCommand(
//                                    line, true);
//                              },
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ],
//                ),
//                new SizedBox(
//                  height: 5,
//                ),
//
//                // Đơn giá
//                new Row(
//                  children: <Widget>[
//                    new Container(
//                      padding: EdgeInsets.all(5),
//                      height: 35,
//                      child: Row(
//                        mainAxisSize: MainAxisSize.min,
//                        children: <Widget>[
//                          new SizedBox(
//                            width: 30,
//                            child: OutlineButton(
//                              child: Icon(
//                                Icons.remove,
//                                size: 12,
//                              ),
//                              onPressed: () {
//                                _viewModel.changePriceOfProductCommand(
//                                    line, false);
//                              },
//                              padding: EdgeInsets.all(0),
//                            ),
//                          ),
//                          new SizedBox(
//                            width: 5,
//                          ),
//                          SizedBox(
//                            width: 120,
//                            child: OutlineButton(
//                              child: Text(
//                                  "${vietnameseCurrencyFormat(line.priceUnit)}"),
//                              onPressed: () async {
//                                var value = await showDialog(
//                                    context: context,
//                                    builder: (ctx) {
//                                      return new NumberInputDialogWidget(
//                                        currentValue: line.priceUnit,
//                                      );
//                                    });
//
//                                print(value);
//                                if (value != null) {
//                                  _viewModel.updateOrderLinePriceCommand(
//                                      line, value);
//                                }
//                              },
//                            ),
//                          ),
//                          new SizedBox(
//                            width: 5,
//                          ),
//                          new SizedBox(
//                            width: 30,
//                            child: OutlineButton(
//                              child: Icon(
//                                Icons.add,
//                                size: 12,
//                              ),
//                              onPressed: () {
//                                _viewModel.changePriceOfProductCommand(
//                                    line, true);
//                              },
//                              padding: EdgeInsets.all(0),
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ],
//                ),
//
//                // Tổng cộng
//                new Text(
//                  "${vietnameseCurrencyFormat(line.productUOMQty * line.priceUnit)}",
//                  textAlign: TextAlign.right,
//                  style: TextStyle(
//                    fontSize: 20,
//                    color: Colors.red,
//                  ),
//                )
//              ],
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}
