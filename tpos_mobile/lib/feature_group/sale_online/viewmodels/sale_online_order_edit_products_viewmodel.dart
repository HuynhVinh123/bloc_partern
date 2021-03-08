/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/16/19 5:56 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/16/19 3:00 PM
 *
 */

import 'dart:async';

import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';

class SaleOnlineOrderEditProductsViewModel extends ScopedViewModel {
  List<SaleOnlineOrderDetail> orderLines;
  void init(List<SaleOnlineOrderDetail> orderDetail) {
    orderLines = orderDetail;
  }

  Future<void> initCommand() async {
    setBusy(true);
    setBusy(false);
  }

  Future<void> addItemFromProductCommand(Product product) async {
    // if (!orderLines.any((f) => f.productId == product.id)) {
    final newSaleOnlineOrderDetail = SaleOnlineOrderDetail();
    newSaleOnlineOrderDetail.productId = product.id;
    newSaleOnlineOrderDetail.productName = product.name;
    newSaleOnlineOrderDetail.price = product.price;
    newSaleOnlineOrderDetail.uomId = product.uOMId;
    newSaleOnlineOrderDetail.uomName = product.uOMName;
    newSaleOnlineOrderDetail.quantity = 1;
    orderLines.add(newSaleOnlineOrderDetail);
    onPropertyChanged("");
    // }
  }

  Future<void> deleteItemCommand(SaleOnlineOrderDetail item) async {
    if (state.isBusy) {
      return;
    }
    setBusy(true);
    orderLines?.remove(item);
    onPropertyChanged("");
    setBusy(false);
  }

  double getSubtotal() {
    double total = 0;
    // ignore: avoid_function_literals_in_foreach_calls
    orderLines?.forEach((f) {
      total += (f.quantity ?? 0) * (f.price ?? 0);
    });
    return total;
  }

  double getQuantity() {
    double quantity = 0;
    // ignore: avoid_function_literals_in_foreach_calls
    orderLines?.forEach((element) {
      quantity += element.quantity;
    });
    return quantity;
  }

  Future<void> updateQuantityCommand(SaleOnlineOrderDetail item, value) async {
    item.quantity = value;
    onPropertyChanged("");
  }

  Future<void> updatePriceCommand(SaleOnlineOrderDetail item, value) async {
    item.price = value;
    onPropertyChanged("");
  }

  Future<void> changeQuantityCommand(
      SaleOnlineOrderDetail item, bool isIncrease) async {
    item.quantity += 1;
  }

  Future<void> changePriceCommand(
      SaleOnlineOrderDetail item, bool isIncrease) async {}

  Future<void> editItemCommand(SaleOnlineOrderDetail item) async {}
}
