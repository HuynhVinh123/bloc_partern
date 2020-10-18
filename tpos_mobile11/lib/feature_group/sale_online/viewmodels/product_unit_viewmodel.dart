/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';

import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';

import 'package:rxdart/rxdart.dart';

import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class ProductUOMViewModel extends Model implements ViewModelBase {
  ProductUOMViewModel({ITposApiService tposApi}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
  }
  //log
  final log = Logger("ProductUnitViewModel");
  ITposApiService _tposApi;

  // List ProductUOM Category
  List<ProductUOM> _productUOM;
  List<ProductUOM> _tempProductUOM;
  List<ProductUOM> get productUOM => _productUOM;
  set productUOM(List<ProductUOM> value) {
    _productUOM = value;
    _productUOMController.add(_productUOM);
  }

  final BehaviorSubject<List<ProductUOM>> _productUOMController =
      BehaviorSubject();
  Stream<List<ProductUOM>> get productUOMStream => _productUOMController.stream;

  int uomCateogoryId;

  Future loadProductUOM() async {
    try {
      if (uomCateogoryId == null) {
        productUOM = await _tposApi.getProductUOM();
        _tempProductUOM = productUOM;
      } else {
        productUOM =
            await _tposApi.getProductUOM(uomCateogoryId: uomCateogoryId);
        _tempProductUOM = productUOM;
      }
    } catch (ex, stack) {
      log.severe("loadProductUOM fail", ex, stack);
      print(ex.toString());
    }
  }

  // Tìm kiếm
  Future<List<ProductUOM>> searchProductUOM(String keyword) async {
    if (keyword == null && keyword == "") {
      return productUOM = _tempProductUOM;
    }

    final String key = StringUtils.removeVietnameseMark(keyword);
    return productUOM = _tempProductUOM
        // ignore: avoid_bool_literals_in_conditional_expressions
        .where((f) => f.name != null
            ? StringUtils.removeVietnameseMark(f.name.toLowerCase())
                .contains(key.toLowerCase())
            : false)
        .toList();
  }

  Future init() async {
    await loadProductUOM();
    searchProductUOM("");
  }

  @override
  void dispose() {}
}
