import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

/// Xử lý logic cho trang người liên hệ
class PartnerSearchContactViewModel extends ViewModelBase {
  PartnerSearchContactViewModel(
      {DialogService dialogService, AccountPaymentApi accountPaymentApi}) {
    _dialog = dialogService ?? locator<DialogService>();
    _apiClient = accountPaymentApi ?? GetIt.instance<AccountPaymentApi>();
    _keywordController
        .debounceTime(
      const Duration(milliseconds: 400),
    )
        .listen((key) {
      getContactPartners();
    });
  }

  DialogService _dialog;
  AccountPaymentApi _apiClient;
  bool isBusy = false;
  bool isError = false;

  bool _isSearch = true;
  bool get isSearch => _isSearch;
  set isSearch(bool value) {
    _isSearch = value;
    notifyListeners();
  }

  List<Partner> _partners = [];
  List<Partner> get partners => _partners;
  set partner(List<Partner> value) {
    _partners = value;
    notifyListeners();
  }

  Future<void> getContactPartners() async {
    try {
      isBusy = true;
      setState(true);
      final result = await _apiClient.getContactPartners(_keyword);
      if (result != null) {
        _partners = result;
      }
      isBusy = false;
      isError = false;
      setState(false);
    } catch (e, s) {
      isBusy = false;
      isError = true;
      logger.error("loadAccountJournalsFail", e, s);
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
}
