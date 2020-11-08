import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/cart_product.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/pos_product_list_viewmodel.dart';
import 'package:tpos_mobile/helpers/app_helper.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PosProductListPage extends StatefulWidget {
  const PosProductListPage(this.positionCart, this.filterProduct);
  final String positionCart;
  final List<CartProduct> filterProduct;
  @override
  _PosProductListPageState createState() => _PosProductListPageState();
}

class _PosProductListPageState extends State<PosProductListPage> {
  final _vm = locator<PosProductListViewmodel>();
  bool isMultiSelect = false;
  final FocusNode _focusSearch = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_vm.countProductInCart() > 0) {
          return await confirmClosePage(context,
              title: S.current.close,
              message: S.current.posOfSale_confirmBackProduct);
        } else {
          Navigator.pop(context);
          return null;
        }
      },
      child: ViewBase<PosProductListViewmodel>(
          model: _vm,
          builder: (context, model, _) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Scaffold(
                key: _key,
                appBar: buildAppBar(context),
                endDrawer: buildFilterPanel(),
                body: Column(
                  children: <Widget>[
                    buildFilter(),
                    Expanded(
                        child: _vm.showListPr
                            ? ListView.separated(
                                padding: const EdgeInsets.only(top: 6),
                                separatorBuilder: (context, index) => Divider(
                                      color: Colors.grey[400],
                                      height: 2,
                                    ),
                                itemCount: _vm.products.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return showItem(_vm.products[index], index);
                                })
                            : buildListGridView()),
                    if (!isMultiSelect)
                      const SizedBox()
                    else
                      _buildButotnConfirm()
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget buildFilterPanel() {
    return AppFilterDrawerContainer(
      onRefresh: () {
        _vm.resetFilter();
      },
      closeWhenConfirm: true,
      onApply: () {
        _vm.handleFilter();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),

            /// Sắp xếp sản phẩm
            child: Text(
              S.current.sort,
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
              Text(S.current.posOfSale_default)
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                value: 2,
                groupValue: _vm.filterStack,
                onChanged: (value) {
                  _vm.changePositionStack(value);
                },
              ),
              Text(S.current.posOfSale_topSales)
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
              Text(S.current.posOfSale_byName)
            ],
          ),
        ],
      ),
    );
  }

  DropdownButton filterPriceDefault() => DropdownButton<String>(
      items: _vm.priceLists.map((item) {
        return DropdownMenuItem<String>(
          value: "${item.id}",
          child: Text(
            item.name ?? "",
            style: const TextStyle(fontSize: 15),
          ),
        );
      }).toList(),
      onChanged: (value) {
        FocusScope.of(context).requestFocus(FocusNode());
        _vm.filterPriceList(value);
      },
      value: _vm.valueFilterPrice,
      elevation: 2,
      style: TextStyle(color: Colors.grey[800], fontSize: 17),
      underline: const SizedBox());

  Widget buildFilter() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: const Color(0xFFEBEDEF), boxShadow: [
        BoxShadow(
            offset: const Offset(0, 1), blurRadius: 1, color: Colors.grey[400])
      ]),
      child: Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 2, right: 15.0),
        child: GestureDetector(
          onTap: () {
            _key.currentState.openEndDrawer();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const SizedBox(
                width: 12,
              ),
              Expanded(child: filterPriceDefault()),
              IconButton(
                onPressed: () {
                  _vm.changeShowProduct();
                },
                icon: _vm.showListPr
                    ? Icon(
                        FontAwesomeIcons.list,
                        color: Colors.grey[600],
                        size: 19,
                      )
                    : Icon(
                        FontAwesomeIcons.thLarge,
                        color: Colors.grey[600],
                        size: 19,
                      ),
              ),
              const SizedBox(
                width: 4,
              ),
              Badge(
                badgeColor: Colors.redAccent,
                badgeContent: Text(
                  "${_vm.countFilter()}",
                  style: const TextStyle(color: Colors.white),
                ),
                child: Icon(
                  Icons.filter_list,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchProduct() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(24)),
        height: 40,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 12,
            ),
            const Icon(
              Icons.search,
              color: Color(0xFF28A745),
            ),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: Center(
                child: Container(
                    height: 35,
                    margin: const EdgeInsets.only(top: 0),
                    child: Center(
                      child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            _vm.setKeyword(value);
                          },
                          focusNode: _focusSearch,
                          autofocus: _vm.checkFocus,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(0),
                              isDense: true,
                              hintText: S.current.search,
                              border: InputBorder.none)),
                    )),
              ),
            ),
            Visibility(
              visible: _searchController.text != "",
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 18,
                ),
                onPressed: () {
                  _searchController.text = "";
                  _vm.setKeyword("");
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () async {
            if (_vm.countProductInCart() > 0) {
              await confirmClosePage(context,
                      title: S.current.close,
                      message: S.current.posOfSale_confirmBackProduct)
                  .then((value) {
                if (value) {
                  Navigator.pop(context);
                }
              });
            } else {
              Navigator.pop(context);
            }
          },
          icon: Icon(
            Icons.close,
            color: Colors.grey[600],
          ),
        ),
        title: buildSearchProduct(),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: buildIconMultiSelect(),
          ),
          InkWell(
              onTap: () async {
                final String barcode =
                    await _vm.barcodeScanningProduct(context);
                if (barcode != null) {
                  _searchController.text = barcode;
                }
              },
              child: Image.asset("images/scan_barcode.png",
                  width: 28, height: 18, color: const Color(0xFF28A745))),
          const SizedBox(
            width: 12,
          )
        ]);
  }

  Widget buildIconMultiSelect() {
    return Center(
        child: InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          isMultiSelect = !isMultiSelect;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 1),
                  blurRadius: 1,
                  color: isMultiSelect ? Colors.green : Colors.grey[300]),
            ],
            border: Border.all(
                color: isMultiSelect ? Colors.white : Colors.grey[200])),
        width: 35,
        height: 35,
        child: Center(
          child: Container(
            child: Text(
              S.current.posOfSale_multiSelect,
              style: TextStyle(
                  fontSize: 10,
                  color: !isMultiSelect ? Colors.grey[700] : Colors.green),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ));
  }

  Widget showItem(CartProduct item, int index) {
    return InkWell(
      onTap: () async {
        print(item.id.toString() + "_" + item.factor.toString());
        if (!isMultiSelect) {
          _vm.removeAllProduct(index);
          _vm.incrementQtyProduct(item, index, widget.positionCart);
          await _vm.insertProductForCart(widget.positionCart);
          Navigator.pop(context);
        } else {
          _vm.incrementQtyProduct(item, index, widget.positionCart);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 6,
          top: 6,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                height: 60,
                width: 40,
                child: item.imageUrl == null || item.imageUrl == ""
                    ? Image.asset("images/no_image.png")
                    : Image.network(
                        item.imageUrl ?? "",
                      ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 6,
                  ),
                  Text("${item.nameGet} (${item.uOMName})"),
                  const SizedBox(
                    height: 6,
                  ),

                  /// Giá
                  Text(
                      "${S.current.posOfSale_price}: ${vietnameseCurrencyFormat(item.price)}"),
                  const SizedBox(
                    height: 6,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _vm.products[index].qty != 0 && isMultiSelect,
              child: Text(
                "${_vm.products[index].qty}",
                style: const TextStyle(
                    color: Colors.cyan,
                    fontSize: 19,
                    fontWeight: FontWeight.w500),
              ),
            ),
            if (!isMultiSelect)
              const SizedBox(
                width: 10,
              )
            else
              Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(4)),
                  child: _vm.products[index].qty == 0
                      ? IconButton(
                          icon: const Icon(
                            Icons.add,
                            color: Color(0xFF28A745),
                          ),
                          onPressed: () {
                            _vm.incrementQtyProduct(
                                item, index, widget.positionCart);
                          },
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.remove,
                            color: Color(0xFF28A745),
                          ),
                          onPressed: () {
                            _vm.deIncrementQtyProduct(item, index);
                          },
                        )),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButotnConfirm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 45,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 2),
                    blurRadius: 2,
                    color: Colors.grey[400])
              ],
              color: const Color(0xFF28A745),
              borderRadius: BorderRadius.circular(6)),
          child: FlatButton(
            onPressed: () async {
              await _vm.insertProductForCart(widget.positionCart);
              Navigator.pop(context);
            },
            child: Center(
              /// Thêm vào giỏ
              child: Text(S.current.posOfSale_addToCart,
                  style: const TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListGridView() {
    return GridView.builder(
        cacheExtent: 0.5,
        itemCount: _vm.products.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return showItemGridView(_vm.products[index], index);
        });
  }

  Widget showItemGridView(CartProduct item, int index) {
    return InkWell(
      onTap: () async {
        if (!isMultiSelect) {
          _vm.removeAllProduct(index);
          _vm.incrementQtyProduct(item, index, widget.positionCart);
          await _vm.insertProductForCart(widget.positionCart);
          Navigator.pop(context);
        } else {
          _vm.incrementQtyProduct(item, index, widget.positionCart);
        }
      },
      child: Stack(
        children: <Widget>[
          Card(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 110,
                      color: Colors.white,
                      child: item.imageUrl == null || item.imageUrl == ""
                          ? Image.asset("images/no_image.png")
                          : Image.network(item.imageUrl ?? ""),
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey.shade200,
                  margin: const EdgeInsets.all(8),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: !isMultiSelect
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            item.nameGet ?? "",
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            vietnameseCurrencyFormat(item.price),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    if (!isMultiSelect)
                      const SizedBox()
                    else
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(4)),
                        child: _vm.products[index].qty == 0
                            ? IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  color: Color(0xFF28A745),
                                ),
                                onPressed: () {
                                  _vm.incrementQtyProduct(
                                      item, index, widget.positionCart);
                                },
                              )
                            : IconButton(
                                icon: const Icon(
                                  Icons.remove,
                                  color: Color(0xFF28A745),
                                ),
                                onPressed: () {
                                  _vm.deIncrementQtyProduct(item, index);
                                },
                              ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                )
              ],
            ),
          )),
          Visibility(
            visible: _vm.products[index].qty != 0 && isMultiSelect,
            child: Positioned(
              top: 4,
              right: 10,
              child: Text(
                "${_vm.products[index].qty}",
                style: const TextStyle(
                    color: Colors.cyan,
                    fontSize: 19,
                    fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
//    _vm.checkFocus = true;
    await _vm.getProducts();
    _vm.products = widget.filterProduct;
    _vm.resetQtyProduct();
    await _vm.getPriceLists();
    await _vm.getPriceListById();
  }
}
