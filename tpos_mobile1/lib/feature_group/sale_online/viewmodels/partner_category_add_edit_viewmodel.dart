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

class PartnerCategoryAddEditViewModel extends ViewModel {
  final _log = new Logger("PartnerCategoryAddEditViewModel");

  PartnerCategoryApi _partnerCategoryApi;

  PartnerCategoryAddEditViewModel({PartnerCategoryApi partnerCategoryApi}) {
    _partnerCategoryApi = partnerCategoryApi ?? locator<PartnerCategoryApi>();
  }

  // Partner Category Command
  void selectPartnerCategoryCommand(PartnerCategory selectedCat) {
    partnerCategory.parent = selectedCat;
    partnerCategory.name = selectedCat.name;
    partnerCategory.parentId = selectedCat.id;
    onPropertyChanged("category");
  }

  // Partner Category
  PartnerCategory _partnerCategory = new PartnerCategory();
  PartnerCategory get partnerCategory => _partnerCategory;
  set partnerCategory(PartnerCategory value) {
    _partnerCategory = value;
    _partnerCategoryController.add(_partnerCategory);
  }

  BehaviorSubject<PartnerCategory> _partnerCategoryController =
      new BehaviorSubject();
  Stream<PartnerCategory> get partnerCategoryStream =>
      _partnerCategoryController.stream;

  // Load Partner Category
  Future<bool> loadPartnerCategory(int id) async {
    try {
      onStateAdd(true, message: "Đang tải");
      var getResult = await _partnerCategoryApi.getPartnerCategory(id);
      if (getResult.error == null) {
        this._partnerCategory = getResult.value;
        if (_partnerCategoryController.isClosed == false)
          this._partnerCategoryController.add(_partnerCategory);
      } else {
        onDialogMessageAdd(
            OldDialogMessage.flashMessage(getResult.error.message));
      }
      return true;
    } catch (ex, stack) {
      _log.severe("Load fail", ex, stack);
      onDialogMessageAdd(OldDialogMessage.error(
        "Load dữ liệu thất bại",
        ex.toString(),
      ));
    }
    onStateAdd(false);
    return false;
  }

  // Save Product Category
  Future<bool> save() async {
    try {
      onStateAdd(true, message: "Đang lưu");
      if (partnerCategory.id == null) {
        await _partnerCategoryApi.insertPartnerCategory(partnerCategory);
        onIsBusyAdd(false);
      } else {
        var result =
            await _partnerCategoryApi.editPartnerCategory(partnerCategory);
        if (result.result == true) {
          onDialogMessageAdd(
              OldDialogMessage.flashMessage("Lưu nhóm khách hàng thành công"));
          onStateAdd(false);
        } else {
          onDialogMessageAdd(new OldDialogMessage.error("", result.message));
          onStateAdd(false);
        }
      }
      return true;
    } catch (ex, stack) {
      _log.severe("save fail", ex, stack);
      onDialogMessageAdd(
        (OldDialogMessage.error(
          "Lưu dữ liệu thất bại",
          ex.toString(),
        )),
      );
    }
    onStateAdd(false);
    return false;
  }

  void init() async {
    onStateAdd(true, message: "Đang tải");
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
