import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:random_color/random_color.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_panel.dart';
import 'package:tpos_mobile/feature_group/category/product_template/ui/add_edit/product_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/product_category_page.dart';
import 'package:tpos_mobile/helpers/barcode.dart';
import 'package:tpos_mobile/helpers/barcode_scan.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/category/viewmodel/product_search_viewmodel.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/new_facebook_post_comment_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/product_template_quick_add_edit_page.dart';

import 'package:tpos_mobile/helpers/helpers.dart';

import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';
import 'package:tpos_mobile/widgets/ModalWaitingWidget.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage(
      {this.onSelected,
      this.priceList,
      this.keyword,
      this.isPriceUnit = false});
  final ProductPrice priceList;
  final Function onSelected;
  final String keyword;
  final bool isPriceUnit;

  @override
  _ProductSearchPageState createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  final _vm = locator<ProductSearchViewModel>();
  final _keywordController = TextEditingController();
  final _keywordFocusNode = FocusNode();
  final _key = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    initData();
    super.initState();
  }

  /// Khởi tạo lại dữ liệu ban đầu cho sản phẩm
  Future initData() async {
    _keywordController.text = widget.keyword ?? "";
    _vm.filterStack = 0;
    _vm.init(priceList: widget.priceList);
    await _vm.initData();
    _keywordController.text = widget.keyword ?? "";
    if (widget.keyword != null) {
      _vm.keywordSink.add(_keywordController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return ScopedModel<ProductSearchViewModel>(
      model: _vm,
      child: ScopedModelDescendant<ProductSearchViewModel>(
        builder: (context, child, model) => Scaffold(
          key: _key,
          backgroundColor: Colors.grey.shade200,
          endDrawer: _buildFilterPanel(),
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.grey),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: TextField(
              controller: _keywordController,
              focusNode: _keywordFocusNode,
              // ignore: avoid_bool_literals_in_conditional_expressions
              autofocus: _vm.isListMode ? true : false,
              onChanged: (value) {
                _vm.keywordSink.add(_keywordController.text.trim());
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "${S.current.search}...",
                suffixIcon: InkWell(
                  child: Icon(
                    Icons.cancel,
                    color: Colors.grey.shade500,
                    size: 17,
                  ),
                  onTap: () {
                    WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _keywordController.clear());
                    _vm.keywordSink.add("");
                  },
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Colors.green,
                ),
                onPressed: () async {
                  final bool result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductTemplateAddEditPage(),
                    ),
                  );

                  if (result == true) {
                    await _vm.refreshData();
                    //_keywordController.text = addedProduct.name;
                    _vm.keywordSink.add(_keywordController.text.trim());
                  }
                },
              ),
              IconButton(
                color: _theme.primaryColor,
                icon: const SvgIcon(
                  SvgIcon.barcode,
                  size: 22,
                  color: Colors.black87,
                ),
                onPressed: () async {
                  // final result = await scanBarcode();
                  final result = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return BarcodeScan();
                  }));
                  if (result != null) {
                    if (result != "") {
                      _keywordController.text = result;
                      _vm.keywordSink.add(_keywordController.text.trim());
                    }
                  }
                },
              )
            ],
          ),
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return ModalWaitingWidget(
        isBusyStream: _vm.isBusyController,
        initBusy: false,
        child: _buildLayout(context));
  }

  Widget _buildLayout(BuildContext context) {
    const _style = TextStyle(fontSize: 14);
    return Column(
      children: <Widget>[
        //TODO lọc theo nhóm
        Container(
          height: 40,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade500, width: 0.5)),
          child: Row(
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                          child: InkWell(
                        onTap: () {
                          FocusScope.of(context)?.requestFocus(FocusNode());
                          _key.currentState.openEndDrawer();
                        },
                        child: Text(
                          "${S.current.priceList}: ${_vm.priceListName}",
                          style: _style,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )),
                      const Icon(Icons.arrow_drop_down),
                      const SizedBox(
                        width: 6,
                      ),
                      Visibility(
                        visible: false,
                        child: Flexible(
                            child: InkWell(
                          onTap: () async {
                            FocusScope.of(context)?.requestFocus(FocusNode());
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProductCategoryPage()));
                            if (result != null) {
                              _vm.productCategory = result;
                              // _vm.onSearchWithProductCategory(
                              //     _vm.productCategory.id);
                            }
                          },
                          child: Text(
                            "${S.current.group}: ${_vm.productCategory.name ?? "<${S.current.selectGroup}>"}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                      ),
                      const Visibility(
                          visible: false, child: Icon(Icons.arrow_drop_down)),
                    ],
                  ),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: MyMaterialButton(
                  color: Colors.transparent,
                  content: const Icon(
                    Icons.grid_on,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    _vm.isListMode = !_vm.isListMode;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: MyMaterialButton(
                  color: Colors.transparent,
                  content: const Icon(
                    Icons.filter_alt_outlined,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    FocusScope.of(context)?.requestFocus(FocusNode());
                    _key.currentState.openEndDrawer();
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _vm.isListMode ? _showListProduct() : _showGridProduct(),
        ),
      ],
    );
  }

  Widget _buildFilterPanel() {
    return AppFilterDrawerContainer(
      onRefresh: () {
        _vm.resetFilter();
      },
      closeWhenConfirm: true,
      onApply: () {
        _keywordController.text = "";
        _vm.handleFilter();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),

            /// Sắp xếp sản phẩm
            child: Text(
              S.current.productArrangements,
              style: const TextStyle(fontSize: 18, color: Color(0xFF28A745)),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: <Widget>[
              Radio(
                value: 1,
                groupValue: _vm.filterStack,
                onChanged: (value) {
                  _vm.changePositionStack(value);
                },
              ),
              Expanded(child: Text(S.current.posOfSale_topSales)),
              Radio(
                value: 5,
                groupValue: _vm.filterStack,
                onChanged: (value) {
                  _vm.changePositionStack(value);
                },
              ),
              Expanded(child: Text(S.current.oldest)),
              // Radio(
              //   value: 2,
              //   groupValue: _vm.filterStack,
              //   onChanged: (value) {
              //     _vm.changePositionStack(value);
              //   },
              // ),
              // const Expanded(child: Text("Theo mã"))
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                value: 3,
                groupValue: _vm.filterStack,
                onChanged: (value) {
                  _vm.changePositionStack(value);
                },
              ),

              /// Theo tên
              Expanded(child: Text(S.current.filterByName)),
              Radio(
                value: 4,
                groupValue: _vm.filterStack,
                onChanged: (value) {
                  _vm.changePositionStack(value);
                },
              ),
              Expanded(child: Text(S.current.latest))
            ],
          ),
          Visibility(
            visible: false,
            child: AppFilterPanel(
              isEnable: true,
              isSelected: true,
              onSelectedChange: (bool value) {
                // _filter.isFilterByCompany = value;
                // handleChangeFilter();
              },
              title: Text(S.current.menu_productGroup),
              children: <Widget>[
                Container(
                  height: 45,
                  margin: const EdgeInsets.only(left: 32, right: 8, bottom: 12),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.grey[400]))),
                  child: InkWell(
                    onTap: () async {},
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(S.current.menu_productGroup,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 15)),
                        ),
                        Visibility(
                          visible: true,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 20,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: AppFilterPanel(
              isEnable: true,
              isSelected: true,
              onSelectedChange: (bool value) {
                // _filter.isFilterByCompany = value;
                // handleChangeFilter();
              },
              title: Text(S.current.priceList),
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 32, right: 8, bottom: 12),
                  padding: const EdgeInsets.only(bottom: 12),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.grey[400]))),
                  child: Text(_vm.priceListName ?? S.current.priceList,
                      style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _showListProduct() {
    return RefreshIndicator(
      onRefresh: () async {
        _vm.filterStack = 0;
        await _vm.refreshData();
        return true;
      },
      child: Scrollbar(
        child: ListView.separated(
          padding: const EdgeInsets.only(left: 0, right: 10),
          itemCount: _vm.products?.length ?? 0,
          separatorBuilder: (context, index) {
            return const Divider(
              height: 1,
              indent: 50,
            );
          },
          itemBuilder: (context, position) {
            return _showLineItem(_vm.products[position], context);
          },
        ),
      ),
    );
  }

  Widget _showLineItem(Product item, BuildContext context) {
    const defaultFontStyle = TextStyle(fontSize: 14);
    return Material(
      color: Colors.white,
      child: ListTile(
        contentPadding:
            const EdgeInsets.only(left: 12, right: 8, top: 0, bottom: 0),
        leading: SizedBox.fromSize(
          size: const Size(40, 40),
          child: Builder(builder: (ctx) {
            if (item.imageUrl != null && item.imageUrl != "") {
              return Image.network(item.imageUrl);
            } else {
              return CircleAvatar(
                backgroundColor: RandomColor().randomColor(),
                child: Text(
                  item.name.substring(0, 1),
                ),
              );
            }
          }),
        ),
        title: Wrap(
          children: <Widget>[
            Text(
              item.nameGet ?? "",
              style: defaultFontStyle,
            ),
//          Text(
//            " [${item.defaultCode ?? ""}] ",
//            style: defaultFontStyle,
//          ),
            Text(' (${item.uOMName ?? ""})',
                maxLines: null,
                softWrap: true,
                style: defaultFontStyle.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.blue)),
            const Text(""),
          ],
        ),
        trailing: Text(
          vietnameseCurrencyFormat(
              widget.isPriceUnit ? item.purchasePrice : item.price),
          style: const TextStyle(color: Colors.red),
        ),
        subtitle: Text(
            "${S.current.menu_inventoryReport}: ${item.inventory} | ${S.current.forecast}: ${item.focastInventory}"),
        onTap: () {
          if (widget.onSelected != null) {
            widget.onSelected(item);
          }
          Navigator.pop(context, item);
        },
      ),
    );
  }

  Widget _showGridProduct() {
    return RefreshIndicator(
      onRefresh: () async {
        await _vm.refreshData();
        return true;
      },
      child: Scrollbar(
        child: GridView.builder(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7),
          itemBuilder: (context, index) => ProductGridItem(
            isPriceUnit: widget.isPriceUnit,
            item: _vm.products[index],
            onPress: () {
              if (widget.onSelected != null)
                widget.onSelected(_vm.products[index]);

              Navigator.pop(context, _vm.products[index]);
            },
          ),
          itemCount: _vm.productCount,
        ),
      ),
    );
  }
}

class ProductGridItem extends StatelessWidget {
  const ProductGridItem(
      {this.item, this.onPress, this.onLongPress, this.isPriceUnit});
  final Product item;
  final VoidCallback onPress;
  final VoidCallback onLongPress;
  final bool isPriceUnit;

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
                child: Image.network(item.imageUrl ?? ""),
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey.shade200,
              margin: const EdgeInsets.all(8),
            ),
            Text(
              item.nameGet ?? "",
              textAlign: TextAlign.center,
            ),
            Text(
              vietnameseCurrencyFormat(
                  isPriceUnit ? item.purchasePrice : item.price),
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
                  "${S.current.remain} ${item.inventory} | ${item.focastInventory} (DB)",
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                  maxLines: 1,
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
