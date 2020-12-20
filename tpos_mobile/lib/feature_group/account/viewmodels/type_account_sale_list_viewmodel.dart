import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class TypeAccountSaleListViewModel extends ViewModelBase {
  TypeAccountSaleListViewModel(
      {DialogService dialogService,
      AccountPaymentTypeApi accountPaymentTypeApi}) {
    _dialog = dialogService ?? locator<DialogService>();
    _apiClient =
        accountPaymentTypeApi ?? GetIt.instance<AccountPaymentTypeApi>();
  }
  DialogService _dialog;
  AccountPaymentTypeApi _apiClient;

  // Danh sách khách hàng
  static const int limit = 100;
  int skip = 0;
  int max = 0;
  int _currentPage = 0;

  bool isLoadMore = false;

  Company _company;
  Company get company => _company;
  set company(Company value) {
    _company = value;
    notifyListeners();
  }

  List<Account> _accounts = [];
  List<Account> get accounts => _accounts;
  set accounts(List<Account> value) {
    _accounts = value;
    notifyListeners();
  }

  Future<void> getAccounts() async {
    setState(true);
    skip = 0;
    _currentPage = 0;
    try {
      final result = await _apiClient.getTypeAccountAccountSales(
          page: _currentPage,
          pageSize: limit,
          skip: skip,
          take: limit,
          companyId: company != null ? company?.id : null);
      if (result != null) {
        accounts = result.result;
        max = result.totalItems;
        if (accounts.length > 99) {
          _showLoadingIndicator();
        }
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadAccountsFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  // Load more
  List<Account> _accountMores;

  Future<List<Account>> loadMoreAccounts() async {
    var result;
    try {
      skip += limit;
      result = await _apiClient.getTypeAccountAccountSales(
          page: _currentPage,
          pageSize: limit,
          skip: skip,
          take: limit,
          companyId: company != null ? company?.id : null);
      _accountMores = result.result;
    } catch (e, s) {
      setState(false, isError: true);
      logger.error("get Account fail", e, s);
      _dialog.showError(title: S.current.error, error: result.errorMessage);
    }
    return _accountMores;
  }

  Future handleItemCreated(int index) async {
    _currentPage++;
    if (skip + limit < max && isLoadMore) {
      final newFetchedItems = await loadMoreAccounts();
      _accounts.addAll(newFetchedItems);
      _removeLoadingIndicator();
      _showLoadingIndicator();
    } else {
      _removeLoadingIndicator();
    }
    isLoadMore = false;
  }

  void _showLoadingIndicator() {
    _accounts.add(tempAccount);
    notifyListeners();
  }

  void _removeLoadingIndicator() {
    _accounts.remove(tempAccount);
    notifyListeners();
  }

  Future<bool> deleteAccount(int id, Account account) async {
    try {
      final bool result = await _apiClient.deleteTypeAccountAccountSale(id);
      if (result) {
        _accounts.remove(account);
        return result;
      }
    } catch (e, s) {
      logger.error("deleteAccountFail", e, s);
      _dialog.showError(error: e);
    }
    return false;
  }

  void showNotify(String message) {
    _dialog.showNotify(title: S.current.notification, message: message ?? "");
  }
}

var tempAccount = Account(name: "temp");
