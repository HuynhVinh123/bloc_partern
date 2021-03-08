import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

class SearchCompanyListViewModel extends ViewModelBase {
  SearchCompanyListViewModel(
      {DialogService dialogService,
      AccountPaymentTypeApi accountPaymentTypeApi}) {
    _dialog = dialogService ?? locator<DialogService>();
    _apiClient =
        accountPaymentTypeApi ?? GetIt.instance<AccountPaymentTypeApi>();

    // handled search
    _keywordController
        .debounceTime(
      const Duration(milliseconds: 400), //TODO Check debounceTime dispable
    )
        .listen((key) {
      getCompanies();
    });
  }
  DialogService _dialog;

  AccountPaymentTypeApi _apiClient;

  List<Company> _companies = <Company>[];
  List<Company> get companies => _companies;
  set companies(List<Company> value) {
    _companies = value;
    notifyListeners();
  }

  Future<void> getCompanies() async {
    setState(true);
    try {
      final result = await _apiClient.getCompanies(_keyword);
      if (result != null) {
        companies = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadCompaniessFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  bool _isSearch = false;
  bool get isSearch => _isSearch;
  set isSearch(bool value) {
    _isSearch = value;
    notifyListeners();
  }

  //searchKeyword
  String _keyword = "";

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
}
