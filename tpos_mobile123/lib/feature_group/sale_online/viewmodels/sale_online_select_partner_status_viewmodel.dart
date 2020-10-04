/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:53 AM
 *
 */

import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:rxdart/rxdart.dart';

class SaleOnlineSelectPartnerStatusViewModel extends Model
    implements ViewModelBase {
  SaleOnlineSelectPartnerStatusViewModel({CommonApi commonApi}) {
    _commonApi = commonApi ?? GetIt.I<CommonApi>();
  }
  //log
  final log = Logger("SaleOnlineSelectPartnerStatusViewModel");
  CommonApi _commonApi;

  // Status
  List<PartnerStatus> _statuss;

  List<PartnerStatus> get statuss => _statuss;

  set statuss(List<PartnerStatus> value) {
    _statuss = value;
    if (_statussController.isClosed == false) {
      _statussController.sink.add(_statuss);
    }
  }

  final BehaviorSubject<List<PartnerStatus>> _statussController =
      BehaviorSubject();
  Stream<List<PartnerStatus>> get statusStream => _statussController.stream;

  void init() {
    loadStatus();
  }

  Future<void> loadStatus() async {
    try {
      statuss = await _commonApi.getPartnerStatus();
    } catch (ex, stack) {
      log.severe("loadStatus fail", ex, stack);
      _statussController.addError("Đã xảy ra lỗi. vui lòng thử lại");
    }
  }

  @override
  void dispose() {
    _statussController.close();
  }
}
