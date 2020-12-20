/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/16/19 5:56 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/16/19 1:25 PM
 *
 */

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order_line.dart';
import 'package:tpos_mobile/helpers/helpers.dart';

import 'package:tpos_mobile/src/tpos_apis/services/object_apis/product_api.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SaleOrderLineEditViewModel extends ViewModel {
  SaleOrderLineEditViewModel({ProductApi productApi}) {
    _productApi = productApi ?? locator<ProductApi>();
  }

  ProductApi _productApi;
  final Logger _log = Logger("SaleOrderLineEditViewModel");

  SaleOrderLine _orderLine;
  SaleOrderLine get orderLine => _orderLine;

  Product _product;
  Product get product => _product;

  double _priceDiscount;
  double get priceDiscount => _priceDiscount;

  double get quantity => _orderLine.productUOMQty ?? 0;
  double get price => _orderLine.priceUnit ?? 0;
  double get discountPercent => _orderLine.discount ?? 0;
  double get discountFix => _orderLine.discountFixed ?? 0;
  double get total => _orderLine.priceTotal ?? 0;
  double get priceSubTotal => _orderLine.priceSubTotal ?? 0;
  String get orderLineNote => _orderLine.note;

  set quantity(double value) {
    _orderLine.productUOMQty = value;
    _orderLine.calculateTotal();
    notifyListeners();
  }

  set price(double value) {
    _orderLine.priceUnit = value;
    _orderLine.calculateTotal();
    notifyListeners();
  }

  set discountPercent(double value) {
    _orderLine.discount = value;
    _orderLine.calculateTotal();
    notifyListeners();
  }

  set discountFix(double value) {
    _orderLine.discountFixed = value;
    _orderLine.calculateTotal();
    notifyListeners();
  }

  set discountType(bool isPercent) {
    final double oldDiscountPercent = discountPercent;
    final double oldDiscountFix = discountFix;
    _orderLine.type = isPercent ? "percent" : "fixed";

    // Tính ngược lại
    if (isPercent == true) {
      discountPercent = oldDiscountFix / price * 100;
    } else {
      discountFix = oldDiscountPercent / 100 * price;
    }

    _orderLine.calculateTotal();
    notifyListeners();
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

  bool get isDiscountPercent => _orderLine?.type == "percent";
  void init(SaleOrderLine orderLine) {
    _orderLine = orderLine;
    initCommand();
  }

  Future<void> initCommand() async {
    try {
      await _loadProductInfo();
    } catch (e, s) {
      _log.severe("initCommand", e, s);
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
  }
}
