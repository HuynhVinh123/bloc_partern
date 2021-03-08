import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/template_ui/app_appbar_search.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/widget_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/view_model/fast_purchase_order_addedit_viewmodel.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PickProductFPO extends StatefulWidget {
  const PickProductFPO({this.searchText, @required this.vm});
  final String searchText;

  @override
  _PickProductFPOState createState() => _PickProductFPOState();
  final FastPurchaseOrderAddEditViewModel vm;
}

class _PickProductFPOState extends State<PickProductFPO> {
  TextEditingController searchController = TextEditingController();
  FastPurchaseOrderAddEditViewModel _viewModel;
  bool isLoading = true;
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
                        // không có dữ liệu với từ khóa
                        child: Text(
                            "${S.current.noData} ${S.current.fastPurchase_withKeyWord} \"${searchController.text}\""),
                      ),
                    )
              : loadingScreen(),
        );
      }),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Container(
          padding: const EdgeInsets.only(left: 8, top: 5, bottom: 5),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: AppAppBarSearchTitle(
            initKeyword: widget.searchText ?? "",
            controller: searchController,
            onSearch: (text) {
              print(text);
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
              final Product item = model.products[index];

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
        padding: const EdgeInsets.all(5),
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
                        // Chưa có tên
                        Text(
                          item.nameGet ?? "<${S.current.noName}>",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            " (${item.uOMName ?? ""})",
                            style: const TextStyle(
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
                  vietnameseCurrencyFormat(item.purchasePrice ?? 0),
                  style: const TextStyle(color: Colors.red),
                )
              ],
            ),
            const Divider()
          ],
        ),
      ),
    );
  }
}
