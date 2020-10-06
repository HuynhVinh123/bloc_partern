/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:53 AM
 *
 */

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SaleOnlineAddEditLiveCampaignViewModel extends ViewModel {
  SaleOnlineAddEditLiveCampaignViewModel(
      {ITposApiService tposApi, DialogService dialog}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _dialog = dialog ?? locator<DialogService>();
  }
  //log
  final log = Logger("SaleOnlineAddEditLiveCampaignViewModel");

  ITposApiService _tposApi;
  DialogService _dialog;

  LiveCampaign liveCampaign;
  String campaignName;
  String note;

  final BehaviorSubject<LiveCampaign> _liveCampaignController =
      BehaviorSubject();
  Stream<LiveCampaign> get liveCampaignStream => _liveCampaignController.stream;

  bool get isEditMode => liveCampaign != null && liveCampaign.id != null;
  Future<void> initViewModel({LiveCampaign editLiveCampaign}) async {
    onStateAdd(true, message: S.current.loading);
    liveCampaign = editLiveCampaign ?? LiveCampaign();
    if (liveCampaign.id != null) {
      await refreshLiveCampaign();
    }
    _liveCampaignController.add(liveCampaign);
    onStateAdd(false);
  }

  // Lấy thông tin chi tiết chiến dịch live
  Future<void> refreshLiveCampaign() async {
    liveCampaign = await _tposApi.getDetailLiveCampaigns(liveCampaign.id);
  }

  // Thêm chiến dịch live
  Future<bool> addLiveCampaign(LiveCampaign newLiveCampaign) async {
    try {
      final result =
          await _tposApi.addLiveCampaign(newLiveCampaign: newLiveCampaign);
      if (result) {
        _dialog.showNotify(
            type: DialogType.NOTIFY_INFO,
            message: S.current.liveCampaign_addSuccess);
      } else {
        _dialog.showError(
          error: result.toString(),
        );
      }
      return true;
    } catch (e, s) {
      log.severe("addLiveCampaign", e, s);
      _dialog.showError(
        error: e,
      );
      return false;
    }
  }

  // Sửa thông tin chiến dịch live
  Future<void> editLiveCampaign(LiveCampaign editLiveCampaign) async {
    final result = await _tposApi.editLiveCampaign(editLiveCampaign);
    if (result) {
      onDialogMessageAdd(
          OldDialogMessage.flashMessage(S.current.liveCampaign_editCampaign));
    } else {
      onDialogMessageAdd(OldDialogMessage.error(
          S.current.error, S.current.liveCampaign_editFailed));
    }
  }

  Future<void> changeStatus(bool isActive) async {
    if (liveCampaign.id != null) {
      try {
        await _tposApi.changeLiveCampaignStatus(liveCampaign.id);
      } catch (e, s) {
        log.severe("change status", e, s);
      }
    }
  }

  Future<bool> save() async {
    try {
      if (liveCampaign.id != null && liveCampaign.id != "") {
        await editLiveCampaign(liveCampaign);
      } else {
        await addLiveCampaign(liveCampaign);
      }
      return true;
    } catch (ex, stack) {
      log.severe("save fail", ex, stack);
      onDialogMessageAdd(OldDialogMessage.error(
          S.current.liveCampaign_saveFailed, ex.toString()));
    }
    return false;
  }

  @override
  void dispose() {
    dialogMessageController?.close();
    _liveCampaignController?.close();
    super.dispose();
  }
}
