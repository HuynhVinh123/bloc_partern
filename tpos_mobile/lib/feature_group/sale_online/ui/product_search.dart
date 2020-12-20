import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logging/logging.dart';
import 'package:random_color/random_color.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/helpers/barcode_scan.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/product_template_quick_add_edit_page.dart';
import 'package:tpos_mobile/helpers/helpers.dart';

import 'package:tpos_mobile/src/tpos_apis/services/object_apis/product_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile/widgets/ModalWaitingWidget.dart';
import 'package:tpos_mobile/widgets/listview_data_error_info_widget.dart';

class ProductSearchDelegate extends SearchDelegate {
  ProductSearchDelegate(
      {ProductSearchViewModel vm, ProductPrice priceList, String keyword}) {
    _vm = vm ?? locator<ProductSearchViewModel>();
    _vm.setPriceList(priceList);
    initQuery = keyword;

    Timer(const Duration(seconds: 1), () {
      query = keyword;
    });
    print(query);
  }
  Function(Product) onSelected;
  ProductSearchViewModel _vm;
  String lastQuery = "";
  String initQuery;

  @override
  List<Widget> buildActions(BuildContext context) {
    final _theme = Theme.of(context);
    return [
      IconButton(
        icon: Icon(
          Icons.cancel,
          color: Colors.black54,
        ),
        onPressed: () {
          query = "";
        },
      ),
      IconButton(
        icon: Icon(
          Icons.add,
          color: _theme.primaryColor,
        ),
        onPressed: () async {
          final ProductTemplate addedProduct = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ProductTemplateQuickAddEditPage(
                        closeWhenDone: true,
                      )));

          if (addedProduct != null) {
            query = addedProduct.name;
          }
        },
      ),
      IconButton(
        color: _theme.primaryColor,
        icon: const SvgIcon(
          SvgIcon.barcode,
          size: 25,
        ),
        onPressed: () async {
          // final result = await scanBarcode();
          final result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) {
            return BarcodeScan();
          }));
          if (result != null) {
            query = result;
          }
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query != lastQuery) {
      _vm._keywordSubject.add(query);
      lastQuery = query;
    }

    return _buildLayout(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _vm._keywordSubject.add(query);
    return ModalWaitingWidget(
      isBusyStream: _vm.isBusyController,
      initBusy: false,
      child: _buildLayout(context),
    );
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
//              Expanded(
//                child: FlatButton(
//                  child: Row(
//                    mainAxisSize: MainAxisSize.max,
//                    children: <Widget>[
//                      Expanded(
//                          child: Text(
//                        "${_vm.selectProductCategory?.name ?? "Chọn nhóm"}",
//                        style: _style,
//                      )),
//                      Icon(Icons.arrow_drop_down)
//                    ],
//                  ),
//                  onPressed: () async {
//                    ProductCategory cat = await Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => ProductCategoryPage(
//                          closeWhenDone: true,
//                          isSearchMode: true,
//                        ),
//                      ),
//                    );
//
//                    _vm.selectProductCategory = cat;
//                  },
//                ),
//              ),
//              Container(
//                margin: EdgeInsets.only(left: 3, right: 3, top: 3, bottom: 3),
//                width: 1,
//                color: Colors.grey,
//              ),
              Expanded(
                child: FlatButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        "Bảng giá: ${_vm.priceList?.name ?? "Giá cố định"}",
                        style: _style,
                      )),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                  onPressed: () {},
                ),
              ),

              OutlineButton(
                child: Icon(Icons.format_list_bulleted),
                onPressed: () {},
              ),
//              Container(
//                margin: EdgeInsets.only(left: 3, right: 3, top: 3, bottom: 3),
//                width: 1,
//                color: Colors.grey,
//              ),
//              Expanded(
//                child: FlatButton(
//                  child: Row(
//                    mainAxisSize: MainAxisSize.max,
//                    children: <Widget>[
//                      Expanded(
//                          child: Text(
//                        "Nhóm",df
//                        style: _style,
//                      )),
//                      Icon(Icons.arrow_drop_down)
//                    ],
//                  ),
//                ),
//              ),
            ],
          ),
        ),
        Expanded(
          child: _showListProduct(),
        ),
      ],
    );
  }

  Widget _showLineItem(Product item, BuildContext context) {
    const defaultFontStyle = TextStyle(fontSize: 14);
    return ListTile(
      contentPadding:
          const EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 0),
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
        vietnameseCurrencyFormat(item.price) ?? '',
        style: TextStyle(color: Colors.red),
      ),
      subtitle:
          Text("Tồn: ${item.inventory} | Dự báo: ${item.focastInventory}"),
      onTap: () {
        if (onSelected != null) {
          onSelected(item);
        }
        close(context, item);
        _vm.dispose();
      },
    );
  }

//  Widget _showGridItem(Product item, BuildContext context) {}

  Widget _showListProduct() {
    return StreamBuilder<List<Product>>(
      stream: _vm.productsStream,
      initialData: null,
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
            padding: const EdgeInsets.only(left: 10, right: 10),
            itemCount: snapshot.data.length ?? 0,
            separatorBuilder: (context, index) {
              return const Divider(
                height: 1,
                indent: 50,
              );
            },
            itemBuilder: (context, position) {
              return _showLineItem(snapshot.data[position], context);
            },
          ),
        );
      },
    );
  }

//  @override
//  ThemeData appBarTheme(BuildContext context) {
//    var _theme = Theme.of(context);
//
//    return ThemeData(
//        backgroundColor: _theme.primaryColor,
//        primaryColor: _theme.primaryColor,
//        accentColor: Colors.white,
//        primaryTextTheme: TextTheme(caption: TextStyle(color: Colors.white)),
//        iconTheme: IconThemeData(color: Colors.white));
//  }
}

class ProductSearchViewModel extends ViewModel {
  ProductSearchViewModel({ITposApiService tposApi, ProductApi productApi}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _productApi = productApi ?? locator<ProductApi>();

    _keywordSubject
        .debounceTime(const Duration(milliseconds: 500))
        .listen((key) {
      _search(key);
    });

    onStateAdd(false);
  }
  ITposApiService _tposApi;
  ProductApi _productApi;
  final Logger _log = Logger("ProductSearchViewModel");

  final String _keyword = "";
  String get keyword => _keyword;
  final int _lastSkip = 0;
  final int _maxResult = 0;
  double scrollOffset = 0;
  ProductPrice priceList;
  Map<String, dynamic> _priceListMap;
  List<Product> _products;

  ProductCategory _selectProductCategory;
  ProductCategory get selectProductCategory => _selectProductCategory;
  set selectProductCategory(ProductCategory value) {
    _selectProductCategory = value;
    onPropertyChanged("");
  }

  Future setPriceList(ProductPrice priceList) async {
    try {
      this.priceList = priceList;
      if (priceList == null) {
        return;
      }
      _priceListMap = await _tposApi.getPriceListItems(priceList?.id);
    } catch (e, s) {
      _log.severe("get price list", e, s);
    }
  }

  Future loadInventory() async {
    try {
      inventories = await _tposApi.getProductInventory();
    } catch (e) {
      print(e);
    }
  }

  bool get canLoadMore {
    return (_lastSkip ?? 0) < (_maxResult ?? 0);
  }

  Map<String, dynamic> inventories;

  final BehaviorSubject<List<Product>> _productsSubject =
      BehaviorSubject<List<Product>>();

  final _categorySubject = BehaviorSubject<List<ProductCategory>>();

  Stream<List<Product>> get productsStream => _productsSubject.stream;
  Stream<List<ProductCategory>> get categorySubject => _categorySubject.stream;
  final BehaviorSubject<String> _keywordSubject = BehaviorSubject<String>();

  StreamSubscription _searchSub;
  Future _search(String key) async {
    final String tempKey =
        StringUtils.removeVietnameseMark(key ?? "").toLowerCase();
    onStateAdd(true);
    try {
      _searchSub?.cancel();
      _searchSub =
          _productApi.productSearch(tempKey, top: 100).asStream().listen(
        (result) {
          if (_productsSubject.isClosed == false) {
            if (result.error) {
              _productsSubject.addError(result.message);
            }

            //if (result.keyword == key) {
            _products = result.result;
            // Map price list

            // ignore: avoid_function_literals_in_foreach_calls
            _products.forEach((f) {
              if (_priceListMap != null) {
                f.price = _priceListMap["${f.id}_${f.uOMId}"] ?? f.price;
              }

              if (inventories != null) {
                f.inventory = inventories[f.id.toString()] != null
                    ? inventories[f.id.toString()]["QtyAvailable"]?.toDouble()
                    : 0;
                f.focastInventory = inventories[f.id.toString()] != null
                    ? inventories[f.id.toString()]["VirtualAvailable"]
                        ?.toDouble()
                    : 0;
              }
            });
            _productsSubject.add(_products);
            onStateAdd(false);
            //}
          }
        },
      )..onError((e, s) {
              onStateAdd(false);
              _log.severe("find product error", e, s);
              onDialogMessageAdd(OldDialogMessage.error("", "", error: e));
              _productsSubject.addError(e, s);
            });
    } catch (e, s) {
      _productsSubject.addError(e, s);
      _log.severe("_search", e, s);
      onStateAdd(false);
    }
  }
}
