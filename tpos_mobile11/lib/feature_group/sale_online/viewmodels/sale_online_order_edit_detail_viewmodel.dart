/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:53 AM
 *
 */

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';

import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:rxdart/rxdart.dart';

class SaleOnlineEditOrderDetailViewModel extends Model
    implements ViewModelBase {
  //log
  final log = Logger("SaleOnlineEditOrderDetailViewModel");

  // orderDetails
  List<SaleOnlineOrderDetail> _details;
  List<SaleOnlineOrderDetail> get details => _details;
  set details(List<SaleOnlineOrderDetail> value) {
    _details = value;
    _detailsController.add(_details);
  }

  final BehaviorSubject<List<SaleOnlineOrderDetail>> _detailsController =
      BehaviorSubject();
  Stream<List<SaleOnlineOrderDetail>> get detailsStream =>
      _detailsController.stream;

  // Select product
  void addNewDetail(Product product) {
    final SaleOnlineOrderDetail newDetail = SaleOnlineOrderDetail();
    newDetail.productId = product.id;
    newDetail.productName = product.name;
    newDetail.uomId = product.uOMId;
    newDetail.uomName = product.uOMName;
    newDetail.quantity = 1;
    newDetail.price = product.price;
    _details.add(newDetail);
    _detailsController.add(_details);
  }

  /// delete product
  void deleteDetail(SaleOnlineOrderDetail detail) {
    _details.remove(detail);
    _detailsController.add(_details);
  }

  /// Thay đổi số lượng

  void changeQuantity(SaleOnlineOrderDetail detail, bool isInscrease) {
    if (isInscrease)
      detail.quantity += 1;
    else if (detail.quantity > 1) {
      detail.quantity -= 1;
    }
    _detailsController.add(_details);
  }

  /// Thay đổi đơn giá
  void changePrice(SaleOnlineOrderDetail detail, bool isIncrease) {
    if (isIncrease)
      detail.price += 1000;
    else if (detail.price > 1000) {
      detail.price -= 1000;
    }

    _detailsController.add(_details);
  }

  /// Tải danh sách chi tiết
  void init() {}

  @override
  void dispose() {
    _detailsController.close();
  }
}
