/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner_category.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/partner_category_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class PartnerCategoryViewModel extends ViewModel {
  //log
  final _log = Logger("PartnerCategoryViewModel");
  ITposApiService _tposApi;
  PartnerCategoryApi _partnerCategoryApi;
  DialogService _dialog;
  PartnerCategoryViewModel(
      {ITposApiService tposApi,
      DialogService dialog,
      PartnerCategoryApi partnerCategoryApi}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _partnerCategoryApi = partnerCategoryApi ?? locator<PartnerCategoryApi>();
    _dialog = dialog ?? locator<DialogService>();
    _keywordController
        .debounceTime(new Duration(milliseconds: 500))
        .listen((newKeyword) {
      searchProductCategory(keyword);
    });
  }

  // List Selected Partner Category
  List<PartnerCategory> selectedPartnerCategories;

  // List Partner Category
  List<PartnerCategory> _partnerCategories;
  List<PartnerCategory> _tempPartnerCategories;
  List<PartnerCategory> get partnerCategories => _partnerCategories;
  set partnerCategories(List<PartnerCategory> value) {
    _partnerCategories = value;
    _partnerCategoriesController.add(_partnerCategories);
  }

  BehaviorSubject<List<PartnerCategory>> _partnerCategoriesController =
      new BehaviorSubject();
  Stream<List<PartnerCategory>> get partnerCategoriesStream =>
      _partnerCategoriesController.stream;

  // Key word
  String _keyword = "";
  String get keyword => _keyword;
  set keyword(String value) {
    _keyword = value;
    _keywordController.add(_keyword);
  }

  Future<void> addNewPartnerCategoryCommand(
      PartnerCategory newPartnerCategory) async {
    _onKeywordAdd(newPartnerCategory.name);
  }

  BehaviorSubject<String> _keywordController = new BehaviorSubject();
  void _onKeywordAdd(String value) {
    _keyword = value;
    if (_keywordController.isClosed == false) {
      _keywordController.add(value);
    }
  }

  Future<void> keywordChangedCommand(String keyword) async {
    _onKeywordAdd(keyword);
  }

  Future loadPartnerCategory() async {
    try {
      partnerCategories = await _partnerCategoryApi.getPartnerCategories();
      _tempPartnerCategories = partnerCategories;
    } catch (ex, stack) {
      _log.severe("loadPartnerCategory fail", ex, stack);
    }
  }

  // Tìm kiếm nhóm khách hàng
  Future<void> searchProductCategory(String keyword) async {
    onStateAdd(true, message: "Đang tải");
    try {
      String key = StringUtils.removeVietnameseMark(keyword);
      var result = await _partnerCategoryApi.partnerCategorySearch(
        key,
      );
      if (result.error == true) {
        _partnerCategoriesController.addError(new Exception(result.message));
      } else {
        partnerCategories = result.result;
        if (_partnerCategoriesController.isClosed == false)
          _partnerCategoriesController.add(partnerCategories);
      }
    } catch (e, s) {
      _log.severe("searchProductCategory", e, s);
      _dialog.showError(error: e);
    }
    onStateAdd(false);
  }

  Future init() async {
    await loadPartnerCategory();
  }

  Future<void> delete(PartnerCategory item) async {
    try {
      await _tposApi.deletePartnerCategory(item.id);
      _partnerCategories.remove(item);
      _dialog.showNotify(message: "Đã xóa ${item.name}");
      addSubject(_partnerCategoriesController, _partnerCategories);
    } catch (e, s) {
      _log.severe("", e, s);
      _dialog.showError(error: e);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
