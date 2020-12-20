import 'package:get_it/get_it.dart';
import 'package:rxdart/subjects.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:rxdart/rxdart.dart';

/// Xử lý logic cho danh sách loại phiếu thu, loại phiếu chi
class AccountPaymentTypeListViewModel extends ViewModelBase {
  AccountPaymentTypeListViewModel(
      {
      DialogService dialogService,
      AccountPaymentApi accountPaymentApi}) {
    _dialog = dialogService ?? locator<DialogService>();

    _apiClient = accountPaymentApi ?? GetIt.instance<AccountPaymentApi>();

    // handled search
    _keywordController
        .debounceTime(
      const Duration(milliseconds: 400),
    )
        .listen((key) {
//      searchProduct();
      getAccounts(isAccountPayment);
    });
  }

  DialogService _dialog;

  AccountPaymentApi _apiClient;

  bool isAccountPayment = false;
  bool autoFocus = false;
  bool _isSearch = true;
  bool isBusy = false;
  bool isError = false;
  List<Account> _searchAccounts = [];
  List<Account> _accounts = [];
  List<Account> get accounts => _accounts;
  set accounts(List<Account> value) {
    _accounts = value;
    notifyListeners();
  }

  bool get isSearch => _isSearch;
  set isSearch(bool value) {
    _isSearch = value;
    notifyListeners();
  }

  Future<void> getAccounts(bool isAccountPayment) async {
    isBusy = true;
    setState(true);
    try {
      List<Account> result;
      if (isAccountPayment) {
        result = await _apiClient.getTypeAccounts(keySearch: _keyword);
      } else if (!isAccountPayment) {
        result = await _apiClient.getTypeAccountSales(keySearch: _keyword);
      }
      if (result != null) {
        _accounts = result;
        _searchAccounts = _accounts;
      }
      isBusy = false;
      isError = false;
      setState(false);
    } catch (e, s) {
      logger.error("loadAccountsFail", e, s);
      _dialog.showError(error: e);
      isBusy = false;
      isError = true;
      setState(false);
    }
  }

  //searchKeyword
  String _keyword;
  String get keyword => _keyword;
  final BehaviorSubject<String> _keywordController = BehaviorSubject();
  void onKeywordAdd(String value) {
    _keyword = value;
    if (_keywordController.isClosed == false) {
      _keywordController.add(_keyword);
    }
  }

  // Search
  Future<void> searchOrderCommand(String keyword) async {
    onKeywordAdd(keyword);
  }

  void searchProduct() {
    final List<Account> findAccounts = [];
    setState(true);
    if (_keyword == "") {
      accounts = _searchAccounts;
    } else {
      for (var i = 0; i < _searchAccounts.length; i++) {
        if (StringUtils.removeVietnameseMark(_searchAccounts[i].name)
            .toLowerCase()
            .contains(
                StringUtils.removeVietnameseMark(_keyword.toLowerCase()))) {
          findAccounts.add(_searchAccounts[i]);
        }
      }
      accounts = findAccounts;
    }
    setState(false);
  }
}
