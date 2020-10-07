import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/account_bank.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/accountbank_line.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

class PosClosePointSaleListInvoiceViewModel extends ViewModelBase {
  PosClosePointSaleListInvoiceViewModel(
      {IPosTposApi tposApiService, DialogService dialogService}) {
    _dialog = dialogService ?? locator<DialogService>();
    _tposApi = tposApiService ?? locator<IPosTposApi>();
  }
  DialogService _dialog;

  IPosTposApi _tposApi;

  AccountBank _accountBank = AccountBank();
  AccountBank get accountBank => _accountBank;
  set accountBank(AccountBank value) {
    _accountBank = value;
    notifyListeners();
  }

  List<AccountBankLine> _accountBankLines = [];
  List<AccountBankLine> get accountBankLines => _accountBankLines;
  set accountBankLines(List<AccountBankLine> value) {
    _accountBankLines = value;
    notifyListeners();
  }

  Future<void> getAccountBankLines(int id) async {
    setState(true);
    try {
      final result = await _tposApi.getAccountBankLine(id);
      if (result != null) {
        accountBankLines = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadAccountBankLinesFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getAccountBank(int id) async {
    setState(true);
    try {
      final result = await _tposApi.getAccountBankDetailInvoice(id);
      if (result != null) {
        accountBank = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadAccountBankFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }
}
