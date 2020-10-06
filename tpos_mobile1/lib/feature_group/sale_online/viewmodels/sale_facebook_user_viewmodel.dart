/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 4:31 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 3:00 PM
 *
 */

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';

import 'package:rxdart/rxdart.dart';

class SaleFacebookUserViewModel implements ViewModelBase {
  SaleFacebookUserViewModel(
      {this.orderNumber,
      this.hasComment,
      this.hasPhone,
      this.hasAddress,
      this.asuid,
      this.facebookId,
      this.statusText,
      this.status,
      this.sessionIndex,
      this.order,
      this.phone,
      this.address,
      this.partnerCode});
  //log
  final log = Logger("SaleFacebookUserViewModel");
  String orderNumber;

  bool hasComment = false;
  bool hasPhone = false;
  bool hasAddress = false;
  String asuid;
  String facebookId;
  String statusText;
  String status;
  int sessionIndex;

  SaleOnlineOrder order;
  String phone;
  String address;
  String parterNote;
  String partnerCode;

  BehaviorSubject<String> notifyListennerController = BehaviorSubject();
  Stream<String> get notifyListennerStream => notifyListennerController.stream;
  Sink<String> get notifyListennerSink => notifyListennerController.sink;
  void onNotifyListenerAdd(String value) {
    if (notifyListennerController.isClosed == false) {
      notifyListennerSink.add(value);
    }
  }

  @override
  void dispose() {
    notifyListennerController.close();
  }
}
