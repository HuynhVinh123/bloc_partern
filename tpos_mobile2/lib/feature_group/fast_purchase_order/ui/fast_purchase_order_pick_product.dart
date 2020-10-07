import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/template_ui/app_appbar_search.dart';

import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/widget_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/view_model/fast_purchase_order_addedit_viewmodel.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/src/tpos_apis/models/product.dart';

class PickProductFPO extends StatefulWidget {
  final String searchText;

  @override
  _PickProductFPOState createState() => _PickProductFPOState();
  final FastPurchaseOrderAddEditViewModel vm;

  PickProductFPO({this.searchText, @required this.vm});
}

class _PickProductFPOState extends State<PickProductFPO> {
  TextEditingController searchController = new TextEditingController();
  FastPurchaseOrderAddEditViewModel _viewModel;
  bool isLoading = true;
  FocusNode _searchFocusNode = new FocusNode();
  @override
  void initState() {
    _viewModel = widget.vm;
    if (widget.searchText != null) {
      searchController.text = widget.searchText;
    }

    _viewModel.getProductList().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<FastPurchaseOrderAddEditViewModel>(
      model: _viewModel,
      child: ScopedModelDescendant<FastPurchaseOrderAddEditViewModel>(
          builder: (context, child, model) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: !isLoading
              ? model.products.isNotEmpty
                  ? _buildBody()
                  : Center(
                      child: Container(
                        child: Text(
                            "không có dữ liệu với từ khóa \"${searchController.text}\""),
                      ),
                    )
              : loadingScreen(),
        );
      }),
    );
  }

  Widget _buildAppBar() {
    Timer debounceProducts;
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Container(
          padding: EdgeInsets.only(left: 8, top: 5, bottom: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: AppAppBarSearchTitle(
            controller: searchController,
            onSearch: (text) {
              print(text);
              debounceProducts =
                  Timer(const Duration(milliseconds: 500), () async {
                try {
                  setState(() {
                    isLoading = true;
                  });
                  await _viewModel.getProductByKeyWord(text);
                  setState(() {
                    isLoading = false;
                  });
                } catch (e) {
                  setState(() {
                    isLoading = false;
                  });
                }
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return ScopedModelDescendant<FastPurchaseOrderAddEditViewModel>(
      builder: (context, child, model) {
        return ListView.builder(
            itemCount: model.products.length,
            itemBuilder: (context, index) {
              Product item = model.products[index];

              return _showListItem(item);
            });
      },
    );
  }

  Widget _showListItem(Product item) {
    return InkWell(
      onTap: () {
        // _viewModel.onPickPartner(item);
        Navigator.pop(context, item);
      },
      child: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CircleAvatar(
                  child: Text(
                      "${item.name[0] ?? ""}${item.name.length > 1 ? item.name[1] ?? "" : ""}"),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "${item.nameGet ?? "<Chưa có tên>"}",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            " (${item.uOMName ?? ""})",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  "${vietnameseCurrencyFormat(item.purchasePrice ?? 0)}",
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
