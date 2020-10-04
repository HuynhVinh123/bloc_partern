/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:53 AM
 *
 */

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:rxdart/rxdart.dart';

class SaleOnlineLiveCampaignManagementViewModel extends ViewModel
    implements ViewModelBase {
  SaleOnlineLiveCampaignManagementViewModel({ITposApiService tposApi}) {
    _tposApi = tposApi ?? locator<ITposApiService>();

    _setPermission();
  }
  //log
  final log = Logger("SaleOnlineLiveCampaignManagementViewModel");

  ITposApiService _tposApi;

  bool permissionAdd = true;
  bool permissionEdit = true;

  bool isDownloadExcel = false;

  void _setPermission() {}

  bool _isOnlyShowAvaiableCampaign = true;

  bool get isOnlyShowAvaiableCampaign => _isOnlyShowAvaiableCampaign;

  set isOnlyShowAvaiableCampaign(bool value) {
    _isOnlyShowAvaiableCampaign = value;
    _isOnlyShowAvaiableCampaignController.sink.add(value);
  }

  final BehaviorSubject<bool> _isOnlyShowAvaiableCampaignController =
      BehaviorSubject();
  Stream<bool> get isOnlyShowAvaiableCampaignStream =>
      _isOnlyShowAvaiableCampaignController.stream;
  final BehaviorSubject<List<LiveCampaign>> _liveCampaignsController =
      BehaviorSubject();

  final BehaviorSubject<bool> _isExportExcelController = BehaviorSubject();
  Stream<bool> get isExportExcelStream => _isExportExcelController.stream;

  set isExportExcel(bool value) {
    _isExportExcelController.sink.add(value);
  }

  void _onLiveCampaignsAdd(List<LiveCampaign> value) {
    if (_liveCampaignsController.isClosed == false) {
      _liveCampaignsController.add(value);
    }
  }

  Stream<List<LiveCampaign>> get liveCampaignsStream =>
      _liveCampaignsController.stream;

  Future refreshLiveCampaign() async {
    try {
      if (_isOnlyShowAvaiableCampaign) {
        final liveCampaigns = await _tposApi.getAvaibleLiveCampaigns();
        _onLiveCampaignsAdd(liveCampaigns);
      } else {
        final liveCampaigns = await _tposApi.getLiveCampaigns();
        _onLiveCampaignsAdd(liveCampaigns);
      }
    } catch (e, s) {
      _liveCampaignsController.addError(e, s);
      log.severe("refresh", e, s);
    }

    return null;
  }

  Future<void> downloadExcel(
      LiveCampaign liveCampaign, BuildContext context) async {
    isExportExcel = true;
    try {
      final result = await _tposApi.exportExcelLiveCampaign(
          liveCampaign.id, liveCampaign.name);
      if (result != null) {
        _showDialog(path: result, context: context);
      }
      isExportExcel = false;
    } catch (e, s) {
      isExportExcel = false;
      final DialogService _dialog = locator<DialogService>();
      _dialog.showError(title: "Lỗi", content: e.toString());
      log.severe("downloadexcel", e, s);
    }
  }

  void _showDialog({String path, BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text("Thông báo"),
          content: Text(
              "File của bạn đã được lưu ở thư  mục: $path. Bạn có muốn mở file?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: const Text(
                "Mở thư mục lưu",
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                if (Platform.isAndroid) {
                  OpenFile.open('/sdcard/download');
                } else {
                  final String dirloc =
                      (await getApplicationDocumentsDirectory()).path;
                  OpenFile.open(dirloc);
                }
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FlatButton(
                  child: const Text(
                    "Đóng",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: const Text(
                    "Mở",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    OpenFile.open(path);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _liveCampaignsController.close();
    _isOnlyShowAvaiableCampaignController.close();
    super.dispose();
  }
}
