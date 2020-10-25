import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/partners.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/feature_group/pos_order/sqlite_database/database_function.dart';
import 'package:tpos_mobile/feature_group/pos_order/sqlite_database/database_helper.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PosPartnerAddEditViewModel extends ViewModelBase {
  PosPartnerAddEditViewModel(
      {IPosTposApi tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<IPosTposApi>();
    _dialog = dialogService ?? locator<DialogService>();
    _dbFunction = dialogService ?? locator<IDatabaseFunction>();
  }

  DialogService _dialog;
  IPosTposApi _tposApi;
  IDatabaseFunction _dbFunction;

  File image;
  Partners partner = Partners();
  bool isUpdateData = false;

  final dbHelper = DatabaseHelper.instance;

  Future<void> getImageFromGallery() async {
    // ignore: deprecated_member_use
    image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    notifyListeners();
  }

  Future<void> getImageFromCamera() async {
    // ignore: deprecated_member_use
    image = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    notifyListeners();
  }

  Future<void> updatePartner(bool isUpdate) async {
    setState(true);
    try {
      if (isUpdate) {
        final result = await _tposApi.updatePartner(partner);
        if (result != null) {
          await _dbFunction.updatePartner(partner);
          showNotifyUpdate(S.current.posOfSale_successful);
        } else {
          isUpdateData = true;
          showNotifyUpdate(S.current.posOfSale_failed);
        }
      } else {
        final result = await _tposApi.updatePartner(partner);
        if (result != null) {
          await _dbFunction.insertPartner(result);
          showNotifyUpdate(S.current.posOfSale_successful);
        } else {
          showNotifyUpdate(S.current.posOfSale_failed);
        }
      }
    } catch (e, s) {
      if (isUpdate) {
        isUpdateData = true;
      }
      logger.error("loadProductFail", e, s);
      _dialog.showError(error: e);
    }
    setState(false);
  }

  void showNotifyUpdate(String title) {
    _dialog.showNotify(title: S.current.notification, message: title);
  }
}