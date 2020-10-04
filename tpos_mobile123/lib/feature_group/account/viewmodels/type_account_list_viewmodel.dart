import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/account.dart';


class TypeAccountListViewModel extends ViewModelBase {
  DialogService _dialog;
  IPosTposApi _tposApi;
  TypeAccountListViewModel(
      {IPosTposApi tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<IPosTposApi>();
    _dialog = dialogService ?? locator<DialogService>();
  }

  // Danh sách khách hàng
  static const int limit = 100;
  int skip = 0;
  int max = 0;
  int _currentPage = 0;

  bool isLoadMore = false;

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
    try {
      var result = await _tposApi.getTypeAccountAccounts(
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
      result = await _tposApi.getTypeAccountAccounts(
          page: _currentPage,
          pageSize: limit,
          skip: skip,
          take: limit,
          companyId: company != null ? company?.id : null);
      _accountMores = result.result;
    } catch (e, s) {
      setState(false, isError: true);
      logger.error("loadAccountsFail fail", e, s);
      _dialog.showError(title: "Lỗi", error: result.errorMessage);
    }
    return _accountMores;
  }

  /// Xủ lý kiểm tra đã scroll list xuống tới item cuối hay chưa. Nếu cuối cùng thì bắt đầu xử lý load thêm dử liệu.
  Future handleItemCreated(int index) async {
    _currentPage++;
    if (skip + limit < max && isLoadMore) {
      var newFetchedItems = await loadMoreAccounts();
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
      bool result = await _tposApi.deleteTypeAccountAccountSale(id);
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
    _dialog.showNotify(title: "Thông báo", message: "$message");
  }
}

var tempAccount = new Account(name: "temp");
