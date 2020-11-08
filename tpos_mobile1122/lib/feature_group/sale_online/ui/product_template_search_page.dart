/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_panel.dart';
import 'package:tpos_mobile/app_core/ui_base/app_bar_button.dart';
import 'package:tpos_mobile/helpers/barcode.dart';

import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/product_category_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/product_template_quick_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/product_template_search_viewmodel.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';

import 'package:tpos_mobile/src/tpos_apis/models/base_list_order_by_type.dart';

import 'package:tpos_mobile/widgets/custom_widget.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

@Deprecated(
    'Tính năng danh sách sản phẩm này sẽ bị loại bỏ và thay thế bởi "ProductTemplateListPage"')
class ProductTemplateSearchPage extends StatefulWidget {
  const ProductTemplateSearchPage(
      {this.closeWhenDone = true,
      this.isSearchMode = true,
      this.onSelectedCallback,
      this.keyWord = ""});

  /// Có đóng khi chọn hay không. Áp dụng cho chế độ tìm kiếm
  final bool closeWhenDone;

  /// Mở ra để tìm kiếm
  /// Ô tìm kiếm mở sẵn và được focus vào, Nhấp chọn sẽ đóng trang lại
  final bool isSearchMode;
  final Function(ProductTemplate) onSelectedCallback;
  final String keyWord;

  @override
  _ProductTemplateSearchPageState createState() =>
      _ProductTemplateSearchPageState(
          closeWhenDone: closeWhenDone,
          isSearchMode: isSearchMode,
          onSelectedCallback: onSelectedCallback,
          keyWord: keyWord);
}

class _ProductTemplateSearchPageState extends State<ProductTemplateSearchPage> {
  _ProductTemplateSearchPageState(
      {this.closeWhenDone,
      this.isSearchMode = true,
      this.onSelectedCallback,
      this.keyWord});

  bool closeWhenDone;
  bool isSearchMode;
  String keyWord;
  Function(ProductTemplate) onSelectedCallback;

  ProductTemplateSearchViewModel productViewModel =
      ProductTemplateSearchViewModel();
  final ISettingService _settingService = locator<ISettingService>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _keywordController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    productViewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ProductTemplateSearchViewModel>(
      model: productViewModel,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade200,
          appBar: buildAppBar(context),
          body: ViewBaseWidget(
            isBusyStream: productViewModel.isBusyController,
            child: Scrollbar(
              child: ScopedModelDescendant<ProductTemplateSearchViewModel>(
                builder: (_, __, ___) => Column(
                  children: <Widget>[
                    Expanded(
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildListDelegate([
                              _showFilterPanel(),
                            ]),
                          ),
                          if (_settingService.isProductSearchViewList)
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (context, index) => _showLineItem(
                                      productViewModel.products[index], index),
                                  childCount:
                                      productViewModel.products?.length ?? 0),
                            ),
                          if (!_settingService.isProductSearchViewList)
                            SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 230,
                                      childAspectRatio: 0.85,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8),
                              delegate: SliverChildBuilderDelegate(
                                  (context, index) => ProductTemplateGridItem(
                                        item: productViewModel.products[index],
                                      ),
                                  childCount:
                                      productViewModel.products?.length ?? 0),
                            ),
                          SliverList(
                            delegate: SliverChildListDelegate([
                              if (productViewModel.canLoadMore)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  child: RaisedButton(
                                    shape: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                            width: 0.5, color: Colors.blue)),
                                    color: Colors.blue,
                                    textColor: Colors.white,
                                    child: productViewModel.isLoadingMore
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(),
                                          )
                                        : const Text("Tải thêm"),
                                    onPressed: () {
                                      productViewModel.loadMoreProductCommand();
                                    },
                                  ),
                                )
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          endDrawer: _buildFilterDrawer(),
        ),
      ),
    );
  }

  /// Giao diện search Product
  Widget _buildSearch() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(24)),
      height: 40,
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 12,
          ),
          const Icon(
            Icons.search,
            color: Color(0xFF28A745),
          ),
          Expanded(
            child: Center(
              child: Container(
                  height: 35,
                  margin: const EdgeInsets.only(left: 4),
                  child: Center(
                    child: TextField(
                      controller: _keywordController,
                      onChanged: (value) {
                        if (value == "" || value.length == 1) {
                          setState(() {});
                        }
                        productViewModel.keywordChangedCommand(value);
                      },
                      decoration: const InputDecoration(
                          contentPadding: const EdgeInsets.all(0),
                          isDense: true,
                          hintText: "Tìm kiếm",
                          border: InputBorder.none),
                    ),
                  )),
            ),
          ),
          Visibility(
            visible: _keywordController.text != "",
            child: IconButton(
              constraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 48,
              ),
              padding: const EdgeInsets.all(0.0),
              icon: const Icon(
                Icons.close,
                color: Colors.grey,
                size: 19,
              ),
              onPressed: () {
                setState(() {
                  _keywordController.text = "";
                });
                productViewModel.keywordChangedCommand("");
              },
            ),
          ),
          IconButton(
            icon: Image.asset("images/scan_barcode.png",
                width: 28, height: 24, color: Colors.grey[600]),
            onPressed: () async {
              FocusScope.of(context).requestFocus(FocusNode());

              final ScanBarcodeResult result = await scanBarcode();
              if (result != null && !result.isError) {
                if (result.result != "") {
                  setState(() {
                    _keywordController.text = result.result;
                  });
                  productViewModel.keywordChangedCommand(result.result);
                }
              } else {
                App.showDefaultDialog(
                    type: AlertDialogType.error,
                    content: result.message,
                    title: S.current.error);
              }
            },
          ),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: _buildSearch(),
      actions: <Widget>[
        AppbarIconButton(
          isEnable: true,
          icon: const Icon(Icons.add),
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ProductTemplate addProduct = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => ProductTemplateQuickAddEditPage(
                          closeWhenDone: true,
                        )));

            if (addProduct != null) {
              productViewModel.addNewProductCommand(Product(
                id: addProduct.id,
                name: addProduct.name,
                nameGet: addProduct.nameGet,
                nameNoSign: addProduct.nameNoSign,
                price: addProduct.price,
                oldPrice: addProduct.oldPrice,
                uOMId: addProduct.uOMId,
                weight: addProduct.weight,
              ));
            }
          },
        ),
      ],
    );
  }

  Widget _showFilterPanel() {
    return Container(
      height: 50,
      child: Card(
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<BaseListOrderBy>(
                  hint: const Text("Sắp xếp"),
                  value: productViewModel.selectedOrderBy,
                  onChanged: (BaseListOrderBy selectedOrderBy) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    productViewModel.selectOrderByCommand(selectedOrderBy);
                  },
                  items: productViewModel.orderByList.keys
                      .map(
                        (f) => DropdownMenuItem<BaseListOrderBy>(
                          value: f,
                          child: Text(productViewModel.orderByList[f]),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const Expanded(
              child: Text(""),
            ),
            IconButton(
              splashColor: Colors.green,
              tooltip: "Danh sách ngang",
              icon: Icon(productViewModel.isViewAsList == true
                  ? FontAwesomeIcons.thLarge
                  : FontAwesomeIcons.list),
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                productViewModel
                    .changeViewTypeCommand(!productViewModel.isViewAsList);
                if (!isSearchMode) {
                  if (!productViewModel.isViewAsList)
                    productViewModel.onDialogMessageAdd(
                        OldDialogMessage.flashMessage(
                            "Nhấn dữ sản phẩm để xóa"));
                  else
                    productViewModel.onDialogMessageAdd(
                        OldDialogMessage.flashMessage(
                            "Vuốt sang trái để xóa sản phẩm"));
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Badge(
                badgeContent: Text(productViewModel.filterCount.toString()),
                child: IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _scaffoldKey.currentState.openEndDrawer();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showLineItem(ProductTemplate item, int index) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key("${item.id}"),
      background: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: 1),
          ),
          color: Colors.green,
        ),
        child: Row(
          children: <Widget>[
            const Expanded(
              child: Text(
                "Xóa dòng này?",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Icon(
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
            title: "Xác nhận xóa",
            message: "Bạn có muốn xóa sản phẩm ${item.name}?");

        if (dialogResult == OldDialogResult.Yes) {
          final result = await productViewModel.deleteProductTemplate(item.id);
          if (result) {
            productViewModel.products.removeAt(index);
          }
          return result;
        } else {
          return false;
        }
      },
      onDismissed: (direction) async {},
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: item.active ? Colors.white : Colors.red.shade200,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
          leading: item.imageUrl != null
              ? ClipRRect(
                  child: Image.network(
                    item.imageUrl,
                    width: 50,
                    height: 50,
                  ),
                  borderRadius: BorderRadius.circular(5),
                )
              : SizedBox(
                  height: 50,
                  width: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Material(
                      color: Colors.grey.shade200,
                    ),
                  ),
                ),
          title: RichText(
            text: TextSpan(
                text: "",
                style: const TextStyle(color: Colors.black, fontSize: 12),
                children: <TextSpan>[
                  TextSpan(
                    text: item.name ?? '',
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  TextSpan(
                    text: " [${item.defaultCode ?? ""}] ",
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  TextSpan(
                      text: ' (${item.uOMName ?? ""})',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 14)),
                ]),
          ),
          subtitle: Row(
            children: <Widget>[
              Text(
                "SL Thực: ${NumberFormat("###,###,###.##").format(item.availableQuantity)}",
                style: const TextStyle(color: Colors.deepOrange),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "Dự báo: ${NumberFormat("###,###,###.##").format(item.virtualQuantity)}",
              ),
            ],
          ),
          trailing: Text(
            vietnameseCurrencyFormat(item.listPrice) ?? '',
            style: const TextStyle(color: Colors.red),
          ),
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            if (isSearchMode) {
              if (onSelectedCallback != null) {
                onSelectedCallback(item);
              }
              if (closeWhenDone) {
                Navigator.pop(context, item);
              }
            } else {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  final ProductTemplateQuickAddEditPage
                      productQuickAddEditPage = ProductTemplateQuickAddEditPage(
                    productId: item.id,
                  );
                  return productQuickAddEditPage;
                }),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildFilterDrawer() {
    return ScopedModelDescendant<ProductTemplateSearchViewModel>(
      builder: (context, _, __) => AppFilterDrawerContainer(
        onApply: () {
          productViewModel.amplyFilterCommand();
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              AppFilterPanel(
                title: const Text("Theo nhóm sản phẩm"),
                isSelected: productViewModel.isFilterByCategory,
                onSelectedChange: (value) =>
                    productViewModel.isFilterByCategory = value,
                children: <Widget>[
                  Wrap(
                    runSpacing: 5,
                    spacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: <Widget>[
                      ...productViewModel.filterProductCategories
                          .map(
                            (f) => Chip(
                              onDeleted: () {
                                productViewModel.deleteFilterCategory(f);
                              },
                              label: Text(f.name),
                            ),
                          )
                          .toList(),
                      ActionChip(
                        label: const Text(
                          "Thêm nhóm khác",
                          style: TextStyle(color: Colors.white),
                        ),
                        avatar: Icon(Icons.add),
                        backgroundColor: Colors.green.shade300,
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductCategoryPage(
                                isSearchMode: true,
                                closeWhenDone: true,
                                selectedItems: productViewModel
                                    .filterProductCategories
                                    .map((f) => f.id)
                                    .toList(),
                              ),
                            ),
                          );

                          if (result != null) {
                            productViewModel.addFilterCategory(result);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              AppFilterPanel(
                title: const Text("Theo bảng giá"),
                isSelected: productViewModel.isFilterByPriceList,
                onSelectedChange: (value) =>
                    productViewModel.isFilterByPriceList = value,
                children: <Widget>[
                  DropdownButton<ProductPrice>(
                    hint: const Text("Chọn một bảng giá"),
                    items: productViewModel.productPriceList
                        ?.map(
                          (f) => DropdownMenuItem<ProductPrice>(
                            child: Text(f.name),
                            value: f,
                          ),
                        )
                        ?.toList(),
                    onChanged: (value) {
                      productViewModel.filterProductPrice = value;
                    },
                    value: productViewModel.filterProductPrice,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    if (keyWord != null && keyWord != "") {
      productViewModel.isBarcode = true;
    }
    productViewModel.keyword = keyWord;
    productViewModel.initCommand();

    productViewModel.dialogMessageController.listen((f) {
      registerDialogToView(context, f, scaffState: _scaffoldKey.currentState);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Load more
        if (productViewModel.isLoadingMore) {
          return;
        }
        productViewModel.loadMoreProductCommand();
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    productViewModel.notifyPropertyChangedController.listen((f) {
      setState(() {});
    });
    super.didChangeDependencies();
  }
}

class ProductTemplateGridItem extends StatelessWidget {
  const ProductTemplateGridItem({this.item, this.onPress, this.onLongPress});
  final ProductTemplate item;
  final VoidCallback onPress;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 300,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                height: 110,
                color: Colors.white,
                child: Image.network(item.imageUrl ?? ''),
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey.shade200,
              margin: const EdgeInsets.all(8),
            ),
            Text(
              item.nameGet ?? '',
              textAlign: TextAlign.center,
            ),
            Text(
              vietnameseCurrencyFormat(item.price) ?? '',
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(
              height: 3,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.deepPurple),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: AutoSizeText(
                  "Còn ${item.availableQuantity} | ${item.virtualQuantity} (DB)",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: onPress,
      onLongPress: onLongPress,
    );
  }
}
