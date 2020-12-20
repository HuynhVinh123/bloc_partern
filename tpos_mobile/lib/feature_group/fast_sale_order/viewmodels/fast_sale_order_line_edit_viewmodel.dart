/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/16/19 5:56 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/16/19 1:25 PM
 *
 */

import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/services/cache_service.dart';

import 'package:tpos_mobile/src/tpos_apis/services/object_apis/product_api.dart';

import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class FastSaleOrderLineEditViewModel extends ViewModel {
  FastSaleOrderLineEditViewModel(
      {TposApiService tposApi, ProductApi productApi}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _productApi = productApi ?? locator<ProductApi>();
    _cacheService = _cacheService ?? GetIt.instance<CacheService>();
  }
  ITposApiService _tposApi;
  ProductApi _productApi;
  CacheService _cacheService;
  final Logger _log = Logger("FastSaleOrderLineEditViewModel");

  List<ResInventoryModel> _inventories;
  List<ResInventoryModel> get inventories => _inventories;
  FastSaleOrderLine _orderLine;
  FastSaleOrderLine get orderLine => _orderLine;

  Product _product;
  Product get product => _product;

  double _priceDiscount;
  double get priceDiscount => _priceDiscount;

  final _totalSubject = BehaviorSubject<double>();
  final _priceDiscountSubject = BehaviorSubject<double>();
  final _discountSubject = BehaviorSubject<double>();
  final _discountFixSubject = BehaviorSubject<double>();

  Stream<double> get totalStream => _totalSubject.stream;
  Stream<double> get priceDiscountStream => _priceDiscountSubject.stream;
  Stream<double> get discountStream => _discountSubject.stream;
  Stream<double> get discountFixStream => _discountFixSubject.stream;

  double get quantity => _orderLine.productUOMQty ?? 0;
  double get price => _orderLine.priceUnit ?? 0;
  double get discountPercent => _orderLine.discount ?? 0;
  double get discountFix => _orderLine.discountFixed ?? 0;
  double get total => _orderLine.priceTotal ?? 0;
  double get priceSubTotal => _orderLine.priceSubTotal ?? 0;
  String get orderLineNote => _orderLine.note;

  set quantity(double value) {
    _orderLine.productUOMQty = value;
    _calcTotal();
    onPropertyChanged("quantity");
  }

  set price(double value) {
    _orderLine.priceUnit = value;
    _calcTotal();
  }

  set discountPercent(double value) {
    _orderLine.discount = value;
    _calcTotal();
  }

  set discountFix(double value) {
    _orderLine.discountFixed = value;
    _calcTotal();
  }

  set total(double value) {
    _orderLine.priceTotal = value;
  }

  set priceSubTotal(double value) {
    _orderLine.priceSubTotal = value;
  }

  set orderLineNote(String value) {
    _orderLine.note = value;
  }

  void _calcTotal() {
    if (_isDiscountPercent) {
      _priceDiscount = price * (100 - discountPercent) / 100;
    } else {
      _priceDiscount = price - discountFix;
    }

    _priceDiscountSubject.add(_priceDiscount);

    _orderLine.calculateTotal();
    _totalSubject.add(total);
  }

  bool _isDiscountPercent = true;
  bool get isDiscountPercent => _isDiscountPercent;
  set isDiscountPercent(bool value) {
    final double oldDiscountPercent = discountPercent;
    final double oldDiscountFix = discountFix;
    _isDiscountPercent = value;
    _orderLine.type = value ? "percent" : "fixed";

    // Tính ngược lại
    if (value == true) {
      discountPercent = oldDiscountFix / price * 100;
    } else {
      discountFix = oldDiscountPercent / 100 * price;
    }
    _calcTotal();
    onPropertyChanged("isDiscountPercent");
  }

  void init(FastSaleOrderLine orderLine) {
    _orderLine = orderLine;
    _isDiscountPercent = orderLine.type == "percent";
    initCommand();
  }

  Future<void> initCommand() async {
    try {
      await _loadProductInfo();
      _calcTotal();
    } catch (e, s) {
      _log.severe("initCommand", e, s);
    }

    onPropertyChanged("");
  }

  /// Khi  thay đổi giảm giá bằng tiền hoặc phần  trăm
  Future<void> changeDiscountTypeCommand(bool isPercent) async {
    final bool oldValue = _isDiscountPercent;
    final double oldPercentValue = discountPercent;
    final double oldDiscountFix = discountFix;
    _isDiscountPercent = isPercent;
    _orderLine.type = isPercent ? "percent" : "fixed";
    if (oldValue != isPercent) {
      if (!isPercent) {
        discountFix = price * oldPercentValue / 100;
        _discountFixSubject.add(discountFix);
      } else {
        discountPercent = oldDiscountFix / price * 100;
        _discountSubject.add(discountPercent);
      }
    }

    onPropertyChanged("");
  }

  Future<void> _loadProductInfo() async {
    final getProductResult =
        await _productApi.getProductSearchById(_orderLine.productId);

    if (getProductResult.value != null) {
      _product = getProductResult.value;
    } else {
      onDialogMessageAdd(OldDialogMessage.flashMessage(
          "${S.current.purchaseOrder_cannotLoadProduct}. ${getProductResult.error.message}"));
    }
    // tồn kho
    final inventoryResult =
        await _tposApi.getProductInventoryById(tmplId: _orderLine.productId);
    _inventories = inventoryResult?.value
        ?.where((f) => f.id == _cacheService.companyCurrent.companyId)
        ?.toList();
  }
}
