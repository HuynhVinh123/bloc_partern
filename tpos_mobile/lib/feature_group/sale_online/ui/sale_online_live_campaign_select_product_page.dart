/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/product_search.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/sale_online_live_campaign_select_product_viewmodel.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';

import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';

import 'package:tpos_mobile/widgets/number_input_left_right_widget.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SaleOnlineLiveCampaignSelectProductPage extends StatefulWidget {
  const SaleOnlineLiveCampaignSelectProductPage({this.details});
  final List<LiveCampaignDetail> details;

  @override
  _SaleOnlineLiveCampaignSelectProductPageState createState() =>
      _SaleOnlineLiveCampaignSelectProductPageState(details: details);
}

class _SaleOnlineLiveCampaignSelectProductPageState
    extends State<SaleOnlineLiveCampaignSelectProductPage> {
  _SaleOnlineLiveCampaignSelectProductPageState(
      {List<LiveCampaignDetail> details}) {
    _details = details;
  }
  SaleOnlineLiveCampaignSelectProductViewModel viewModel =
      SaleOnlineLiveCampaignSelectProductViewModel();

  List<LiveCampaignDetail> _details;

  @override
  void dispose() {
    super.dispose();
    viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /// Danh sách sản phẩm
        title: Text(S.current.products),
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final ProductSearchDelegate dg = ProductSearchDelegate();
              final selectedProduct =
                  await showSearch(context: context, delegate: dg);
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

  Widget _buildListProductItem(LiveCampaignDetail item) {
    final TextStyle itemTextStyle = TextStyle(color: Colors.black);
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key("${item.id}_${item.productId}_${item.productName}"),
      child: ListTile(
        contentPadding:
            const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
        title: RichText(
          text: TextSpan(
            text: "",
            style: itemTextStyle.copyWith(color: Colors.green),
            children: [
              TextSpan(
                text: item.productName ?? "",
                style: itemTextStyle,
              ),
              TextSpan(
                text: " (${item.quantity})",
                style: itemTextStyle.copyWith(color: Colors.blue),
              )
            ],
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  vietnameseCurrencyFormat(item.price ?? 0),
                  style: itemTextStyle.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Text(
                    "x",
                    style: itemTextStyle.copyWith(color: Colors.green),
                    textAlign: TextAlign.left,
                  )),
              Expanded(
                flex: 2,
                child: SizedBox(
                  child: NumberInputLeftRightWidget(
                    key: Key(item.id.toString()),
                    value: item.quantity ?? 0,
                    fontWeight: FontWeight.bold,
                    onChanged: (value) {
                      setState(() {
                        viewModel.changeProductQuantityCommand(item, value);
                      });
                    },
                  ),
                  height: 35,
                ),
              )
            ],
          ),
        ),
        onTap: () async {},
      ),
      background: Container(
        color: Colors.green,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                S.current.deleteALine,
                style: itemTextStyle.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const Icon(
              Icons.delete_forever,
              color: Colors.red,
              size: 40,
            )
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        final dialogResult = await showQuestion(
            context: context,
            title: S.current.delete,
            message:
                "${S.current.liveCampaign_deleteProduct} ${item.productName}?");

        if (dialogResult == OldDialogResult.Yes) {
          return true;
        } else {
          return false;
        }
      },
      onDismissed: (direction) {
        viewModel.deleteOrderLineCommand(item);
      },
    );
  }

  Widget _showBody() {
    return StreamBuilder<List<LiveCampaignDetail>>(
      stream: viewModel.detailsStream,
      initialData: viewModel.details,
      builder: (ctx, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text(S.current.liveCampaign_noProduct),
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
              return _buildListProductItem(snapshot.data[index]);
            });
      },
    );
  }

  @override
  void initState() {
    viewModel.details = _details;
    super.initState();
  }
}
