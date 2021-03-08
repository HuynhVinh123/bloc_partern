import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class AccountPaymentAddContactViewmodel extends ViewModelBase {
  AccountPaymentAddContactViewmodel(
      {DialogService dialogService, AccountPaymentApi accountPaymentApi}) {
    _dialog = dialogService ?? locator<DialogService>();
    _apiClient = accountPaymentApi ?? GetIt.instance<AccountPaymentApi>();
  }

  DialogService _dialog;

  AccountPaymentApi _apiClient;

  PartnerContact partner = PartnerContact();

  Future<void> getContactDefault() async {
    try {
      setState(true);
      final result = await _apiClient.getContactDefault();
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
      final result = await _apiClient.addContactPartner(partner);
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
