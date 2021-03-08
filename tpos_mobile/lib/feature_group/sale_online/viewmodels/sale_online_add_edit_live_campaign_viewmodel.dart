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
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/services/dialog_service/new_dialog_service.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SaleOnlineAddEditLiveCampaignViewModel extends ScopedViewModel {
  SaleOnlineAddEditLiveCampaignViewModel({NewDialogService newDialog}) {
    _campaignApi = GetIt.I<LiveCampaignApi>();
    _newDialog = newDialog ?? GetIt.I<NewDialogService>();
  }
  //log
  final log = Logger("SaleOnlineAddEditLiveCampaignViewModel");

  LiveCampaignApi _campaignApi;
  NewDialogService _newDialog;

  LiveCampaign liveCampaign;
  String campaignName;
  String note;

  final BehaviorSubject<LiveCampaign> _liveCampaignController =
      BehaviorSubject();
  Stream<LiveCampaign> get liveCampaignStream => _liveCampaignController.stream;

  bool get isEditMode => liveCampaign != null && liveCampaign.id != null;
  Future<void> initViewModel({LiveCampaign editLiveCampaign}) async {
    setBusy(true, message: S.current.loading);
    try {
      liveCampaign = editLiveCampaign ?? LiveCampaign();
      if (liveCampaign.id != null) {
        await refreshLiveCampaign();
      }
      _liveCampaignController.add(liveCampaign);
      setBusy(false);
    } catch (e) {
      setBusy(false);
      _newDialog.showError(content: e.toString());
    }
    notifyListeners();
  }

  // Lấy thông tin chi tiết chiến dịch live
  Future<void> refreshLiveCampaign() async {
    liveCampaign = await _campaignApi.getDetailLiveCampaigns(liveCampaign.id);
  }

  // Thêm chiến dịch live
  Future<bool> addLiveCampaign(LiveCampaign newLiveCampaign) async {
    // try {
    //   setBusy(true, message: S.current.loading);
    await _campaignApi.addLiveCampaign(newLiveCampaign: newLiveCampaign);
    _newDialog.showToast(message: S.current.updateSuccessful);
    setBusy(false);
    return true;
    // } catch (e, s) {
    //   setBusy(false);
    //   log.severe("addLiveCampaign", e, s);
    //   _newDialog.showError(content: e.toString());
    //   return false;
    // }
  }

  // Sửa thông tin chiến dịch live
  Future<void> editLiveCampaign(LiveCampaign editLiveCampaign) async {
    // try {
    //   setBusy(true, message: S.current.loading);
    await _campaignApi.editLiveCampaign(editLiveCampaign);
    // onDialogMessageAdd(
    //      OldDialogMessage.flashMessage(S.current.liveCampaign_editCampaign));
    _newDialog.showToast(message: S.current.updateSuccessful);
    // } catch (e, s) {
    //   // onDialogMessageAdd(OldDialogMessage.error(S.current.error, e.toString()));
    //   _newDialog.showError(content: e.toString());
    // }
    // setBusy(false);
  }

  Future<void> changeStatus(bool isActive) async {
    if (liveCampaign.id != null) {
      try {
        await _campaignApi.changeLiveCampaignStatus(liveCampaign.id);
      } catch (e, s) {
        log.severe("change status", e, s);
      }
    }
  }

  Future<bool> save() async {
    setBusy(true, message: S.current.loading);
    try {
      if (liveCampaign.id != null && liveCampaign.id != "") {
        await editLiveCampaign(liveCampaign);
      } else {
        await addLiveCampaign(liveCampaign);
      }
      setBusy(false);
      return true;
    } catch (ex, stack) {
      setBusy(false);
      log.severe("save fail", ex, stack);
      _newDialog.showError(content: ex.toString());
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
