/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/16/19 5:56 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/16/19 2:23 PM
 *
 */

import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/sale_online_order_line_edit_viewmodel.dart';
import 'package:tpos_mobile/helpers/helpers.dart';

import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';

import 'package:tpos_mobile/widgets/custom_widget.dart';

class SaleOnlineOrderLineEditPage extends StatefulWidget {
  const SaleOnlineOrderLineEditPage(this.orderLine);
  final SaleOnlineOrderDetail orderLine;

  @override
  _SaleOnlineOrderLineEditPageState createState() =>
      _SaleOnlineOrderLineEditPageState(orderLine);
}

class _SaleOnlineOrderLineEditPageState
    extends State<SaleOnlineOrderLineEditPage> {
  _SaleOnlineOrderLineEditPageState(this.orderLine);
  SaleOnlineOrderDetail orderLine;

  final SaleOnlineOrderLineEditViewModel _viewModel =
      locator<SaleOnlineOrderLineEditViewModel>();

  @override
  void initState() {
    _viewModel.init(orderLine);
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
        title: const Text("Tùy chọn thuộc tính"),
      ),
      body: _showBody(),
    );
  }

  Widget _showBody() {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.orange.shade100,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.asset("images/no_image.png")),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _viewModel.orderLine?.productName ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("Đơn vị: ${_viewModel.orderLine.uomName ?? ""}"),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: const Text("Số lượng: "),
                title: Container(
                  child: NumberInputLeftRightWidget(
                    value: orderLine.quantity,
                    seedValue: 1,
                    numberFormat: "###,###,###",
                    fontWeight: FontWeight.bold,
                    onChanged: (value) {
                      setState(() {
                        _viewModel.orderLine.quantity = value;
                      });
                    },
                  ),
                  alignment: const Alignment(1, 1),
                ),
              ),
              ListTile(
                leading: const Text("Đơn giá: "),
                title: Container(
                    alignment: const Alignment(1, 1),
                    child: NumberInputLeftRightWidget(
                      value: orderLine.price,
                      seedValue: 1000,
                      numberFormat: "###,###,###,###",
                      fontWeight: FontWeight.bold,
                      onChanged: (value) {
                        setState(() {
                          _viewModel.orderLine.price = value;
                        });
                      },
                    )),
              ),
              ListTile(
                leading: const Text("Thành tiền: "),
                title: Text(
                  "${vietnameseCurrencyFormat(_viewModel.orderLine.quantity * _viewModel.orderLine.price)} ",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
        ),
        SafeArea(
          child: Container(
            width: double.infinity,
            child: RaisedButton(
              color: Colors.green,
              child: Text(
                "XÁC NHẬN",
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }
}
