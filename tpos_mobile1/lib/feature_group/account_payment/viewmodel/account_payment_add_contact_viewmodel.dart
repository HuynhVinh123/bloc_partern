import 'package:flutter/cupertino.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner_contact.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class AccountPaymentAddContactViewmodel extends ViewModelBase {
  AccountPaymentAddContactViewmodel(
      {IPosTposApi tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<IPosTposApi>();
    _dialog = dialogService ?? locator<DialogService>();
  }

  DialogService _dialog;
  IPosTposApi _tposApi;

  PartnerContact partner = PartnerContact();

  Future<void> getContactDefault() async {
    try {
      setState(true);
      final result = await _tposApi.getContactDefault();
      if (result != null) {
        partner = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadContactDefaultFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> addContactPartner(BuildContext context) async {
    try {
      setState(true);
      final result = await _tposApi.addContactPartner(partner);
      if (result != null) {
        showNotify(S.current.contact_addSuccess);
        Navigator.pop(context, true);
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadContactDefaultFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  void showNotify(String message) {
    _dialog.showNotify(title: S.current.notification, message: message ?? "");
  }
}
