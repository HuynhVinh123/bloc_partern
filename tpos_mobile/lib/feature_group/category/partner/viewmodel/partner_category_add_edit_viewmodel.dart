import 'dart:async';

import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner_category.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/partner_category_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PartnerCategoryAddEditViewModel extends ViewModel {
  PartnerCategoryAddEditViewModel({PartnerCategoryApi partnerCategoryApi}) {
    _partnerCategoryApi = partnerCategoryApi ?? locator<PartnerCategoryApi>();
  }

  final _log = Logger("PartnerCategoryAddEditViewModel");

  PartnerCategoryApi _partnerCategoryApi;

  // Partner Category Command
  void selectPartnerCategoryCommand(PartnerCategory selectedCat) {
    partnerCategory.parent = selectedCat;
    partnerCategory.name = selectedCat.name;
    partnerCategory.parentId = selectedCat.id;
    onPropertyChanged("category");
  }

  // Partner Category
  PartnerCategory _partnerCategory = PartnerCategory();
  PartnerCategory get partnerCategory => _partnerCategory;
  set partnerCategory(PartnerCategory value) {
    _partnerCategory = value;
    _partnerCategoryController.add(_partnerCategory);
  }

  final BehaviorSubject<PartnerCategory> _partnerCategoryController =
      BehaviorSubject();
  Stream<PartnerCategory> get partnerCategoryStream =>
      _partnerCategoryController.stream;

  // Load Partner Category
  Future<bool> loadPartnerCategory(int id) async {
    try {
      // Đang tải
      onStateAdd(true, message: S.current.loading);
      final getResult = await _partnerCategoryApi.getPartnerCategory(id);
      if (getResult.error == null) {
        _partnerCategory = getResult.value;
        if (_partnerCategoryController.isClosed == false)
          _partnerCategoryController.add(_partnerCategory);
      } else {
        onDialogMessageAdd(
            OldDialogMessage.flashMessage(getResult.error.message));
      }
      return true;
    } catch (ex, stack) {
      _log.severe("Load fail", ex, stack);
      onDialogMessageAdd(OldDialogMessage.error(
        S.current.loadFailed,
        ex.toString(),
      ));
    }
    onStateAdd(false);
    return false;
  }

  // Save Product Category
  Future<bool> save() async {
    try {
      // Đang lưu
      onStateAdd(true, message: S.current.saving);
      if (partnerCategory.id == null) {
        await _partnerCategoryApi.insertPartnerCategory(partnerCategory);
        onIsBusyAdd(false);
      } else {
        var result =
            await _partnerCategoryApi.editPartnerCategory(partnerCategory);
        if (result.result == true) {
          onDialogMessageAdd(OldDialogMessage.flashMessage(S.current.success));
          onStateAdd(false);
        } else {
          onDialogMessageAdd(OldDialogMessage.error("", result.message));
          onStateAdd(false);
        }
      }
      return true;
    } catch (ex, stack) {
      _log.severe("save fail", ex, stack);
      onDialogMessageAdd(
        OldDialogMessage.error(
          S.current.saveFailed,
          ex.toString(),
        ),
      );
    }
    onStateAdd(false);
    return false;
  }

  void init() async {
    onStateAdd(true, message: S.current.loading);
    if (partnerCategory.id != null) {
      await loadPartnerCategory(partnerCategory.id);
    }
    onPropertyChanged("init");
    onStateAdd(false);
  }

  @override
  void dispose() {
    _partnerCategoryController.close();
    super.dispose();
  }
}
