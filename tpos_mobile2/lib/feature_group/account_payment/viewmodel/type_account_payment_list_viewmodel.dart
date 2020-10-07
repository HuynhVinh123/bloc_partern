import 'package:rxdart/subjects.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/feature_group/pos_order/services/pos_tpos_api.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/account.dart';
import 'package:rxdart/rxdart.dart';

class TypeAccountPaymentListViewModel extends ViewModelBase {
  TypeAccountPaymentListViewModel(
      {IPosTposApi tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<IPosTposApi>();
    _dialog = dialogService ?? locator<DialogService>();
    // handled search
    _keywordController
        .debounceTime(
      const Duration(milliseconds: 400),
    )
        .listen((key) {
      searchProduct();
    });
  }

  DialogService _dialog;
  IPosTposApi _tposApi;

  bool _isSearch = false;
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
    setState(true);
    try {
      List<Account> result;
      if (isAccountPayment) {
        result = await _tposApi.getTypeAccounts(keySearch: _keyword);
      } else if (!isAccountPayment) {
        result = await _tposApi.getTypeAccountSales(keySearch: _keyword);
      }
      if (result != null) {
        _accounts = result;
        _searchAccounts = _accounts;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadAccountsFail", e, s);
      _dialog.showError(error: e);
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
