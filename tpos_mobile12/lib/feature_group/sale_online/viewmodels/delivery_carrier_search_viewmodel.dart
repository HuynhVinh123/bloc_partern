/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/16/19 5:56 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/16/19 4:05 PM
 *
 */

import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/models/delivery_carrier.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';

class DeliveryCarrierSearchViewModel extends ViewModel {
  DeliveryCarrierSearchViewModel({ITposApiService tposApi}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
  }
  ITposApiService _tposApi;

  DeliveryCarrier selectedDeliveryCarrier;
  bool isSearch = true;
  bool isCloseOnDone = true;
  Function(DeliveryCarrier) selectedCallback;
  void init({
    DeliveryCarrier selectedCarrier,
    bool isSearch = true,
    bool isCloseOnDone = true,
    Function(DeliveryCarrier) selectedCallback,
  }) {
    selectedDeliveryCarrier = selectedCarrier;
    this.isSearch = isSearch;
    this.isCloseOnDone = isCloseOnDone;
    this.selectedCallback = selectedCallback;
  }

  Future<void> initCommand() async {
    onStateAdd(true);
    try {
      await _reloadDeliveryCarrier();
    } catch (e, s) {
      onDeliveryCarriersAdd(null, stackTrade: s);
    }

    onStateAdd(false);
  }

  List<DeliveryCarrier> _deliveryCarriers;
  List<DeliveryCarrier> get deliveryCarriers => _deliveryCarriers;
  final BehaviorSubject<List<DeliveryCarrier>> _deliveryCarriersController =
      BehaviorSubject();

  Stream<List<DeliveryCarrier>> get deliveryCarriersStream =>
      _deliveryCarriersController.stream;

  void onDeliveryCarriersAdd(List<DeliveryCarrier> value,
      {Object error, stackTrade}) {
    _deliveryCarriers = value;
    if (_deliveryCarriersController.isClosed == false) {
      if (value != null) {
        _deliveryCarriersController.add(_deliveryCarriers);
      }
      if (error != null)
        _deliveryCarriersController.addError(error, stackTrade);
    }
  }

  Future<void> _reloadDeliveryCarrier() async {
    _deliveryCarriers = await _tposApi.getDeliveryCarriers();
    onDeliveryCarriersAdd(_deliveryCarriers);
  }
}
