/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_service/odata_filter.dart';
import 'package:tpos_mobile/feature_group/sale_online/services/tpos_api_service.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/base_list_order_by_type.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/product_api.dart';

class ProductSearchViewModel extends ScopedViewModel implements ViewModelBase {
  ProductSearchViewModel(
      {ISettingService settingService, ProductApi productApi}) {
    _settingService = settingService ?? locator<ISettingService>();
    _productApi = productApi ?? locator<ProductApi>();

    // Listen keyword changing
    _keywordController
        .debounceTime(const Duration(milliseconds: 500))
        .listen((keyword) {
      searchProductV2(isBarcode: isBarcode);
    });

    try {
      _selectedOrderBy =
          BaseListOrderBy.values[_settingService.productSearchOrderByIndex];
    } catch (e) {
      _selectedOrderBy = BaseListOrderBy.NAME_ASC;
    }
  }
  //log
  final _log = Logger("SearchProductViewModel");

  ISettingService _settingService;
  ProductApi _productApi;

  /* FILTER */

  BaseListOrderBy _selectedOrderBy;
  BaseListOrderBy get selectedOrderBy => _selectedOrderBy;
  final Map<BaseListOrderBy, String> _orderByList = {
    BaseListOrderBy.NAME_ASC: "Tên (A-Z)",
    BaseListOrderBy.NAME_DESC: "Tên (Z-A)",
    BaseListOrderBy.PRICE_ASC: "Giá bán tăng dần",
    BaseListOrderBy.PRICE_DESC: "Giá bán giảm dần",
  };

  Map<BaseListOrderBy, String> get orderByList => _orderByList;

  /* FILTER */
  // Keyword controll
  String _keyword = "";
  String get keyword => _keyword;
  set keyword(String value) {
    _keyword = value;
    _keywordController.add(_keyword);
  }

  bool isBarcode = false;
  int _lastSkip = 0;
  int _maxResult = 0;
  List<Product> products;

  bool get canLoadMore {
    return (_lastSkip ?? 0) < (_maxResult ?? 0);
  }

  final BehaviorSubject<String> _keywordController = BehaviorSubject();
  void _onKeywordAdd(String value) {
    _keyword = value;
    if (_keywordController.isClosed == false) {
      _keywordController.add(value);
    }
  }

  final BehaviorSubject<List<Product>> _productsController = BehaviorSubject();
  Stream<List<Product>> get productsStream => _productsController.stream;

  Future<void> initCommand() async {
    onIsBusyAdd(true);

    onIsBusyAdd(false);
  }

  Future<void> keywordChangedCommand(String keyword) async {
    _onKeywordAdd(keyword);
  }

//  Future searchProduct() async {
//    onIsBusyAdd(true);
//    try {
//      var products = await _repository.searchProduct(_keyword);
//
//      if (_selectedOrderBy == BaseListOrderBy.NAME_ASC)
//        products.sort((p1, p2) => p1.name.compareTo(p2.name));
//      else if (_selectedOrderBy == BaseListOrderBy.NAME_DESC) {
//        products.sort((p1, p2) => p1.name.compareTo(p2.name));
//        products = products.reversed.toList();
//      } else if (_selectedOrderBy == BaseListOrderBy.PRICE_ASC) {
//        products.sort((p1, p2) => (p1.price ?? 0).compareTo((p2.price ?? 0)));
//      } else if (_selectedOrderBy == BaseListOrderBy.PRICE_DESC) {
//        products.sort((p1, p2) => (p1.price ?? 0).compareTo((p2.price ?? 0)));
//        products = products.reversed.toList();
//      }
//       Future(() {
//        if (_productsController.isClosed == false)
//          _productsController.add(products);
//      });
//    } catch (ex, stack) {
//      _log.severe("searchProduct fail", ex, stack);
//      _productsController.addError(ex);
//    }
//    onIsBusyAdd(false);
//  }

  Future searchProductV2(
      {bool isBarcode = false, bool isLoadMore = false}) async {
    onIsBusyAdd(true);

    final OldOdataSortItem sort = OldOdataSortItem(field: "Name", dir: "ASC");
    if (selectedOrderBy != null) {
      if (_selectedOrderBy == BaseListOrderBy.NAME_ASC) {
        sort.field = "Name";
        sort.dir = "asc";
      } else if (_selectedOrderBy == BaseListOrderBy.NAME_DESC) {
        sort.field = "Name";
        sort.dir = "desc";
      } else if (_selectedOrderBy == BaseListOrderBy.PRICE_ASC) {
        sort.field = "Price";
        sort.dir = "asc";
      } else if (_selectedOrderBy == BaseListOrderBy.PRICE_DESC) {
        sort.field = "Price";
        sort.dir = "desc";
      }
    }

    if (isLoadMore == false) {
      _lastSkip = 0;
    }
    try {
      final result = await _productApi.productSearch(keyword,
          top: 100,
          skip: _lastSkip == 0 ? null : _lastSkip,
          isSearchStartWith: false,
          type: isBarcode ? ProductSearchType.BARCODE : ProductSearchType.ALL,
          sortBy: sort);
      if (result.error == true) {
        _productsController.addError(Exception(result.message));
      } else {
        _maxResult = result.resultCount;
        if (isLoadMore) {
          products.addAll(result.result);
        } else {
          products = result.result;
        }

        _lastSkip = products?.length ?? 0;
        if (_productsController.isClosed == false)
          _productsController.add(products);
      }
    } catch (e, s) {
      _log.severe("searchProduct", e, s);
      _productsController.addError(e, s);
    }
    onIsBusyAdd(false);
  }

  Future loadMoreProductCommand() async {
    searchProductV2(isBarcode: isBarcode, isLoadMore: true);
  }

  /// selectOrderByCommand
  Future<void> selectOrderByCommand(BaseListOrderBy selectOrderBy) async {
    _selectedOrderBy = selectOrderBy;
    onPropertyChanged("selectedOrderBy");
    await amplyFilterCommand();
  }

  /// Aply Filter COmmand
  /// amplyFilterCommand
  Future<void> amplyFilterCommand() async {
    //save setting
    onIsBusyAdd(true);
    try {
      _settingService.productSearchOrderByIndex = _selectedOrderBy.index;
      await searchProductV2(isBarcode: isBarcode);
    } catch (e, s) {
      _log.severe("amplyFilterCommand", e, s);
    }
    //await _filter();
    onIsBusyAdd(false);
  }

  bool get isViewAsList {
    return _settingService.isProductSearchViewList;
  }

  Future<void> changeViewTypeCommand(bool isList) async {
    _settingService.isProductSearchViewList = isList;
    onPropertyChanged("");
  }

  Future<void> addProductCommand(Product product) async {
    _onKeywordAdd(product.name);
  }

  @override
  void dispose() {
    _productsController.close();
    _keywordController.close();
    super.dispose();
  }
}
