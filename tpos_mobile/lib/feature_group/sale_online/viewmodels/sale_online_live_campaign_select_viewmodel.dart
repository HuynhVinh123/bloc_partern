/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:53 AM
 *
 */

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class SaleOnlineLiveCampaignSelectViewModel implements ViewModelBase {
  SaleOnlineLiveCampaignSelectViewModel({ITposApiService tposApi}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
  }
  ITposApiService _tposApi;
  final Logger _log = Logger("SaleOnlineLiveCampaignSelectViewModel");

  final _notifyChangedController = BehaviorSubject<String>();
  Stream<String> get notifyChangedStream => _notifyChangedController.stream;
  Function(String) get notifyChangedAdd => _notifyChangedController.sink.add;

  final _dialogController = BehaviorSubject<OldDialogMessage>();
  Stream<OldDialogMessage> get dialogStream => _dialogController.stream;

  final _liveCampaignsController = BehaviorSubject<List<LiveCampaign>>();
  Stream<List<LiveCampaign>> get liveCampaignsStream =>
      _liveCampaignsController.stream;
  Function(List<LiveCampaign>) get liveCampaignsAdd =>
      _liveCampaignsController.sink.add;

  Future init() async {
    try {
      liveCampaignsAdd(await _tposApi.getAvaibleLiveCampaigns());
    } catch (e, s) {
      _log.severe("init", e, s);
      _liveCampaignsController.addError("init", s);
    }
  }

  @override
  void dispose() {
    _notifyChangedController.close();
    _dialogController.close();
  }
}
