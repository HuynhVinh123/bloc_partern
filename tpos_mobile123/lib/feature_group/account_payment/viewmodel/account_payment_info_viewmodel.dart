import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/account_payment.dart';

class AccountPaymentInfoViewModel extends ViewModelBase {
  AccountPaymentInfoViewModel(
      {IPosTposApi tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<IPosTposApi>();
    _dialog = dialogService ?? locator<DialogService>();
  }

  DialogService _dialog;
  IPosTposApi _tposApi;

  AccountPayment _accountpayment = AccountPayment();

  AccountPayment get accountpayment => _accountpayment;
  set accountpayment(AccountPayment value) {
    _accountpayment = value;
    notifyListeners();
  }

  Future<void> getAccountPayment(int id) async {
    setState(true);
    try {
      final result = await _tposApi.getInfoAccountPayment(id);
      if (result != null) {
        accountpayment = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadAccountPaymentsFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> confirmAccountPayment(int id) async {
    try {
      setState(true);
      await _tposApi.confirmAccountPayment(accountpayment.id);
      await getAccountPayment(id);
      setState(false);
    } catch (e, s) {
      logger.error("confirmAccountPaymentFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> cancelAccountPayment(int id) async {
    try {
      setState(true);
      await _tposApi.cancelAccountPayment(accountpayment.id);
      await getAccountPayment(id);
//      Navigator.pop(context, true);
      setState(false);
    } catch (e, s) {
      logger.error("cancelAccountPaymentFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }
}
