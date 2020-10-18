import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:random_color/random_color.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/category/viewmodel/product_search_viewmodel.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/new_facebook_post_comment_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/product_template_quick_add_edit_page.dart';

import 'package:tpos_mobile/helpers/helpers.dart';


import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';
import 'package:tpos_mobile/widgets/ModalWaitingWidget.dart';

class ProductSearchPage extends StatefulWidget {
  final ProductPrice priceList;
  final Function onSelected;
  final String keyword;
  final bool isPriceUnit;
  ProductSearchPage(
      {this.onSelected,
      this.priceList,
      this.keyword,
      this.isPriceUnit = false});
  @override
  _ProductSearchPageState createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  final _vm = locator<ProductSearchViewModel>();
  final _keywordController = TextEditingController();
  final _keywordFocusNode = FocusNode();
  @override
  void initState() {
    _vm.init(priceList: widget.priceList);
    _keywordController.addListener(() {
      _vm.keywordSink.add(_keywordController.text.trim());
      print(_keywordController.text.trim());
    });

    _vm.initData();

    _keywordController.text = widget.keyword ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    return ScopedModel<ProductSearchViewModel>(
      model: _vm,
      child: ScopedModelDescendant<ProductSearchViewModel>(
        builder: (context, child, model) => Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.grey),
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: TextField(
              controller: _keywordController,
              focusNode: _keywordFocusNode,
              autofocus: _vm.isListMode ? true : false,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Tìm kiếm...",
                suffixIcon: InkWell(
                  child: Icon(
                    Icons.cancel,
                    color: Colors.grey.shade500,
                    size: 17,
                  ),
                  onTap: () {
                    WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _keywordController.clear());
                  },
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.green,
                ),
                onPressed: () async {
                  ProductTemplate addedProduct = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductTemplateQuickAddEditPage(
                                closeWhenDone: true,
                              )));

                  if (addedProduct != null) {
                    _keywordController.text = addedProduct.name;
                  }
                },
              ),
              IconButton(
                color: _theme.primaryColor,
                icon: SvgPicture.asset(
                  "images/barcode_scan.svg",
                  width: 25,
                  height: 25,
                ),
                onPressed: () async {
                  var result = await scanBarcode();
                  if (result.isError) {}
                  _keywordController.text = result.result;
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
    var _style = TextStyle(fontSize: 14);
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
                      Expanded(
                          child: Text(
                        "Bảng giá: ${_vm.priceListName}",
                        style: _style,
                      )),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: MyMaterialButton(
                  color: Colors.transparent,
                  content: Icon(
                    Icons.grid_on,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    _vm.isListMode = !_vm.isListMode;
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

  Widget _showListProduct() {
    return Scrollbar(
      child: ListView.separated(
        padding: EdgeInsets.only(left: 0, right: 10),
        itemCount: (_vm.products?.length ?? 0),
        separatorBuilder: (context, index) {
          return Divider(
            height: 1,
            indent: 50,
          );
        },
        itemBuilder: (context, position) {
          return _showLineItem(_vm.products[position], context);
        },
      ),
    );
  }

  Widget _showLineItem(Product item, BuildContext context) {
    final defaultFontStyle = new TextStyle(fontSize: 14);
    return Material(
      color: Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 12, right: 8, top: 0, bottom: 0),
        leading: SizedBox.fromSize(
          size: Size(40, 40),
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
              "${item.nameGet}",
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
            Text(""),
          ],
        ),
        trailing: Text(
          "${vietnameseCurrencyFormat(widget.isPriceUnit ? item.purchasePrice : item.price)}",
          style: TextStyle(color: Colors.red),
        ),
        subtitle:
            Text("Tồn: ${item.inventory} | Dự báo: ${item.focastInventory}"),
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
    return Scrollbar(
      child: GridView.builder(
        padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
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
    );
  }
}

class ProductGridItem extends StatelessWidget {
  final Product item;
  final VoidCallback onPress;
  final VoidCallback onLongPress;
  final bool isPriceUnit;
  ProductGridItem(
      {this.item, this.onPress, this.onLongPress, this.isPriceUnit});
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
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                height: 110,
                color: Colors.white,
                child: Image.network("${item.imageUrl}"),
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey.shade200,
              margin: EdgeInsets.all(8),
            ),
            Text(
              "${item.nameGet}",
              textAlign: TextAlign.center,
            ),
            Text(
              "${vietnameseCurrencyFormat(isPriceUnit ? item.purchasePrice : item.price)}",
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(
              height: 3,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.deepPurple),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: AutoSizeText(
                  "Còn ${item.inventory} | ${item.focastInventory} (DB)",
                  style: TextStyle(color: Colors.white),
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
