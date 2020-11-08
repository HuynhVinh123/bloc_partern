/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/16/19 5:56 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/16/19 2:18 PM
 *
 */

import 'dart:async';

import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';

class SaleOnlineOrderLineEditViewModel extends ViewModel {
  SaleOnlineOrderLineEditViewModel();
  SaleOnlineOrderDetail _orderLine;
  SaleOnlineOrderDetail get orderLine => _orderLine;

  Future<void> init(SaleOnlineOrderDetail orderLine) async {
    _orderLine = orderLine;
  }

  double subTotal;
  double total;
}
