/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/product_list_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/sale_online_order_edit_detail_viewmodel.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';
import 'package:intl/intl.dart';

import 'package:tpos_mobile/widgets/number_input_dialog_widget.dart';

class SaleOnlineEditOrderDetailPage extends StatefulWidget {
  const SaleOnlineEditOrderDetailPage(this.details);
  final List<SaleOnlineOrderDetail> details;

  @override
  _SaleOnlineEditOrderDetailPageState createState() =>
      _SaleOnlineEditOrderDetailPageState(details);
}

class _SaleOnlineEditOrderDetailPageState
    extends State<SaleOnlineEditOrderDetailPage> {
  _SaleOnlineEditOrderDetailPageState(this.details);
  List<SaleOnlineOrderDetail> details;

  SaleOnlineEditOrderDetailViewModel viewModel =
      SaleOnlineEditOrderDetailViewModel();
  @override
  void initState() {
    viewModel.details = details;
    viewModel.init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết đơn hàng"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final selectedProduct = await Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => const ProductListPage()));

              if (selectedProduct != null) {
                viewModel.addNewDetail(selectedProduct);
              }
            },
          )
        ],
      ),
      body: _showBody(),
    );
  }

  Widget _showBody() {
    return StreamBuilder<List<SaleOnlineOrderDetail>>(
      stream: viewModel.detailsStream,
      initialData: viewModel.details,
      builder: (ctx, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Text("Danh sách sản phẩm trống"),
          );
        }
        return ListView.separated(
            itemCount: viewModel.details?.length ?? 0,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(5),
            separatorBuilder: (ctx, index) {
              return const Divider(
                height: 1,
              );
            },
            itemBuilder: (ctx, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.image),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            viewModel.details[index].productName ?? '',
                            style:
                                TextStyle(fontSize: 15, color: Colors.orange),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          // Số lượng
                          Row(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(5),
                                height: 35,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 30,
                                      child: OutlineButton(
                                        child: Icon(
                                          Icons.remove,
                                          size: 12,
                                        ),
                                        onPressed: () {
                                          viewModel.changeQuantity(
                                              viewModel.details[index], false);
                                        },
                                        padding: const EdgeInsets.all(0),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: OutlineButton(
                                        child: Text(
                                            "${viewModel.details[index].quantity}"),
                                        onPressed: () async {
                                          final value = await showDialog(
                                              context: context,
                                              builder: (ctx) {
                                                return NumberInputDialogWidget(
                                                  currentValue: viewModel
                                                      .details[index].quantity,
                                                );
                                              });

                                          if (value != null) {
                                            viewModel.details[index].quantity =
                                                double.tryParse(value);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      width: 30,
                                      child: OutlineButton(
                                        child: Icon(
                                          Icons.add,
                                          size: 12,
                                        ),
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () {
                                          viewModel.changeQuantity(
                                              viewModel.details[index], true);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),

                          // Đơn giá
                          Row(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(5),
                                height: 35,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 30,
                                      child: OutlineButton(
                                        child: Icon(
                                          Icons.remove,
                                          size: 12,
                                        ),
                                        onPressed: () {
                                          viewModel.changePrice(
                                              viewModel.details[index], false);
                                        },
                                        padding: const EdgeInsets.all(0),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: OutlineButton(
                                        child: Text(NumberFormat("###,###,###")
                                            .format(viewModel
                                                    .details[index].price ??
                                                0)),
                                        onPressed: () async {
                                          final value = await showDialog(
                                              context: context,
                                              builder: (ctx) {
                                                return NumberInputDialogWidget(
                                                  currentValue: viewModel
                                                      .details[index].price,
                                                );
                                              });

                                          viewModel.details[index].price =
                                              double.tryParse(value);
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      width: 30,
                                      child: OutlineButton(
                                        child: Icon(
                                          Icons.add,
                                          size: 12,
                                        ),
                                        onPressed: () {
                                          viewModel.changePrice(
                                              viewModel.details[index], true);
                                        },
                                        padding: const EdgeInsets.all(0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      iconSize: 15,
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        viewModel.deleteDetail(viewModel.details[index]);
                      },
                    )
                  ],
                ),
              );
            });
      },
    );
  }
}
