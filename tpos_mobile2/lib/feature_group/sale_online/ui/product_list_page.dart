/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/product_quick_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/product_template_quick_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/product_search_viewmodel.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/ProductTemplate.dart';
import 'package:tpos_mobile/src/tpos_apis/models/base_list_order_by_type.dart';
import 'package:tpos_mobile/src/tpos_apis/models/product.dart';

import 'package:tpos_mobile/widgets/custom_widget.dart';
import 'package:tpos_mobile/widgets/listview_data_error_info_widget.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage(
      {this.closeWhenDone = true,
      this.isSearchMode = true,
      this.onSelectedCallback,
      this.keyWord = ""});
  final bool closeWhenDone;
  final bool isSearchMode;
  final Function(Product) onSelectedCallback;
  final String keyWord;

  @override
  _ProductListPageState createState() => _ProductListPageState(
      closeWhenDone: closeWhenDone,
      isSearchMode: isSearchMode,
      onSelectedCallback: onSelectedCallback,
      keyWord: keyWord);
}

class _ProductListPageState extends State<ProductListPage> {
  _ProductListPageState(
      {this.closeWhenDone,
      this.isSearchMode = true,
      this.onSelectedCallback,
      this.keyWord});
  bool closeWhenDone;
  bool isSearchMode;
  String keyWord;
  Function(Product) onSelectedCallback;

  final TextEditingController _keywordController = TextEditingController();
  ProductSearchViewModel productViewModel = ProductSearchViewModel();
  final ISettingService _settingService = locator<ISettingService>();
  @override
  void dispose() {
    super.dispose();
    productViewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: buildAppBar(context),
        body: ViewBaseWidget(
          isBusyStream: productViewModel.isBusyController,
          child: Column(
            children: <Widget>[
              _showFilterPanel(),
              Expanded(
                child: _settingService.isProductSearchViewList
                    ? _showListProduct()
                    : _showListProductSquare(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showListProduct() {
    return StreamBuilder<List<Product>>(
      stream: productViewModel.productsStream,
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          return ListViewDataErrorInfoWidget(
            errorMessage: "Đã xảy ra lỗi!. \n" + snapshot.error.toString(),
          );
        }

        if (snapshot.data == null) {
          return const Center(
            child: Text(""),
          );
        }

        return Scrollbar(
          child: ListView.separated(
            padding: const EdgeInsets.only(left: 12, right: 12),
            itemCount: (snapshot.data.length ?? 0) + 1,
            separatorBuilder: (context, index) {
              return const Divider(
                height: 1,
              );
            },
            itemBuilder: (context, position) {
              if (position == snapshot.data.length) {
                if (productViewModel.canLoadMore) {
                  return OutlineButton(
                    child: Text(
                      "Tải thêm...",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      productViewModel.loadMoreProductCommand();
                    },
                  );
                } else {
                  return const SizedBox();
                }
              }
              return _showLineItem(snapshot.data[position]);
            },
          ),
        );
      },
    );
  }

  Widget _showListProductSquare() {
    return StreamBuilder<List<Product>>(
      stream: productViewModel.productsStream,
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          return ListViewDataErrorInfoWidget(
            errorMessage: "Đã xảy ra lỗi!. \n" + snapshot.error.toString(),
          );
        }

        if (snapshot.data == null) {
          return const Center(
            child: Text(""),
          );
        }

        return Scrollbar(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            padding: const EdgeInsets.only(left: 5, right: 5),
            itemCount: snapshot.data.length,
            itemBuilder: (context, position) {
              return Padding(
                padding: const EdgeInsets.all(5),
                child: RaisedButton(
                  color: Colors.green.shade100,
                  textColor: Colors.blueGrey,
                  padding: const EdgeInsets.all(5),
                  child: Center(
                    child: Text(
                      snapshot.data[position].name,
                      style: const TextStyle(fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (isSearchMode) {
                      if (onSelectedCallback != null)
                        onSelectedCallback(snapshot.data[position]);
                      if (closeWhenDone) {
                        Navigator.pop(context, snapshot.data[position]);
                      }
                    } else {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          final ProductQuickAddEditPage
                              productQuickAddEditPage = ProductQuickAddEditPage(
                            productId: snapshot.data[position].id,
                          );
                          return productQuickAddEditPage;
                        }),
                      );
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Giao diện search Product
  Widget _buildSearch() {
    return Container(
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
          Icon(
            Icons.search,
            color: const Color(0xFF28A745),
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
                      decoration: InputDecoration(
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
              icon: Icon(
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
              try {
                final barcode = await BarcodeScanner.scan();
                if (barcode != null) {
                  _keywordController.text = barcode.rawContent;
                  setState(() {
                    productViewModel.keyword = barcode.rawContent;
                  });
                }
              } on PlatformException catch (e) {
                if (e.code == BarcodeScanner.cameraAccessDenied) {
                  showError(
                      context: context,
                      title: "Chưa cấp quyền camera",
                      message:
                          "Vui lòng vào cài đặt cho phép ứng dụng truy cập camera");
                } else {
                  showError(
                      context: context,
                      title: "Chưa quét được mã vạch",
                      message: "Vui lòng thử lại");
                }
              } on FormatException {
                showError(
                    context: context,
                    title: "Chưa quét được mã vạch",
                    message: "Vui lòng thử lại");
              } catch (e) {
                showError(
                    context: context,
                    title: "Chưa quét được mã vạch",
                    message: "Vui lòng thử lại");
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
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }),
//      title: Padding(
//        padding: const EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 8),
//        child: AppbarSearchWidget(
//          keyword: productViewModel.keyword,
//          autoFocus: isSearchMode,
//          onTextChange: (text) {
//            productViewModel.keywordChangedCommand(text);
//          },
//        ),
//      ),
      title: _buildSearch(),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ProductTemplate addProduct = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => const ProductTemplateQuickAddEditPage(
                          closeWhenDone: true,
                        )));

            if (addProduct != null) {
              productViewModel.keywordChangedCommand(addProduct.name);
            }

//            if (addProduct != null) {
//              productViewModel.addNewProductCommand( Product(
//                id: addProduct.id,
//                name: addProduct.name,
//                nameGet: addProduct.nameGet,
//                nameNoSign: addProduct.nameNoSign,
//                price: addProduct.price,
//                oldPrice: addProduct.oldPrice,
//                uOMId: addProduct.uOMId,
//                weight: addProduct.weight,
//              ));
//            }
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
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _showLineItem(Product item) {
    const defaultFontStyle = TextStyle(fontSize: 14);
    return ListTile(
      contentPadding:
          const EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 0),
      //leading: Image.asset("images/no_image.png"),
      title: Wrap(
        children: <Widget>[
          Text(
            item.nameGet ?? '',
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
        "${vietnameseCurrencyFormat(item.price) ?? 0}",
        style: TextStyle(color: Colors.red),
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
              final ProductQuickAddEditPage productQuickAddEditPage =
                  ProductQuickAddEditPage(
                productId: item.id,
              );
              return productQuickAddEditPage;
            }),
          );
        }
      },
    );
  }

//  Widget _showSquarePictureItem(Product item) {
//    return RaisedButton(
//      child: Text(""),
//      onPressed: () {},
//    );
//  }

  @override
  void initState() {
    if (keyWord != null && keyWord != "") {
      productViewModel.isBarcode = true;
    }
    productViewModel.keyword = keyWord;
    productViewModel.initCommand();
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
