/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/16/19 5:56 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/16/19 4:07 PM
 *
 */

import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/delivery_carrier_search_viewmodel.dart';

import 'package:tpos_mobile/widgets/custom_widget.dart';
import 'package:tpos_mobile/widgets/listview_data_error_info_widget.dart';

class DeliveryCarrierSearchPage extends StatefulWidget {
  const DeliveryCarrierSearchPage(
      {this.selectedDeliveryCarrier,
      this.isSearch,
      this.closeWhenDone,
      this.selectedCallback});
  final DeliveryCarrier selectedDeliveryCarrier;
  final bool isSearch;
  final bool closeWhenDone;
  final Function(DeliveryCarrier) selectedCallback;

  @override
  _DeliveryCarrierSearchPageState createState() =>
      _DeliveryCarrierSearchPageState(
          selectedDeliveryCarrier: selectedDeliveryCarrier,
          selectedCallback: selectedCallback,
          isSearch: isSearch,
          closeWhenDone: closeWhenDone);
}

class _DeliveryCarrierSearchPageState extends State<DeliveryCarrierSearchPage> {
  _DeliveryCarrierSearchPageState(
      {DeliveryCarrier selectedDeliveryCarrier,
      bool isSearch,
      bool closeWhenDone,
      Function(DeliveryCarrier) selectedCallback}) {
    _viewModel.init(
      selectedCarrier: selectedDeliveryCarrier,
      isCloseOnDone: closeWhenDone = closeWhenDone,
      isSearch: isSearch,
      selectedCallback: selectedCallback,
    );
  }

  final _viewModel = locator<DeliveryCarrierSearchViewModel>();

  @override
  void initState() {
    _viewModel.initCommand();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewBaseStateWidget(
      stateStream: _viewModel.stateController,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Chọn đối tác giao hàng"),
        ),
        body: _showBody(),
      ),
    );
  }

  Widget _showBody() {
    return StreamBuilder<List<DeliveryCarrier>>(
        stream: _viewModel.deliveryCarriersStream,
        initialData: _viewModel.deliveryCarriers,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ListViewDataErrorInfoWidget(
              errorMessage: "Đã xảy ra lỗi!. \n" + snapshot.error.toString(),
            );
          }
          return _showDeliveryCarrierList(_viewModel.deliveryCarriers);
        });
  }

  Widget _showDeliveryCarrierList(List<DeliveryCarrier> items) {
    if (items == null) {
      return const Center(
        child: Text(""),
      );
    }
    if (items.isEmpty) {
      return const Center(
        child: Text("Không có dữ liệu!"),
      );
    }
    return ListView.separated(
        itemBuilder: (ctx, index) {
          return _showDeliveryCarrierItem(items[index]);
        },
        separatorBuilder: (ctx, index) {
          return const Divider(
            height: 1,
            indent: 50,
          );
        },
        itemCount: items?.length ?? 0);
  }

  Widget _showDeliveryCarrierItem(DeliveryCarrier item) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Text(item.name.substring(0, 1)),
      ),
      title: Text(item.name ?? ''),
      onTap: () {
        if (_viewModel.selectedCallback != null)
          _viewModel.selectedCallback(item);
        if (_viewModel.isCloseOnDone) {
          Navigator.pop(context, item);
        } else {}
      },
    );
  }
}
