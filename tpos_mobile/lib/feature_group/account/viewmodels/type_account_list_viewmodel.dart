import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/services/dialog_service/new_dialog_service.dart';

class TypeAccountListViewModel extends ViewModelBase {
  TypeAccountListViewModel(
      {AccountPaymentTypeApi accountPaymentTypeApi,
      NewDialogService newDialog}) {
    _apiClient =
        accountPaymentTypeApi ?? GetIt.instance<AccountPaymentTypeApi>();
    _newDialog = newDialog ?? GetIt.I<NewDialogService>();
  }
  NewDialogService _newDialog;

  AccountPaymentTypeApi _apiClient;

  // Danh sách khách hàng
  static const int limit = 100;
  int skip = 0;
  int max = 0;
  int _currentPage = 0;

  bool isLoadMore = false;
  bool isBusy = false;
  bool isError = false;

  List<Account> _accounts = [];
  List<Account> get accounts => _accounts;
  set accounts(List<Account> value) {
    _accounts = value;
    notifyListeners();
  }

  Company _company;
  Company get company => _company;
  set company(Company value) {
    _company = value;
    notifyListeners();
  }

  /// Lấy danh sách loại phiếu thu.
  Future<void> getAccounts() async {
    setState(true);
    skip = 0;
    _currentPage = 0;
    isBusy = true;
    try {
      final result = await _apiClient.getTypeAccountAccounts(
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
      isBusy = false;
      isError = false;
    } catch (e, s) {
      isBusy = false;
      isError = true;
      logger.error("loadAccountsFail", e, s);
      _newDialog.showError(content: e.toString());
      setState(false);
    }
  }

  // Load more
  List<Account> _accountMores;

  Future<List<Account>> loadMoreAccounts() async {
    // ignore: prefer_typing_uninitialized_variables
    var result;
    try {
      skip += limit;
      result = await _apiClient.getTypeAccountAccounts(
          page: _currentPage,
          pageSize: limit,
          skip: skip,
          take: limit,
          companyId: company != null ? company?.id : null);
      _accountMores = result.result;
    } catch (e, s) {
      setState(false, isError: true);
      logger.error("loadAccountsFail fail", e, s);
      _newDialog.showError(content: result.errorMessage);
    }
    return _accountMores;
  }

  /// Xủ lý kiểm tra đã scroll list xuống tới item cuối hay chưa. Nếu cuối cùng thì bắt đầu xử lý load thêm dử liệu.
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
      _newDialog.showError(content: e.toString());
    }
    return false;
  }

  void showNotify(String message) {
    _newDialog.showToast(message: message ?? "");
  }
}

var tempAccount = Account(name: "temp");
