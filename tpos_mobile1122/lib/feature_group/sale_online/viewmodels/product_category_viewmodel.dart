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
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';

class ProductCategoryViewModel extends ViewModel implements ViewModelBase {
  //log
  final _log = new Logger("ProductCategoryViewModel");
  ITposApiService _tposApi;
  ProductCategoryViewModel({ITposApiService tposApi}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _keywordController
        .debounceTime(Duration(milliseconds: 400))
        .listen((newKeyword) {
      searchProductCategory(keyword);
    });
  }

  // List Product Category
  List<ProductCategory> _productCategories;
  List<ProductCategory> get productCategories => _productCategories;
  set productCategories(List<ProductCategory> value) {
    _productCategories = value;
    _productsCategoriesController.add(_productCategories);
  }

  /// set price list
  set priceList(ProductPrice priceList) {}

  BehaviorSubject<List<ProductCategory>> _productsCategoriesController =
      new BehaviorSubject();
  Stream<List<ProductCategory>> get productCategoriesStream =>
      _productsCategoriesController.stream;

//  Future loadProductCategories() async {
//    try {
//      productCategories = await _tposApi.getProductCategories();
//    } catch (ex, stack) {
//      _log.severe("loadProductCategory fail", ex, stack);
//    }
//  }

  // Keyword controll
  String _keyword = "";
  String get keyword => _keyword;
  set keyword(String value) {
    _keyword = value;
    _keywordController.add(_keyword);
  }

  BehaviorSubject<String> _keywordController = new BehaviorSubject();
  void _onKeywordAdd(String value) {
    _keyword = value;
    if (_keywordController.isClosed == false) {
      _keywordController.add(value);
    }
  }

  Future<void> addNewProductCategoryCommand(
      ProductCategory newProductCategory) async {
    _onKeywordAdd(newProductCategory.name);
  }

  Future<void> keywordChangedCommand(String keyword) async {
    _onKeywordAdd(keyword);
  }

  // Tìm kiếm danh mục sản phẩm
  Future<void> searchProductCategory(String keyword) async {
    onStateAdd(true, message: "Đang tải");
    try {
      String key = StringUtils.removeVietnameseMark(keyword);
      var result = await _tposApi.productCategorySearch(
        key,
      );
      if (result.error == true) {
        _productsCategoriesController.addError(new Exception(result.message));
      } else {
        productCategories = result.result;
        if (_productsCategoriesController.isClosed == false)
          _productsCategoriesController.add(productCategories);
      }
    } catch (e, s) {
      _log.severe("searchProductCategory", e, s);
      if (_productsCategoriesController.isClosed == false)
        _productsCategoriesController.addError(e, s);
    }
    onStateAdd(false);
  }

  // Xóa danh mục sản phẩm
  Future<bool> deleteProductCategory(int id) async {
    try {
      var result = await _tposApi.deleteProductCategory(id);
      if (result.result == true) {
        onDialogMessageAdd(
            new OldDialogMessage.flashMessage("Đã xóa danh mục sản phẩm"));
        return true;
      } else {
        onDialogMessageAdd(new OldDialogMessage.error("", result.message));
        return false;
      }
    } catch (ex, stack) {
      _log.severe("deleteProductCategory fail", ex, stack);
      onDialogMessageAdd(new OldDialogMessage.error("", ex.toString(),
          title: "Lỗi không xác định!"));
      return false;
    }
  }

  Future init() async {
    searchProductCategory("");
  }

  @override
  void dispose() {
    _keywordController.close();
    _productsCategoriesController.close();
  }
}
