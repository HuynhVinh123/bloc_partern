import 'dart:async';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/cart_product.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/payment.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/price_list.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/feature_group/pos_order/sqlite_database/database_function.dart';
import 'package:tpos_mobile/feature_group/pos_order/sqlite_database/database_helper.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:flutter/services.dart';

class PosProductListViewmodel extends ViewModelBase {
  PosProductListViewmodel(
      {IPosTposApi tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<IPosTposApi>();
    _dialog = dialogService ?? locator<DialogService>();
    _dbFunction = dialogService ?? locator<IDatabaseFunction>();

    _keywordController
        .debounceTime(const Duration(milliseconds: 500))
        .listen((keyword) {
      searchProduct();
    });
  }

  DialogService _dialog;
  IPosTposApi _tposApi;
  IDatabaseFunction _dbFunction;

  List<bool> checkSelectProduct;
  bool checkFocus = true;
  bool showListPr = true;
  int filterStack = 1;
  int countProduct = 0;
  String valueFilterPrice = "";
  String barcode = "";
  final dbHelper = DatabaseHelper.instance;

  PriceList _priceList = PriceList();
  final List<Lines> _productCarts = [];
  List<dynamic> _filterPrices = [];

  List<CartProduct> _searchProducts = [];

  List<PriceList> _priceLists = [];
  List<PriceList> get priceLists => _priceLists;
  set priceLists(List<PriceList> value) {
    _priceLists = value;
    notifyListeners();
  }

  List<CartProduct> _products = [];
  List<CartProduct> get products => _products;
  set products(List<CartProduct> value) {
    _products = value;
    notifyListeners();
  }

  List<dynamic> get filterPrices => _filterPrices;
  set filterPrices(List<dynamic> value) {
    _filterPrices = value;
    notifyListeners();
  }

  PriceList get priceList => _priceList;
  set priceList(PriceList value) {
    _priceList = value;
    notifyListeners();
  }

  final BehaviorSubject<String> _keywordController = BehaviorSubject();
  String _keyword = "";
  String get keyword => _keyword;

  Future<void> setKeyword(String value) async {
    _keyword = value;
    _keywordController.add(value);
    //notifyListeners();
  }

  Future<void> getPriceLists() async {
    setState(true);
    priceLists = await _dbFunction.queryGetPriceLists();
    valueFilterPrice = priceLists[0].id.toString();
  }

  Future<void> getProducts() async {
    setState(true);
    try {
      products = await _dbFunction.queryProductAllRows();
      checkSelectProduct = List(products.length);
      _searchProducts = products;
      setState(false);
    } catch (e) {
      setState(false);
    }
  }

  void searchProduct() {
    final List<CartProduct> findProduct = [];
    setState(true);
    if (_keyword == "") {
      products = _searchProducts;
    } else {
      for (var i = 0; i < _searchProducts.length; i++) {
        if (StringUtils.removeVietnameseMark(_searchProducts[i].name)
            .toLowerCase()
            .contains(StringUtils.removeVietnameseMark(_keyword.toLowerCase()))) {
          findProduct.add(_searchProducts[i]);
        }
      }
      products = findProduct;
    }
    setState(false);
  }

//  Future<void> insertProductForCart(String position) async {
//    for (var i = 0; i < _productCarts.length; i++) {
//      List<Lines> lstProduct = await _dbFuction.queryGetProductWithID(
//          position, _productCarts[i].productId);
//      if (lstProduct.length == 0) {
//        await _dbFuction.insertProductCart(_productCarts[i]);
//      } else {
//        _productCarts[i].id = lstProduct[0].id;
//        _productCarts[i].qty = _productCarts[i].qty + lstProduct[0].qty;
//        await _dbFuction.updateProductCart(_productCarts[i]);
//      }
//    }
//  }

  Future<void> insertProductForCart(String position) async {
    for (var i = 0; i < _productCarts.length; i++) {
      final List<Lines> lstProduct = await _dbFunction.queryGetProductWithID(
          position, _productCarts[i].productId);
      if (lstProduct.isEmpty) {
        await _dbFunction.insertProductCart(_productCarts[i]);
      } else {
        bool checkSameMoney = false;
        int positionUpdate = 0;
        for (var j = 0; j < lstProduct.length; j++) {
          if (lstProduct[j].priceUnit == _productCarts[i].priceUnit) {
            checkSameMoney = true;
            positionUpdate = j;
          }
        }
        if (checkSameMoney) {
          _productCarts[i].id = lstProduct[positionUpdate].id;
          _productCarts[i].qty =
              _productCarts[i].qty + lstProduct[positionUpdate].qty;
          await _dbFunction.updateProductCart(_productCarts[i]);
        } else {
          await _dbFunction.insertProductCart(_productCarts[i]);
        }
      }
    }
  }

  Future<void> filterListPrice(int id) async {
    setState(true, message: "Đang tải..");
    try {
      final result = await _tposApi.exeListPrice("$id");
      if (result != null) {
        filterPrices = result;
      }
//      setState(false);
    } on SocketException catch (e, s) {
      logger.error("SocketException", e, s);
      await getPriceListById();
      setState(false);
    } catch (e, s) {
      logger.error("handleListPriceFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getPriceListById() async {
    setState(true);
    try {
      final config = await _dbFunction.queryGetPosConfig();
      final result =
          await _dbFunction.queryGetPriceListById(config[0].priceListId);
      print(result[0].id.toString() + " - " + result[0].name);
      priceList = result[0];
      valueFilterPrice = result[0].id.toString();
      filterPrices = await _dbFunction.queryGetProductPriceList();
//      filterPrice(false);
    } catch (e) {
      setState(false);
      _dialog.showError(error: e);
    }
    setState(false);
  }

  // Method for scanning barcode....
  Future barcodeScanningProduct() async {
    try {
      final _barcode = await BarcodeScanner.scan();
      await setKeyword(_barcode.rawContent);
      updateInfoBarcode(_barcode.rawContent);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        updateInfoBarcode("No camera permission!");
      } else {
        updateInfoBarcode("Unknown error: $e");
      }
    } on FormatException {
      updateInfoBarcode("UNothing captured.");
    } catch (e) {
      updateInfoBarcode("Unknown error: $e'");
    }
  }

  void updateInfoBarcode(String valueBarCode) {
    barcode = valueBarCode;
    print(valueBarCode);
    notifyListeners();
  }

  void deIncrementQtyProduct(CartProduct item, int index) {
    if (products[index].qty > 0) {
      products[index].qty--;
    }
    if (products[index].qty == 0) {
      for (int i = 0; i < _productCarts.length; i++) {
        if (_productCarts[i].productId == item.id) {
          _productCarts.remove(_productCarts[i]);
          break;
        }
      }
    }
    notifyListeners();
  }

  // Xóa tất cả sản phẩm trước khi thực hiện add(Để không bị lưu sản phẩm khi chuyển đổi  giữa chọn nhìu sản phẩm và chọn 1 sản phẩm)
  void removeAllProduct(int index) {
    _productCarts.clear();
    products[index].qty = 0;
    notifyListeners();
  }

  void incrementQtyProduct(
      CartProduct cartProduct, int index, String position) {
    products[index].qty++;

    final Lines line = Lines();
    line.discount = 0;
    line.discountType = "percent";
    line.note = "";
    line.priceUnit = cartProduct.price;
    line.productId = cartProduct.id;
    line.qty = cartProduct.qty;
    line.uomId = 1;
    line.productName = cartProduct.nameGet;
    line.tb_cart_position = position;
    line.uomName = cartProduct.uOMName;
    line.image = cartProduct.imageUrl;

    if (_productCarts.isNotEmpty) {
      for (var i = 0; i < _productCarts.length; i++) {
        if (_productCarts[i].productId == line.productId) {
          _productCarts.removeAt(i);
        }
      }
      _productCarts.add(line);
    } else {
      _productCarts.add(line);
    }

    notifyListeners();
  }

  Future<void> filterBanChay() async {
    List<CartProduct> _stackProducts = [];
    _stackProducts = await _dbFunction.queryProductAllRows();

    for (var i = 0; i < _stackProducts.length - 1; i++) {
      for (var j = i + 1; j < _stackProducts.length; j++) {
        if (_stackProducts[i].posSalesCount < _stackProducts[j].posSalesCount) {
          CartProduct product = CartProduct();
          product = _stackProducts[j];
          _stackProducts[j] = _stackProducts[i];
          _stackProducts[i] = product;
        }
      }
    }
    products = _stackProducts;
  }

  void filterName() {
    List<CartProduct> _stackProducts = [];
    _stackProducts = products;
    _stackProducts
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    products = _stackProducts;
  }

  void filterPrice(bool isSetState) {
    for (var i = 0; i < filterPrices.length; i++) {
      for (var j = 0; j < _products.length; j++) {
        if (filterPrices[i].key ==
            (_products[j].id.toString() +
                "_" +
                products[j].factor.floor().toString())) {
          products[j].price = filterPrices[i].value;
          break;
        }
      }
    }
    if (isSetState) {
      notifyListeners();
    }
  }

  void changePositionStack(int value) {
    filterStack = value;
    notifyListeners();
  }

  void filterPriceList(String value) {
    checkFocus = false;
    for (var i = 0; i < priceLists.length; i++) {
      if (priceLists[i].id.toString() == value) {
        priceList = priceLists[i];
      }
    }
    valueFilterPrice = value;
    handleFilter();
  }

  Future<void> handleFilter() async {
    if (filterStack == 2) {
      filterBanChay();
    } else if (filterStack == 3) {
      filterName();
    } else {
      getProducts();
    }
    if (priceList.id != null) {
      await filterListPrice(priceList.id);
      await getProducts();
      filterPrice(true);
    }
  }

  void updatePriceList(PriceList value) {
    priceList = value;
  }

  int countFilter() {
    int count = 0;
    if (filterStack != 1) {
      count++;
    }
    if (priceList.name != null && priceList.name != "Bảng giá mặc định") {
      count++;
    }
    return count;
  }

  void resetFilter() {
    filterStack = 1;
    priceList = PriceList();
    notifyListeners();
  }

  void changeShowProduct() {
    showListPr = !showListPr;
    notifyListeners();
  }

  void changeSelect(int index) {
    if (checkSelectProduct[index] == null) {
      checkSelectProduct[index] = true;
    } else {
      checkSelectProduct[index] = !checkSelectProduct[index];
    }
    notifyListeners();
  }

  int countProductInCart() {
    return _productCarts.length;
  }

  void resetQtyProduct() {
    for (int i = 0; i < _products.length; i++) {
      _products[i].qty = 0;
    }
  }
}
